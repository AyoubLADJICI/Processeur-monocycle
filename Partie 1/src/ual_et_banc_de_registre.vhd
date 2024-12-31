library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ual_et_banc_de_registre is
    Port (
        Clk, Rst : in std_logic;
        OP  : in std_logic_vector(2 downto 0);
        RA, RB, RW  : in std_logic_vector(3 downto 0);
        WE  : in std_logic;
        Wout : out std_logic_vector(31 downto 0)
    );
end ual_et_banc_de_registre;

architecture Behavioral of ual_et_banc_de_registre is
--Déclaration des signaux internes
signal busA, busB, busW: std_logic_vector(31 downto 0);

begin

--Instanciation du banc de registres
I_banc_de_registre: entity work.banc_de_registre
port map (Clk => Clk, Rst => Rst, W => busW, RA => RA, RB => RB, RW => RW, WE => WE, A => busA, B => busB);

--Instanciation de l'UAL
I_ual: entity work.ual
port map (OP => OP, A => busA, B => busB, S => busW, N => open, Z => open, C => open, V => open);

Wout <= busW;


end Behavioral;