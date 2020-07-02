library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity CalcControlUnit is
   port(clk       : in  std_logic;
        start     : in  std_logic;
		  mode      : in  std_logic_vector(1 downto 0);
		  divDone   : in  std_logic;
		  multDone  : in  std_logic;
		  reset     : out std_logic;
		  addMode   : out std_logic;
		  subMode   : out std_logic;
		  multMode  : out std_logic;
		  checkSigned : out std_logic;
		  divMode   : out std_logic);
end CalcControlUnit;


architecture Behavioral of CalcControlUnit is

   type TState is (ST_IDLE, ST_MULT_START, ST_CHECKSIGNED, ST_BUFFER_div, ST_BUFFER_mult,ST_MULT_WAIT, ST_DIV_START, ST_DIV_WAIT, ST_SUB_START,ST_ADD_START, ST_RESET);
   signal s_state : TState := ST_IDLE;

begin
   process(clk)
   begin
      if (rising_edge(clk)) then
		
            case s_state is
            when ST_IDLE       =>
					
					reset <= '0';
					addMode <= '0';
               subMode  <= '0';
               multMode   <= '0';
					divMode  <= '0';
					
               if (start = '1') then
                  if (mode = "00") then
                     s_state <= ST_ADD_START;
                     addMode <= '1';
                     subMode  <= '0';
                     multMode   <= '0';
							divMode  <= '0';
                  elsif (mode = "01") then
							s_state <= ST_SUB_START;
                     addMode <= '0';
                     subMode  <= '1';
                     multMode   <= '0';
							divMode  <= '0';
						elsif (mode = "10" or mode = "11") then
							s_state <= ST_CHECKSIGNED;
                     addMode <= '0';
                     subMode  <= '0';
                  end if;
               end if;
				
				
            when ST_ADD_START =>
               s_state <= ST_IDLE;
               addMode <= '0';
				
				when ST_SUB_START =>
               s_state <= ST_IDLE;
               subMode <= '0';
					
            when ST_CHECKSIGNED =>
					checkSigned <= '1';
					
					if(mode = "11") then
						s_state <= ST_BUFFER_div;
					elsif(mode = "10") then
						s_state <= ST_BUFFER_mult;
					end if;
				
				when ST_BUFFER_div =>
					s_state <= ST_DIV_START;
					checkSigned <= '0';
					divMode  <= '1';
				
				when ST_BUFFER_mult =>
					s_state <= ST_MULT_START;
					multMode   <= '1';
					checkSigned <= '0';
					
					
            when ST_MULT_START =>
					multMode <= '0';
               s_state <= ST_MULT_WAIT;
					checkSigned <= '0';

            when ST_MULT_WAIT  =>
               if (multDone = '1') then
                  s_state <= ST_IDLE;
               end if;		

            when ST_DIV_START  =>
				
					s_state <= ST_DIV_WAIT;
					checkSigned <= '0';
					divMode  <= '0';

            when ST_DIV_WAIT   =>
               if (divDone = '1') then
                  s_state <= ST_IDLE;
               end if;
				
				when ST_RESET =>
					reset <= '1';
					s_state <= ST_IDLE;
					
            end case;
      end if;
   end process;
end Behavioral;
