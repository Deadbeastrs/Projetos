library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;

entity Scroll is
   port(flip        : in  std_logic;
        clk         : in  std_logic;
		  clk1hz      : in  std_logic;
		  reset       : in  std_logic;
		  inload      : in  std_logic_vector(6 downto 0);
        HEX0        : out std_logic_vector(6 downto 0);
		  HEX1        : out std_logic_vector(6 downto 0);
		  HEX2        : out std_logic_vector(6 downto 0);
		  HEX3        : out std_logic_vector(6 downto 0);
		  HEX4        : out std_logic_vector(6 downto 0);
		  HEX5        : out std_logic_vector(6 downto 0);
		  HEX6        : out std_logic_vector(6 downto 0);
		  HEX7        : out std_logic_vector(6 downto 0));
end Scroll;

architecture Behavioral of Scroll is

	signal s_result : std_logic_vector(55 downto 0) := X"FFFFFFFFFFFFFF";
	
begin

   process(clk, clk1hz)
   begin
		if(rising_edge(clk)) then

		if(reset = '1') then
			s_result <= (others => '1');
		else
			if(clk1hz = '1') then
				if(flip = '1') then
					s_result(55 downto 7) <= s_result(48 downto 0);
					s_result(6 downto 0) <= inload(6 downto 0);
				end if;
			end if;
		end if;
		   HEX0 <= s_result(6 downto 0);
			HEX1 <= s_result(13 downto 7);
			HEX2 <= s_result(20 downto 14);
			HEX3 <= s_result(27 downto 21);
			HEX4 <= s_result(34 downto 28);
			HEX5 <= s_result(41 downto 35);
			HEX6 <= s_result(48 downto 42);
			HEX7 <= s_result(55 downto 49);
		end if;
   end process;

end Behavioral;