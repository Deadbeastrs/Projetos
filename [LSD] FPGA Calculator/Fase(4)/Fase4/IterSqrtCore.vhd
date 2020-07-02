library IEEE;
use IEEE.STD_LOGIC_1164.all;
 
entity IterSqrtCore is
   generic(numBits : positive := 16);
   port(clk        : in  std_logic;
        reset      : in  std_logic;
        start      : in  std_logic;
        busy       : out std_logic;
        done       : out std_logic;
        operand0   : in  std_logic_vector((numBits - 1) downto 0);  --Dividendo
        quotient   : out std_logic_vector((numBits - 1) downto 0));
end IterSqrtCore;
 
architecture Structural of IterSqrtCore is
 
	signal s_load, s_loadA , s_qBit, s_shiftLeftQ, s_shiftLeftR, s_shiftLeftV, s_accEnable,s_accOp, s_loadR  : std_logic;
	signal s_quociente, s_remainder,s_operand0, s_remainderShifted, s_accLoadData,teste : std_logic_vector(15 downto 0);
	signal s_operand2bit : std_logic_vector(1 downto 0);

begin
process (clk, s_accOp)
	begin
		if(rising_edge(clk)) then
			if(s_accOp = '0') then
				s_accLoadData <= s_remainderShifted(15 downto 2) & s_operand0(15 downto 14);
			else
				s_accLoadData <= s_remainderShifted;
			end if;
			quotient <= s_quociente;
		end if;
end process;

    control_unit : entity work.SqrtControlUnit(Behavioral)
      generic map(numBits   => numBits)
      port map(clk          => clk,
               reset        => reset,
               start        => start,
					MSB          => s_remainder(15),
               busy         => busy,
               done         => done,
					loadReg      => s_load,
					loadA        => s_loadA,
					loadR        => s_loadR,
					acc_sub_sum  => s_accOp,
               qBit         => s_qBit,
					shiftR       => s_shiftLeftR,
					shiftQ       => s_shiftLeftQ,
					shiftVal     => s_shiftLeftV,
					accEnable    => s_accEnable);
 
 
   
    Quociente_reg : entity work.ShiftRegN(Behavioral)
        generic map(N        => 16)
        port map(asyncReset  => '0',
                syncReset    => '0',
                clk          => clk,
                enable       => '1',
                load         => s_load,
                shiftLeft    => s_shiftLeftQ,
                shiftRight   => '0',
                shLeftSerIn  => s_qBit,
                shRightSerIn => '0',
                parDataIn    => (others => '0'),
                parDataOut   => s_quociente);
    
	 Value_reg : entity work.ShiftRegN(Behavioral)
        generic map(N         => 16)
        port map(asyncReset   => '0',
                syncReset    => reset,
                clk          => clk,
                enable       => '1',
                load         => s_load,
                shiftLeft    => s_shiftLeftV,
                shiftRight   => '0',
                shLeftSerIn  => '0',
                shRightSerIn => '0',
                parDataIn    => operand0,
                parDataOut   => s_operand0);
	
	Remainder_reg : entity work.ShiftRegN(Behavioral)
        generic map(N         => 16)
        port map(asyncReset   => '0',
                syncReset    => reset,
                clk          => clk,
                enable       => '1',
                load         => s_loadR,
                shiftLeft    => s_shiftLeftR,
                shiftRight   => '0',
                shLeftSerIn  => '0',
                shRightSerIn => '0',
                parDataIn    => s_remainder,
                parDataOut   => s_remainderShifted);
   
    resto_acc: entity work.addsubregn(Behavioral)
      generic map(N         => 16)
      port map(asyncReset   => '0',
               syncReset    => reset,
               load         => s_loadA ,
               loadData     => s_accLoadData, --Ja depois do shift de s_remainder
               clk          => clk,
               enable       => s_accEnable,
               addSub_n     => s_accOp,
               dataIn       => s_quociente(13 downto 0) & "01",  --Ja depois de shift do s_quociente
               dataOut      => s_remainder);
                   
   
end Structural;