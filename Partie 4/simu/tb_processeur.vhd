library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_processeur is
end entity;

architecture testbench of tb_processeur is
    signal Clk : std_logic := '0';
    signal Reset : std_logic := '1';
    signal Afficheur : std_logic_vector(31 downto 0);
    signal OK :boolean := TRUE;
begin

    --Instanciation du processeur
    UUT : entity work.processeur
    port map (Clk => Clk, Reset => Reset, Afficheur => Afficheur);

    Clk_process: process
    begin
        report "Debut de la simulation";
        Reset <= '1';
        wait for 1 ns;
        Reset <= '0';
        while now < 2 us loop
            Clk <= '1';
            wait for 10 ns;
            Clk <= '0';
            wait for 10 ns;
        end loop;
        if Afficheur = x"00000037" then
            report "TEST REUSSI : L'afficheur affiche le bon resultat." severity note;
        else
            report "TEST ECHOUE : L'afficheur n'affiche pas le bon resultat." severity error;
            OK <= FALSE;
        end if;
        report "Fin de la simulation";
        wait;
    end process;

end architecture testbench;
