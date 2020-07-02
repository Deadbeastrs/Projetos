library IEEE;
use IEEE.STD_LOGIC_1164.all;
 
entity DivCtrlUnit is
   generic(numBits  : positive := 8);
   port(clk         : in  std_logic;
        reset       : in  std_logic;
        start       : in  std_logic;
        busy        : out std_logic;
        done        : out std_logic;
        regsInit    : out std_logic;
        accEnable   : out std_logic;
        shiftBit    : out  std_logic;
        accBit      : out  std_logic;
        MSB         : in  std_logic;
        regsShiftLeft   : out std_logic;
		  regsShiftRight   : out std_logic);
end DivCtrlUnit;
 
architecture Behavioral of DivCtrlUnit is
type TState is (ST_IDLE, ST_INIT, ST_SHIFT_RIGHT, ST_SUB, ST_CHECKMSB, ST_ACC, ST_SHIFT_LEFT);
signal s_currentState, s_nextState : TState;
 
subtype TCounter is natural range 0 to numBits;
signal s_iterCnt : TCounter;
 
begin
    process(clk)
    begin
        if(rising_edge(clk)) then
            if(reset = '1') then
                s_currentState <= ST_IDLE;
            else
                s_currentState <= s_nextState;
            end if;
        end if;
    end process;
	 
	 process(clk)
    begin
      if (rising_edge(clk)) then
		
         if (s_currentState = ST_IDLE) then
            s_iterCnt <= 1;
         elsif (s_currentState = ST_SHIFT_LEFT) then
            s_iterCnt <= s_iterCnt + 1;
         end if;
			
			if(MSB = '1') then  
            shiftBit <= '0';
         else
            shiftBit <= '1';  
         end if;
			
      end if;
		
    end process;
   
    process(s_currentState, start, MSB, s_iterCnt)
    begin
        s_nextState <= s_currentState;
       
        case s_currentState is
       
        when ST_IDLE =>
		  
            if(start = '1') then
                s_nextState <= ST_INIT;
            end if;
       
        when ST_INIT =>
		  
            s_nextState <= ST_SHIFT_RIGHT;
           
        when ST_SHIFT_RIGHT =>
            s_nextState <= ST_SUB;
           
        when ST_SUB =>
		  
				s_nextState <= ST_CHECKMSB;
      
        
		  when ST_CHECKMSB =>
		  
            if(MSB = '1') then
                s_nextState <= ST_ACC;
            else
                s_nextState <= ST_SHIFT_LEFT;
            end if;
				
				
        when ST_ACC =>
            s_nextState <= ST_SHIFT_LEFT;
           
        when ST_SHIFT_LEFT =>
		  
            if(s_iterCnt < numBits) then
                s_nextState <= ST_SHIFT_RIGHT;
            else
                s_nextState <= ST_IDLE;
            end if;
           
      end case;
   end process;
   
 
    process(s_currentState, MSB )
   begin
      busy      <= '0';
      done      <= '0';
      regsInit  <= '0';
      accEnable <= '0';
      regsShiftLeft <= '0';
		regsShiftRight <= '0';
      --shiftBit  <= '0';
      accBit    <= '0';
       
      case s_currentState is
      when ST_IDLE =>
		  
         done      <= '1';
		   accEnable <= '0';
         busy      <= '0';
			regsShiftLeft <= '0';
 
      when ST_INIT =>
			
         busy      <= '1';
			done      <= '0';
         regsInit  <= '1';
         accEnable <= '0';
			regsShiftLeft <= '0';
 
        when ST_SHIFT_RIGHT =>
			
			regsInit  <= '0';
         busy      <= '1';
			regsShiftRight <= '1';
			regsShiftLeft <= '0';
			
		  when ST_SUB =>
			
			busy      <= '1';
			accBit    <= '0'; 
			regsShiftRight <= '0';
			accEnable <= '1';
		
		  when ST_CHECKMSB =>
		  			busy      <= '1';
			accBit    <= '0'; 
			regsShiftRight <= '0';
			accEnable <= '0';
			
        when ST_ACC =>
		  
			accEnable <= '1';
         busy      <= '1';
         accBit    <= '1';         
   
      when ST_SHIFT_LEFT =>
		
         busy      <= '1';
         regsShiftLeft <= '1';
			accEnable <= '0';
			
      end case;
   end process;
end Behavioral;