library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_ual is
end tb_ual;

architecture testbench of tb_ual is
    signal OP : std_logic_vector(2 downto 0);
    signal A, B : std_logic_vector(31 downto 0);
    signal S : std_logic_vector(31 downto 0);
    signal N, Z, C, V : std_logic;
    signal OK : boolean := TRUE;

begin
    -- Instanciation de l'UAL
    ual_inst : entity work.ual
        port map (OP => OP, A => A, B => B, S => S, N => N, Z => Z, C => C, V => V);

    process
    begin
        report "Debut de la simulation";
        -- Test d'addition
        OP <= "000"; 
        A <= X"00000001"; -- 1
        B <= X"00000002"; -- 2
        wait for 10 ns;
        if N = '0' and Z = '0' and C = '0' and V = '0' and S = x"00000003" then
            report "L addition de A et B (A=1 et B=2) donne bien S = 3 et tous les drapeaux ont pris la bonne valeur." severity note;
        else
            report "Une erreur a ete signale dans l'addition A + B (A = 1 et B = 2) soit dans la valeur de S soit dans les valeurs des drapeaux." severity error;
            OK <= FALSE;
        end if;
   
        A <= X"00000000"; -- 0
        B <= X"00000000"; -- 0
        wait for 10 ns;
        if N = '0' and Z = '1' and C = '0' and V = '0' and S = x"00000000" then
            report "L addition de A et B (A=0 et B=0) donne bien S = 0 et tous les drapeaux ont pris la bonne valeur." severity note;
        else
            report "Une erreur a ete signale dans l'addition A + B (A = 0 et B = 0) soit dans la valeur de S soit dans les valeurs des drapeaux." severity error;
            OK <= FALSE;
        end if;
        
        A <= X"80000000"; -- 2147483648
        B <= X"80000000"; -- 2147483648
        wait for 10 ns;
        if N = '0' and Z = '1' and C = '1' and V = '1' and S = x"00000000"  then
           report "L addition de A et B (A=2147483648 et B=2147483648) genere bien un debordement et donc impossible de stocker le resultat dans S (32 bits) et tous les drapeaux ont pris la bonne valeur." severity note;
        else
            report "Une erreur a ete signale dans l'addition A + B (A = 2147483648 et B = 2147483648) soit dans la valeur de S soit dans les valeurs des drapeaux." severity error;
            OK <= FALSE;
        end if;

        --Test d'affectation de B à la sortie
        OP <= "001";
        B <= x"02345678";
        wait for 10 ns;
        if N = '0' and Z = '0' and C = '0' and V = '0' and S = x"02345678" then
            report "L affectation de B a la sortie est un succes" severity note;
        else
            report "L affectation de B a la sortie a echoue" severity error;
            OK <= FALSE;
        end if;

        -- Test de soustraction
        OP <= "010"; 
        A <= X"00000005"; -- 5
        B <= X"00000003"; -- 3
        wait for 10 ns;
        if N = '0' and Z = '0' and C = '0' and V = '0' and S = x"00000002"  then
            report "La soustraction de A et B (A=5 et B=3) donne bien S = 2 et tous les drapeaux ont pris la bonne valeur." severity note;
        else
            report "Une erreur a ete signale dans la soustraction A - B (A = 5 et B = 3) soit dans la valeur de S soit dans les valeurs des drapeaux." severity error;
            OK <= FALSE;
        end if;
        
        A <= X"FFFFFFF6"; -- -10
        B <= X"00000005"; -- 5
        wait for 10 ns;
        if N = '1' and Z = '0' and C = '0' and V = '0' and S = x"FFFFFFF1"  then
            report "La soustraction de A et B (A = -10 et B = 5) donne bien S = -15 et tous les drapeaux ont pris la bonne valeur." severity note;
        else
            report "Une erreur a ete signale dans la soustraction A - B (A = -10 et B = 5) soit dans la valeur de S soit dans les valeurs des drapeaux." severity error;
            OK <= FALSE;
        end if;

        -- Test d'affectation de A à la sortie
        OP <= "011";
        A <= x"87654321";
        wait for 10 ns;
        if N = '1' and Z = '0' and C = '0' and V = '0' and S = x"87654321" then
            report "L affectation de A a la sortie est un succes" severity note;
        else
            report "L affectation de A a la sortie a echoue" severity error;
            OK <= FALSE;
        end if;

        -- Test de AND
        OP <= "101"; 
        A <= X"FFFFFFFF"; 
        B <= X"00F0F0F0"; 
        wait for 10 ns;
        if N = '0' and Z = '0' and C = '0' and V = '0' and S = x"00F0F0F0"  then
            report "L operation AND a ete reussi." severity note;
        else
            report "L operation AND a echoue." severity error;
            OK <= FALSE;
        end if;

        -- Test de OR
        OP <= "100"; 
        A <= X"F0F0F0F0"; 
        B <= X"0F0F0F0F"; 
        wait for 10 ns;
        if N = '1' and Z = '0' and C = '0' and V = '0' and S = x"FFFFFFFF"  then
            report "L operation OR a ete reussi." severity note;
        else
            report "L operation OR a echoue." severity error;
            OK <= FALSE;
        end if;

        -- Test de XOR
        OP <= "110"; 
        A <= X"0000000F"; 
        B <= X"000000F0"; 
        wait for 10 ns;
        if N = '0' and Z = '0' and C = '0' and V = '0' and S = x"000000FF"  then
            report "L operation XOR a ete reussi." severity note;
        else
            report "L operation XOR a echoue." severity error;
            OK <= FALSE;
        end if;

        -- Test de NOT
        OP <= "111"; -- NOT
        A <= X"FFFFFFFF"; 
        wait for 10 ns;
        if N = '0' and Z = '1' and C = '0' and V = '0' and S = x"00000000"  then
            report "L operation NOT a ete reussi." severity note;
        else
            report "L operation NOT a echoue." severity error;
            OK <= FALSE;
        end if;

        if (OK) then
            report "UAL valide avec succes" severity note;
        else
            report "UAL contient des erreurs" severity error;
        end if;

        report "Fin de la simulation.";
        wait;
    end process;

end testbench;
