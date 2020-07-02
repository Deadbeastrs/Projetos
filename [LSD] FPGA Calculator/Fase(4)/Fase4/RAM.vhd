library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
 
entity RAM is
port( writeClk : in std_logic;
      writeEnable : in std_logic;
      writeData : in std_logic_vector(6 downto 0);
		readAddress : in std_logic_vector(6 downto 0);
      writeAddress : in std_logic_vector(6 downto 0);
      readData : out std_logic_vector(6 downto 0));
end RAM;
 
architecture Behavioral of RAM is
subtype TDataWord is std_logic_vector(6 downto 0);
type TMemory is array (0 to 63) of TDataWord ;
signal s_memory : TMemory := (others => (others => '1'));
 
begin
    process(writeClk)
    begin
        if (rising_edge(writeClk)) then
            if (writeEnable = '1') then
                s_memory(to_integer(unsigned(writeAddress))) <= writeData;
            end if;
				readData <= s_memory(to_integer(unsigned(readAddress)));
        end if;
    end process;
end Behavioral;