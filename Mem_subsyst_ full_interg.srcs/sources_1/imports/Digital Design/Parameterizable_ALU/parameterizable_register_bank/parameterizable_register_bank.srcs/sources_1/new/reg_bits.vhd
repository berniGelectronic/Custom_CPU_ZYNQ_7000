
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Parametrizable D type Flip flop with enable
-- recevies generic data_size

entity reg_bits is
    GENERIC( data_size : natural := 16);
    Port ( 
           -- Inputs
           clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           en : in STD_LOGIC;
           -- Outputs
           DATA_IN : in STD_LOGIC_VECTOR (data_size -1 downto 0);
           DATA_OUT : out STD_LOGIC_VECTOR (data_size -1 downto 0));
end reg_bits;

architecture Behavioral of reg_bits is

begin
process(clk)
   begin
     if(rising_edge(clk)) then
         if(rst = '1') then
             DATA_OUT <=(others => '0');
         elsif(en = '1') then 
             DATA_OUT <= DATA_IN;
         End if;
     End if;
   end process;


end Behavioral;
