library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Registre32 is
    port(
        Clk, Rst : in std_logic;
        WE : in std_logic;
        DataIN : in std_logic_vector(31 downto 0);
        DataOUT : out std_logic_vector(31 downto 0)
    );
end entity;

architecture Behavioural of Registre32 is
signal RegAff : std_logic_vector(31 downto 0); 

begin
process(Clk, Rst)
begin
    if Rst = '1' then
        RegAff <= (others =>'0');
    elsif rising_edge(Clk) then
        if WE = '1' then
            RegAff <= DataIN;
        end if;
    end if;
    end process;
    DataOUT <= RegAff;
end architecture;