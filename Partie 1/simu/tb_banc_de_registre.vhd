library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;

entity tb_banc_de_registre is
end entity;

architecture testbench of tb_banc_de_registre is
    constant CLK_PERIOD : time := 10 ns;

    signal Clk, Rst : std_logic := '0';
    signal RA, RB, RW : std_logic_vector(3 downto 0);
    signal WE : std_logic := '0';
    signal A, B, W : std_logic_vector(31 downto 0);
    signal OK : boolean := TRUE;

begin
    --Instanciation du banc de registres
    UUT: entity work.banc_de_registre
    port map(Clk => Clk, Rst => Rst, W => W, RA => RA, RB => RB, RW => RW, WE => WE, A => A, B => B);

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
    alias banc_tb : table is <<signal UUT.Banc : table>>;
        begin
        report "Debut de la simulation";
        Rst <= '1';
        RA <= "0000";
        RB <= "0000";
        RW <= "0000";
        W <= x"00000000";

        wait for 2 ns;

        Rst <= '0';
        --Test 1 : Ecriture de 93 dans le registre 7
        W <= x"0000005D"; --93 en decimale
        RW <= "0111";
        WE <= '1';
        wait until rising_edge(clk);
        wait for 1 ns;
        if banc_tb(to_integer(unsigned(RW))) = x"0000005D" then
            report "Test 1 : Ecriture dans R(7) reussi (R(7) = 93)." severity note;
        else
            report "Test 1 : Ecriture dans R(7) echoue (R(7) doit valoir 93)." severity warning;
            OK <= False;
        end if;
        wait for 2 ns;

        --Test 2: Lecture du registre 7 et 15
        RA <= "0111";
        RB <= "1111";
        WE <= '0';
        wait for 1 ns;
        if banc_tb(to_integer(unsigned(RA))) = x"0000005D" and banc_tb(to_integer(unsigned(RB))) = x"00000030" then
            report "Test 2 : Lecture de R(7) et R(15) reussi (R(7) = 93 et R(15) = 48)." severity note;
        else
            report "Test 2 : Lecture de R(7) et R(15) echoue (R(7) doit valoir 93 ou R(15) doit valoir 48)." severity warning;
            OK <= False;
        end if;
        wait for 2 ns;

        --Test 3 : Ecriture de 26 dans le registre 3
        W <= x"0000001A"; --26 en decimale
        RW <= "0011";
        WE <= '1';
        wait until rising_edge(clk);
        wait for 1 ns;
        if banc_tb(to_integer(unsigned(RW))) = x"0000001A" then
            report "Test 3 : Ecriture dans R(3) reussi (R(3) = 26)." severity note;
        else
            report "Test 3 : Ecriture dans R(3) echoue (R(3) doit valoir 26)." severity warning;
            OK <= False;
        end if;
        wait for 2 ns;

        --Test 4: Lecture du registre 3 
        RA <= "0011";
        WE <= '0';
        wait for 1 ns;
        if banc_tb(to_integer(unsigned(RA))) = x"0000001A" then
            report "Test 4 : Lecture de R(3) reussi (R(3) = 26)." severity note;
        else
            report "Test 4 : Lecture de R(3) echoue (R(3) doit valoir 26)." severity warning;
            OK <= False;
        end if;
        wait for 2 ns;

        --Test 5: Ecriture de 213 dans le registre 15
        W <= x"000000D5"; --213 en decimale
        RW <= "1111";
        WE <= '1';
        wait until rising_edge(clk);
        wait for 1 ns;
        if banc_tb(to_integer(unsigned(RW))) = x"000000D5" then
            report "Test 5 : Ecriture dans R(15) reussi (R(15) = 213)." severity note;
        else
            report "Test 5 : Ecriture dans R(15) echoue (R(15) doit valoir 213)." severity warning;
            OK <= False;
        end if;
        wait for 2 ns;

        if (OK) then
            report "Banc de registre simule avec succes" severity note;
        else
            report "La simulation contient des erreurs" severity error;
        end if; 

        report "Fin de la simulation.";
        wait;
    end process;
end architecture;