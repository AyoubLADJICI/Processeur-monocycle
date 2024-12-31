library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity unite_de_gestion is
    Port (
        Offset : in std_logic_vector(23 downto 0);
        Clk, Reset, nPCsel : in std_logic;
        IRQ, IRQ_END : in std_logic;
        VICPC : in std_logic_vector(31 downto 0);
        Instruction : out std_logic_vector(31 downto 0);
        IRQ_SERV : out std_logic
    );
end unite_de_gestion;

architecture Behavioral of unite_de_gestion is
-- Déclaration des signaux internes
signal SignExtOffset, busPC, A_in, B_in, LR : std_logic_vector(31 downto 0);
signal PC_in, PC_out : std_logic_vector(31 downto 0);

begin
--Instanciation du signe d'extension
I_extension_signe: entity work.extension_signe generic map(N => 24)
port map(E => Offset, S => SignExtOffset);

A_in <=  std_logic_vector((signed(PC_out)) + 1);
B_in <=  std_logic_vector((signed(PC_out)) + 1 + to_integer(signed(SignExtOffset)));

--Instanction du multiplexeur 2 vers 1
I_mux2v1: entity work.mux2v1 generic map(N => 32)
port map(A => A_in, B => B_in, COM => nPCsel, S => busPC);

--Instanciation du registre PC
I_Registre_PC: entity work.Registre_PC
port map(Clk => Clk, Reset => Reset, PCin => PC_in, PCout => PC_out);

--Instanciation du registre LR
I_Registre_LR: entity work.Registre32
port map(Clk => Clk, Rst => Reset, We => IRQ, DataIN => PC_out, DataOUT => LR);

--Instanciation de la mémoire d'instruction
I_instruction_memory: entity work.instruction_memory_IRQ
port map(PC => PC_out, Instruction => Instruction);

process(Clk, Reset)
    begin
        if IRQ = '1' then
            PC_in <= VICPC;
            IRQ_SERV <= '1';
            PC_in <= busPC;
        else
            IRQ_SERV <= '0';
            if IRQ_END = '1' then
                PC_in <= std_logic_vector(signed(LR) + 1);
            else
                PC_in <= busPC;
            end if;
        end if;
end process;

end architecture Behavioral;