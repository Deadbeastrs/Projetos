library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity SaveControl is
   port(clk         : in  std_logic;
        reset       : in  std_logic;
        start       : in  std_logic;
        busy        : out std_logic;
        done        : out std_logic;
        loadOp0     : out  std_logic;
        loadDone    : in std_logic;
        AddDone     : in std_logic;
        addOp0      : out std_logic;
		  OpAdd      : out std_logic;
		  resetCounter : out std_logic;
		  loadOp1     : out std_logic;
		  addOp1      : out std_logic;
		  loadResult  : out std_logic;
		  addResult   : out std_logic;
		  addOvf     : out std_logic);
end SaveControl;

architecture funcao of SaveControl is

   type TState is (ST_IDLE, ST_LoadOp0, ST_AddOp0,ST_AddOp, ST_LoadOp1, ST_AddOp1, ST_LoadResult, ST_AddResult, ST_AddOvf);
   signal s_state : TState;

begin
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
               if (start = '1') then
                  s_state  <= ST_LoadOp0;
                  busy     <= '1';
                  done     <= '0';
						loadOp0  <= '1';
               end if;
					
            when ST_LoadOp0 =>
					resetCounter <= '1';
					if(loadDone = '1') then
						loadOp0  <= '0';
						s_state  <= ST_AddOp0;
						addOp0   <= '1';
					end if;
				
				when ST_AddOp0  =>
					resetCounter <= '0';
					if(AddDone = '1') then
						addOp0   <= '0';
						OpAdd  <= '1';
						s_state  <= ST_AddOp;
					end if;
				
            when ST_AddOp =>
					OpAdd  <= '0';
					loadOp1  <= '1';
					s_state  <= ST_LoadOp1;

            when ST_LoadOp1 =>
					resetCounter <= '1';
					if(loadDone = '1') then
						loadOp1  <= '0';
						s_state  <= ST_AddOp1;
						addOp1   <= '1';
					end if;
				
				when ST_AddOp1  =>
					resetCounter <= '0';
					if(AddDone = '1') then
						addOp1   <= '0';
						loadResult  <= '1';
						s_state  <= ST_LoadResult;
					end if;
				
				when ST_LoadResult  =>
					resetCounter <= '1';
					if(loadDone = '1') then
						loadResult  <= '0';
						s_state  <= ST_AddResult;
						addResult   <= '1';
					end if;
				
				when ST_AddResult  =>
					resetCounter <= '0';
					if(AddDone = '1') then
						addResult   <= '0';
						addOvf  <= '1';
						s_state  <= ST_AddOvf;
					end if;
					
				when ST_AddOvf  =>
					addOvf  <= '0';
					s_state  <= ST_IDLE;
					
            end case;
         end if;
      end if;
   end process;
end funcao;