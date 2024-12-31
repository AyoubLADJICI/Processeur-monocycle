library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity processeur is
    port(
        Clk, Reset : in std_logic;
        IRQ0, IRQ1 : in std_logic;
        Afficheur : out std_logic_vector(31 downto 0)
    );
end entity;

architecture Behavioural of processeur is
signal InstructionOut : std_logic_vector(31 downto 0);
signal Imm24: std_logic_vector(23 downto 0);
signal nPCSEL, RegWr: std_logic;
signal flagsOUT : std_logic_vector(3 downto 0);
signal flagsNZCV : std_logic_vector(31 downto 0);
signal RD, RN, RM : std_logic_vector(3 downto 0);
signal ALUSrc, WrSrc, RegSel : std_logic;
signal Imm8 : std_logic_vector(7 downto 0);
signal MemWr : std_logic;
signal ALUCtrl : std_logic_vector(2 downto 0);
signal busBtoMem : std_logic_vector(31 downto 0);
signal signalIRQ_END : std_logic;
signal signalIRQ_SERV, signalIRQ : std_logic;
signal signalVICPC : std_logic_vector(31 downto 0);
begin

Imm24 <= InstructionOut(23 downto 0);
flagsNZCV <= flagsOUT & x"0000000";
RD <= InstructionOut(15 downto 12);
RN <= InstructionOut(19 downto 16);
RM <= InstructionOut(3 downto 0);
Imm8 <= InstructionOut(7 downto 0);

--Instanciation de l'unite de gestion
I_unite_de_gestion: entity work.unite_de_gestion
port map (Offset => Imm24, Clk => Clk, Reset => Reset, nPCsel => nPCsel, IRQ => signalIRQ , IRQ_END=> signalIRQ_END, VICPC => signalVICPC ,Instruction => InstructionOut, IRQ_SERV => signalIRQ_SERV);

--Instanciation de l'unite de contrôle
I_unite_de_controle: entity work.unite_de_controle
port map(Clk => Clk, Reset => Reset, Instruction => InstructionOut, busB => busBtoMem, flagsNZCV => flagsNZCV, nPCSel => nPCSEL, PSREn => open, RegWr => RegWr, RegSel => RegSel, 
RegAff => open, ALUSrc => ALUSrc, WrSrc => WrSrc, MemWr => MemWr, IRQ_END => signalIRQ_ENd, ALUCtrl => ALUCtrl, Afficheur => Afficheur);

--Instanciation de l'unite de traitement
I_unite_de_traitement: entity work.unite_de_traitement
port map (Clk => Clk, Reset => Reset, OP => ALUCtrl, RN => RN, RM => RM, RD => RD, WE => RegWr, COM1 => ALUSrc, COM2 => WrSrc, RegSel => RegSel, Imm => Imm8, WrEN => MemWr, 
busBtoMem => busBtoMem ,flagsOut => flagsOUT, Sout => open);

--Instanciation du vic
I_vic: entity work.vic
port map(Clk => Clk, Reset => Reset, IRQ_SERV => signalIRQ_SERV, IRQ0 => IRQ0, IRQ1 => IRQ1, IRQ => signalIRQ, VICPC => signalVICPC);

end architecture;