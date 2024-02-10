library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity sev_seg is
    Port ( digits : in STD_LOGIC_VECTOR(15 downto 0);
           clk : in STD_LOGIC;
           an : out STD_LOGIC_VECTOR(3 downto 0);
           cat : out STD_LOGIC_VECTOR(6 downto 0)
           );
end sev_seg;

architecture Structural of sev_seg is
    signal mux_an : std_logic_vector(3 downto 0) := (others => '0');
    signal mux_cat : std_logic_vector(3 downto 0);
    signal counter_out : std_logic_vector(15 downto 0) := (others => '0');
    
begin
 count : process(clk) is
    begin
    
    if rising_edge(clk) then
        counter_out <= counter_out + 1;
    end if;
    end process;
     
 mux_c: process(counter_out(14)) is
    begin 
     --if rising_edge(counter_out(14)) then
        case counter_out(15 downto 14) is
            when "00" => mux_cat <= digits(3 downto 0);
            when "01" => mux_cat <= digits(7 downto 4);
            when "10" => mux_cat <= digits(11 downto 8);
            when "11" => mux_cat <= digits(15 downto 12);
            when others => mux_cat <= "0000";
        end case;
     --end if;
 end process;
 
 mux_a: process(counter_out(14)) is
     begin 
      --if rising_edge(counter_out(14)) then
         case counter_out(15 downto 14) is
             when "00" => mux_an <= "1110";
             when "01" => mux_an <= "1101";
             when "10" => mux_an <= "1011";
             when "11" => mux_an <= "0111";
             when others => mux_an <= "1111";
         end case;
      --end if;
  end process;
  
hex2sevseg: process(mux_cat) 
    begin
    case mux_cat is
                when "0000" => cat <= "1000000";    -- Display 0
                when "0001" => cat <= "1111001";    -- Display 1
                when "0010" => cat <= "0100100";    -- Display 2
                when "0011" => cat <= "0110000";    -- Display 3
                when "0100" => cat <= "0011001";    -- Display 4
                when "0101" => cat <= "0010010";    -- Display 5
                when "0110" => cat <= "0000010";    -- Display 6
                when "0111" => cat <= "1111000";    -- Display 7
                when "1000" => cat <= "0000000";    -- Display 8
                when "1001" => cat <= "0011000";    -- Display 9
                when "1010" => cat <= "0001000";    -- Display A
                when "1011" => cat <= "0000011";    -- Display b
                when "1100" => cat <= "1000110";    -- Display C
                when "1101" => cat <= "0100001";    -- Display d
                when "1110" => cat <= "0000110";    -- Display E
                when "1111" => cat <= "0001110";    -- Display F
                when others => cat <= "1110111";    -- Blank display
     end case;
end process;
an <= mux_an;

end Structural;
        