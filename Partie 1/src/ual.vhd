library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ual is
    Port(
        OP : in std_logic_vector(2 downto 0); --Signal de commande permettant de distinguer les differentes operations
        A, B : in std_logic_vector(31 downto 0);
        S : out std_logic_vector(31 downto 0);
        N,Z,C,V : out std_logic
    );
end entity;

architecture Behavorial of ual is
begin
    process(OP, A, B) is
        variable Y : std_logic_vector(31 downto 0);
        variable resultat : std_logic_vector(32 downto 0);
    begin
        case OP is
            when "000" => --Addition (A+B)
                resultat := std_logic_vector(('0' & signed(A)) + ('0' & signed(B)));
                Y := std_logic_vector(signed(A) + signed(B));
            when "001" => --La sortie Y recupere la donnee dans le bus B 
                resultat := std_logic_vector('0' & signed(B));
                Y := B;
            when "010" => --Soustraction (A-B)
                resultat := std_logic_vector('0' & signed(A) - ('0' & signed(B)));
                Y := std_logic_vector(signed(A) - signed(B));
            when "011" => --La sortie Y recupere la donnee dans le bus A 
                resultat := std_logic_vector('0' & signed(A));
                Y := A;
            when "100" => --Operation boolenne : A OR B
                resultat := std_logic_vector('0' & signed(A) or ('0' & signed(B)));
                Y := A or B;
            when "101" => --Operation boolenne : A AND B
                resultat := std_logic_vector('0' & signed(A) and ('0' & signed(B)));
                Y := A and B;
            when "110" => --Operation boolenne : A XOR B
                resultat := std_logic_vector('0' & signed(A) xor ('0' & signed(B)));
                Y := A xor B;
            when "111"=> --Operation boolenne : NOT(A)
                resultat := std_logic_vector('0' & not(signed(A)));
                Y := not(A);
            when others =>
                Y := (others => '0');
        end case;
        if Y(31) = '1' then
            N <= '1';
        else
            N <= '0';
        end if;
        if Y = (31 downto 0 => '0') then
            Z <= '1';
        else
            Z <= '0';
        end if;
        if resultat(32) = '1' then
            C <= '1';
        else
            C <= '0';
        end if;
        if (A(31) = B(31) and Y(31) /= A(31)) then
            V <= '1';
        else
            V <= '0';
        end if;
        S <= Y; 
    end process;
end Behavorial;