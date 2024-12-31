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

--Fonction d'initialisation de la mémoire
function init_memoire return table is
variable result : table;
begin
    for i in 62 downto 0 loop
            result(i) := (others=> '0');
    end loop;
        result(63):= x"12345678";
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