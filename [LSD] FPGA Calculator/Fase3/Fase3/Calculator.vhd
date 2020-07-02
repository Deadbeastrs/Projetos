library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;

entity Calculator is
   port(CLOCK_50 : in  std_logic;
        KEY      : in  std_logic_vector(3 downto 0);
        SW       : in  std_logic_vector(17 downto 0);
		  HEX0     : out std_logic_vector(6 downto 0);
		  HEX1     : out std_logic_vector(6 downto 0);
		  HEX2     : out std_logic_vector(6 downto 0);
		  HEX3     : out std_logic_vector(6 downto 0);
		  HEX4     : out std_logic_vector(6 downto 0);
		  HEX5     : out std_logic_vector(6 downto 0);
		  HEX6     : out std_logic_vector(6 downto 0);
		  HEX7     : out std_logic_vector(6 downto 0);
        LEDR     : out std_logic_vector(0 downto 0));
end Calculator;

architecture Structural of Calculator is

   signal s_add, s_sub, s_mult, s_div, s_start, s_checkSigned, s_sqrt,s_sw16, s_reset    : std_logic;
	signal s_overflow_sum, s_overflow_sub, s_overflow, s_scroll                           : std_logic;
	signal s_key0, s_key1, s_key2, s_key3, s_sqrtkey                                      : std_logic;
	signal s_sign_sum, s_sign_sub, s_sign_mult_div, s_sign, s_op0sign,  s_op1sign         : std_logic;
   signal s_multDone, s_divDone, s_sqrtDone, s_saveDone                                  : std_logic := '0';
	signal s_mode, s_writeAddress, s_readAddress                                          : std_logic_vector(1 downto 0);
	signal s_operand0, s_operand1, s_foperand0, s_foperand1                               : std_logic_vector(7 downto 0);
	signal s_multResult, s_finalResult, s_sqrtResult                                      : std_logic_vector(15 downto 0);
	signal s_divQuotient                                                                  : std_logic_vector(7 downto 0);
   signal s_sumResult,s_subResult                                                        : std_logic_vector(7 downto 0);
	signal s_clk1hz , s_teste , s_resetScroll                                             : std_logic;
	signal s_writeEnable, s_startRead, s_save                                             : std_logic;
	signal s_pos                                                                          : std_logic_vector(1 downto 0) := "10";
	signal s_20                                                                           : std_logic_vector(4 downto 0);
	signal s_writeData, s_readData                                                        : std_logic_vector(15 downto 0);
	signal s_increment                                                                    : std_logic_vector(6 downto 0);
	signal testeOut, s_HEX0, s_HEX1, s_HEX2, s_HEX3, s_HEX4, s_HEX5,s_HEX6, s_HEX7        : std_logic_vector(6 downto 0);
	signal s_HEX0Dec, s_HEX1Dec, s_HEX2Dec, s_HEX3Dec, s_HEX4Dec, s_HEX5Dec               : std_logic_vector(6 downto 0);
	signal s_HEX0Scr, s_HEX1Scr, s_HEX2Scr, s_HEX3Scr, s_HEX4Scr, s_HEX5Scr, s_HEX6Scr, s_HEX7Scr  : std_logic_vector(6 downto 0) := "1111111";
	signal countSave : integer range 0 to 4 := 0;
	

begin
   process(CLOCK_50)
   begin
      if (rising_edge(CLOCK_50)) then
			
			s_operand0    <= SW(15 downto 8);
			s_operand1    <= SW(7 downto 0);
			--LEDR(15 downto 0) <= s_finalResult;
			
			--Calcular incremento de memoria--
			
			s_20 <= "10100";
			s_increment <= std_logic_vector(unsigned(s_20) * to_unsigned(countSave - 1,2));
			
			--******************************--
			
			--HEX to Signal--
			HEX0 <= s_HEX0;
			HEX1 <= s_HEX1;
			HEX2 <= s_HEX2;
			HEX3 <= s_HEX3;
			HEX4 <= s_HEX4;
			HEX5 <= s_HEX5;
			HEX6 <= s_HEX6;
			HEX7 <= s_HEX7;
			--*************--
			
         s_start  <= '0';
			
		if(SW(16) = '0' and SW(17) = '0') then
		
         if(s_key1 = '1') then
				
				s_mode <= "01";
				s_start <= '1';
				
			elsif(s_key2 = '1') then
				
				s_mode <= "10";
				s_start <= '1';
				
			elsif(s_key3 = '1') then
			   
				s_mode <= "11";
				s_start <= '1';
				
			elsif(s_key0 = '1') then
				
				s_mode <= "00";
				s_start <= '1';
				
			end if;
		
			case s_mode is
				when "00" =>
				   s_sign <= s_sign_sum;
					s_overflow <= s_overflow_sum;
					if(s_overflow = '0') then --Dont display if Overflow
						s_finalResult(15 downto 8) <= (others => '0');
						s_finalResult(7 downto 0) <= s_sumResult;
					end if;
				when "01" =>
				   s_sign <= s_sign_sub;
					s_overflow <= s_overflow_sub;
					if(s_overflow = '0') then --Dont display if Overflow
						s_finalResult(15 downto 8) <= (others => '0');
						s_finalResult(7 downto 0) <= s_subResult;
					end if;
				when "10" =>
					s_overflow <= '0';
				   s_sign <= s_sign_mult_div;
					s_finalResult(15 downto 0) <= s_multResult;
				when "11" =>
				   s_sign <= s_sign_mult_div;
					if(unsigned(s_operand0) = 0 or unsigned(s_operand1) = 0) then --Dont display if Overflow
						s_finalResult(15 downto 0) <= (others => '0');
						s_overflow <= '1';
					else
						s_finalResult(15 downto 8) <= (others => '0');
					   s_finalResult(7 downto 0) <= s_divQuotient;
						s_overflow <= '0';
					end if;
			end case;	
			
			elsif(SW(16) = '1' and SW(17) = '0') then
				
				s_overflow <= '0';
				s_finalResult(15 downto 0) <= s_sqrtResult;
				
		end if;
			
			if(s_start = '1') then
				countSave <= countSave + 1;
			end if;
			
			if(countSave = 4) then
				countSave <= 1;
			end if;
			
			--Led Blink Ovf--
			if(s_clk1hz = '1') then 
				if(s_overflow = '1') then
					LEDR(0) <= '1';
				else
					LEDR(0) <= '0';
				end if;
			else
				LEDR(0) <= '0';
			end if;
			--*************--
			
			if(SW(17) = '1') then
				s_overflow <= '0';
				s_scroll <= '1';
				s_resetScroll <= '0';
				s_HEX0 <= s_HEX0Scr;
				s_HEX1 <= s_HEX1Scr;
				s_HEX2 <= s_HEX2Scr;
				s_HEX3 <= s_HEX3Scr;
				s_HEX4 <= s_HEX4Scr;
				s_HEX5 <= s_HEX5Scr;
				s_HEX6 <= s_HEX6Scr;
				s_HEX7 <= s_HEX7Scr;
			else
				s_resetScroll <= '1';
				s_HEX0 <= s_HEX0Dec;
				s_HEX1 <= s_HEX1Dec;
				s_HEX2 <= s_HEX2Dec;
				s_HEX3 <= s_HEX3Dec;
				s_HEX4 <= s_HEX4Dec;
				s_HEX5 <= s_HEX5Dec;
				s_HEX6 <= (others => '1');
				s_HEX7 <= (others => '1');
				s_scroll <= '0';
			end if;
      end if;
   end process;
	
	--Master Control Unit-- 
	
   CalcControlUnit : entity work.CalcControlUnit(Behavioral)
      port map(clk         => CLOCK_50,
               mode        => s_mode,
					start_sqrt  => s_sw16,
               start       => s_start,
					sqrtDone    => s_sqrtDone,
               divDone     => s_divDone,
               multDone    => s_multDone,
					reset       => s_reset,
               addMode     => s_add,
               subMode     => s_sub,
					saveDone    => s_saveDone,
					save        => s_save,
               multMode    => s_mult,
					sqrtMode    => s_sqrt,
					checkSigned => s_checkSigned,
					divMode     => s_div);
	
	--*******************--
	
	-- Core Functions | Multiplication | | Division | | Sum | | Subtraction | --

   mult_core : entity work.IterMultCore(Structural)
      generic map(numBits => 8)
      port map(clk        => CLOCK_50,
               reset      => '0',
               start      => s_mult,
               --busy       => LEDG(1),
               done       => s_multDone,
               operand0   => s_foperand0,
               operand1   => s_foperand1,
               result     => s_multResult);


   div_core : entity work.IterDivCore(Structural)
      generic map(numBits => 8)
      port map(clk        => CLOCK_50,
               reset      => s_reset,
               start      => s_div,
               --busy       => LEDG(2),
               done       => s_divDone,
               operand0   => s_foperand0,
               operand1   => s_foperand1,
               quotient   => s_divQuotient);

	
	add_core : entity work.AddCore(Behavioral)
      generic map(N => 8)
      port map(clk        => CLOCK_50,
               start      => s_add,
					sign       => s_sign_sum,
               operand0   => s_operand0,
               operand1   => s_operand1,
					overf      => s_overflow_sum,
               result     => s_sumResult);
			
			
	sub_core : entity work.SubCore(Behavioral)
      generic map(N => 8)
      port map(clk        => CLOCK_50,
               start      => s_sub,
					sign       => s_sign_sub,
               operand0   => s_operand0,
               operand1   => s_operand1,
					overf      => s_overflow_sub,
               result     => s_subResult);
	
	sqrt_core : entity work.IterSqrtCore(Structural)
      port map(clk        => CLOCK_50,
               start      => s_sqrt,
					reset      => s_reset,
					--busy       => LEDG(4),
               done       => s_sqrtDone,
               operand0   => SW(15 downto 0),
               quotient   => s_sqrtResult);
	
	
	--**************************************************************************--
					
	--Signed Transformation-- LEDG
		
	 Two_c_to_Un: entity work.CheckSigned(Behavioral)
      port map(clk        => CLOCK_50,
               start      => s_checkSigned,
					sign       => s_sign_mult_div,
					op0sign    => s_op0sign,
					op1sign    => s_op1sign,
               operand0   => s_operand0,
               operand1   => s_operand1,
               fOperand0  => s_foperand0,
					fOperand1  => s_foperand1);

	--*********************--
	
	--Binary To 7 segments--
	
	BinTo7Seg : entity work.binto7segments(Behavioral)
		generic map(numBits => 16)
      port map(clk        => CLOCK_50,
               binaryIn   => s_finalResult,
					sign       => s_sign,
					start      => '1',
					HEX0       => s_HEX0Dec,
               HEX1       => s_HEX1Dec,
               HEX2       => s_HEX2Dec,
               HEX3       => s_HEX3Dec,
					HEX4       => s_HEX4Dec,
					HEX5       => s_HEX5Dec);
	
	--********************--
	
	--Save to RAM--
	Save_RAM : entity work.Save_to_RAM(Behavioral)
	    			port map(clk      => CLOCK_50,
							   increment    => s_increment,
	   					   startWrite  => s_save,
							   startRead   => SW(17),
								--doneDec     => LEDG(5),
								operandSqrt => SW(15 downto 0),
								clk1hz     => s_teste,
							   operand0    => s_foperand0,
							   operand1    => s_foperand1,
							   oprand0Sign => s_op0sign,
							   oprand1Sign => s_op1sign,
							   operation   => s_mode,
							   result      => s_finalResult,
							   overflow    => s_overflow,
							   readData    => testeOut,
							   saveDone    => s_saveDone,
							   resultSign  => s_sign);
	--***********--
	
	--Scroll--
		
		Scroll : entity work.Scroll(Behavioral)
				port map(Clk     => CLOCK_50,
							clk1hz  => s_teste,
							flip    => s_scroll,
							reset   => s_resetScroll,
							inload  => testeOut,
							HEX0    => s_HEX0Scr,
							HEX1    => s_HEX1Scr,
							HEX2    => s_HEX2Scr,
							HEX3    => s_HEX3Scr,
							HEX4    => s_HEX4Scr,
							HEX5    => s_HEX5Scr,
							HEX6    => s_HEX6Scr,
							HEX7    => s_HEX7Scr);
	
	
	--******--
	--Debouncers--
	
	button0 : entity work.DebounceUnit(Behavioral)
				generic map(inPolarity => '0',
							outPolarity => '1')
				port map(refClk => CLOCK_50,
							dirtyIn => KEY(0),
							pulsedOut => s_key0);
	
	button1 : entity work.DebounceUnit(Behavioral)
				generic map(inPolarity => '0',
							outPolarity => '1')
				port map(refClk => CLOCK_50,
							dirtyIn => KEY(1),
							pulsedOut => s_key1);
	
	button2 : entity work.DebounceUnit(Behavioral)
				generic map(inPolarity => '0',
							outPolarity => '1')
				port map(refClk => CLOCK_50,
							dirtyIn => KEY(2),
							pulsedOut => s_key2);
	
   button3 : entity work.DebounceUnit(Behavioral)
		      generic map(inPolarity => '0',
							outPolarity => '1')
				port map(refClk => CLOCK_50,
	 					   dirtyIn => KEY(3),
							pulsedOut => s_key3);
	
	sw16    : entity work.DebounceUnit(Behavioral)
	         generic map(inPolarity => '1',
							   outPolarity => '1')
				port map(refClk => CLOCK_50,
	 					   dirtyIn => SW(16),
							pulsedOut => s_sw16);
	
	clock1hz    : entity work.DebounceUnit(Behavioral)
	         generic map(inPolarity => '1',   
							   outPolarity => '1')
				port map(refClk => CLOCK_50,
	 					   dirtyIn => s_clk1hz,
							pulsedOut => s_teste);
							
	--*********--
	
	EnableGenerator1hz : entity work.ClkDividerN(Behavioral)
	         generic map(divFactor => 50000000)
				port map(clkIn => CLOCK_50,
							clkOut => s_clk1hz );
	
	
	
 end Structural;
