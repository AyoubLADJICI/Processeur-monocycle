library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;

entity tb_ual_et_banc_de_registre is
end entity;

architecture testbench of tb_ual_et_banc_de_registre is
    constant CLK_PERIOD : time := 10 ns;

    signal Clk : std_logic := '0';
    signal Rst : std_logic := '0';
    signal RA, RB, RW : std_logic_vector(3 downto 0);
    signal WE : std_logic := '0';
    signal OP : std_logic_vector(2 downto 0);
    signal Wout : std_logic_vector(31 downto 0);
    signal OK : boolean := TRUE;

begin
    -- Instanciation de l'assemblage du banc de registres et de l'ual 
    UUT: entity work.ual_et_banc_de_registre
    port map (Clk => Clk, Rst => Rst, OP => OP , RA => RA, RB => RB, RW => RW, WE => WE, Wout => Wout);

    Clk_Process: process
    begin
        while (now <= 350 ns) loop
            Clk <= '0';
            wait for CLK_PERIOD;
            Clk <= '1';
            wait for CLK_PERIOD;
        end loop;
        wait;
    end process;
    
    Test_Process: process
    type table is array(15 downto 0) of std_logic_vector(31 downto 0);
    alias banc_tb : table is <<signal .UUT.I_banc_de_registre.Banc : table>>;
        begin
        report "Debut de la simulation";
        Rst <= '1';
        OP <= "000";
        RA <= "0000"; 
        RB <= "0000"; 
        RW <= "0000"; 

        wait for 1 ns;
            
        -- Test de l'opération R(1) = R(15)
        Rst <= '0';
        RA <= "1111"; 
        RB <= "0000"; 
        RW <= "0001"; 
        WE <= '1';
        OP <= "011";  -- Opération de copie de R(A) dans R(W) 
        wait until rising_edge(Clk);
        wait for 1 ns;
        if banc_tb(1) = x"00000030" then
            report "Test 1 (R(1) = R(15) reussi." severity note;
        else
            report "Test 1 (R(1) = R(15) echoue." severity warning;
            OK <= False;
        end if;

        -- Test de l'opération R(1) = R(1) + R(15)
        RA <= "1111"; 
        RB <= "0001"; 
        RW <= "0001";
        OP <= "000";  --Addition 
        wait until rising_edge(Clk);
        wait for 1 ns;
        if banc_tb(1) = x"00000060" then
            report "Test 2 (R(1) = R(1) + R(15) reussi." severity note;
        else
            report "Test 2 (R(1) = R(1) + R(15) echoue." severity warning;
            OK <= False;
        end if;

        -- Test de l'opération R(2) = R(1) + R(15)
        RA <= "1111"; 
        RB <= "0001"; 
        RW <= "0010"; 
        OP <= "000";  -- 
        wait until rising_edge(Clk);
        wait for 1 ns;
        if banc_tb(2) = x"00000090" then
            report "Test 3 (R(2) = R(1) + R(15)) reussi." severity note;
        else
            report "Test 3 (R(2) = R(1) + R(15)) echoue." severity warning;
            OK <= False;
        end if;

        -- Test de l'opération R(3) = R(1) - R(15)
        RA <= "0001"; 
        RB <= "1111"; 
        RW <= "0011"; 
        OP <= "010";  -- Soustraction 
        wait until rising_edge(Clk);
        wait for 1 ns;
        if banc_tb(3) = x"00000030" then
            report "Test 4 (R(3) = R(1) - R(15)) reussi." severity note;
        else
            report "Test 4 (R(3) = R(1) - R(15)) echoue." severity warning;
            OK <= False;
        end if;

        -- Test de l'opération R(5) = R(7) - R(15)
        RA <= "0111"; 
        RB <= "1111"; 
        RW <= "0101"; 
        OP <= "010";  -- Soustraction
        wait until rising_edge(Clk);
        wait for 1 ns;
        if banc_tb(5) = x"FFFFFFD0" then
            report "Test 5 (R(5) = R(7) - R(15)) reussi." severity note;
        else
            report "Test 5 (R(5) = R(7) - R(15)) echoue." severity warning;
            OK <= False;
        end if;
    
        if (OK) then
            report "L assemblage de l UAL et le banc de registre a ete simule avec succes" severity note;
        else
            report "La simulation contient des erreurs" severity error;
        end if;
    
        report "Fin de la simulation.";
        wait;
    end process;
end architecture;