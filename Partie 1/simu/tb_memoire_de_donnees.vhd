library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_memoire_de_donnees is
end entity tb_memoire_de_donnees;

architecture testbench of tb_memoire_de_donnees is
    constant CLK_PERIOD : time := 10 ns;
    signal CLK, Reset, WrEN : std_logic := '0';
    signal Addr : std_logic_vector(5 downto 0) := (others => '0');
    signal DataIn, DataOut : std_logic_vector(31 downto 0);
    signal OK: boolean := TRUE;

begin
    -- Instanciation du module memoire de données
    UUT: entity work.memoire_de_donnees
    port map (CLK => CLK, Reset => Reset, WrEN => WrEN, Addr => Addr, DataIn => DataIn, DataOut => DataOut);

    clk_process: process
    begin
        while now < 20 ns loop
            clk <= '0';
            wait for CLK_PERIOD / 2;
            clk <= '1';
            wait for CLK_PERIOD / 2;
        end loop;
        wait;
    end process;

    Test_Process: process
    type table is array(63 downto 0) of std_logic_vector(31 downto 0);
    alias memoire_tb : table is <<signal UUT.memoire : table>>;
    begin
        report "Debut de la simulation";
        Reset <= '1';
        WrEN <= '0';
        Addr <= (others => '0');
        DataIn <= (others => '0');

        wait for 2 ns;

        --Test 1
        Reset <= '0';
        DataIn <= x"12345678";
        Addr <= "011010"; -- Adresse arbitraire (26 en decimale)
        WrEN <= '1';
        wait until rising_edge(CLK);
        wait for 1 ns;
        if DataOut = x"12345678" and memoire_tb(to_integer(unsigned(Addr))) = x"12345678" then
            report "Test 1: ecriture et lecture dans la memoire reussies." severity note;
        else
            report "Test 1: ecriture ou lecture dans la memoire echouee." severity error;
            OK <= FALSE;
        end if;

        --Test 2
        Reset <= '0';
        DataIn <= x"11100111";
        Addr <= "111110"; -- Adresse arbitraire (62 en decimale)
        WrEN <= '1';
        wait until rising_edge(CLK);
        wait for 1 ns;
        if DataOut = x"11100111" and memoire_tb(to_integer(unsigned(Addr))) = x"11100111" then
            report "Test 2: ecriture et lecture dans la memoire reussies." severity note;
        else
            report "Test 2: ecriture ou lecture dans la memoire echouee." severity error;
            OK <= FALSE;
        end if;

        if (OK) then
            report "La memoire de donnees a ete simule avec succes." severity note;
        else
            report "La simulation contient des erreurs." severity error;
        end if;

        report "Fin de la simulation.";
        wait;
    end process;
end architecture testbench;
