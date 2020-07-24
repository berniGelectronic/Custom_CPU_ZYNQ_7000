

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Testbench for Control Logic 
-- inputs clock, enable, reset signals 
-- Instruction input accepts 32bit binary number (instruction)
-- Testing these instructions
-- inc R1,R0                            
-- addi R2, R0, 0005                     
-- shl R3,R1,3                           
-- storr R2, R3                          
-- load R5,1f1f                                            
-- jmp 16                               
-- brc R1, x, -4      

entity control_logic_TB is
end control_logic_TB;

architecture Behavioral of control_logic_TB is
--constant
constant clk_period : time := 10ns;
--inputs
signal clk : STD_LOGIC;
signal rst : STD_LOGIC;
signal RAM_DATA    : STD_LOGIC_VECTOR(15 downto 0); --RAM Data in
signal INSTRUCTION : STD_LOGIC_VECTOR(31 downto 0); --32 bits Instruciton

begin

UUT: entity work.control_logic
PORT MAP(
         clk => clk,
         rst => rst,
         INSTRUCTION => INSTRUCTION,
         RAM_DATA    =>RAM_DATA);

-- Clock process
 clk_process :process
 begin
 CLK <= '0';
 wait for clk_period/2;
 CLK <= '1';
 wait for clk_period/2;
 end process; 

-- Test procedure
-- 2 instructions for checking offset of PC
-- JMP and BRC instruction
TEST: process
begin
wait for 100 ns; --wait for initialization
wait until falling_edge(CLK);-- input signals change at falling edge
-- reset registers 
rst <= '0';
wait for clk_period*2;
rst <= '1'; 
wait for clk_period*2;
rst <= '0';  
INSTRUCTION <="00101100001000000000000000000000"; --inc R1,R0
wait for clk_period;
INSTRUCTION <="00101000010000000000000000000101"; --addi R2, R0, 0005
wait for clk_period;
INSTRUCTION <="01100000011000010000000001100000"; --shl R3,R1,3
wait for clk_period;
INSTRUCTION <="10101000000000110000000000000010"; --storr R2, R3
RAM_DATA <= X"0005"; -- Simulation of RAM Data
wait for clk_period;
INSTRUCTION <="10000100101000111110001111100000"; --load R5,1f1f
RAM_DATA <= X"0007"; -- Simulation of RAM Data
wait for clk_period;
INSTRUCTION <="11000000000000000000010000000000"; --jmp 16
wait for clk_period;
INSTRUCTION <="11000100000000011111111000000001"; --brc R1, x, -4
wait;
end process;
end Behavioral;
