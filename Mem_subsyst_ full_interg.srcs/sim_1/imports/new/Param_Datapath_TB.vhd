library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.DigEng.ALL;

entity Param_Datapath_TB is

end Param_Datapath_TB;

architecture Behavioral of Param_Datapath_TB is

-- Constants
constant Data_size  : natural := 16;
constant reg_size   : natural := 32;
constant clk_period : time := 10ns;

-- Inputs
signal REG_A         : STD_LOGIC_VECTOR((log2(reg_size)) - 1 downto 0);
signal REG_B         : STD_LOGIC_VECTOR((log2(reg_size)) - 1 downto 0);   
signal WRITE_EN      : STD_LOGIC;  
signal CLK           : STD_LOGIC;  
signal RST           : STD_LOGIC; 
signal WRITE_REG_ADDR: STD_LOGIC_VECTOR ((log2(reg_size))- 1 downto 0);
signal IMMED         : STD_LOGIC_VECTOR(Data_size - 1 downto 0);  
signal MEM_ADD       : STD_LOGIC_VECTOR(Data_size - 1 downto 0);  
signal Sel           : STD_LOGIC_VECTOR(2 downto 0); 
signal ALU           : STD_LOGIC_VECTOR(3 downto 0); 
signal SHIFT         : STD_LOGIC_VECTOR ((log2(data_size))- 1 downto 0);
signal RAM_DATA      : STD_LOGIC_VECTOR(Data_size - 1 downto 0); 
signal OEN           : STD_LOGIC;

-- Outputs
signal Flags         : STD_LOGIC_VECTOR (7 downto 0);
signal MEM_DATA_WRITE: STD_LOGIC_VECTOR(Data_size - 1 downto 0); 
signal MEM_DATA_ADD  : STD_LOGIC_VECTOR ((data_size - 1) downto 0);


type test_vector is record
-- inputs
REG_A            : STD_LOGIC_VECTOR((log2(reg_size)) - 1 downto 0);    
REG_B            : STD_LOGIC_VECTOR((log2(reg_size)) - 1 downto 0);    
WRITE_EN         : STD_LOGIC;                                          
WRITE_REG_ADDR   : STD_LOGIC_VECTOR ((log2(reg_size))- 1 downto 0);    
IMMED            : STD_LOGIC_VECTOR(Data_size - 1 downto 0);           
MEM_ADD          : STD_LOGIC_VECTOR(Data_size - 1 downto 0);           
Sel              : STD_LOGIC_VECTOR(2 downto 0);                       
ALU              : STD_LOGIC_VECTOR(3 downto 0);                       
SHIFT            : STD_LOGIC_VECTOR ((log2(data_size))- 1 downto 0);   
RAM_DATA         : STD_LOGIC_VECTOR(Data_size - 1 downto 0);          
OEN              : STD_LOGIC;        
                              
-- Outputs     
Flags            : STD_LOGIC_VECTOR (7 downto 0);                                                      
MEM_DATA_WRITE   : STD_LOGIC_VECTOR(Data_size - 1 downto 0);   
MEM_DATA_ADD     : STD_LOGIC_VECTOR ((data_size - 1) downto 0);
             

end record;

type test_vector_array is array (natural range <>) of test_vector;                                                       
constant test_vectors : test_vector_array := (                                                                   
    --REG_A,   REG_B,   WRITE_EN,  WRITE_REG_ADDR,   IMMED,     MEM_ADD,      Sel,      ALU,     SHIFT , RAM_DATA, OEN,    Flags,    MEM_DATA_write,   MEM_DATA_ADD,                                       
  ("00000",  "00000",   '1',        "00001",        X"0000",    X"0000",     "000",    "1000",  "0000",  X"0000",  '0',  "01010110",    "ZZZZZZZZZZZZZZZZ",        X"0001"),      
   --inc R1, R0; [store the value 1 into register R1]            
                                                                                                                                                                                                                                                                                                                                                     
  ("00000",  "00000",   '1',        "00010",        X"0005",    X"0000",     "100",    "1010",  "0000",  X"0000",  '0',  "01010010",   "ZZZZZZZZZZZZZZZZ",        X"0005"),     
   -- addi R2, R0, 0005; [store value 5 into register R2]
                                                                                                 
  ("00001",  "00000",   '1',        "00011",        X"0000",    X"0000",     "000",    "1010",  "0011",  X"0000",  '0',  "01010110",    "ZZZZZZZZZZZZZZZZ",        X"0001"),    
   --shl R3, R1, 3; [store value 8 into register R3]      
                                                               
  ("00000",  "00010",   '0',        "00000",        X"0000",    X"0005",     "010",    "0000",  "0000",  X"0000",  '1',  "01100001",    X"0005",        X"0005"),  
   -- storr R2, R3; [store 5 into memory at address 8]  
   --#issue lies within the shift 4/5 bits fine when 5 issue when 4 #                                                                     
  ("00000",  "00000",   '1',        "00101",        X"0000",    X"1F1F",     "011",    "0000",  "0000",  X"0007",  '0',  "01100001",    "ZZZZZZZZZZZZZZZZ",        X"1F1F"));                                                                                 
   --loadi R5, 1f1f; [load into R5 the contents of the memory at address 1F1F - assume
   -- that the value in question is 7 and provide it in your testbench] 
begin
UUT: entity work.Param_Datapath
-- map top level entity pins to testbench  
GENERIC MAP( data_size => data_size,
             reg_size  => reg_size) 

   PORT MAP( REG_A          => REG_A,
             REG_B          => REG_B,
             WRITE_EN       => WRITE_EN,
             CLK            => CLK,
             RST            => RST,
             WRITE_REG_ADDR => WRITE_REG_ADDR, 
             IMMED          => IMMED,
             MEM_ADD        => MEM_ADD,
             Sel            => Sel,
             ALU            => ALU,
             SHIFT          => SHIFT,
             RAM_DATA       => RAM_DATA,
             OEN            => OEN,
             Flags          => Flags,          
             MEM_DATA_WRITE => MEM_DATA_WRITE,
             MEM_DATA_ADD   => MEM_DATA_ADD);
  
 -- Clock process
 clk_process :process
 begin
 CLK <= '0';
 wait for clk_period/2;
 CLK <= '1';
 wait for clk_period/2;
 end process; 
                        
-- Test procedure
TEST: process
begin
wait for 100 ns; --wait for initialization
wait until falling_edge(CLK);-- input signals change at falling edge
-- reset registers 
RST <= '1';
wait for 20ns;
RST <= '0';
 -- test all input vectors
 for i in test_vectors'range loop
      
      REG_A           <= test_vectors(i).REG_A;
      REG_B           <= test_vectors(i).REG_B;  
      WRITE_EN        <= test_vectors(i).WRITE_EN;
      WRITE_REG_ADDR  <= test_vectors(i).WRITE_REG_ADDR;
      IMMED           <= test_vectors(i).IMMED;
      MEM_ADD         <= test_vectors(i).MEM_ADD;
      Sel             <= test_vectors(i).Sel;
      ALU             <= test_vectors(i).ALU ;
      SHIFT           <= test_vectors(i).SHIFT ;
      RAM_DATA        <= test_vectors(i).RAM_DATA;
      OEN             <= test_vectors(i).OEN;
      
      
      wait for 60 ns;
      
--Report error for every wrong test case of Flags, MEM_DATA_WRITE 
-- and MEM_DATA_ADD.         
assert  (                                                               
        (Flags = test_vectors(i).Flags)  -- correct                                                          
         and                                                           
        (MEM_DATA_WRITE = test_vectors(i).MEM_DATA_WRITE) 
         and                                                            
        (MEM_DATA_ADD = test_vectors(i).MEM_DATA_ADD)  -- correct                                                             
        )  
        -- report the values of all inputs and outputs in the case of wrong predicted values  with formatting                                                                             
report   CR &
"test_vectors value "    & integer'image(i) & " FAILED " & CR & CR &       
"for inputs"             & CR &
"Reg A value: "          & integer  'image(to_integer(unsigned(REG_A))) & CR &  
"Reg B value: "          & integer  'image(to_integer(unsigned(REG_B))) & CR &
"WRITE_EN : "            & std_logic'image(WRITE_EN) & CR &  
"WRITE_REG_ADDR : "      & integer  'image(to_integer(signed(WRITE_REG_ADDR))) & CR &
"IMMED : "               & integer  'image(to_integer(unsigned(IMMED))) & CR &
"MEM_ADD : "             & integer  'image(to_integer(unsigned(MEM_ADD))) & CR &
"Sel: "                  & integer  'image(to_integer(unsigned(Sel))) & CR &
"ALU: "                  & integer  'image(to_integer(unsigned(ALU))) & CR &
"SHIFT: "                & integer  'image(to_integer(unsigned(SHIFT))) & CR &
"RAM_DATA: "             & integer  'image(to_integer(unsigned(RAM_DATA))) & CR &
"OEN: "                  & std_logic'image(OEN) & CR & CR &

"for outputs"            & CR & CR &
"Actual Values"          & CR &
"Flags: "                & integer  'image(to_integer(unsigned(test_vectors(i).Flags))) & CR &         
"MEM_DATA_WRITE: "       & integer  'image(to_integer(unsigned(test_vectors(i).MEM_DATA_WRITE))) & CR &
"MEM_DATA_ADD : "        & integer  'image(to_integer(unsigned(test_vectors(i).MEM_DATA_ADD))) & CR & CR &

"Expected Values"        & CR &
"Flags: "                & integer  'image(to_integer(unsigned(Flags))) & CR &
"MEM_DATA_WRITE: "       & integer  'image(to_integer(unsigned(MEM_DATA_WRITE))) & CR & 
"MEM_DATA_ADD : "        & integer  'image(to_integer(unsigned(MEM_DATA_ADD))) & CR
              
                                             
 severity error; -- only reports errors does NOT stop the program if errors detected                                                        
                                                                                                                                     
  end loop;                                                                        
     
wait; -- waits forever
      
end process;    
  
end Behavioral;


