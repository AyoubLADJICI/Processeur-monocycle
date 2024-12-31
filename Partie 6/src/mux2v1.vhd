library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;

entity mux2v1 is
    generic(N : integer := 8);
    port(
        A, B : in std_logic_vector(N-1 downto 0);
        COM : std_logic;
        S : out std_logic_vector(N-1 downto 0)
    );
end entity;

architecture Behavorial of mux2v1 is 
begin
    process(A, B, COM)
        begin
            if COM = '0' then
                S <= A;
            else
                S <= B;
            end if;
    end process;            
end architecture;
