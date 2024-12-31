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
-- Declaration Type Tableau Memoire
type table is array(63 downto 0) of std_logic_vector(31 downto 0);

-- Fonction d'Initialisation de la mémoire
function init_memoire return table is
variable result : table;
begin
    for i in 63 downto 0 loop
        --Initialisation des données dans la mémoire entre le registre 16 (inclus) et registre 26(exclus)
        --car le programme de test va faire la somme de ces données dans un premier temps
        if i>=16 and i<26 then 
            result(i) := std_logic_vector(to_signed(i-15,32));
        else
            result(i) := (others => '1');
        end if;
    end loop;
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