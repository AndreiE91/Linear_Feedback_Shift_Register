library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity mpg is
    Port ( btn : in STD_LOGIC_VECTOR(4 downto 0);
           clk : in STD_LOGIC;
           enable : out STD_LOGIC_VECTOR(4 downto 0));
end mpg;

architecture Behavioral of mpg is
    signal s_counter : std_logic_vector(15 downto 0) := (others => '0');
    signal q0 : std_logic_vector(4 downto 0);
    signal q1 : std_logic_vector(4 downto 0);
    signal q2 : std_logic_vector(4 downto 0);
    
begin
 count : process(clk) is
    begin
    
    if rising_edge(clk) then
        s_counter <= s_counter + 1;
    end if;
    end process;
     
 dff1: process(clk) is
    begin 
     if rising_edge(clk) then
        if(s_counter = x"F") then
            q2 <= btn;
        end if;
     end if;
 end process;
 
 dff2: process(clk) is
     begin 
      if rising_edge(clk) then
         q1 <= q2;
      end if;
 end process;
 dff3: process(clk) is
      begin 
       if rising_edge(clk) then
          q0 <= q1;
       end if;
  end process;
    
    enable <= q1 AND NOT(q0);
end Behavioral;