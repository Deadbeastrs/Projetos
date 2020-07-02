library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
 
entity Save_to_RAM is
port(clk         : in std_logic;
     startWrite  : in std_logic := '0';
	  increment   : in std_logic_vector(6 downto 0);
	  startRead   : in std_logic := '0';
	  sqrt        : in std_logic;
	  oprSqrt     : in std_logic_vector(15 downto 0);
	  clk1hz      : in std_logic;
	  operand0    : in std_logic_vector(7 downto 0);
	  operand1    : in std_logic_vector(7 downto 0);
	  oprand0Sign : in std_logic;
	  oprand1Sign : in std_logic;
	  operation   : in std_logic_vector(1 downto 0);
	  result      : in std_logic_vector(15 downto 0);
	  overflow    : in std_logic;
	  doneDec     : out std_logic;
	  saveDone    : out std_logic;
	  readData    : out std_logic_vector(6 downto 0);
	  resultSign  : in std_logic);
end Save_to_RAM;

 
architecture Behavioral of Save_to_RAM is

	signal countWrite : integer range 0 to 5;
	signal countRead : integer range 0 to 60;
	signal s_decoder : std_logic_vector(15 downto 0);
	signal s_writeData : std_logic_vector(6 downto 0);
	signal val_5, val_4, val_3, val_2, val_1, val_0 : std_logic_vector(6 downto 0);
	signal s_readAddress : std_logic_vector(6 downto 0);
	signal s_writeAddress : std_logic_vector(6 downto 0);
	signal s_startDec : std_logic;
	signal s_sign, s_saveDone, s_doneDec, s_resetSeg, s_loadOp0, s_loadOp1, s_loadRes, s_addDone, op0_write, op1_write, s_addOp, s_addOvf, res_write  : std_logic := '0';
	
begin
   process(clk)
   begin
      if (rising_edge(clk)) then
			if(s_resetSeg = '1') then
				countWrite <= 0;
			end if;
			if(s_loadOp0 = '1') then
				s_startDec <= '1';
				if(sqrt = '0') then
					s_decoder(7 downto 0) <= operand0;
					s_sign    <= oprand0Sign;
				else
					s_decoder <= oprSqrt;
					s_sign <= '0';
				end if;
				if(s_doneDec = '1') then
					s_startDec <= '0';
				end if;
			end if;
			
			if(s_loadOp1 = '1') then
				s_startDec <= '1';
				s_decoder(7 downto 0) <= operand1;
				s_sign    <= oprand1Sign;
				if(s_doneDec = '1') then
					s_startDec <= '0';
				end if;
			end if;
			
			if(s_loadRes = '1') then
				s_startDec <= '1';
				s_decoder <= result;
				s_sign    <= resultSign;
				if(s_doneDec = '1') then
					s_startDec <= '0';
				end if;
			end if;
			
			if(s_addOp = '1') then
				s_writeAddress <= std_logic_vector(6 + unsigned(increment));
				if(sqrt = '0') then
					if(operation = "00") then
						s_writeData <= "0001000";
					elsif(operation = "01") then
						s_writeData <= "0000011";
					elsif(operation = "10") then
						s_writeData <= "1000110";
					elsif(operation = "11") then
						s_writeData <= "0100001";
					end if;
				else
					s_writeData <= "1100001";
				end if;
			end if;
			
			if(op0_write = '1') then
			
				case countWrite is
				when 0 =>
					s_writeAddress <= std_logic_vector(0 + unsigned(increment));
					s_writeData <= val_5;
				when 1 =>
					s_writeAddress <= std_logic_vector(1 + unsigned(increment));
					s_writeData <= val_4;
				when 2 =>
					s_writeAddress <= std_logic_vector(2 + unsigned(increment));
					s_writeData <= val_3;
				when 3 =>
					s_writeAddress <= std_logic_vector(3 + unsigned(increment));
					s_writeData <= val_2;
				when 4 =>
					s_writeAddress <= std_logic_vector(4 + unsigned(increment));
					s_writeData <= val_1;
				when 5 =>
					s_writeAddress <= std_logic_vector(5 + unsigned(increment));
					s_writeData <= val_0;
				end case;
				
				if(countWrite = 5) then
					countWrite <= 0;
					s_addDone <= '1';
				else
					countWrite <= countWrite + 1;
					s_addDone <= '0';
				end if;
				
			end if;
			

			if(op1_write = '1') then
				countWrite <= countWrite + 1;
				case countWrite is
				when 0 =>
					s_writeAddress <= std_logic_vector(7 + unsigned(increment));
					s_writeData <= val_5;
				when 1 =>
					s_writeAddress <= std_logic_vector(8 + unsigned(increment));
					s_writeData <= val_4;
				when 2 =>
					s_writeAddress <= std_logic_vector(9 + unsigned(increment));
					s_writeData <= val_3;
				when 3 =>
					s_writeAddress <= std_logic_vector(10 + unsigned(increment));
					s_writeData <= val_2;
				when 4 =>
					s_writeAddress <= std_logic_vector(11 + unsigned(increment));
					s_writeData <= val_1;
				when 5 =>
					s_writeAddress <= std_logic_vector(12 + unsigned(increment));
					s_writeData <= val_0;
				end case;
				
				if(countWrite = 5) then
					countWrite <= 0;
					s_addDone <= '1';
				else
					s_addDone <= '0';
				end if;
				
			end if;
			
			if(res_write = '1') then
				countWrite <= countWrite + 1;
				case countWrite is
				when 0 =>
					s_writeAddress <= std_logic_vector(13 + unsigned(increment));
					s_writeData <= val_5;
				when 1 =>
					s_writeAddress <= std_logic_vector(14 + unsigned(increment));
					s_writeData <= val_4;
				when 2 =>
					s_writeAddress <= std_logic_vector(15 + unsigned(increment));
					s_writeData <= val_3;
				when 3 =>
					s_writeAddress <= std_logic_vector(16 + unsigned(increment));
					s_writeData <= val_2;
				when 4 =>
					s_writeAddress <= std_logic_vector(17 + unsigned(increment));
					s_writeData <= val_1;
				when 5 =>
					s_writeAddress <= std_logic_vector(18 + unsigned(increment));
					s_writeData <= val_0;
				end case;
				
				if(countWrite = 5) then
					countWrite <= 0;
					s_addDone <= '1';
				else
					s_addDone <= '0';
				end if;
				
			end if;
			
			if(s_addOvf = '1') then
				if(overflow = '1') then
					s_writeAddress <= std_logic_vector(19 + unsigned(increment));
					s_writeData <= "0000110";
				else
					s_writeAddress <= std_logic_vector(19 + unsigned(increment));
					s_writeData <= "1111111";
				end if;
			end if;
		
			if(startRead = '1') then
				s_readAddress <= std_logic_vector(to_unsigned(countRead, 7));
				if(clk1hz = '1') then
					countRead <= countRead + 1;
				end if;
			else
				countRead <= 0;
			end if;
			if(countRead = 60) then
				countRead <= 0;
			end if;
				
      end if;
		
   end process;
	
	BinTo7Seg : entity work.binto7segments(Behavioral)
		generic map(numBits => 16)
      port map(clk        => clk,
               binaryIn   => s_decoder,
					sign       => s_sign,
					start      => s_startDec,
					done       => s_doneDec,
					HEX0       => val_0,
               HEX1       => val_1,
               HEX2       => val_2,
               HEX3       => val_3,
					HEX4       => val_4,
					HEX5       => val_5);
					
	
	RAM : entity work.RAM(Behavioral)
   port map(writeClk      => clk,
            writeEnable   => '1',
				writeData     => s_writeData,
				readAddress   => s_readAddress,
            writeAddress  => s_writeAddress,
				readData      => readData);
	
	RAMControl : entity work.SaveControl(funcao)
   port map(clk        => clk,
            reset      => '0',
				start      => startWrite,
            done       => doneDec,
				loadOp0    => s_loadOp0,
				resetCounter => s_resetSeg,
				sqrtMode   => sqrt, 
				loadDone   => s_doneDec,
				AddDone    => s_addDone,
				addOp0     => op0_write,
				OpAdd      => s_addOp,
				loadOp1    => s_loadOp1,
				addOp1     => op1_write,
				loadResult => s_loadRes,
				addResult  => res_write,
				addOvf     => s_addOvf);
				
end Behavioral;