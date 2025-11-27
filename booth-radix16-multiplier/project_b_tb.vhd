library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Testbench for project_b
entity project_b_tb is
end project_b_tb;

architecture arc_project_b_tb of project_b_tb is

  constant N : integer := 8;  -- Input bit width

  -- component declaration
  component project_b
    generic (
      N : integer := 8
    );
    port (
      clk        : in std_logic;
      rst        : in std_logic;
      start      : in std_logic;
      A          : in std_logic_vector(N-1 downto 0);
      B          : in std_logic_vector(N-1 downto 0);
      P          : out std_logic_vector(2*N-1 downto 0);
      EQZ        : out std_logic;
      done       : out std_logic
    );
  end component;

  -- signals for connecting 
  signal clk        : std_logic := '0';
  signal rst        : std_logic := '0';
  signal start      : std_logic := '0';
  signal A          : std_logic_vector(N-1 downto 0) := (others => '0');
  signal B          : std_logic_vector(N-1 downto 0) := (others => '0');
  signal P          : std_logic_vector(2*N-1 downto 0);
  signal EQZ        : std_logic;
  signal done       : std_logic;

  constant clk_period : time := 10 ns;  -- clock period 
begin

  -- instantiate 
  UUT: project_b
    generic map (N => N)
    port map (
      clk    => clk,
      rst    => rst,
      start  => start,
      A      => A,
      B      => B,
      P      => P,
      EQZ    => EQZ,
      done   => done
    );

  -- clock generator process (50% D.C)
  clk_process : process
  begin
    while true loop
      clk <= '0';
      wait for clk_period / 2;
      clk <= '1';
      wait for clk_period / 2;
    end loop;
  end process;

  -- test cases
  stim_proc : process
  begin
    -- Reset the system
    rst <= '1';
    wait for 20 ns;
    rst <= '0';

    -- Test 1: A = 0, B = 10
    A <= std_logic_vector(to_signed(0, N));
    B <= std_logic_vector(to_signed(10, N));
    start <= '1';
    wait for clk_period;
    start <= '0';
    wait until done = '1';
    wait for clk_period;

    -- Test 2: A = -5, B = 2
    rst <= '1';
    wait for 20 ns;
    rst <= '0';
    A <= std_logic_vector(to_signed(-5, N));
    B <= std_logic_vector(to_signed(2, N));
    start <= '1';
    wait for clk_period;
    start <= '0';
    wait until done = '1';
    wait for clk_period;

    -- Test 3: A = 4, B = -6
    rst <= '1';
    wait for 20 ns;
    rst <= '0';
    A <= std_logic_vector(to_signed(4, N));
    B <= std_logic_vector(to_signed(-6, N));
    start <= '1';
    wait for clk_period;
    start <= '0';
    wait until done = '1';
    wait for clk_period;

    -- Test 4: A = -8, B = -3
    rst <= '1';
    wait for 20 ns;
    rst <= '0';
    A <= std_logic_vector(to_signed(-8, N));
    B <= std_logic_vector(to_signed(-3, N));
    start <= '1';
    wait for clk_period;
    start <= '0';
    wait until done = '1';
    wait for clk_period;

    -- Test 5: A = -3, B = 5
    rst <= '1';
    wait for 20 ns;
    rst <= '0';
    A <= std_logic_vector(to_signed(-3, N));
    B <= std_logic_vector(to_signed(5, N));
    start <= '1';
    wait for clk_period;
    start <= '0';
    wait until done = '1';
    wait for clk_period;

    wait;
  end process;

end arc_project_b_tb;
