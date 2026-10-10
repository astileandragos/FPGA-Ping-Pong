library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ping_pong_top is
    Port ( clk      : in STD_LOGIC;
           rst      : in STD_LOGIC;
           btnL     : in STD_LOGIC;
           btnR     : in STD_LOGIC;
           led      : out STD_LOGIC_VECTOR(15 downto 0);
           segments : out STD_LOGIC_VECTOR(6 downto 0);
           anodes   : out STD_LOGIC_VECTOR(7 downto 0));
end ping_pong_top;

architecture Behavioral of ping_pong_top is

    component clk_divider is
        Port ( clk : in STD_LOGIC; tick_out : out STD_LOGIC);
    end component;

    component game_fsm is
        Port ( clk, rst, tick, btnL, btnR : in STD_LOGIC;
               led : out STD_LOGIC_VECTOR(15 downto 0);
               score1, score2 : out integer range 0 to 9);
    end component;

    component seven_seg_controller is
        Port ( clk : in STD_LOGIC;
               score1, score2 : in integer range 0 to 9;
               segments : out STD_LOGIC_VECTOR(6 downto 0);
               anodes : out STD_LOGIC_VECTOR(7 downto 0));
    end component;

    signal tick_sig : STD_LOGIC;
    signal s1_sig, s2_sig : integer range 0 to 9;

begin

    U1: clk_divider port map (clk => clk, tick_out => tick_sig);
    
    U2: game_fsm port map (
        clk => clk, rst => rst, tick => tick_sig, 
        btnL => btnL, btnR => btnR, led => led,
        score1 => s1_sig, score2 => s2_sig
    );
    
    U3: seven_seg_controller port map (
        clk => clk, score1 => s1_sig, score2 => s2_sig,
        segments => segments, anodes => anodes
    );
end Behavioral;