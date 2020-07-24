library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
use work.DigEng.ALL;
-- Architecture B Parameterizable Single Cycle Data Path
-- Synchronous read Register Bank connected to an Asynchronous  
-- Data Path.
-- The Data path contains 3 multiplexers, a sinlge ALU and 
-- a simulated ram Address output.
-- Multiplexer 1 controls the Input B of the ALU it either inputs 
-- the immediate value or the value from Read B input from the register selected.
-- Multiplexer 2 controls what value is output to the RAM smulated address, 
--it is either the output of the ALU or the input memory address.
--Multiplexer 3 controls the data that is input to the register bank input, 
--either the output of the ALU is input or the value that is contained within 
--address of the simulated RAM.
-- the simulated ram output is made up of a value to write to the ram 
-- controlled by a tristate buffer an input for ram value to simulate the  
-- value at that address and an output for the Address.
-- The ALU performs +1, -1, A+B, A-B, And, Or, Xor,Not operations, 
--shift left & right, rotate left & right and the flags from 
--the results are below
-- note only one of the bove ALU operations is able to be performed per clk cycle
-- Flags(0): OUT = 0
-- Flags(1): OUT ? 0
-- Flags(2): OUT = 1
-- Flags(3): OUT < 0
-- Flags(4): OUT > 0
-- Flags(5): OUT ? 0
-- Flags(6): OUT ? 0
-- Flags(7): Overflow  

-- Sel mux selector - 3 bit 
-- Sel(100) = Sel(MUX1 0 0);
-- Sel(010) = Sel(0 MUX2 0);
-- Sel(001) = Sel(0 0 MUX3);

entity Param_Datapath is
GENERIC ( data_size : natural := 16;
          reg_size  : natural := 32);

    Port ( REG_A           : in STD_LOGIC_VECTOR ((log2(reg_size))-1 downto 0);
           REG_B           : in STD_LOGIC_VECTOR ((log2(reg_size))-1 downto 0);
           WRITE_EN        : in STD_LOGIC;
           -- ENABLES REGISTERS TO BE WRITTEN TO WHEN VALUE 1
           CLK             : in STD_LOGIC;
           RST             : in STD_LOGIC;
           WRITE_REG_ADDR  : in STD_LOGIC_VECTOR ((log2(reg_size))- 1 downto 0);
           -- REGISTER NUMBER TO BE WRITTEN TO 
           IMMED           : in STD_LOGIC_VECTOR ((data_size- 1) downto 0);
           MEM_ADD         : in STD_LOGIC_VECTOR ((data_size- 1) downto 0);
           -- MEMORY OF SIMULATED RAM TO BE CHOSEN 
           Sel             : in STD_LOGIC_VECTOR (2 downto 0);
           -- BIT 0 CONTROLS mux 3, -- BIT 1 CONTROLS mux 2, -- BIT 2 CONTROLS mux 1
           ALU             : in STD_LOGIC_VECTOR (3 downto 0);
           SHIFT           : in STD_LOGIC_VECTOR ((log2(data_size))- 1 downto 0);
           -- number of shifts/rotations the ALU should infer on the data
           RAM_DATA        : in STD_LOGIC_VECTOR ((data_size - 1) downto 0);
           -- data from address of the RAM simulation
           OEN             : in STD_LOGIC;
           -- output enable to write to Ram simulation values.
           Flags           : out STD_LOGIC_VECTOR (7 downto 0);
           MEM_DATA_WRITE  : out STD_LOGIC_VECTOR ((data_size - 1) downto 0);  
            --data to be written to the RAM simulation  
           MEM_DATA_ADD    : out STD_LOGIC_VECTOR ((data_size - 1) downto 0));
            -- address of the RAM simulation to be read or written to 
            
end Param_Datapath;

architecture Behavioral of Param_Datapath is

signal REG_A_DATA_INT        : STD_LOGIC_VECTOR((data_size-1) downto 0);
signal REG_B_DATA_INT        : STD_LOGIC_VECTOR((data_size-1) downto 0);
signal ALU_SHIFT_OUT_INT     : STD_LOGIC_VECTOR((data_size-1) downto 0);
signal SHIFT_OUT_INT         : STD_LOGIC_VECTOR((data_size-1) downto 0);
signal MUX_1_OUT_INT         : STD_LOGIC_VECTOR((data_size-1) downto 0);
signal MUX_2_OUT_INT         : STD_LOGIC_VECTOR((data_size-1) downto 0);
signal MUX_3_OUT_INT         : STD_LOGIC_VECTOR((data_size-1) downto 0);
signal Flags_INT             : STD_LOGIC_VECTOR(7 downto 0);

begin

Reg_Bank: entity work.reg_bank
            Generic map( data_size => data_size,
                         reg_size  => reg_size)
            
              port map ( -- inputs 
                         CLK        => clk ,
                         rst        => RST,
                         Write_en   => WRITE_EN,
                         Write_addr => WRITE_REG_ADDR,
                         Reg_A      => REG_A, 
                         Reg_B      => REG_B,
                         DATA_IN    => MUX_3_OUT_INT,
                         -- outputs 
                         DATA_OUT_1 => REG_A_DATA_INT,
                         DATA_OUT_2 => REG_B_DATA_INT);

ALU_Parameterizable: entity work.Parameterizable_ALU 
            Generic map( data_size => data_size)
            
               Port map (-- inputs 
                         A       => REG_A_DATA_INT,
                         B       => MUX_1_OUT_INT,
                         X       => SHIFT,
                         OpCode  => ALU,
                         -- outputs   
                         ALU_Out => ALU_SHIFT_OUT_INT,
                         Flags   => Flags_INT);

 
  --MULTIPLEXER 1
 MUX_1_OUT_INT  <= IMMED when Sel(2) = '1' else--
                   REG_B_DATA_INT when Sel(2) = '0' else --
                   (others => 'U');                                 
  --MULTIPLEXER 2                                                                                       
 MUX_2_OUT_INT  <=  MEM_ADD when Sel(1) = '1' else-- 
                   ALU_SHIFT_OUT_INT when Sel(1) = '0' else-- 
                   (others => 'U');                                                            
   --MULTIPLEXER 3                                                                                  
 MUX_3_OUT_INT  <= RAM_DATA when Sel(0) = '1' else--                                    
                   ALU_SHIFT_OUT_INT when Sel(0) = '0' else--                                    
                   (others => 'U');                               
                                          
 MEM_DATA_WRITE <= REG_B_DATA_INT;
 MEM_DATA_ADD   <= MUX_2_OUT_INT;
 Flags <= Flags_INT;  
                                    
end Behavioral;           

 