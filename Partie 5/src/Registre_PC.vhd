library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Registre_PC is
    port(
        Clk, Reset : in std_logic;
        PCin : in std_logic_vector(31 downto 0);
        PCout : out std_logic_vector(31 downto 0)
    );
end entity;

architecture Behavioral of Registre_PC is
begin
process(Clk, Reset)
    begin
        if Reset = '1' then
            PCout <= (others => '0');
        elsif rising_edge(Clk) then
            PCout <= PCin;
        end if;
    end process;
end architecture;
       