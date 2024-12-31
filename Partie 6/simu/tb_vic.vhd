library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_vic is
end tb_vic;

architecture testbench of tb_vic is
    constant CLK_PERIOD : time := 10 ns;
    signal Clk, Reset : std_logic := '0';
    signal IRQ_SERV, IRQ0, IRQ1: std_logic := '0';
    signal IRQ: std_logic;
    signal VICPC: std_logic_vector(31 downto 0);
    signal OK: boolean := TRUE;
    
begin
    -- Instanciation du vic
    vic_inst : entity work.VIC
    port map (Clk => Clk, Reset => Reset, IRQ_SERV => IRQ_SERV, IRQ0 => IRQ0, IRQ1 => IRQ1, IRQ => IRQ, VICPC => VICPC);

    Clk_Process: process
    begin
        while now < 270 ns loop
            Clk <= '1';
            wait for CLK_PERIOD / 2;
            Clk <= '0';
            wait for CLK_PERIOD / 2;
        end loop;
        wait;
    end process;

    process
    begin
        report "Debut de la simulation";
        Reset <= '1';
        wait for 2 ns;
        Reset <= '0';
        
        report "Test : Aucune requete d'interruption " severity note;
        wait until rising_edge(Clk);
        wait for 1 ns;
        if VICPC = x"00000000" then
            report "La sortie VICPC est bien a 0 lorsqu'il n'y a aucune requete d'interruption." severity note;
        else
            report "Probleme avec la sortie VICPC lorsqu'il n'y a aucune requete d'interruption." severity error;
            OK <= FALSE;
        end if;

        wait until falling_edge(Clk);
        report "Test des deux requetes d'interruption externe sans priorite : " severity note;    
        report "Test de la requete d'interruption IRQ0 : " severity note; 
        IRQ0 <= '1';
        wait until rising_edge(Clk);
        wait for 1 ns;
        if VICPC = x"00000009" and IRQ = '1' then
            report "La sortie VICPC possede la bonne adresse de debut du sous-programme d'interruption avec IRQ0 = '1' et IRQ1 = '0'." severity note;
            report "La sortie IRQ a bien ete mise a jour." severity note;
        else
            report "La sortie VICPC ne possede pas la bonne adresse de debut du sous-programme d'interruption avec IRQ0 = '1' et IRQ1 = '0'." severity error;
            report "Ou bien la sortie IRQ n'a pas ete mise a jour." severity error;
            OK <= FALSE;
        end if;

        wait until falling_edge(Clk);
        report "Test de la requete d'interruption IRQ1 : " severity note; 
        IRQ0 <= '0';
        IRQ1 <= '1';
        wait until rising_edge(Clk);
        wait until rising_edge(Clk);
        wait for 1 ns;
        if VICPC = x"00000015" and IRQ = '1' then
            report "La sortie VICPC possede la bonne adresse de debut du sous-programme d'interruption avec IRQ0 = '0' et IRQ1 = '1'." severity note;
            report "La sortie IRQ a bien ete mise a jour." severity note;
        else
            report "La sortie VICPC ne possede pas la bonne adresse de debut du sous-programme d'interruption avec IRQ0 = '0' et IRQ1 = '1'." severity error;
            report "Ou bien la sortie IRQ n'a pas ete mise a jour." severity error;
            OK <= FALSE;
        end if;
        
        wait until falling_edge(Clk);
        report "Test des deux requetes d'interruption externe avec la priorite : " severity note;
        IRQ0 <= '1';
        IRQ1 <= '1';
        --wait for CLK_PERIOD;
        wait until rising_edge(Clk);
        wait for 1 ns;
        if VICPC = x"00000009" and IRQ = '1' then
            report "La sortie VICPC possede la bonne adresse de debut du sous-programme d'interrutpion." severity note;
            report "La prioriete a bien ete respectee lorsque IRQ0 et IRQ1 sont actives" severity note;
        else
            report "La sortie VICPC ne possede pas la bonne adresse de debut du sous-programme d'interrutpion." severity note;
            report "La prioriete n'a pas ete respectee lorsque IRQ0 et IRQ1 sont actives" severity note;
            OK <= FALSE;
        end if;
        

        wait until falling_edge(Clk);
        report "Test de l'acquittement de l'interruption : " severity note;
        IRQ0 <= '0';
        IRQ_SERV <= '1';
        wait until rising_edge(Clk);
        wait until rising_edge(Clk);
        wait for 1 ns;
        if VICPC = x"00000000" and IRQ = '0' then
            report "Le test de l'acquittement du serveur a ete reussi." severity note;
        else
            report "Le test de l'acquittement du serveur n'a pas ete reussi." severity note;
            OK <= FALSE;
        end if;
        
        if (OK) then
            report "Le composant VIC a ete valide avec succes." severity note;
        else
            report "Le composant VIC contient des erreurs." severity error;
        end if;

        report "Fin de la simulation.";
        wait;
    end process;

end testbench;
