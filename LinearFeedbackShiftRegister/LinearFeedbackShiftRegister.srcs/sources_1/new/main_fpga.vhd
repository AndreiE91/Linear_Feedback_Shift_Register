library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity main_fpga is
 Port (clk : in    std_logic;
btn : inout    std_logic_vector(4 downto 0);
sw  : in    std_logic_vector(15 downto 0);
led : out   std_logic_vector(15 downto 0);
an  : out   std_logic_vector(3 downto 0);
cat : out   std_logic_vector(6 downto 0));
end main_fpga;

architecture Behavioral of main_fpga is

component mpg is
    port (
      clk    : in    std_logic;
      btn    : in    std_logic_vector(4 downto 0);
      enable : out   std_logic_vector(4 downto 0)
    );
  end component;

component sev_seg is
port (
  clk    : in    std_logic;
  digits : in    std_logic_vector(15 downto 0);
  an     : out   std_logic_vector(3 downto 0);
  cat    : out   std_logic_vector(6 downto 0)
);
end component;

component LFSR4_5 is
        port (clk,rst: in std_logic;					
            looplen: in std_logic_vector(0 to 4);
            variant: in std_logic; --'0' means 4 bit, '1' means 5 bit
            output: inout std_logic_vector(0 to 4);
            button: inout std_logic);
    end component;

signal s_mpg_out : std_logic_vector(4 downto 0);
signal s_digits : std_logic_vector(15 downto 0);
signal s_counter_en : std_logic_vector(4 downto 0);

signal lfsr_out : std_logic_vector(4 downto 0);

begin

--a <= x"00F0000F";
--b <= x"FF000003";

lfsr : LFSR4_5 port map (
    looplen => sw(5 downto 1),
    clk => clk,
    variant => sw(0),
    button => btn(0),
    rst => sw(15),
    output => lfsr_out
);

sev_seg_comp : component sev_seg
    port map (
      clk    => clk,
      digits => s_digits,
      an     => an,
      cat    => cat
    );
    
   mpg_comp : component mpg
        port map (
          clk    => clk,
          btn => btn,
          enable     => s_counter_en
        );
        
see_7seg_led : process(clk) is
           begin
               s_digits(4 downto 0) <= lfsr_out;
               led(4 downto 0) <= lfsr_out;
           end process;
        --led <= sw;

end Behavioral;