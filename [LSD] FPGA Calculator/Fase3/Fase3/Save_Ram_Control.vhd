library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity Save_Ram_Control is
   port(clk        : in  std_logic;
        reset      : in  std_logic;
        startWrite : in  std_logic;
		  startRead  : in  std_logic;
		  load       : out std_logic_vector(3 downto 0);
        busy       : out std_logic;
		  saveDone   : out std_logic);
end Save_Ram_Control;

architecture Structural of Save_Ram_Control is

   type TState is (ST_IDLE, ST_0, ST_1, ST_2, ST_3, ST_4, ST_5, ST_00, ST_01, ST_02, ST_03, ST_04, ST_05, ST_000, ST_001, ST_002, ST_003, ST_004, ST_005);
	signal s_state : TState;
	
begin

   process(clk)
   begin
      if (rising_edge(clk)) then
         if (reset = '1') then
            s_state   <= ST_IDLE;
            busy      <= '0';
            saveDone      <= '1';

         else
            case s_state is
            when ST_IDLE =>
               if (startWrite = '1') then
                  s_state  <= ST_OP0Sign;
						load     <= "0001";
                  busy     <= '1';
                  saveDone <= '0';
					else
						busy      <= '0';
						saveDone  <= '1';
					end if;

            when ST_OP0Sign =>
					load     <= "0010";
               s_state  <= ST_OP0;

            when ST_OP0 =>
					load     <= "0011";
               s_state  <= ST_OP;
				
				when ST_OP =>
					load     <= "0100";
               s_state  <= ST_OP1Sign;
				
				when ST_OP1Sign =>
					load     <= "0101";
               s_state  <= ST_OP1;
				
				when ST_OP1 =>
					load     <= "0110";
               s_state  <= ST_EQUAL;
				
				when ST_EQUAL =>
					load     <= "0111";
               s_state  <= ST_RESULT;
				
				when ST_RESULT =>
					load     <= "1000";
               s_state  <= ST_RESULTSIGN;
				
				when ST_RESULTSIGN =>
					load     <= "1001";
               s_state  <= ST_OVERFLOW;
				
				when ST_OVERFLOW =>
					load     <= "1010";
               s_state  <= ST_IDLE;
					
            end case;
         end if;
      end if;
   end process;
   
end Structural;