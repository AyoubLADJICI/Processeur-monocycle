library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity unite_de_gestion is
    Port (
        Offset : in std_logic_vector(23 downto 0);
        Clk, Reset, nPCsel : in std_logic;
        Instruction : out std_logic_vector(31 downto 0)
    );
end unite_de_gestion;

architecture Behavioral of unite_de_gestion is
-- Déclaration des signaux internes
signal SignExtOffset, busPC, Addr,A_in,B_in : std_logic_vector(31 downto 0);

begin
--Instanciation du signe d'extension
I_extension_signe: entity work.extension_signe generic map(N => 24)
port map(E => Offset, S => SignExtOffset);

A_in <=  std_logic_vector(unsigned(Addr) + 1);
B_in <= std_logic_vector(unsigned(Addr) + 1 + to_integer(unsigned(SignExtOffset)));

--Instanction du multiplexeur 2 vers 1
I_mux2v1: entity work.mux2v1 generic map(N => 32)
port map(A => A_in, B => B_in, COM => nPCsel, S => busPC);

--Instanciation du registre PC
I_Registre_PC: entity work.Registre_PC
port map(Clk => Clk, Reset => Reset, PCin => busPC, PCout =>Addr);

--Instanciation de la mémoire d'instruction
I_instruction_memory: entity work.instruction_memory
port map(PC => Addr, Instruction => Instruction);

end architecture Behavioral;