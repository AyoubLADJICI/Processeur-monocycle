library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_unite_de_traitement is
end tb_unite_de_traitement;

architecture testbench of tb_unite_de_traitement is
    constant CLK_PERIOD : time := 10 ns;

    signal Clk, Reset : std_logic := '0';
    signal OP : std_logic_vector(2 downto 0);
    signal RA, RB, RW : std_logic_vector(3 downto 0);
    signal WE, COM1, COM2 : std_logic;
    signal Imm : std_logic_vector(7 downto 0);
    signal WrEN : std_logic;
    signal N,Z,C,V : std_logic;
    signal Sout : std_logic_vector(31 downto 0);
    signal OK : boolean := TRUE;

begin
    --Instanciation de l'unité de traitement
    UUT: entity work.unite_de_traitement
    port map(Clk => Clk, Reset => Reset, OP => OP, RA => RA, RB => RB, RW => RW, WE => WE, COM1 => COM1, COM2 => COM2, Imm => Imm, WrEN => WrEN, flag(0) => N, flag(1) => Z, flag(2) => C, flag(3) => V, Sout => Sout);

    Clk_Process: process
    begin
        while (now <= 100 ns) loop
            Clk <= '0';
            wait for CLK_PERIOD;
            Clk <= '1';
            wait for CLK_PERIOD;
        end loop;
        wait;
    end process;

    Test_Process: process
    begin
        report "Debut de la simulation";
        Reset <= '1';
        OP <= "000";
        RA <= "0000"; 
        RB <= "0000";
        RW <= "0000";
        WE <= '0';
        COM1 <= '0';
        COM2 <= '0';
        WrEN <= '0';
        Imm <= (others => '0');
        wait for 1 ns;

        --Test 1 : Addition de 2 registres
        Reset <= '0';
        OP <= "000"; --Addition
        RA <= "1111"; 
        RB <= "0001";
        RW <= "0010";
        WE <= '1';
        COM1 <= '0';
        COM2 <= '0';
        WrEN <= '1';
        wait until rising_edge(Clk);
        wait for 1 ns;
        if Sout = x"00000030" then
            report "Test 1: Addition de 2 registres reussie." severity note;
        else
            report "Test 1: Addition de 2 registres echouee." severity error;
            OK <= FALSE;
        end if;

        --Test 2 : Addition d'un registre avec une valeur immédiate
        OP <= "000"; --Addition
        RA <= "0010";
        RB <= "1111";
        RW <= "0011";
        COM1 <= '1';
        COM2 <= '0';
        Imm <= x"02"; -- Valeur immédiate à ajouter
        wait until rising_edge(Clk);
        wait for 1 ns;
        if Sout = x"00000032" then
            report "Test 2: Addition d'un registre avec une valeur immediate reussie." severity note;
        else
            report "Test 2: Addition d'un registre avec une valeur immediate echouee." severity error;
            OK <= FALSE;
        end if;

        --Test 3 : Soustraction de 2 registres
        OP <= "010"; --Soustraction
        RA <= "0011";
        RB <= "1111";
        RW <= "0100";
        COM1 <= '0';
        COM2 <= '0';
        wait until rising_edge(Clk);
        wait for 1 ns;
        if Sout = x"00000002" then
            report "Test 3: Soustraction de 2 registres reussie." severity note;
        else
            report "Test 3: Soustraction de 2 registres echouee." severity error;
            OK <= FALSE;
        end if;

        --Test 4 : Soustraction d'une valeur immédiate à un registre
        OP <= "010"; --Soustraction
        RA <= "0011";
        RB <= "0000";
        RW <= "0101";
        COM1 <= '1';
        COM2 <= '0';
        Imm <= x"80"; -- Valeur immédiate à soustraire
        wait until rising_edge(Clk);
        wait for 1 ns;
        if Sout = x"000000B2" then
            report "Test 4: Soustraction d'une valeur immediate a un registre reussie." severity note;
        else
            report "Test 4: Soustraction d'une valeur immediate a un registre echouee." severity error;
            OK <= FALSE;
        end if;

        --Test 5 : Copie de la valeur d'un registre dans un autre registre
        OP <= "011"; --Copie de R(A) dans R(W)
        RA <= "0101";
        RB <= "0000";
        RW <= "0111";
        COM1 <= '0';
        COM2 <= '0';
        wait until rising_edge(Clk);
        wait for 1 ns;
        if Sout = x"000000B2" then
            report "Test 5: Copie de la valeur d'un registre dans un autre registre reussie." severity note;
        else
            report "Test 5: Copie de la valeur d'un registre dans un autre registre echouee." severity error;
            OK <= FALSE;
        end if;

        --Test 6 : Écriture d'un registre dans un mot de la mémoire
        RA <= "0000";
        RB <= "1111";
        RW <= "0000";
        COM1 <= '0';
        COM2 <= '1';
        wait until rising_edge(Clk);
        wait for 1 ns;
        if Sout = x"00000030" then
            report "Test 6: Ecriture d'un registre dans un mot de la memoire reussie." severity note;
        else
            report "Test 6: Ecriture d'un registre dans un mot de la memoire echouee." severity error;
            OK <= FALSE;
        end if;

        --Test 7 : Lecture d'un mot de la mémoire dans un registre
        OP <= "000";
        RA <= "0100";
        RB <= "0100";
        RW <= "0000";
        WE <= '0';
        COM1 <= '1';
        COM2 <= '1';
        Imm <= x"3D";
        wait until rising_edge(Clk);
        wait for 1 ns;
        if Sout = x"00000002" then
            report "Test 7: Lecture d'un mot de la memoire dans un registre reussie." severity note;
        else
            report "Test 7: Lecture d'un mot de la memoire dans un registre echouee." severity error;
            OK <= FALSE;
        end if;

        if (OK) then
            report "L'unite de traitement a ete simule avec succes." severity note;
        else
            report "La simulation contient des erreurs." severity error;
        end if;

        report "Fin de la simulation.";
        wait;
    end process;
end architecture;
