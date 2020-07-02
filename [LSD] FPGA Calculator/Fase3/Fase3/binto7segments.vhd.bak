library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;

entity binto7segments is
	generic(numBits  : positive := 16);
   port(clk      : in  std_logic;
        binaryIn : in  std_logic_vector(numBits-1 downto 0);
		  sign     : in std_logic;
        HEX0     : out std_logic_vector(6 downto 0);
		  HEX1     : out std_logic_vector(6 downto 0);
		  HEX2     : out std_logic_vector(6 downto 0);
		  HEX3     : out std_logic_vector(6 downto 0);
		  HEX4     : out std_logic_vector(6 downto 0);
		  HEX5     : out std_logic_vector(6 downto 0));
end binto7segments;

architecture Behavioral of binto7segments is

	signal s_resto4,s_resto3,s_resto2, s_resto1, s_binaryIn : std_logic_vector(15 downto 0);
	signal num0, num1, num2, num3, num4 : std_logic_vector(15 downto 0);
	signal sign_value : std_logic_vector(3 downto 0);

begin
   process(clk)
   begin
      if(rising_edge(clk)) then
				
				--Binary to bcd--
				num4 <= std_logic_vector(unsigned(binaryIn) / 10000);
				s_resto4 <= std_logic_vector(unsigned(binaryIn) rem 10000);
				
				num3 <= std_logic_vector(unsigned(s_resto4) / 1000);
				s_resto3 <= std_logic_vector(unsigned(s_resto4) rem 1000);
				
				num2 <= std_logic_vector(unsigned(s_resto3) / 100);
				s_resto2 <= std_logic_vector(unsigned(s_resto3) rem 100);
				
				num1 <= std_logic_vector(unsigned(s_resto2) / 10);
				s_resto1 <= std_logic_vector(unsigned(s_resto2) rem 10);
				
				num0 <= std_logic_vector(s_resto1);
				--**************--
				
				if(sign = '1') then
					sign_value <= "1100";
				else
					sign_value <= "0000";
				end if;
				
		end if;
	end process;
	
	decoder0 : entity work.Bin7SegDecoder(teste)
					port map(binInput => num0(3 downto 0),
								decOut_n => HEX0(6 downto 0));
	
	
	decoder1 : entity work.Bin7SegDecoder(teste)
					port map(binInput => num1(3 downto 0),
								decOut_n => HEX1(6 downto 0));
	
	
	decoder2 : entity work.Bin7SegDecoder(teste)
					port map(binInput => num2(3 downto 0),
								decOut_n => HEX2(6 downto 0));
	
	
   decoder3 : entity work.Bin7SegDecoder(teste)
					port map(binInput => num3(3 downto 0),
								decOut_n => HEX3(6 downto 0));
			
	decoder4 : entity work.Bin7SegDecoder(teste)
					port map(binInput => num4(3 downto 0),
								decOut_n => HEX4(6 downto 0));
	
	decoder5 : entity work.Bin7SegDecoder(teste)
					port map(binInput => sign_value,
								decOut_n => HEX5(6 downto 0));
end Behavioral;