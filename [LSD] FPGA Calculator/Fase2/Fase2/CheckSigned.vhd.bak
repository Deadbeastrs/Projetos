library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;

entity CheckSigned is
   port(clk       : in  std_logic;
        start     : in  std_logic;
		  mode      : in  std_logic_vector(1 downto 0);
		  operand0  : in  std_logic_vector(7 downto 0);
		  operand1  : in  std_logic_vector(7 downto 0);
		  sign      : out std_logic;
		  fOperand0 : out  std_logic_vector(7 downto 0);
		  fOperand1 : out  std_logic_vector(7 downto 0));
end CheckSigned;


architecture Behavioral of CheckSigned is
begin
   process(clk)
   begin
      if (rising_edge(clk)) then
			if(start = '1') then
				if(mode = "10" or mode = "11") then
				
					if(operand0(7) = '1') then
						fOperand0 <= not std_logic_vector((unsigned(operand0) - 1));
					else
						fOperand0 <= operand0;
					end if;
					if(operand1(7) = '1') then
						fOperand1 <= not std_logic_vector((unsigned(operand1) - 1));
					else
						fOperand1 <= operand1;
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
      end if;
   end process;
end Behavioral;
