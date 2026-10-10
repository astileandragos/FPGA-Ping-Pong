library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity seven_seg_controller is
    Port ( clk      : in  STD_LOGIC;
           score1   : in  integer range 0 to 9;
           score2   : in  integer range 0 to 9;
           segments : out STD_LOGIC_VECTOR(6 downto 0); 
           anodes   : out STD_LOGIC_VECTOR(7 downto 0)); 
end seven_seg_controller;

architecture Behavioral of seven_seg_controller is
    signal refresh_cnt : unsigned(19 downto 0) := (others => '0');
    signal digit_val   : integer range 0 to 9;
begin

process(clk)
begin

    if rising_edge(clk) then 
    refresh_cnt <= refresh_cnt + 1; 
    end if;
    
end process;

process(refresh_cnt(19), score1, score2) 
begin

        if refresh_cnt(19) = '0' then
            anodes <= "01111111"; 
            digit_val <= score1;
        else
            anodes <= "11111110"; 
            digit_val <= score2;
        end if;
        
end process;


with digit_val select
       segments <=  "1000000" when 0, 
                    "1111001" when 1, 
                    "0100100" when 2,
                    "0110000" when 3, 
                    "0011001" when 4, 
                    "0010010" when 5,
                    "0000010" when 6, 
                    "1111000" when 7, 
                    "0000000" when 8,
                    "0010000" when 9, 
                    "1111111" when others;
end Behavioral;