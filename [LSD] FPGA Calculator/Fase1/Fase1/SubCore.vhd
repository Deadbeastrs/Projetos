library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;

entity SubCore is
   generic(N         : positive := 8);
   port(start       : in  std_logic;
        clk         : in  std_logic;
		  sign        : out std_logic;
		  overf       : out std_logic;
        result      : out  std_logic_vector((N - 1) downto 0);
        operand0    : in  std_logic_vector((N - 1) downto 0);
        operand1    : in std_logic_vector((N - 1) downto 0));
end SubCore;

architecture Behavioral of SubCore is
	signal s_result : std_logic_vector((N - 1) downto 0);
	signal s_sign   : std_logic;
begin

   process(clk)
   begin
		if(rising_edge(clk)) then
			if(start = '1') then
				s_sign <= '0';
				s_result <= std_logic_vector(signed(operand0) - signed(operand1));
			end if;
			
			if(s_sign = '0') then
				if(s_result(N - 1) = '1') then
					s_sign <= '1';
					s_result <= std_logic_vector(unsigned (not s_result) + 1);
				end if;
			end if;
			
			result <= s_result;
			sign   <= s_sign;
						if( ((operand0(7) = '0'  and operand1(7) = '1' ) and (s_sign = '1')) or ((operand0(7) = '1'  and operand1(7) = '0' ) and (s_sign = '0'))  ) then
				overf <= '1';
			else 
				overf <= '0';
			end if;
			
		end if;
   end process;

end Behavioral;
