library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
use work.DigEng.ALL;

--@Type Custom CPU on ZYNQ 7000 , ZedBoard
--@Module Digital Design @University of York, 2019/20
--@Students Bernard & Oliver 
--@Date December 2019.

-- Top Entity for synchronous general purpose processor.
-- The top entity implements tested entitys to make up the system:
-- control unit for instruction register,sequencer and decode logic
-- proccessing unit name:data path,ALU and bank of 32 registers within
-- Memory Management unit (MMU)
-- Dual Port Memory 128x32  32 bit-word addressable
-- output reg 16 bits top 8MSBs output to LEDs on board
-- for more infomration regarding each entity see the corresponding file.

-- The system processes through the instructions as per the design supplied
-- The system should finish with the values:
--If the program has run correctly, execution should finish at
--instruction 43 and never move from there. Register and
--memory contents should be the following (decimal):
--r1 = 33; r2 = 16; r3 = r4 = r5 = r6 = r9 = 0;
--r7 = r8 = 44800; r10 = -1 (65535); r11 = r12 = 1;
--DMEM(0) = 700; DMEM(1) = 44801
--The LEDs should display decimal 44800. 

entity Mem_Subsys_Full_Interg is
 GENERIC ( data_size : natural := 16;
           reg_size  : natural := 32);
    Port ( PB_Start  : in STD_LOGIC;
           clk       : in STD_LOGIC;
           PB_Rst    : in STD_LOGIC;
           LEDs      : out STD_LOGIC_VECTOR (7 downto 0));
end Mem_Subsys_Full_Interg;

architecture Behavioral of Mem_Subsys_Full_Interg is

-- internal RAM Instruction to Control unit
signal RAM_Inst_to_CTRL_Unit_int : STD_LOGIC_VECTOR(31 downto 0);

--signals to and from MMU
--data from ram to MMU internal signal
signal int_Data_Ram_In      : STD_LOGIC_VECTOR (31 downto 0);    
--Instruction address from MMU to RAM internal signal  
signal int_Inst_Add_Ram     : STD_LOGIC_VECTOR (6 downto 0);    
-- data from RAM to MMU internal signal  
signal int_Data_Ram_Out     : STD_LOGIC_VECTOR (31 downto 0);   
-- data address internal signal
signal int_Data_Add         : STD_LOGIC_VECTOR (6 downto 0);  
-- data from MMU to output reg internal signal                      
signal int_Output_Reg       : STD_LOGIC_VECTOR (15 downto 0);
-- write enable from MMU to RAM internal signal 
signal int_Write_En_Ram     : STD_LOGIC;  
-- write enable from MMU to Output register internal signal    
signal int_Write_En_Out_Reg : STD_LOGIC;
--signals from control logic to Datapath
-- Register A to Datapath internal signal  
signal int_RA_to_Datapath : STD_LOGIC_VECTOR(4 downto 0); 
-- Register B to Datapath internal signal  
signal int_RB_to_Datapath : STD_LOGIC_VECTOR(4 downto 0); 
-- Write Address to Datapath internal signal  
signal int_WA_to_Datapath : STD_LOGIC_VECTOR(4 downto 0); 
-- Memory address to Datapath internal signal  
signal int_MEM_ADDR_to_Datapath    : STD_LOGIC_VECTOR(data_size - 1 downto 0); --16 bit immidate value
-- Immediate value to Datapath internal signal  
signal int_IMM_VALUE_to_Datapath   : STD_LOGIC_VECTOR(data_size - 1 downto 0); --16 bit immidate value
-- Address offset to Datapath internal signal  
signal int_ADDR_OFFSET_to_Datapath : STD_LOGIC_VECTOR(9 downto 0); 
-- Program offset to Datapath internal signal  
signal int_PC_OFFSET_to_Datapath   : STD_LOGIC_VECTOR(8 downto 0); 
-- Shift value to Datapath internal signal     
signal int_SHIFTER_to_Datapath     : STD_LOGIC_VECTOR(3 downto 0); 
-- branch CONDition to Datapath internal signal      
signal int_COND_to_Datapath : STD_LOGIC_VECTOR(2 downto 0); 
-- Output enable to Datapath internal signal      
signal int_OEN_to_Datapath  : STD_LOGIC;
-- Multiplexer control selector Signal to Datapath internal signal  
signal int_S_to_Datapath    : STD_LOGIC_VECTOR(2 downto 0); 
-- Arithmatatic Logic Unit control Signal to Datapath internal signal  
signal int_ALU_to_Datapath  : STD_LOGIC_VECTOR(3 downto 0);
-- Write enable to Datapath internal signal          
signal int_WEN_to_Datapath  : STD_LOGIC; 
-- Memory instruction address to datapath internal signal
signal int_MIA_to_Datapath  : STD_LOGIC_VECTOR(7 downto 0); 
-- RAM data to datapath internal signal
signal int_RAM_DATA_to_Datapath       : STD_LOGIC_VECTOR ((data_size - 1) downto 0);
--RAM DATA to data path internal signal
signal int_MEM_DATA_WRITE_to_Datapath : STD_LOGIC_VECTOR ((data_size - 1) downto 0);  
--RAM DATA ADDRESS internal signal
signal int_MEM_DATA_ADD_to_Datapath   : STD_LOGIC_VECTOR ((data_size - 1) downto 0); 
-- flags from ALU to the control unit internal signal
signal int_FLAGS_ALU_to_Datapath      : STD_LOGIC_VECTOR(7 downto 0); 
-- LEDs value output internal signal
signal int_LEDs : STD_LOGIC_VECTOR(data_size-1 downto  0);

begin
-- output LEDS connected to top 8 MSBs
LEDs <= int_LEDs(15 downto 8); 

Control_Logic: entity work.control_logic
PORT MAP   (--Inputs            
            clk            => clk, 
            rst            => PB_Rst, 
            FLAGS_ALU      => int_FLAGS_ALU_to_Datapath,
            INSTRUCTION    => RAM_Inst_to_CTRL_Unit_int, 
            --Outputs
            MIA            => int_MIA_to_Datapath,
            RA             => int_RA_to_Datapath,
            RB             => int_RB_to_Datapath,
            WA             => int_WA_to_Datapath,
            MEM_ADDR       => int_MEM_ADDR_to_Datapath,
            IMM_VALUE      => int_IMM_VALUE_to_Datapath,
            ADDR_OFFSET    => int_ADDR_OFFSET_to_Datapath,
            PC_OFFSET      => int_PC_OFFSET_to_Datapath,
            SHIFTER        => int_SHIFTER_to_Datapath,
            COND           => int_COND_to_Datapath,
            OEN            => int_OEN_to_Datapath,
            SEL            => int_S_to_Datapath,
            ALU            => int_ALU_to_Datapath,
            WEN            => int_WEN_to_Datapath);


DATAPATH: entity work.Param_Datapath
GENERIC MAP ( data_size => data_size,
              reg_size => reg_size)
PORT MAP(
         REG_A          => int_RA_to_Datapath,
         REG_B          => int_RB_to_Datapath,
         WRITE_EN       => int_WEN_to_Datapath,
         CLK            => clk,
         RST            => PB_Rst,
         WRITE_REG_ADDR => int_WA_to_Datapath,
         IMMED          => int_IMM_VALUE_to_Datapath,
         MEM_ADD        => int_MEM_ADDR_to_Datapath,
         Sel            => int_S_to_Datapath,
         ALU            => int_ALU_to_Datapath,
         SHIFT          => int_SHIFTER_to_Datapath,
         RAM_DATA       => int_RAM_DATA_to_Datapath,
         OEN            => int_OEN_to_Datapath,
         Flags          => int_FLAGS_ALU_to_Datapath,  
         MEM_DATA_WRITE => int_MEM_DATA_WRITE_to_Datapath,
         MEM_DATA_ADD   => int_MEM_DATA_ADD_to_Datapath
         );

Output_reg: entity work.reg_bits
Generic map( data_size => data_size)
PORT MAP   ( --inputs
             clk       => clk,
             rst       => PB_rst,
             en        => int_Write_En_Out_Reg,
             DATA_IN   => int_Output_Reg,
             -- outputs
             DATA_OUT  => int_LEDs); 

Dual_Port_RAM: entity work.Dual_Port_Mem
PORT MAP ( -- inputs
          clk          => clk,
          Inst_Add     => int_Inst_Add_Ram,
          Data_Add     => int_Data_Add,
          Write_Data_En=> int_Write_En_Ram,
          Data_In      => int_Data_Ram_Out,     
          -- outputs
          Data_Out     => int_Data_Ram_In,
          Inst_Out     => RAM_Inst_to_CTRL_Unit_int);
 
Memory_Management_Unit: entity work.Mem_Manag_Unit
Port map (    
          --inputs         
          Start_PB         =>  PB_Start,                      
          Output_En_In     =>  int_OEN_to_Datapath,
          Inst_Add_In      =>  int_MIA_to_Datapath,
          Data_Proc_In     =>  int_MEM_DATA_WRITE_to_Datapath,
          Data_Add_In      =>  int_MEM_DATA_ADD_to_Datapath,
          Data_Ram_In      =>  int_Data_Ram_In,
          --outputs            
          Inst_Add_Ram     =>  int_Inst_Add_Ram,                   
          Data_Ram_Out     =>  int_Data_Ram_Out,
          Data_Proc_Out    =>  int_RAM_DATA_to_Datapath,
          Data_Add         =>  int_Data_Add,
          Output_Reg       =>  int_Output_Reg,
          Write_En_Ram     =>  int_Write_En_Ram,        
          Write_En_Out_Reg =>  int_Write_En_Out_Reg);
         
end Behavioral; 
