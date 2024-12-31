library ieee;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity vic is
    port(
        Clk: in std_logic;
        Reset: in std_logic;
        IRQ_SERV: in std_logic;
        IRQ0: in std_logic;
        IRQ1: in std_logic;
        IRQ: out std_logic;
        VICPC: out std_logic_vector(31 downto 0)
    );
end entity;

architecture Behavioral of vic is
--Déclaration des signaux internes
signal IRQ0_memo, IRQ0_etatprecedent : std_logic;
signal IRQ1_memo, IRQ1_etatprecedent : std_logic;

begin
    process(Clk, Reset)
    begin
        if Reset = '1' then
            IRQ0_memo <= '0'; 
            IRQ0_etatprecedent <= '0';
            IRQ1_memo <= '0'; 
            IRQ1_etatprecedent <= '0';
            VICPC <= (others => '0');
        elsif rising_edge(Clk) then
            IRQ0_etatprecedent <= IRQ0;
            IRQ1_etatprecedent <= IRQ1;

            if IRQ0 = '1' and IRQ0_etatprecedent = '0' then --Detection d'un front montant sur IRQ0 
                IRQ0_memo <= '1';
            end if;

            if IRQ1 = '1' and IRQ1_etatprecedent = '0' then --Detection d'un front montant sur IRQ1
                IRQ1_memo <= '1';
            end if;

            if IRQ_SERV = '1' then
                IRQ0_memo <= '0';
                IRQ1_memo <= '0';
            end if;

            if IRQ0 = '0' and IRQ1_memo = '0' then
                VICPC <= (others => '0');
            end if;
        
            if IRQ0 = '1' then
                VICPC <= x"00000009";
            elsif IRQ1_memo = '1' then
                VICPC <= x"00000015";
            end if;
        end if;
    end process;
    IRQ <= IRQ1_memo or IRQ0_memo;
end architecture;
