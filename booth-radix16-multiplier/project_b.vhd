library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Top-level entity for Booth Radix-16 Multiplier Project
entity project_b is
  generic (
    N : integer := 8  -- Bit width of inputs A and B
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
end project_b;

architecture arc_project_b of project_b is

  -- Internal control signals from CU to OU
  signal load              : std_logic;
  signal shift_enable  : std_logic;

  -- Internal signal from OU to CU
  signal EQZ_internal : std_logic;

begin

  --genric map OU_R16
  OU_inst : entity work.OU_R16
    generic map (
      N => N
    )
    port map (
      clk                 => clk,
      rst                 => rst,
      A                   => A,
      B                   => B,
      load                => load,
      shift_enable        => shift_enable,
      P                   => P,
      EQZ                 => EQZ_internal
    );

  -- port map CU
  CU_inst : entity work.CU
    port map (
      clk             => clk,
      rst             => rst,
      start           => start,
      EQZ             => EQZ_internal,
      done            => done,
      load_o          => load,
      shift_enable_o  => shift_enable
    );

  -- connect internal EQZ signal to output port
  EQZ <= EQZ_internal;

end arc_project_b;
