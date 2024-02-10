library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity LFSR4_5_tb is
end LFSR4_5_tb;

architecture tb_arch of LFSR4_5_tb is
    -- Component declaration
    component LFSR4_5
        port (
            rst: in std_logic;
            looplen: in std_logic_vector(0 to 4);
            variant: in std_logic;
            output: inout std_logic_vector(0 to 4);
            button: in std_logic
        );
    end component;
    
    -- Signals for test bench
    signal rst_tb: std_logic := '0';
    signal looplen_tb: std_logic_vector(0 to 4) := "00000";
    signal variant_tb: std_logic := '0';
    signal output_tb: std_logic_vector(0 to 4);
    signal button_tb: std_logic := '0';
    
begin

    -- Instantiate the Unit Under Test (UUT)
    uut: LFSR4_5 port map (
        rst => rst_tb,
        looplen => looplen_tb,
        variant => variant_tb,
        output => output_tb,
        button => button_tb
    );

    -- Stimulus process
    stimulus: process
    begin
        -- Apply reset
        rst_tb <= '1';
        wait for 10 ns;
        rst_tb <= '0';
        
        -- Apply inputs and button press
        looplen_tb <= "01111"; -- Example loop length
        variant_tb <= '0'; -- Example variant
        button_tb <= '1';
        wait for 10 ns;
        button_tb <= '0';
        
        -- Wait for some time
        wait for 100 ns;
        
        -- Apply new inputs and button press
        looplen_tb <= "11001"; -- Example loop length
        variant_tb <= '1'; -- Example variant
        button_tb <= '1';
        wait for 10 ns;
        button_tb <= '0';
        
        -- Allow some time for simulation
        wait for 100 ns;
        
        -- End the simulation
        wait;
    end process;

end tb_arch;
