library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Control Unit for Booth Radix-16 Multiplier
entity CU is
  port (
    clk                       : in  std_logic;  
    rst                       : in  std_logic;    
    start                     : in  std_logic;  
    EQZ                       : in  std_logic;    
    done                      : out std_logic;   
    load_o                    : out std_logic;   
    shift_enable_o            : out std_logic     -- enable shifting
  );
end CU;

architecture arc_CU of CU is

  -- FSM states
  type state_type is (IDLE, LOAD, SHIFT, WAIT_DONE);
  signal current_state, next_state : state_type := IDLE;

begin

  -- update state on clock
  process(clk, rst)
  begin
    if rst = '1' then
      current_state <= IDLE;
    elsif rising_edge(clk) then
      current_state <= next_state;
    end if;
  end process;

  --define next state and outputs
  process(current_state, start, EQZ)
  begin

    -- default values 
    load_o         <= '0';
    shift_enable_o <= '0';
    done           <= '0';
    next_state     <= current_state;

    case current_state is

      when IDLE =>
        -- wait for start signal
        if start = '1' then
          next_state <= LOAD;
        end if;

      when LOAD =>
        -- load A and B to registers
        load_o <= '1';
        next_state <= SHIFT;

      when SHIFT =>
        -- enable shifting and acc
        shift_enable_o <= '1';
        if EQZ = '1' then
          next_state <= WAIT_DONE;
        else
          next_state <= SHIFT; -- Keep shifting until RB = 0
        end if;

      when WAIT_DONE =>
        -- finish, go back to IDLE
        done <= '1';
        next_state <= IDLE;

    end case;
  end process;

end arc_CU;
