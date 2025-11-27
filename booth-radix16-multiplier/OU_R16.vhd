library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Booth Radix-16 Multiplier - Operational Unit
entity OU_R16 is
  generic (
    N : integer := 16  -- Input bit width
  );
  port (
    clk                  : in std_logic;
    rst                  : in std_logic;
    A                    : in std_logic_vector(N-1 downto 0);
    B                    : in std_logic_vector(N-1 downto 0);
    load                 : in std_logic;
    shift_enable         : in std_logic;
    P                    : out std_logic_vector(2*N-1 downto 0); 
    EQZ                  : out std_logic 
  );
end OU_R16;

architecture arc_OU of OU_R16 is
 
  signal RA                 : signed(2*N-1 downto 0);                     -- extended A
  signal RB                 : std_logic_vector(2*N+1 downto 0);           -- extended B + guard bits
  signal ACC                : signed(2*N-1 downto 0) := (others => '0');  -- Accumulator
  signal shift_amount       : integer range 0 to 4*N := 0;                -- counter shift for partial products

begin

  process(clk, rst)
    variable RB_slice   : std_logic_vector(4 downto 0);    -- 5 LSBs from RB
    variable partial_pp : signed(2*N-1 downto 0);           
    variable acc_var    : signed(2*N-1 downto 0);          -- Temp accumulator
    variable B_ext      : std_logic_vector(2*N downto 0);  -- Extended B with sign and guard bit
	 
	 begin
    if rst = '1' then
      -- Reset all internal registers
      RA  <= (others => '0');
      RB  <= (others => '0');
      ACC <= (others => '0');
      shift_amount <= 0; 

    elsif rising_edge(clk) then
      if load = '1' then
        -- On load, initialize RA and RB with sign-extension and guard bit
        RA <= resize(signed(A), RA'length);
        B_ext := std_logic_vector(resize(signed(B), B_ext'length));
        RB <= B_ext & '0';   -- add guard bit
        ACC <= (others => '0');
        shift_amount <= 0;

      elsif shift_enable = '1' then
        -- Extract 5 LSBs from RB
        RB_slice := RB(4 downto 0);

        -- Booth Radix-16 decoding 
        case RB_slice is
          when "00000" | "11111" => partial_pp := (others => '0');
          when "00001" | "00010" => partial_pp := RA;
          when "00011" | "00100" => partial_pp := shift_left(RA, 1);
          when "00101" | "00110" => partial_pp := shift_left(RA, 1) + RA;
          when "00111" | "01000" => partial_pp := shift_left(RA, 2);
          when "01001" | "01010" => partial_pp := shift_left(RA, 2) + RA;
          when "01011" | "01100" => partial_pp := shift_left(RA, 2) + shift_left(RA, 1);
          when "01101" | "01110" => partial_pp := shift_left(RA, 2) + shift_left(RA, 1) + RA;
          when "01111"           => partial_pp := shift_left(RA, 3);
          when "11110" | "11101" => partial_pp := -RA;
          when "11100" | "11011" => partial_pp := -shift_left(RA, 1);
          when "11010" | "11001" => partial_pp := -(shift_left(RA, 1) + RA);
          when "11000" | "10111" => partial_pp := -shift_left(RA, 2);
          when "10110" | "10101" => partial_pp := -(shift_left(RA, 2) + RA);
          when "10100" | "10011" => partial_pp := -(shift_left(RA, 2) + shift_left(RA, 1));
          when "10010" | "10001" => partial_pp := -(shift_left(RA, 2) + shift_left(RA, 1) + RA);
          when "10000"           => partial_pp := -shift_left(RA, 3);
          when others            => partial_pp := (others => '0');
        end case;

        -- acc shifted partial product
        acc_var := ACC + shift_left(partial_pp, shift_amount);
        ACC <= acc_var;

        -- shift RB right by 4 bits (pad with 0s)
        RB <= "0000" & RB(RB'high downto 4);

        --shift for next cycle
        shift_amount <= shift_amount + 4;
      end if;
    end if;
  end process;

  -- output
  P   <= std_logic_vector(ACC); -- Final product
  EQZ <= '1' when RB = (RB'range => '0') else '0'; -- Set when RB is zero

end arc_OU;
