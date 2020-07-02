library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity SqrtControlUnit is
   generic(numBits  : positive := 16);
   port(clk         : in  std_logic;
        reset       : in  std_logic;
        start       : in  std_logic;
		  MSB         : in  std_logic;
		  loadReg     : out std_logic;
        busy        : out std_logic;
        done        : out std_logic;
		  loadA       : out std_logic;
		  loadR       : out std_logic;
		  acc_sub_sum : out std_logic;
		  qBit        : out std_logic;
		  shiftR      : out std_logic;
        shiftQ      : out std_logic;
		  shiftVal    : out std_logic;
        accEnable   : out std_logic);
end SqrtControlUnit;

architecture Behavioral of SqrtControlUnit is

   type TState is ( ST_IDLE, ST_START,ST_BUFFER2, ST_BUFFER1, ST_BUFFER, ST_LOADACC, ST_SUB, ST_COMPARE, ST_ADD, ST_SHIFTQ, ST_SHIFTR, ST_SHIFTVAL);
   signal s_state : TState := ST_IDLE ;

   subtype TCounter is natural range 0 to numBits;
   signal s_iterCnt : TCounter;
	signal s_twoCounter : TCounter;

begin
	process(clk)
   begin
		
	end process;
	
   process(clk)
   begin
      if (rising_edge(clk)) then
         if (reset = '1') then
            s_state   <= ST_IDLE;
            busy      <= '0';
            done      <= '1';

         else
            case s_state is
            when ST_IDLE =>
					shiftQ <= '0';
					done   <= '1';
					busy   <= '0';
					s_iterCnt <= 0;
               if (start = '1') then
                  s_state  <= ST_START;
                  busy     <= '1';
                  done     <= '0';
               end if;
				
				when ST_START =>
					loadReg <= '1';
					loadR <= '1';
					s_state  <= ST_BUFFER2; 
				
				when ST_BUFFER2 =>
					s_state  <= ST_LOADACC;
					loadReg  <= '0';
					loadR <= '0';
					
            when ST_LOADACC =>		
					shiftVal <= '0';
					loadA    <= '1';
					s_state  <= ST_SUB;
					
				when ST_SUB =>
					loadA    <= '0';
					accEnable<= '1';
					acc_sub_sum <= '0';
					s_iterCnt<= s_iterCnt + 1;
					
					s_state  <= ST_BUFFER;
				
				when ST_BUFFER =>
					accEnable<= '0';
					s_state  <= ST_COMPARE;
					
            when ST_COMPARE =>
					
					
					if(MSB = '1') then
						s_state  <= ST_ADD;
						qBit     <= '0';
					else
						s_state  <= ST_SHIFTQ;
						qBit     <= '1';
					end if;
				
				when ST_ADD =>
					loadA    <= '1';
					accEnable<= '1';
					acc_sub_sum <= '1';
					s_state  <= ST_SHIFTQ;
					
            when ST_SHIFTQ =>
					accEnable<= '0';
					loadA    <= '0';
					shiftQ <= '1';
					acc_sub_sum <= '0';
					s_twoCounter <= 1;
					if(s_iterCnt < numBits/2) then --numBits/2
						s_state  <= ST_SHIFTR;
						loadR <= '1';
					else
						s_state  <= ST_IDLE;
					end if;
					
				when ST_SHIFTR =>
					s_twoCounter <= s_twoCounter + 1;
					loadR <= '0';
					shiftQ <= '0';
					shiftR <= '1';
					if(s_twoCounter = 2) then
						s_twoCounter <= 1;
						s_state  <= ST_SHIFTVAL;
					end if;
				when ST_SHIFTVAL =>
					s_twoCounter <= s_twoCounter + 1;
				   shiftR <= '0';
					shiftVal <= '1';
					if(s_twoCounter = 2) then
						s_state  <= ST_BUFFER1;
					end if;
					
				when ST_BUFFER1 =>
				   shiftVal <= '0';
					s_state  <= ST_LOADACC;
				
            end case;
         end if;
      end if;
   end process;
end Behavioral;