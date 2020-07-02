library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;

entity CheckSigned is
   port(clk       : in  std_logic;
        start     : in  std_logic;
		  operand0  : in  std_logic_vector(7 downto 0);
		  operand1  : in  std_logic_vector(7 downto 0);
		  op0sign   : out std_logic;
		  op1sign   : out std_logic;
		  sign      : out std_logic;
		  fOperand0 : out  std_logic_vector(7 downto 0);
		  fOperand1 : out  std_logic_vector(7 downto 0));
end CheckSigned;


architecture Behavioral of CheckSigned is
	
	signal s_op0sign : std_logic;
	signal s_op1sign : std_logic;
	
begin
   process(clk)
   begin
      if (rising_edge(clk)) then
			if(start = '1') then
				
					if(operand0(7) = '1') then
						fOperand0 <= not std_logic_vector((unsigned(operand0) - 1));
						s_op0sign <= '1';
					else
						fOperand0 <= operand0;
						s_op0sign <= '0';
					end if;
					if(operand1(7) = '1') then
						fOperand1 <= not std_logic_vector((unsigned(operand1) - 1));
						s_op1sign <= '1';
					else
						fOperand1 <= operand1;
						s_op1sign <= '0';
					end if;
					
					--sign Detection--
					if(operand0(7) = '1' xor operand1(7) = '1') then
						sign <= '1';
					else
						sign <= '0';
					end if;
					--**************--
					
					
			end if;
      end if;
   end process;
end Behavioral;
