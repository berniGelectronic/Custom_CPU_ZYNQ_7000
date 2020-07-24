library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- This Dual Port Memory is a 128 address 0-127, 32 bit data ram.
-- The 1st 64 addresses (0-63) contain instructions and the final
-- 64-127 will be data.
-- The dual reads are Asynchronous
-- The single writes are synchronous
-- NO RESET avaliable
-- read commands output a 32 bit word for both instructions and data
-- input data is always a 32 bit word
-- all addresses input to the memory are 7 bits
entity Dual_Port_Mem is
    Port ( 
           clk           : in STD_LOGIC;
           Inst_Add      : in STD_LOGIC_VECTOR (6 downto 0);
           Data_Add      : in STD_LOGIC_VECTOR (6 downto 0);
           Write_Data_En : in STD_LOGIC;
           Data_In       : in STD_LOGIC_VECTOR (31 downto 0);
           Data_Out      : out STD_LOGIC_VECTOR (31 downto 0);
           Inst_Out      : out STD_LOGIC_VECTOR (31 downto 0));
           
          
end Dual_Port_Mem;


architecture Behavioral of Dual_Port_Mem is

type ram_type is array (0 to 127)of std_logic_vector (31 downto 0);
signal my_ram: ram_type := (
-- instruction memory
0  => "00000000000000000000000000000000", -- nop                  , 
1  => "10000101111000000011111000000000", -- loadi rt, imm        , loadi r15, h01F0
2  => "11000100000011111111111110000000", -- brc ra, cond, off    , br r15,=0,-1
3  => "00101011111000000000000000011111", -- addi rt, ra, imm     , addi r31, r0, h001F    
4  => "00100100001000000000000000000000", -- add rt, ra, rb       , add r1, r0, r0
5  => "00101100001000010000000000000000", -- inc rt, ra           , inc r1, r1
6  => "11000100000111110000001010000011", -- brc ra, cond, off    , br r31, <0, +5 (L2)
7  => "10101000000111110000000000000001", -- storr rb, ra         , storr r1, r31
8  => "00101100001000010000000000000000", -- inc rt, ra           , inc r1, r1               
9  => "00001111111111110000000000000000", -- dec rt, ra           , dec r31, r31        
10 => "11000000000000001111111000000000", -- jmp off              , jmp -4 (L1)              
11 => "10000100010000000000001000000000", -- loadi rt, imm        , loadi r2, h0010
12 => "01010111110000000000000000000100", -- ori rt, ra, imm      , ori r30, r0, h0004
13 => "10001000011111100000000000000000", -- loadr rt, ra         , loadr r3, r30
14 => "10010000100111100000000011000000", -- loado rt, ra, off    , loado r4, r30, 3
15 => "01011011101000001111111111111111", -- xori rt, ra, imm     , xori r29, r0, hFFFF
16 => "10000000111000000000000000000000", -- move rt, ra          , move r7, r0
17 => "01010000101111010000000000010000", -- andi rt, ra, imm     , andi r5, r29, h0010
18 => "01010000110001000000000000000001", -- andi rt, ra, imm     , andi r6, r4, h0001
19 => "11000100000001100000000100000000", -- brc ra, cond, off    , br r6, =0, +2 (L4)
20 => "00100100111000110000000000000111", -- add rt, ra, rb       , add r7, r3, r7
21 => "01100100100001000000000000100000", -- shr rt, ra, n        , shr r4, r4, 1
22 => "01100000011000110000000000100000", -- shl rt, ra, n        , shl r3, r3, 1
23 => "00001100101001010000000000000000", -- dec rt, ra           , dec r5, r5            
24 => "11000100000001011111110100000001", -- brc ra, cond, off    , br r5, ?0, -6 (L3)    
25 => "10100100000000000000000000000111", -- stori rb, imm        , stori r7, 0
26 => "01101000111001110000000100100000", -- rol rt, ra, n        , rol r7, r7, 9
27 => "01101100111001110000000001100000", -- ror rt, ra, n        , ror r7, r7, 3
28 => "01000001000001110000000000000000", -- not rt, ra           , not r8, r7
29 => "01001101000111010000000000001000", -- xor rt, ra, rb       , xor r8, r29, r8
30 => "00000101001010000000000000000111", -- sub rt, ra, rb       , sub r9, r8, r7
31 => "00001001010010010000000000000001", -- subi rt, ra, imm     , subi r10, r9, h0001
32 => "11000100000010100000010010000100", -- brc ra, cond, off    , br r10, >0, +9 (Lx)
33 => "11000100000010100000010000000110", -- brc ra, cond, off    , br r10, ?0, +8 (Lx)
34 => "00101001011010100000000000000010", -- addi rt, ra, imm     , addi r11, r10, h0002
35 => "11000100000010110000001100000101", -- brc ra, cond, off    , br r11, ?0, +6 (Lx)
36 => "01001001100001110000000000001011", -- or rt, ra, rb        , or r12, r7, r11             
37 => "10110000000000000000000001001010", -- storo rb, ra, off    , storo r12, r0, 1        
38 => "01000101100010100000000000001011", -- and rt, ra, rb       , and r12, r12, r11 
39 => "11000100000011000000000110000010", -- brc ra, cond, off    , br r12, =1, +3 (Lok)        
40 => "11000000000000000000000000000000", -- jmp off              , jmp +0                
41 => "11000000000000000000000000000000", -- jmp off              , jmp +0                      
42 => "10100100000000000011111100000111", -- stori rb, imm        , stori r7,h01F8             
43 => "11000000000000000000000000000000", -- jmp off              , jmp +0
-- all other addresses are data memory 
others => X"00000000");

begin
-- instruction Asynchronous read
Inst_Out <= my_ram(to_integer(unsigned(Inst_Add)));
-- data Asynchronous read
Data_Out <= my_ram(to_integer(unsigned(Data_Add)));

-- Synchronous Write, NO RESET
process (clk)
begin
    if(rising_edge(clk)) then 
        if (Write_Data_En = '1') then
        my_ram(to_integer(unsigned(Data_Add))) <= Data_In;
        end if;
    end if;
end process;
end Behavioral;
