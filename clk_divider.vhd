library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity clk_divider is
    Port ( clk      : in  STD_LOGIC;
           tick_out : out STD_LOGIC);
end clk_divider;

architecture Behavioral of clk_divider is
    signal count : integer range 0 to 9999999 := 0;
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if count = 9999999 then
                count <= 0;
                tick_out <= '1';
            else
                count <= count + 1;
                tick_out <= '0';
            end if;
        end if;
    end process;
end Behavioral;