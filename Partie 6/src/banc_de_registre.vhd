library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;

entity banc_de_registre is
    port(
        Clk, Rst : in std_logic;
        W : in std_logic_vector(31 downto 0);
        RA, RB, RW : in std_logic_vector(3 downto 0);
        WE : in std_logic;
        A : out std_logic_vector(31 downto 0);
        B : out std_logic_vector(31 downto 0)
    );
end banc_de_registre;

architecture Behavorial of banc_de_registre is
--Déclaration Type Tableau Memoire
type table is array(15 downto 0) of std_logic_vector(31 downto 0);

--Fonction d'Initialisation du Banc de Registres
function init_banc return table is
variable result : table;
begin
    for i in 14 downto 0 loop
            result(i) := (others=>'0');
    end loop;
        result(15):=X"00000030";
        return result;
end init_banc;

--Déclaration et Initialisation du Banc de Registres 16x32 bits
signal Banc: table := init_banc;

begin
    process(Clk, Rst)
    begin
        if Rst = '1' then
           banc <= init_banc;
        elsif rising_edge(Clk) then
            if WE = '1' then
                Banc(to_integer(unsigned(RW))) <= W;
            end if;
        end if;
    end process;
    A <= Banc(to_integer(unsigned(RA)));
    B <= Banc(to_integer(unsigned(RB)));
end Behavorial;
