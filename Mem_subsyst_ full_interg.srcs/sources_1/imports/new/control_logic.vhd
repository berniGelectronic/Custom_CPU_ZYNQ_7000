library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Control Logic Top Entity (Architecture B)
-- Receives 32 bit Instruction and extract all
-- control signals from itREG A (5bits), REG B (5 bits), WA/RT(5 bits), SHIFTER(4 bits), WEN (1 bit
-- COND(3 bits), OEN(1 bit) ,MEM ADDR(16 bits), IMM_Value(16 bits), ADDR_OFFSET (10bits), 
-- PC_Offset (9bit) because number can be positive or negative, MIA(8bits)
-- Implements Program counter(8bits) and Instruction Register(16bits)
-- 2 Generics for data_size and Param_REG_size
-- Program counter with CLB and MIA converts 9 bit offset with PC to 8 bit address

--CONDITION bits ENCODING
-- Flags(0): OUT  = 0  : Cond = 000
-- Flags(1): OUT != 0  : Cond = 001
-- Flags(2): OUT  = 1  : Cond = 010
-- Flags(3): OUT  < 0  : Cond = 011
-- Flags(4): OUT  > 0  : Cond = 100
-- Flags(5): OUT <= 0  : Cond = 101
-- Flags(6): OUT >= 0  : Cond = 110
-- Flags(7): Overflow  : Cond = 111

entity control_logic is
--Genrics for data_size and reg size
generic (data_size  :    natural := 16;
         param_REG_size :natural := 32);
  Port ( 
         --Inputs
         clk : in STD_LOGIC; --clock signal 
         rst : in STD_LOGIC; --reset signal
         FLAGS_ALU  : in STD_LOGIC_VECTOR(7 downto 0); -- flags from ALU
         INSTRUCTION: in STD_LOGIC_VECTOR(31 downto 0); -- 32 bits instruction from RAM
         --Output
         MIA : out STD_LOGIC_VECTOR(7 downto 0);  -- Memory instruction address 
         RA  : out STD_LOGIC_VECTOR(4 downto 0);  --5 Bits Register A           
         RB  : out STD_LOGIC_VECTOR(4 downto 0);  --5 Bits Register B           
         WA  : out STD_LOGIC_VECTOR(4 downto 0);  --5 Bits Write register       
         MEM_ADDR    : out STD_LOGIC_VECTOR(data_size - 1 downto 0);--16 bit immidiate address 
         IMM_VALUE   : out STD_LOGIC_VECTOR(data_size - 1 downto 0);--16 bit immidate value    
         ADDR_OFFSET : out STD_LOGIC_VECTOR(9 downto 0); -- 10 bit address offset        
         PC_OFFSET   : out STD_LOGIC_VECTOR(8 downto 0); -- 9 bit Program Counter offset
         SHIFTER     : out STD_LOGIC_VECTOR(3 downto 0); -- shifter bits                
         COND : out STD_LOGIC_VECTOR(2 downto 0);        -- condition bits       
         OEN  : out STD_LOGIC;                           -- Output enable        
         SEL  : out STD_LOGIC_VECTOR(2 downto 0);        -- mux selector         
         ALU  : out STD_LOGIC_VECTOR(3 downto 0);        -- ALU function                
         WEN  : out STD_LOGIC);                          -- Write enable signal  
           
end control_logic;

architecture Behavioral of control_logic is
--internal Instruction REG signals
signal int_IR_IN : STD_LOGIC_VECTOR(31 downto 0);
signal int_IR_OUT : STD_LOGIC_VECTOR(31 downto 0);

--internal clb signal
signal int_CLB_SEL :STD_LOGIC;

--internal sequencer signals
signal int_PC_OUT : STD_LOGIC_VECTOR(7 downto 0);
signal int_PC_plus_OFF_OUT: STD_LOGIC_VECTOR(7 downto 0);
signal int_PC_plus_OFF_9Bits: STD_LOGIC_VECTOR(8 downto 0);

--internal enable
signal int_en : STD_LOGIC;

--internal control signals
signal int_RA : STD_LOGIC_VECTOR(4 downto 0); --5 Bits RA 
signal int_RB : STD_LOGIC_VECTOR(4 downto 0); --5 Bits RB 
signal int_WA : STD_LOGIC_VECTOR(4 downto 0); --5 Bits WA 
signal int_MEM_ADDR    : STD_LOGIC_VECTOR(data_size - 1 downto 0); --16 bit immidiate address
signal int_IMM_VALUE   : STD_LOGIC_VECTOR(data_size - 1 downto 0); --16 bit immidate value
signal int_ADDR_OFFSET : STD_LOGIC_VECTOR(9 downto 0); -- 10 bit addr off  
signal int_PC_OFFSET   : STD_LOGIC_VECTOR(8 downto 0); -- 9 bit PC off     
signal int_SHIFTER     : STD_LOGIC_VECTOR(3 downto 0); -- 4 bits shift     
signal int_COND   : STD_LOGIC_VECTOR(2 downto 0);   -- condition bits
signal int_OEN    : STD_LOGIC;                      -- Output enable 
signal int_SEL    : STD_LOGIC_VECTOR(2 downto 0);   -- mux selector
signal int_ALU    : STD_LOGIC_VECTOR(3 downto 0);   -- ALU function          
signal int_WEN    : STD_LOGIC;                      -- Write enable signal
signal int_MIA    : STD_LOGIC_VECTOR(7 downto 0);   -- Memory instruction address internal
signal int_FLAGS_ALU      : STD_LOGIC_VECTOR(7 downto 0); -- flags from ALU
-- selection of imm value or addres offset
signal int_IMM_VALUE_or_ADDR_OFFSET : STD_LOGIC_VECTOR(data_size -1 downto 0); 
signal int_ADDR_OFFSET_16bits : STD_LOGIC_VECTOR(data_size -1 downto 0);

begin
RA <=              int_RA ;
RB <=              int_RB ;
WA <=              int_WA ;
MEM_ADDR <=        int_MEM_ADDR ;
IMM_VALUE<=        int_IMM_VALUE_or_ADDR_OFFSET ;
ADDR_OFFSET <=     int_ADDR_OFFSET;  
PC_OFFSET<=        int_PC_OFFSET ;
SHIFTER  <=        int_SHIFTER; 
COND<=             int_COND; 
OEN <=             int_OEN ;
SEL <=             int_SEL;   
ALU <=             int_ALU; 
WEN <=             int_WEN; 
MIA <=             int_MIA;
int_FLAGS_ALU <= FLAGS_ALU;
int_IR_IN <= INSTRUCTION;
int_en <= '1';

--sequencer
PC: entity work.reg_bits
    Generic map( data_size => 8)
    port map (clk => clk,
              rst => rst,
              en  => int_en,
              DATA_IN  => int_MIA,
              DATA_OUT => int_PC_OUT); 

--Instruction Register               
INSTR_REG: entity work.reg_bits
    Generic map( data_size => 32)
    port map (clk => clk,
              rst => rst,
              en  => int_en,
              DATA_IN  => int_IR_IN,
              DATA_OUT => int_IR_OUT); 

-- PC_OFFSET -- 9 bit
int_PC_OFFSET <= int_IR_OUT(15 downto 7) when int_IR_OUT(31 downto 26) = "110000" else --jmp off
                 int_IR_OUT(15 downto 7) when int_IR_OUT(31 downto 26) = "110001" else --brc ra,cond,off
                 (others => '0');                            
  
--resize int_PC_OUT -> 0 before int_PC_OUT => 9 bits -> do the signed math and send it to int_PC_plus_OFF_9Bits                   
int_PC_plus_OFF_9Bits <= std_logic_vector('0'&signed(int_PC_OUT) + signed(int_PC_OFFSET)) when int_IR_OUT(31 downto 26) = "110000" else --jmp off
                         std_logic_vector('0'&signed(int_PC_OUT) + signed(int_PC_OFFSET)) when int_IR_OUT(31 downto 26) = "110001" else --brc ra,cond,off
                         (others => '0');  

--Selects first 8 bits to output on MIA
int_PC_plus_OFF_OUT <= int_PC_plus_OFF_9Bits(7 downto 0) when int_IR_OUT(31 downto 26) = "110000" else --jmp off                  
                       int_PC_plus_OFF_9Bits(7 downto 0) when int_IR_OUT(31 downto 26) = "110001" else --brc ra,cond,off
                      (others => '0');                     
                      

-- condition from CLB 
-- Program counter output is everytime +1 or add PC Offset when JMP or BRC instruction come                       
int_MIA <=  int_PC_plus_OFF_OUT  when int_IR_OUT(31 downto 26) = "110000" else --jmp off        
            int_PC_plus_OFF_OUT  when int_CLB_SEL = '1' and int_IR_OUT(31 downto 26) = "110001" else --brc ra,cond,off
            std_logic_vector(unsigned(int_PC_OUT) + 1);

-- CLB PART -- ONLY Instruction --brc ra,cond,off 
-- Checks Condition bits in brc instruction, compares them with ALU FLAG bits -> if true output 1 
-- MIA mux selects int_PC_plus_OFF_OUT (int_PC_plus_OFF_9Bits)      
int_CLB_SEL <= '1' when int_COND = "000" and int_FLAGS_ALU(0)= '1' and int_IR_OUT(31 downto 26) = "110001" else
               '1' when int_COND = "001" and int_FLAGS_ALU(1)= '1' and int_IR_OUT(31 downto 26) = "110001" else
               '1' when int_COND = "010" and int_FLAGS_ALU(2)= '1' and int_IR_OUT(31 downto 26) = "110001" else
               '1' when int_COND = "011" and int_FLAGS_ALU(3)= '1' and int_IR_OUT(31 downto 26) = "110001" else
               '1' when int_COND = "100" and int_FLAGS_ALU(4)= '1' and int_IR_OUT(31 downto 26) = "110001" else
               '1' when int_COND = "101" and int_FLAGS_ALU(5)= '1' and int_IR_OUT(31 downto 26) = "110001" else
               '1' when int_COND = "110" and int_FLAGS_ALU(6)= '1' and int_IR_OUT(31 downto 26) = "110001" else
               '1' when int_COND = "111" and int_FLAGS_ALU(7)= '1' and int_IR_OUT(31 downto 26) = "110001" else
               '0';
              
-- RA 5 bits
int_RA <=   (others => '0')         when int_IR_OUT(31 downto 26) = "000000" else -- no op
            (others => '0')         when int_IR_OUT(31 downto 26) = "100001" else --load rt, imm
            (others => '0')         when int_IR_OUT(31 downto 26) = "101001" else --stori rb, ra
            (others => '0')         when int_IR_OUT(31 downto 26) = "110000" else --jmp off  
            int_IR_OUT(20 downto 16);                                                                   

-- RB 5 bits   
int_RB <=   int_IR_OUT(4 downto 0)  when int_IR_OUT(31 downto 26) = "001001" else --add rt,ra,rb
            int_IR_OUT(4 downto 0)  when int_IR_OUT(31 downto 26) = "000001" else --sub rt,ra,rb
            int_IR_OUT(4 downto 0)  when int_IR_OUT(31 downto 26) = "010001" else --and rt,ra,rb
            int_IR_OUT(4 downto 0)  when int_IR_OUT(31 downto 26) = "010010" else --or rt,ra,rb
            int_IR_OUT(4 downto 0)  when int_IR_OUT(31 downto 26) = "010011" else --xor rt,ra,rb
            int_IR_OUT(4 downto 0)  when int_IR_OUT(31 downto 26) = "101001" else --stori rb,imm
            int_IR_OUT(4 downto 0)  when int_IR_OUT(31 downto 26) = "101010" else --storr rb,ra
            int_IR_OUT(4 downto 0)  when int_IR_OUT(31 downto 26) = "101100" else --storo rb,ra,off                                                       
            (others => '0');
            
-- WA/RT 5 bits                                     
int_WA <=   (others => '0')         when int_IR_OUT(31 downto 26) = "000000" else -- no op
            (others => '0')         when int_IR_OUT(31 downto 26) = "101001" else --stori rb, imm
            (others => '0')         when int_IR_OUT(31 downto 26) = "101010" else --storr rb,ra
            (others => '0')         when int_IR_OUT(31 downto 26) = "101100" else --storo rb,ra,off
            (others => '0')         when int_IR_OUT(31 downto 26) = "110000" else --jmp off
            (others => '0')         when int_IR_OUT(31 downto 26) = "110001" else -- brc ra,cond,off
            int_IR_OUT(25 downto 21);  
            
-- MEM_ADDR -- 16 bits -- immidiate memory address which goes to MUX2                                  
int_MEM_ADDR <= int_IR_OUT(20 downto 5) when int_IR_OUT(31 downto 26) = "100001" else --loadi rt,imm
                int_IR_OUT(20 downto 5) when int_IR_OUT(31 downto 26) = "101001" else --stori rb,imm
                (others => '0');
                            
-- IMM_VALUE --16 bits 
int_IMM_VALUE<= int_IR_OUT(15 downto 0) when int_IR_OUT(31 downto 26) = "001010" else --addi rt,ra,imm
                int_IR_OUT(15 downto 0) when int_IR_OUT(31 downto 26) = "000010" else --subi rt,ra,imm
                int_IR_OUT(15 downto 0) when int_IR_OUT(31 downto 26) = "010100" else --andi rt,ra,imm
                int_IR_OUT(15 downto 0) when int_IR_OUT(31 downto 26) = "010101" else --ori rt,ra,imm
                int_IR_OUT(15 downto 0) when int_IR_OUT(31 downto 26) = "010110" else --xori rt,ra,imm
                (others => '0');
                 
-- ADDR_OFFSET -- 10 bits -- Data address offset  
int_ADDR_OFFSET <= int_IR_OUT(15 downto 6) when int_IR_OUT(31 downto 26) = "100100" else --loado rt,ra,off
                   int_IR_OUT(15 downto 6) when int_IR_OUT(31 downto 26) = "101100" else --storo rb,ra,off
                   (others => '0');

-- Converts 10 bits to 16 bits by adding 0s in front of int_ADDR_OFFSET                 
int_ADDR_OFFSET_16bits <= "000000" & int_ADDR_OFFSET when int_IR_OUT(31 downto 26) = "100100" else --loado rt,ra,off
                          "000000" & int_ADDR_OFFSET when int_IR_OUT(31 downto 26) = "101100" else --storo rb,ra,off 
                          (others => '0');  

--ADDR OFFSET or IMMIDATE VALUE
--Selects Data Address Offset or immidiate Value which goes to MUX 1
--Immidiate value goes always execept for Loado and Storo instructions when goes Data address offset 
int_IMM_VALUE_or_ADDR_OFFSET <= int_ADDR_OFFSET_16bits when int_IR_OUT(31 downto 26) = "100100" else --loado rt,ra,off   
                                int_ADDR_OFFSET_16bits when int_IR_OUT(31 downto 26) = "101100" else --storo rb,ra,off   
                                int_IMM_VALUE;                                                                          
                          
-- SHIFTER -- 4 bit
int_SHIFTER  <= int_IR_OUT(8 downto 5) when int_IR_OUT(31 downto 26) = "011000" else --shl rt,ra,n
                int_IR_OUT(8 downto 5) when int_IR_OUT(31 downto 26) = "011001" else --shr rt,ra,n
                int_IR_OUT(8 downto 5) when int_IR_OUT(31 downto 26) = "011010" else --rol rt,ra,n
                int_IR_OUT(8 downto 5) when int_IR_OUT(31 downto 26) = "011011" else --ror rt,ra,n
                (others => '0');
            
-- COND   -- 3 bit        
int_COND <= int_IR_OUT(2 downto 0) when int_IR_OUT(31 downto 26) = "110001" else --brc ra,cond,off
            (others => '0');        

-- OEN -- 1 bit
int_OEN <= '1' when int_IR_OUT(31 downto 26) = "101001" else --stori rb,imm
           '1' when int_IR_OUT(31 downto 26) = "101010" else --storr rb,ra
           '1' when int_IR_OUT(31 downto 26) = "101100" else --storo rb,ra,off
           '0';
       
-- Sel mux selector - 3 bit (Architectue B)
-- Sel(100) = Sel(MUX1 0 0);
-- Sel(010) = Sel(0 MUX2 0);
-- Sel(001) = Sel(0 0 MUX3);
int_SEL   <= "100" when int_IR_OUT(31 downto 26) = "001010" else --addi rt, ra, imm
             "100" when int_IR_OUT(31 downto 26) = "000010" else --subi rt, ra, imm
             "100" when int_IR_OUT(31 downto 26) = "010100" else --andi rt,ra,imm
             "100" when int_IR_OUT(31 downto 26) = "010101" else --ori rt,ra,imm
             "100" when int_IR_OUT(31 downto 26) = "010110" else --xori rt,ra,imm
             "011" when int_IR_OUT(31 downto 26) = "100001" else --loadi rt,imm
             "001" when int_IR_OUT(31 downto 26) = "100010" else --loadr rt,ra
             "101" when int_IR_OUT(31 downto 26) = "100100" else --loado rt,ra,off 
             "010" when int_IR_OUT(31 downto 26) = "101001" else --stori rb,imm
             "100" when int_IR_OUT(31 downto 26) = "101100" else --storo rb,ra,off           
             "000"; 
           
-- WEN -- 1 bit       
int_WEN <= '0'   when int_IR_OUT(31 downto 26) = "000000" else -- no op
           '0'   when int_IR_OUT(31 downto 26) = "101001" else --stori rb,imm
           '0'   when int_IR_OUT(31 downto 26) = "101010" else --storr rb,ra
           '0'   when int_IR_OUT(31 downto 26) = "101100" else --storo rb,ra,off
           '0'   when int_IR_OUT(31 downto 26) = "110000" else --jmp off
           '1';     
          
-- ALU -- 4 bits
int_ALU <= "1010" when int_IR_OUT(31 downto 26) = "001001" else --add rt, ra, rb
           "1010" when int_IR_OUT(31 downto 26) = "001010" else --addi rt, ra, imm
           "1011" when int_IR_OUT(31 downto 26) = "000001" else --sub rt, ra, rb 
           "1011" when int_IR_OUT(31 downto 26) = "000010" else --subi rt, ra, imm 
           "1000" when int_IR_OUT(31 downto 26) = "001011" else --inc rt, ra 
           "1001" when int_IR_OUT(31 downto 26) = "000011" else --dec rt, ra
           "0111" when int_IR_OUT(31 downto 26) = "010000" else --not rt, ra       
           "0100" when int_IR_OUT(31 downto 26) = "010001" else --and rt, ra, rb   
           "0100" when int_IR_OUT(31 downto 26) = "010100" else --andi rt, ra, imm 
           "0101" when int_IR_OUT(31 downto 26) = "010010" else --or rt, ra, rb
           "0101" when int_IR_OUT(31 downto 26) = "010101" else --ori rt, ra, imm
           "0110" when int_IR_OUT(31 downto 26) = "010011" else --xor rt, ra, rb
           "0110" when int_IR_OUT(31 downto 26) = "010110" else --xori rt, ra, imm
           "1100" when int_IR_OUT(31 downto 26) = "011000" else --shl rt, ra, n
           "1101" when int_IR_OUT(31 downto 26) = "011001" else --shr rt, ra, n
           "1110" when int_IR_OUT(31 downto 26) = "011010" else --rol rt, ra, n
           "1111" when int_IR_OUT(31 downto 26) = "011011" else --ror rt, ra, n 
           "1010" when int_IR_OUT(31 downto 26) = "100100" else --loado rt,ra,off
           "1010" when int_IR_OUT(31 downto 26) = "101100" else --storo rt,ra,off
           "1010" when int_IR_OUT(31 downto 26) = "110001" else --brc ra,cond,off       
           "0000";
           
end Behavioral;
