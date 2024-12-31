library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_extension_signe is
end entity tb_extension_signe;

architecture testbench of tb_extension_signe is
    constant N : integer := 8;
    signal E : std_logic_vector(N-1 downto 0);
    signal S : std_logic_vector(31 downto 0);
    signal OK : boolean := TRUE;

begin
    --Instanciation du module d'extension de signe
    UUT: entity work.extension_signe
    generic map(N => N)
    port map(E => E, S => S);

    Test_Process: process
    begin
        report "Debut de la simulation";
        
        -- Test 1 : Signe positif (MSB = '0')
        E <= "01111101";
        wait for 2 ns;
        if S = "00000000000000000000000001111101" then
            report "Test 1: Signe positif (MSB = '0') reussi." severity note;
        else
            report "Test 1: Signe positif (MSB = '0') echoue." severity error;
            OK <= FALSE;
        end if;

        -- Test 2 : Signe négatif (MSB = '1')
        E <= "10001110";
        wait for 2 ns;
        if S = "11111111111111111111111110001110" then
            report "Test 2: Signe negatif (MSB = '1') reussi." severity note;
        else
            report "Test 2: Signe negatif (MSB = '1') echoue." severity error;
            OK <= FALSE;
        end if;
        
        if (OK) then
            report "Extension de signe a ete simule avec succes" severity note;
        else
            report "La simulation contient des erreurs" severity error;
        end if; 
        report "Fin de la simulation.";
        wait;
    end process;
end architecture testbench;
