library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity game_fsm is
    Port ( clk    : in  STD_LOGIC;
           rst    : in  STD_LOGIC;
           tick   : in  STD_LOGIC;
           btnL   : in  STD_LOGIC;
           btnR   : in  STD_LOGIC;
           led    : out STD_LOGIC_VECTOR(15 downto 0);
           score1 : out integer range 0 to 9;
           score2 : out integer range 0 to 9);
end game_fsm;

architecture Behavioral of game_fsm is

    type state_type is (START, MOVE_RIGHT, MOVE_LEFT, FLASH);
    signal state, next_state : state_type;
    signal led_reg   : STD_LOGIC_VECTOR(15 downto 0) := x"8000";
    signal s1, s2    : integer range 0 to 9 := 0;
    signal flash_cnt : integer range 0 to 4 := 0; 
    
begin

    process(clk, rst)
    begin
        if rst = '1' then
            state <= START;
            led_reg <= x"8000";
            s1 <= 0;
            s2 <= 0;
            flash_cnt <= 0;
        elsif rising_edge(clk) then
            state <= next_state;
            
            if state = START then
                led_reg <= x"8000";
                flash_cnt <= 0;
                
            elsif state = FLASH then
                if tick = '1' then
                    led_reg <= not led_reg; 
                    if flash_cnt = 4 then
                        flash_cnt <= 0;
                    else
                        flash_cnt <= flash_cnt + 1;
                    end if;
                end if;
            elsif tick = '1' then
                if state = MOVE_RIGHT then
                    led_reg <= '0' & led_reg(15 downto 1);
                elsif state = MOVE_LEFT then
                    led_reg <= led_reg(14 downto 0) & '0';
                end if;
            end if;

            if state /= FLASH and next_state = FLASH then
                led_reg <= x"FFFF"; 
                if state = MOVE_RIGHT then
                    if s1 < 9 then s1 <= s1 + 1; else s1 <= 0; end if;
                elsif state = MOVE_LEFT then
                    if s2 < 9 then s2 <= s2 + 1; else s2 <= 0; end if;
                end if;
            end if;
            
        end if;
    end process;

    process(state, btnL, btnR, led_reg, tick, flash_cnt)
    begin
        next_state <= state; 
        case state is
            when START =>
                if btnL = '1' then next_state <= MOVE_RIGHT; 
                end if;
            when MOVE_RIGHT =>
                if btnR='1' and led_reg/=x"0001" then
                    next_state<=FLASH;                    
                elsif led_reg = x"0001" then 
                    if btnR = '1' then 
                        next_state <= MOVE_LEFT; 
                    elsif tick = '1' then 
                        next_state <= FLASH; 
                    end if;
                end if;
            when MOVE_LEFT =>
                if btnL='1' and led_reg /=x"8000" then
                    next_state<=FLASH;
                elsif led_reg = x"8000" then 
                    if btnL = '1' then 
                        next_state <= MOVE_RIGHT; 
                    elsif tick = '1' then 
                        next_state <= FLASH; 
                    end if;
                end if;
            when FLASH =>
                if tick = '1' and flash_cnt = 4 then 
                    next_state <= START; 
                end if;
        end case;
    end process;

    led <= led_reg;
    score1 <= s1;
    score2 <= s2;
end Behavioral;