library IEEE;
use IEEE.STD_LOGIC_1164.all;
 
entity IterDivCore is
   generic(numBits : positive := 8);
   port(clk        : in  std_logic;
        reset      : in  std_logic;
        start      : in  std_logic;
        busy       : out std_logic;
        done       : out std_logic;
        operand0   : in  std_logic_vector((numBits - 1) downto 0);  --Dividendo
        operand1   : in  std_logic_vector((numBits - 1) downto 0);  --Divisor
        quotient   : out std_logic_vector((numBits - 1) downto 0));
end IterDivCore;
 
architecture Structural of IterDivCore is
 
signal s_regsInit,s_acc, s_accEnable, s_regsShiftRight,s_regsShiftLeft  : std_logic;
signal s_extOperand1, s_load_remainder : std_logic_vector((2 * numBits - 1) downto 0); -- divisor
signal s_quotient : std_logic_vector((2 * numBits - 1) downto 0);
signal s_remainder : std_logic_vector((2 * numBits - 1) downto 0);
signal s_divisor   : std_logic_vector((numBits - 1) downto 0);
signal s_div1 : std_logic_vector((2 * numBits - 1) downto 0);
signal s_shiftBit : std_logic;
signal s_accBit   : std_logic;

begin
	process(clk)
    begin
        if(rising_edge(clk)) then
            
				s_load_remainder((2 * numBits) - 1 downto numBits) <= (others => '0');
				s_load_remainder((numBits) - 1 downto 0) <= operand0;
	 
				s_extOperand1( (2 * numBits) - 1 downto numBits) <= operand1;
				s_extOperand1((numBits) - 1 downto 0)	<= (others => '0');
	 
				quotient <= s_quotient(numBits - 1 downto 0);
				
        end if;
    end process;
   
    control_unit : entity work.DivCtrlUnit(Behavioral)
      generic map(numBits   => numBits)
      port map(clk          => clk,
               reset        => reset,
               start        => start,
               busy         => busy,
               done         => done,
               shiftBit     => s_shiftBit,
               accBit       => s_accBit,
               MSB          => s_remainder(2 * numBits - 1),
               accEnable    => s_accEnable,
               regsInit     => s_regsInit,
               regsShiftLeft  => s_regsShiftLeft,
					regsShiftRight => s_regsShiftRight);
 
 
   
    divisor_reg : entity work.ShiftRegN(Behavioral)
        generic map(N         => 2 * numBits)
        port map(asyncReset   => '0',
                syncReset    => reset,
                clk          => clk,
                enable       => '1',
                load         => s_regsInit,
                shiftLeft    => '0',
                shiftRight   => s_regsShiftRight,
                shLeftSerIn  => '0',
                shRightSerIn => '0',
                parDataIn    => s_extOperand1,
                parDataOut   => s_div1);
               
    quotient_reg : entity work.ShiftRegN(Behavioral)
        generic map(N         => 2 * numBits)
        port map(asyncReset   => '0',
                syncReset    => '0',
                clk          => clk,
                enable       => '1',
                load         => s_regsInit,
                shiftLeft    => s_regsShiftLeft,
                shiftRight   => '0',
                shLeftSerIn  => s_shiftBit,
                shRightSerIn => '0',
                parDataIn    => (others => '0'),
                parDataOut   => s_quotient);
 
   
    result_acc: entity work.AddSubRegN(Behavioral)
      generic map(N         => 2 * numBits)
      port map(asyncReset   => '0',
               syncReset    => reset,
               load         => s_regsInit,
               loadData     => s_load_remainder,
               clk          => clk,
               enable       => s_accEnable,
               addSub_n     => s_accBit,
               dataIn       => s_div1,
               dataOut      => s_remainder);
                   
   
end Structural;