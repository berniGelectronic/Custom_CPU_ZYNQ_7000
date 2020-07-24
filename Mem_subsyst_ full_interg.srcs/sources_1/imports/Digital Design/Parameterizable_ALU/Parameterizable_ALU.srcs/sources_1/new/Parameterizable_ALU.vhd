library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
use work.DigEng.ALL;

-- Parametrizable ALU entitiy
-- 1 x generic - Data size
-- 2 x Data size inputs, 1 x log2(data size) input for shift and rotate bits
-- 1 x Opcode input
-- 1 x output of ALU, 1 x Flag out

entity Parameterizable_ALU is
generic (Data_Size : natural := 16);
        
         
    Port ( A : in STD_LOGIC_VECTOR ((Data_Size-1) downto 0);
           B : in STD_LOGIC_VECTOR ((Data_Size-1) downto 0);
           X : in STD_LOGIC_VECTOR (log2(Data_Size)-1 downto 0);
           OpCode : in STD_LOGIC_VECTOR (3 downto 0);
           ALU_Out : out STD_LOGIC_VECTOR (Data_Size-1 downto 0);
           Flags : out STD_LOGIC_VECTOR (7 downto 0));
end Parameterizable_ALU;


architecture Behavioral of Parameterizable_ALU is

signal MUX_Output : STD_LOGIC_VECTOR((Data_Size-1) downto 0);
signal X_Integer : integer ;

begin
X_Integer <= to_integer(unsigned(X));


                                                   -- identity
                                       MUX_Output <= A when (OpCode  = "0000") else--
                                        (others => '0')when (OpCode  = "0001") else--
                                        (others => '0')when (OpCode  = "0010") else--
                                        (others => '0')when (OpCode  = "0011") else--
                                       
                                                   -- bitwise logic
                                              (A and B) when(OpCode  = "0100") else--
                                               (A or B) when(OpCode  = "0101") else--
                                              (A xor B) when(OpCode  = "0110") else--
                                                (Not A) when(OpCode  = "0111") else--
                                                   -- Arithmetic
 STD_LOGIC_VECTOR        (((signed(A)) + 1))            when(OpCode  = "1000") else--
 STD_LOGIC_VECTOR        (((signed(A)) - 1))            when(OpCode  = "1001") else--
 STD_LOGIC_VECTOR        (((signed(A)) + (signed(B))))  when(OpCode  = "1010") else-- 
 STD_LOGIC_VECTOR        (((signed(A)) - (signed(B))))  when(OpCode  = "1011") else-- 
                                                   --shift
 STD_LOGIC_VECTOR(shift_left  (signed(A),   X_Integer)) when (OpCode = "1100") else--
 STD_LOGIC_VECTOR(shift_right (signed(A),   X_Integer)) when (OpCode = "1101") else--
 STD_LOGIC_VECTOR(rotate_left (unsigned(A), X_Integer)) when (OpCode = "1110") else--
 STD_LOGIC_VECTOR(rotate_right(unsigned(A), X_Integer)) when (OpCode = "1111") else--
                                                                     (others => 'U');
    
   Flags(0) <= '1' when (signed(MUX_Output)  = 0) else '0'; -- equal to 0 check
   Flags(1) <= '1' when (signed(MUX_Output) /= 0) else '0'; -- not equal to 0 check
   Flags(2) <= '1' when (signed(MUX_Output)  = 1) else '0'; -- equal to 1 check
   Flags(3) <= '1' when (signed(MUX_Output)  < 0) else '0'; -- less than 0 check
   Flags(4) <= '1' when (signed(MUX_Output)  > 0) else '0'; -- greater than 0 check
   Flags(5) <= '1' when (signed(MUX_Output) <= 0) else '0'; -- less than or equal to 0 check
   Flags(6) <= '1' when (signed(MUX_Output) >= 0) else '0'; -- greater than or equal to 0 check
   
   Flags(7) <= '1' when (OpCode = "1000" and A(Data_Size-1)= '0' and MUX_Output(Data_Size-1)= '1' ) else
               '1' when (OpCode = "1001" and A(Data_Size-1)= '1' and MUX_Output(Data_Size-1)= '0')  else 
               
               '1' when (OpCode = "1010" and A(Data_Size-1)= '0' and B(Data_Size-1)= '0' and MUX_Output(Data_Size-1)= '1') else
               '1' when (OpCode = "1010" and A(Data_Size-1)= '1' and B(Data_Size-1)= '1' and MUX_Output(Data_Size-1)= '0') else
               
               '1' when (OpCode = "1011" and A(Data_Size-1)= '1' and B(Data_Size-1)= '0' and MUX_Output(Data_Size-1)= '0') else
               '1' when (OpCode = "1011" and A(Data_Size-1)= '0' and B(Data_Size-1)= '1' and MUX_Output(Data_Size-1)= '1') else
               '0';
                         
 ALU_Out <= MUX_Output;

end Behavioral;
