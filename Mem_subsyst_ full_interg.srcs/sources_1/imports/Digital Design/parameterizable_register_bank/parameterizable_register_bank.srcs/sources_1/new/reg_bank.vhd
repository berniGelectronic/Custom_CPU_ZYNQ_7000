

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.DigEng.ALL; 

-- parameterizable register bank 
-- One Write per clock cycle, dual read
-- two generics for data size and number of registers
-- 2D Array of register outputs [reg_X][data_size]

entity reg_bank is
    GENERIC ( data_size : natural := 16;
              reg_size  : natural := 8);
    Port( 
          -- inputs
          clk : in STD_LOGIC;
          rst : in STD_LOGIC;
          Write_en   : in STD_LOGIC;
          Write_addr : in STD_LOGIC_VECTOR (log2(reg_size)-1 downto 0);
          Reg_A : in STD_LOGIC_VECTOR (log2(reg_size)-1 downto 0);
          Reg_B : in STD_LOGIC_VECTOR (log2(reg_size)-1 downto 0);       
          DATA_IN : in STD_LOGIC_VECTOR (data_size -1 downto 0);
          -- outputs
          DATA_OUT_1: out STD_LOGIC_VECTOR (data_size-1 downto 0);
          DATA_OUT_2: out STD_LOGIC_VECTOR (data_size-1 downto 0));
end reg_bank;
architecture Behavioral of reg_bank is
-- Internal signals
-- 2D array of register outputs 
type reg_bank is array (reg_size-1  downto 0) 
    of STD_LOGIC_VECTOR(data_size -1  downto 0);
signal int_reg_bank_out : reg_bank;  -- array
-- internal from decoder to registers
signal int_reg_addr     : STD_LOGIC_VECTOR ( reg_size -1 downto 0); 
-- internal buffer B enable
signal int_buff_B_en    : STD_LOGIC_VECTOR( reg_size -1 downto 0); 
-- internal buffer A enable
signal int_buff_A_en    : STD_LOGIC_VECTOR( reg_size -1 downto 0); 
-- internal Data_in for register 0
signal int_data_in_reg0 : STD_LOGIC_VECTOR(data_size -1 downto  0); 

begin
Reg0: entity work.reg_bits
            Generic map( data_size => data_size)
            port map ( clk => clk,
                       rst => rst,
                       en => int_reg_addr(0),
                       DATA_IN => int_data_in_reg0,
                       DATA_OUT => int_reg_bank_out(0)); 
                                        
int_reg_addr(0) <= '0';             
DATA_OUT_1 <= int_reg_bank_out(0) when (int_buff_A_en(0) = '1')
                                  else (others => 'Z'); -- Z = high-impedance 
DATA_OUT_2 <= int_reg_bank_out(0) when (int_buff_B_en(0) = '1')
                                  else (others => 'Z'); -- Z = high-impedance     
                                   
-- starting from 1, 0 is phantom register, not used
REG: for i in 1 to reg_size - 1 generate
   one_bit: entity work.reg_bits
            Generic map( data_size => data_size)
            port map ( clk => clk,
                       rst => rst,
                       en => int_reg_addr(i),
                       DATA_IN => DATA_IN,
                       DATA_OUT => int_reg_bank_out(i));
            
            -- buffer implementation          
            DATA_OUT_1 <= int_reg_bank_out(i) when (int_buff_A_en(i) = '1')
                                              else (others => 'Z'); -- Z = high-impedance 
            DATA_OUT_2 <= int_reg_bank_out(i) when (int_buff_B_en(i) = '1')
                                              else (others => 'Z'); -- Z = high-impedance 

--Write address reg decoder   
int_reg_addr(i) <= '1' when (i = unsigned(Write_addr) and Write_en = '1')
                   else 'Z';                         
    end generate;
    
--reg A/B address Decoder
DECODER: for i in 0 to reg_size - 1 generate
int_buff_A_en(i)<= '1' when (i = unsigned(Reg_A))
                       else 'Z';
int_buff_B_en(i)<= '1' when (i = unsigned(Reg_B))
                       else 'Z';       

end generate;
       
end Behavioral;                   
                   