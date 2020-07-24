
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity Mem_Subsys_Full_TB is

end Mem_Subsys_Full_TB;

architecture Behavioral of Mem_Subsys_Full_TB is

constant clk_period : time := 10ns;
--inputs
signal clk : STD_LOGIC;
signal PB_rst : STD_LOGIC;
signal PB_Start: STD_LOGIC;
--signal en  : STD_LOGIC;
--signal RAM_DATA    : STD_LOGIC_VECTOR(15 downto 0); --RAM Data in
--signal INSTRUCTION : STD_LOGIC_VECTOR(31 downto 0); --32 bits Instruciton
begin

UUT: entity work.Mem_Subsys_Full_Interg
PORT MAP(
         clk => clk,
         PB_Start=> PB_Start,
         PB_Rst  => PB_rst);

-- Clock process
 clk_process :process
 begin
 clk <= '0';
 wait for clk_period/2;
 clk <= '1';
 wait for clk_period/2;
 end process; 

-- Test procedure
TEST: process
begin
wait for 100 ns; --wait for initialization
wait until falling_edge(CLK);-- input signals change at falling edge
-- reset registers 
PB_rst <= '0';
PB_Start  <= '0';
wait for clk_period*2;
PB_rst <= '1'; 
wait for clk_period*2;
PB_rst <= '0';
wait for clk_period*5;
PB_Start  <= '1'; 
wait for clk_period*2.6;
PB_Start  <= '0'; 


wait;
end process; 

end Behavioral;
