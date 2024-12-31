library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Decodeur is
    port(
        Instruction, PSR : in std_logic_vector(31 downto 0);
        nPC_SEL, PSREn, RegWr, RegSel, ALUSrc, WrSrc, MemWr, RegAff : out std_logic;
        ALUCtrl : out std_logic_vector(2 downto 0);
        IRQ_END : out std_logic
    );
end entity;

architecture Behavioural of Decodeur is
    type enum_instruction is (MOV, ADDi, ADDr, CMP, LDR, STR, BAL, BLT, BX); 
    signal instr_courante: enum_instruction;
begin
    process(Instruction)
    begin
        if Instruction(31 downto 20) = "111000111010" then --x"E3A"
            instr_courante <= MOV;
        elsif Instruction(31 downto 20) = "111000101000" then --x"E28"
            instr_courante <= ADDi;
        elsif Instruction(31 downto 20) = "111000001000" then --x"E08"
            instr_courante <= ADDr;
        elsif Instruction(31 downto 20) = "111000010101" or Instruction(31 downto 20) = "111000110101" then
            instr_courante <= CMP;
        elsif Instruction(31 downto 20) = "111001100001" then
            instr_courante <= LDR;
        elsif Instruction(31 downto 20) = "111001100000" then
            instr_courante <= STR;
        elsif Instruction(31 downto 24) = "11101010" then --x"EA"
            instr_courante <= BAL;
        elsif Instruction(31 downto 24) = "10111010" then --x"BA"
            instr_courante <= BLT;
        elsif Instruction = x"EB000000" then 
            instr_courante <= BX;
        end if;
    end process;

    process(Instruction, instr_courante)
    begin
        case instr_courante is
            when MOV =>
                nPC_SEL <= '0';
                RegWr <= '1';
                ALUSrc <= '1';
                ALUCtrl <= "001";
                PSREn <= '0';
                MemWr <= '0';
                WrSrc <= '0';
                RegAff <= '0';
            when ADDi =>
                nPC_SEL <= '0';
                RegWr <= '1';
                ALUSrc <= '1';
                ALUCtrl <= "000";
                PSREn <= '0';
                MemWr <= '0';
                WrSrc <= '0';
                RegAff <= '0';
            when ADDr =>
                nPC_SEL <= '0';
                RegWr <= '1';
                ALUSrc <= '0';
                ALUCtrl <= "000";
                PSREn <= '0';
                MemWr <= '0';
                WrSrc <= '0';
                RegSel <= '0';
                RegAff <= '0'; 
            when CMP =>
                nPC_SEL <= '0';
                RegWr <= '0';
                ALUSrc <= '1';
                ALUCtrl <= "010";
                PSREn <= '1';
                MemWr <= '0';
                RegAff <= '0';
            when LDR =>
                nPC_SEL <= '0';
                RegWr <= '1';
                ALUSrc <= '1';
                ALUCtrl <= "000";
                PSREn <= '0';
                MemWr <= '0';
                WrSrc <= '1';
                RegAff <= '0';
            when STR =>
                nPC_SEL <= '0';
                RegWr <= '0';
                ALUSrc <= '1';
                ALUCtrl <= "000";
                PSREn <= '0';
                MemWr <= '1';
                RegSel <= '1';
                RegAff <= '1';
            when BAL =>
                nPC_SEL <= '1';
                RegWr <= '0';
                PSREn <= '0';
                MemWr <= '0';
                RegAff <= '0';
            when BLT =>
                nPC_SEL <= PSR(28); 
                RegWr <= '0';
                PSREn <= '0';
                MemWr <= '0';
                RegAff <= '0'; 
            when BX =>
                IRQ_END <= '1'; 
            when others =>
                nPC_SEL <= '0';
                RegWr <= '0';
                ALUSrc <= '0';
                ALUCtrl <= "000";
                PSREn <= '0';
                MemWr <= '0';
                WrSrc <= '0';
                RegSel <= '0';
                RegAff <= '0';
        end case;
    end process;
end architecture;
