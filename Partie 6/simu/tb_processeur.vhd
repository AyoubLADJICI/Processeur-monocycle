library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_processeur is
end entity;

architecture testbench of tb_processeur is
    signal Clk : std_logic := '0';
    signal Reset : std_logic := '1';
    signal IRQ_END : std_logic; 
    signal Afficheur : std_logic_vector(31 downto 0);
    signal OK :boolean := TRUE;
begin

    --Instanciation du processeur
    UUT : entity work.processeur
    port map (Clk => Clk, Reset => Reset, IRQ_END => IRQ_END, Afficheur => Afficheur);

    Clk_process: process
    begin
        Reset <= '1';
        wait for 1 ns;
        Reset <= '0';
        while now < 5 us loop
            Clk <= '1';
            wait for 10 ns;
            Clk <= '0';
            wait for 10 ns;
        end loop;
        if Afficheur = x"000000CD" then
            report "TEST REUSSI : L'afficheur affiche le bon resultat." severity note;
        else
            report "TEST ECHOUE : L'afficheur n'affiche pas le bon resultat." severity error;
            OK <= FALSE;
        end if;
        wait;
    end process;

end architecture testbench;
