library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;

entity tb_mux2v1 is
end entity;

architecture testbench of tb_mux2v1 is
    constant N : integer := 8;
    signal A, B, S : std_logic_vector(N-1 downto 0);
    signal COM : std_logic := '0';
    signal OK : boolean := TRUE;

begin
    --Instanciation du multiplexeur
    UUT: entity work.mux2v1
    generic map(N => 8) -- Taille des données (4 bits)
    port map(A => A, B => B, COM => COM, S => S);

    Test_Process: process
    begin
        report "Debut de la simulation";
        --Test 1 : Sélection de l'entrée A (COM = '0')
        COM  <= '0';
        A <= "01011101";
        B <= "11010101";
        wait for 1 ns;
        if S = A then
            report "Test 1: Selection de l'entree A reussie." severity note;
        else
            report "Test 1: Selection de l'entree A echouee." severity error;
            OK <= False;
        end if;

        --Test 2 : Sélection de l'entrée B (COM = '1')
        COM  <= '1';
        wait for 1 ns;
        if S = B then
            report "Test 2: Selection de l'entree B reussie." severity note;
        else
            report "Test 2: Selection de l'entree B echouee." severity error;
            OK <= False;
        end if;

        if (OK) then
            report "Multipleur 2 vers 1 a ete simule avec succes" severity note;
        else
            report "La simulation contient des erreurs" severity error;
        end if; 

        report "Fin de la simulation.";
        wait;
    end process;
end architecture;
