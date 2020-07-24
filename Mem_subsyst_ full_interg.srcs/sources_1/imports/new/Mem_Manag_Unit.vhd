library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
-- Asynchronous combinational Memory Management unit (MMU)
-- address range = X'0100-X'01ff for peripherals
-- start push button value is at address X'01F0
-- LED's address X'01F8
-- 8 LEDs on board so 8 MSBs of the 16 bit data sent to output reg (LEDs)
-- ram data/instruction accesses kept separate within the MMU
-- no page management implemented
-- data 16 bits from processor
-- data 32 bits from RAM, made up of 2 16 bit sections of data 
-- MMU makes 128 virtual addresses in the 64 data addresses in ram  


entity Mem_Manag_Unit is
    Port ( 
           --PB = push button
           --En = enable
           --Add = address
           --Proc = processing
           --Reg = register
           --inputs           
           Start_PB         : in STD_LOGIC;
           Output_En_In     : in STD_LOGIC;
           Inst_Add_In      : in STD_LOGIC_VECTOR (7 downto 0);          
           Data_Proc_In     : in STD_LOGIC_VECTOR (15 downto 0);
           Data_Add_In      : in STD_LOGIC_VECTOR (15 downto 0);
           Data_Ram_In      : in STD_LOGIC_VECTOR (31 downto 0);
           --outputs
           Inst_Add_Ram     : out STD_LOGIC_VECTOR (6 downto 0);
           Data_Ram_Out     : out STD_LOGIC_VECTOR (31 downto 0);
           Data_Proc_Out    : out STD_LOGIC_VECTOR (15 downto 0);
           Data_Add         : out STD_LOGIC_VECTOR (6 downto 0);
           Output_Reg       : out STD_LOGIC_VECTOR (15 downto 0);
           Write_En_Ram     : out STD_LOGIC;
           Write_En_Out_Reg : out STD_LOGIC);
            
end Mem_Manag_Unit;
  
architecture Behavioral of Mem_Manag_Unit is
  
  -- start push button 1 bit value resized to 16 bits
  signal Start_PB_resize : std_logic_vector(15 downto 0);
  -- data written to memory 16 MSB or LSB has been overwritten
  signal edited_memory_data: std_logic_vector(31 downto 0);
  -- LSBs of Data from RAM memory address
  signal int_LSB_16bits  : std_logic_vector(15 downto 0);
  -- MSBs of Data from RAM memory address
  signal int_MSB_16bits  : std_logic_vector(15 downto 0);
begin
  
 -- Instruction address selection for RAM when MSB = 0 
 Inst_Add_Ram <= Inst_Add_In(6 downto 0) when Inst_Add_In(7) = '0' else
              (others => '0');

 -- physical data address +64 offset for data section in RAM           
 Data_Add     <= std_logic_vector(unsigned(Data_Add_In(7 downto 1))+ 64);
 
 -- output reg address write enable signal functionality             
 Write_En_Out_Reg <= '1' when ((Output_En_In = '1') and (Data_Add_In = X"01F8"))else '0';

-- output reg data line connection to MMU data bus
 Output_Reg <= Data_Proc_In;      
 
 -- 1 bit push button value resized to be 16 bits, converted to data             
 Start_PB_resize<= X"0001" when Start_PB ='1' else
                   (others=> '0');
 
-- ram write enable signal connections
   Write_En_Ram <= '1' when (Output_En_In = '1') else
                 '0';
                 
 -- Data from the MMU to the Processor 
 -- push button 16 bit value of X'0001 written to processor when address is X"01F0"
 -- when data address in bit (0) value is 0 the 16 LSBs from rams 32 bit data are written to processor
 -- when data address in bit (0) value is 1 the 16 MSBs from rams 32 bit data are written to processor
 Data_Proc_Out <= Start_PB_resize when (Data_Add_In = X"01F0") else
                  Data_Ram_In (15 downto 0) when Data_Add_In(0) = '0' else
                  Data_Ram_In (31 downto 16)when Data_Add_In(0) = '1' else 
                  (others => 'U');

--The 16 LSB from  RAMs 32 bit memory data written to internal signal
 int_LSB_16bits <= Data_Ram_In(15 downto 0);
 --The 16 MSB from  RAMs 32 bit memory data written to internal signal
 int_MSB_16bits <= Data_Ram_In(31 downto 16);
 
 -- data to RAM address organised via data address bit (0) from processor,
 -- if address bit value (0) is 0 then the 16LSBs are over written keeping
 -- the original 16 MSBs.
 -- if address bit value (0) is 1 then the 16MSBs are over written keeping
 -- the original 16 LSBs.
  
 edited_memory_data(31 downto 0) <= Data_Proc_In & int_LSB_16bits when Data_Add_In(0) = '1' else
                                    int_MSB_16bits & Data_Proc_In when Data_Add_In(0) = '0' else
                                    (others => '0');
                                    
 -- updated 32 bit RAM data for address selected written back to RAM                                   
 Data_Ram_Out<= edited_memory_data; 

 end Behavioral;
