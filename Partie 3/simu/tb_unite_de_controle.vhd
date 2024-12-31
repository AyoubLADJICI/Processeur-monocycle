library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_unite_de_controle is
end tb_unite_de_controle;

architecture testbench of tb_unite_de_controle is
    constant CLK_PERIOD : time := 10 ns;
    signal Clk, Reset : std_logic := '0';
    signal Instruction, busW, flagsNZCV, Afficheur : std_logic_vector(31 downto 0);
    signal nPCSel,PSREn, RegWr, RegSel,RegAff, ALUSrc, WrSrc, MemWr : std_logic;
    signal ALUCtrl : std_logic_vector(2 downto 0);
    signal OK: boolean := TRUE;

begin
    -- Instanciation de l'unité de contrôle
    UUT: entity work.unite_de_controle
    port map (Clk => Clk, Reset => Reset,Instruction => Instruction, busW => busW, flagsNZCV => flagsNZCV,nPCSel => nPCSel,PSREn => PSREn,RegWr => RegWr,RegSel => RegSel, RegAff => RegAff, 
    ALUSrc => ALUSrc,WrSrc => WrSrc,MemWr => MemWr,ALUCtrl => ALUCtrl,Afficheur => Afficheur);

    Clk_Process: process
    begin
        while now < 100 ns loop
            Clk <= '0';
            wait for CLK_PERIOD / 2;
            Clk <= '1';
            wait for CLK_PERIOD / 2;
        end loop;
        wait;
    end process;

    Test_Process: process
    type enum_instruction is (MOV, ADDi, ADDr, CMP, LDR, STR, BAL, BLT);
    alias instr_courante_tb: enum_instruction is <<signal .UUT.I_decodeur.instr_courante : enum_instruction>>;
    begin
        report "Debut de la simulation";
        Reset <= '1';
        Instruction <= x"E0822000"; -- ADD R2,R2,R0 -- R2 = R2 + R0 (addition avec un registre donc ADDr)
        flagsNZCV <= (others => '0');
        wait until rising_edge(Clk);
        wait for 1 ns;
        if (instr_courante_tb = ADDr) then
            report "L'instruction ADDr a bien ete decodee." severity note;
            if (nPCSEL = '0' and RegWr = '1' and ALUSrc = '0' and ALUCtrl = "000" and PSREn = '0' and MemWr = '0' and WrSrc = '0' and RegSel = '0' and RegAff = '0') then
                report "Test ADD R2,R2,R0 -- R2 = R2 + R0 reussi." severity note;
            else
                report "Test ADD R2,R2,R0 -- R2 = R2 + R0 echoue." severity error;
                OK <= FALSE;
            end if;
        else
            report "L'instruction ADDr a mal ete decodee." severity error;
            OK <= FALSE;
        end if;
        
        Instruction <= x"EAFFFFF7";
        wait for 2 ns;
        Reset <= '0';
        -- Simulation de différentes instructions et états du PSR
        Instruction <= x"E3A01020"; -- MOV R1,#0x20 -- R1 = 0x20
        flagsNZCV <= (others => '0');
        wait until rising_edge(Clk);
        wait for 1 ns;
        if (instr_courante_tb = MOV) then
            report "L'instruction MOV a bien ete decodee." severity note;
            if (nPCSEL = '0' and RegWr = '1' and ALUSrc = '1' and ALUCtrl = "001" and PSREn = '0' and MemWr = '0' and WrSrc = '0' and RegAff = '0') then
                report "Test MOV R1,#0x20 -- R1 = 0x20 reussi." severity note;
            else
                report "Test MOV R1,#0x20 -- R1 = 0x20 echoue." severity error;
                OK <= FALSE;
            end if;
        else
            report "L'instruction MOV a mal ete decodee." severity error;
            OK <= FALSE;
        end if;

        Instruction <= x"E3A02000"; -- MOV R2,#0x00 -- R2 = 0
        flagsNZCV <= (others => '0');
        wait until rising_edge(Clk);
        wait for 1 ns;
        if (instr_courante_tb = MOV) then
            report "L'instruction MOV a bien ete decodee." severity note;
            if (nPCSEL = '0' and RegWr = '1' and ALUSrc = '1' and ALUCtrl = "001" and PSREn = '0' and MemWr = '0' and WrSrc = '0' and RegAff = '0') then
                report "Test MOV R2,#0x00 -- R2 = 0 reussi." severity note;
            else
                report "Test MOV R2,#0x00 -- R2 = 0 echoue." severity error;
                OK <= FALSE;
            end if;
        else
            report "L'instruction MOV a mal ete decodee." severity error;
            OK <= FALSE;
        end if;

        Instruction <= x"E6110000"; -- LDR R0,0(R1) -- R0 = DATAMEM[R1]
        flagsNZCV <= (others => '0');
        wait until rising_edge(Clk);
        wait for 1 ns;
        if (instr_courante_tb = LDR) then
            report "L'instruction LDR a bien ete decodee." severity note;
            if (nPCSEL = '0' and RegWr = '1' and ALUSrc = '1' and ALUCtrl = "000" and PSREn = '0' and MemWr = '0' and WrSrc = '1' and RegAff = '0') then
                report "Test LDR R0,0(R1) -- R0 = DATAMEM[R1] reussi." severity note;
            else
                report "Test LDR R0,0(R1) -- R0 = DATAMEM[R1] echoue." severity error;
                OK <= FALSE;
            end if;
        else
            report "L'instruction LDR a mal ete decodee." severity error;
            OK <= FALSE;
        end if;

        Instruction <= x"E0822000"; -- ADD R2,R2,R0 -- R2 = R2 + R0 (addition avec un registre donc ADDr)
        flagsNZCV <= (others => '0');
        wait until rising_edge(Clk);
        wait for 1 ns;
        if (instr_courante_tb = ADDr) then
            report "L'instruction ADDr a bien ete decodee." severity note;
            if (nPCSEL = '0' and RegWr = '1' and ALUSrc = '0' and ALUCtrl = "000" and PSREn = '0' and MemWr = '0' and WrSrc = '0' and RegSel = '0' and RegAff = '0') then
                report "Test ADD R2,R2,R0 -- R2 = R2 + R0 reussi." severity note;
            else
                report "Test ADD R2,R2,R0 -- R2 = R2 + R0 echoue." severity error;
                OK <= FALSE;
            end if;
        else
            report "L'instruction ADDr a mal ete decodee." severity error;
            OK <= FALSE;
        end if;

        Instruction <= x"E2811001"; -- ADD R1,R1,#1 -- R1 = R1 + 1 (addition avec une valeur immediate donc ADDi)
        flagsNZCV <= (others => '0');
        wait until rising_edge(Clk);
        wait for 1 ns;
        if (instr_courante_tb = ADDi) then
            report "L'instruction ADDi a bien ete decodee." severity note;
            if (nPCSEL = '0' and RegWr = '1' and ALUSrc = '1' and ALUCtrl = "000" and PSREn = '0' and MemWr = '0' and WrSrc = '0' and RegAff = '0') then
                report "Test ADD R1,R1,#1 -- R1 = R1 + 1 reussi." severity note;
            else
                report "Test ADD R1,R1,#1 -- R1 = R1 + 1 echoue." severity error;
                OK <= FALSE;
            end if;
        else
            report "L'instruction ADDi a mal ete decodee." severity error;
            OK <= FALSE;
        end if;

        Instruction <= x"E351002A"; -- CMP R1,0x2A -- Flag = R1-0x2A,si R1 <= 0x2A
        flagsNZCV <= (others => '0');
        wait until rising_edge(Clk);
        wait for 1 ns;
        if (instr_courante_tb = CMP) then
            report "L'instruction CMP a bien ete decodee." severity note;
            if (nPCSEL = '0' and RegWr = '0' and ALUSrc = '1' and ALUCtrl = "010" and PSREn = '1' and MemWr = '0' and RegAff = '0') then
                report "Test CMP R1,0x2A -- Flag = R1-0x2A,si R1 <= 0x2A reussi." severity note;
            else
                report "Test CMP R1,0x2A -- Flag = R1-0x2A,si R1 <= 0x2A echoue." severity error;
                OK <= FALSE;
            end if;
        else
            report "L'instruction CMP a mal ete decodee." severity error;
            OK <= FALSE;
        end if;

        Instruction <= x"BAFFFFFB"; -- BLT loop -- PC =PC+1+(-5) si N = 1
        flagsNZCV <= (others => '0');
        wait until rising_edge(Clk);
        wait for 1 ns;
        if (instr_courante_tb = BLT) then
            report "L'instruction BLT a bien ete decodee." severity note;
            if (nPCSEL = flagsNZCV(28) and RegWr = '0' and PSREn = '0' and MemWr = '0' and RegAff = '0') then
                report "Test BLT loop -- PC =PC+1+(-5) si N = 1 reussi." severity note;
            else
                report "Test BLT loop -- PC =PC+1+(-5) si N = 1 echoue." severity error;
                OK <= FALSE;
            end if;
        else
            report "L'instruction BLT a mal ete decodee." severity error;
            OK <= FALSE;
        end if;

        Instruction <= x"E6012000"; -- STR R2,0(R1) -- DATAMEM[R1] = R2
        flagsNZCV <= (others => '0');
        wait until rising_edge(Clk);
        wait for 1 ns;
        if (instr_courante_tb = STR) then
            report "L'instruction STR a bien ete decodee." severity note;
            if (nPCSEL = '0' and RegWr = '0' and ALUSrc = '1' and ALUCtrl = "000" and PSREn = '0' and MemWr = '1' and RegSel = '1' and RegAff = '1') then
                report "Test STR R2,0(R1) -- DATAMEM[R1] = R2 reussi." severity note;
            else
                report "Test STR R2,0(R1) -- DATAMEM[R1] = R2 echoue." severity error;
                OK <= FALSE;
            end if;
        else
            report "L'instruction STR a mal ete decodee." severity error;
            OK <= FALSE;
        end if;

        Instruction <= x"EAFFFFF7"; -- BAL main -- PC=PC+1+(-9)
        wait until rising_edge(Clk);
        wait for 1 ns;
        if (instr_courante_tb = BAL) then
            report "L'instruction BAL a bien ete decodee." severity note;
            if (nPCSEL = '1' and RegWr = '0' and PSREn = '0' and MemWr = '0' and RegAff = '0') then
                report "Test BAL main -- PC=PC+1+(-9) reussi." severity note;
            else
                report "Test BAL main -- PC=PC+1+(-9) echoue." severity error;
                OK <= FALSE;
            end if;
        else
            report "L'instruction BAL a mal ete decodee." severity error;
            OK <= FALSE;
        end if;

        if (OK) then
            report "L'unite de controle a ete simulee avec succes." severity note;
        else
            report "La simulation de l'unite de contrôle contient des erreurs." severity error;
        end if;

        report "Fin de la simulation";
        
        wait;
    end process;
end testbench;
