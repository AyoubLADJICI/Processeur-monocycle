library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_unite_de_gestion is
end tb_unite_de_gestion;

architecture testbench of tb_unite_de_gestion is
    constant CLK_PERIOD : time := 10 ns;
    signal Clk, Reset, nPCsel : std_logic := '0';
    signal Offset : std_logic_vector(23 downto 0) := (others => '0');
    signal Instruction : std_logic_vector(31 downto 0);
    signal OK : boolean := TRUE;

begin
    -- Instanciation de l'unité de gestion
    UUT: entity work.unite_de_gestion
    port map (Offset => Offset, Clk => Clk, Reset => Reset, nPCsel => nPCsel, Instruction => Instruction);

    Clk_Process: process
    begin
        while now < 30 ns loop
            Clk <= '0';
            wait for CLK_PERIOD / 2;
            Clk <= '1';
            wait for CLK_PERIOD / 2;
        end loop;
        wait;
    end process;

    Test_Process: process
    begin
        report "Debut de la simulation";
        Reset <= '1';
        wait for 2 ns;
        Reset <= '0';
        if Instruction = x"E3A01020" then
            report "Test Instuction = mem(0) = x'E3A01020' reussi." severity note;
        else
            report "Test Instuction = mem(0) = x'E3A01020' echoue." severity note;
            OK <= FALSE;
        end if;

        --Test avec nPCsel = 0 (PC = PC + 1)
        nPCsel <= '0';
        wait until rising_edge(Clk);
        wait for 1 ns;
        if Instruction = x"E3A02000" then
            report "Test nPCsel = 0 :" severity note;
            report "Test Instuction = mem(1) = x'E3A02000' reussi." severity note;
        else
            report "Test nPCsel = 0 :" severity note;
            report "Test Instuction = mem(1) = x'E3A02000' echoue." severity error;
            OK <= FALSE;
        end if;
        
        wait for 2 ns;
        Reset <= '1';
        wait for 2 ns;
        Reset <= '0';
        --Test avec nPCsel = 1 (PC = PC + 1 + SignExtOffset)
        nPCsel <= '1';
        Offset <= x"000005"; 
        wait until rising_edge(Clk);
        wait for 1 ns;
        if Instruction = x"BAFFFFFB" then
            report "Test nPCsel = 1 :" severity note;
            report "Test Instuction = mem(1) = x'BAFFFFFB' reussi." severity note;
        else
            report "Test nPCsel = 1 :" severity note;
            report "Test Instuction = mem(1) = x'BAFFFFFB' echoue." severity error;
            OK <= FALSE;
        end if;
        Reset<='1';

        if (OK) then
            report "L'unite de gestion a ete simule avec succes." severity note;
        else
            report "La simulation contient des erreurs." severity error;
        end if;

        report "Fin de la simulation";
        
        wait;
    end process;
end testbench;
