library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top_level is
	port(
		MAX10_CLK1_50 	:  in  std_logic;
		KEY			 	:  in  std_logic_vector(1 downto 0);
		SW 				:  in  std_logic_vector(9 downto 0);
		HEX0 			:  out  std_logic_vector(0 to 6);
		HEX1 			:  out  std_logic_vector(0 to 6);
		HEX2 			:  out  std_logic_vector(0 to 6);
		HEX3 			:  out  std_logic_vector(0 to 6)
	);
end entity;

architecture RTL of top_level is
    signal Clk, Reset, pol  : std_logic;
    signal sigAfficheur : std_logic_vector(31 downto 0);
begin

Clk <= MAX10_CLK1_50;
Reset <= not KEY(0);
pol <= SW(9);

-- instanciation du processeur
I_processeur: entity work.processeur
port map(Clk => Clk, Reset => Reset, Afficheur => sigAfficheur);

--instanciation du module (SEVEN_SEG) 4 fois
inst1 : entity work.seven_seg
port map(Data => sigAfficheur(3 downto 0), Pol => pol, Segout => HEX0);

inst2 : entity work.seven_seg
port map(Data => sigAfficheur(7 downto 4), Pol => pol, Segout => HEX1);

inst3 : entity work.seven_seg
port map(Data => sigAfficheur(11 downto 8), Pol => pol, Segout => HEX2);

inst4 : entity work.seven_seg
port map(Data => sigAfficheur(15 downto 12), Pol => pol, Segout => HEX3);
end architecture;