library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;

entity extension_signe is
    generic(N : integer := 8);
    port(
        E : in std_logic_vector(N-1 downto 0);
        S : out std_logic_vector(31 downto 0)
    );
end entity;

architecture Behavorial of extension_signe is
begin
    process(E)
    begin
       S(N-1 downto 0) <= E; --Tous les bits de sortie entre entre S(N-1) et S(0) prennet la valeur de E
       S(31 downto N) <= (others => E(N-1)); --Tous les bits de sortie entre entre S(31) et S(N) sont mit soit à '0' ou à '1' selon la valeur de E(N-1)
    end process;
end architecture;