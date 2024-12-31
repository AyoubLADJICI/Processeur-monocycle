library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;

entity memoire_de_donnees is
    port(
        CLK, Reset, WrEN : in std_logic;
        Addr : in std_logic_vector(5 downto 0);
        DataIn : in std_logic_vector(31 downto 0);
        DataOut : out std_logic_vector(31 downto 0)
    );
end entity;

architecture Behavioral of memoire_de_donnees is
--Déclaration Type Tableau Memoire
type table is array(63 downto 0) of std_logic_vector(31 downto 0);

--Fonction d'Initialisation de la mémoire
function init_memoire return table is
variable result : table;
begin
    for i in 63 downto 0 loop
        result(i) := (others => '0');
    end loop;
    result(32) := x"00000001";
    result(33) := x"00000002";
    result(34) := x"00000003";
    result(35) := x"00000004";
    result(36) := x"00000005";
    result(37) := x"00000006";
    result(38) := x"00000007";
    result(39) := x"00000008";
    result(40) := x"00000009";
    result(41) := x"0000000A";
    return result;
end init_memoire;

--Déclaration et Initialisation du Banc de Registres 64x32 bits
signal memoire: table := init_memoire;
begin
    process(Clk, Reset)
    begin
        if Reset = '1' then
            memoire <= init_memoire;
        elsif rising_edge(CLK) then
            if WrEN = '1' then
                memoire(to_integer(unsigned(Addr))) <= DataIn;
            end if;
        end if;
    end process;
    DataOut <= memoire(to_integer(unsigned(Addr)));
end architecture;