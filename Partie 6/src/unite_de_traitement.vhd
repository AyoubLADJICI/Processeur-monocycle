library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity unite_de_traitement is
    Port (
        Clk, Reset : in std_logic;
        OP  : in std_logic_vector(2 downto 0);
        RN, RM, RD: in std_logic_vector(3 downto 0);
        WE  : in std_logic;
        COM1, COM2, RegSel : in std_logic;
        Imm : in std_logic_vector(7 downto 0);
        WrEN : in std_logic;
        busBtoMem: out std_logic_vector(31 downto 0);
        flagsOut : out std_logic_vector(3 downto 0);  
        Sout : out std_logic_vector(31 downto 0)
    );
end unite_de_traitement;

architecture Behavioral of unite_de_traitement is
    -- Déclaration des signaux internes
    signal busA, busB, busS, busW, SignalAluOUT, Signal_extension, signalDataOut  : std_logic_vector(31 downto 0);
    signal signalRB, flags : std_logic_vector(3 downto 0);
begin

flagsOut <= flags;


-- Instanciation du banc de registres
RegisterBank_Instance: entity work.banc_de_registre
port map (Clk => Clk, Rst => Reset, W => busW, RA => RN, RB => signalRB, RW => RD, WE => WE, A => busA, B => busB);
busBtoMem <= busB;
-- Instanciation de l'UAL
I_UAL: entity work.ual
port map (OP => OP, A => busA, B => busS, S => SignalAluOUT, N => flags(0), Z => flags(1), C => flags(2), V => flags(3));

--Instanciation de TROIS multiplexeur 2 vers 1
I1_Mux2v1: entity work.mux2v1 generic map (N => 32)
port map(A => busB, B => Signal_extension, COM => COM1, S => busS);

I2_Mux2v1: entity work.mux2v1 generic map(N => 32)
port map(A => SignalAluOUT, B => signalDataOut, COM => COM2, S => busW);

I3_Mux2v1: entity work.mux2v1 generic map (N => 4)
port map(A => RM, B => RD, COM => RegSel, S => signalRB);

--Instanciation du signe d'extension
I_extension_signe: entity work.extension_signe generic map(N => 8)
port map(E => Imm, S => Signal_extension);

--Instanciation de la mémoire de données
I_memoire_de_donnees: entity work.memoire_de_donnees
port map(CLK => Clk, Reset => Reset, WrEN => WrEN, Addr => SignalAluOUT(5 downto 0), DataIN => busB, DataOut => signalDataOut);

Sout <= busW;

end architecture Behavioral;