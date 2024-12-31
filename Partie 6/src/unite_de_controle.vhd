library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity unite_de_controle is
    port(
        Clk, Reset : in std_logic;
        Instruction,flagsNZCV : in std_logic_vector(31 downto 0);
        nPCSel, PSREn, RegWr, RegSel,RegAff, ALUSrc, WrSrc, MemWr, IRQ_END: out std_logic;
        ALUCtrl : out std_logic_vector(2 downto 0);
        busB : in std_logic_vector(31 downto 0);
        Afficheur : out std_logic_vector(31 downto 0)
    );
end entity;

architecture Behavioural of unite_de_controle is
signal signalDataOut : std_logic_vector(31 downto 0);
signal signalPSREn, signalRegAff : std_logic;
begin

--Instanciation du Decodeur
I_decodeur: entity work.Decodeur
port map(Instruction => Instruction, PSR => signalDataOUT, nPC_SEL => nPCSel, PSREn => signalPSREn, RegWr => RegWr, RegSel => RegSel, ALUSrc => ALUSrc, WrSrc => WrSrc, MemWr => MemWr,IRQ_END => IRQ_END, 
RegAff => signalRegAff, ALUCtrl => ALUCtrl);

PSREn <= signalPSREn;
RegAff <= signalRegAff;
--Instanciation du registre PSR
I_RegPSR: entity work.Registre32
port map(Clk => Clk, Rst => Reset, WE => signalPSREn, DataIN => flagsNZCV, DataOUT => signalDataOUT);


--Instanciation du registre Afficheur
I_RegAff: entity work.Registre32
port map(Clk => Clk, Rst => Reset, WE => signalRegAff, DataIN => busB, DataOUT => Afficheur);
end architecture;