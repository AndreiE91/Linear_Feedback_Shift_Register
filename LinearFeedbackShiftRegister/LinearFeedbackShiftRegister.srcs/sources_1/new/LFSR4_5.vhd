library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity LFSR4_5 is
	port (clk, rst: in std_logic;					
	looplen: in std_logic_vector(0 to 4);
	variant: in std_logic; --'0' means 4 bit, '1' means 5 bit
	output: inout std_logic_vector(0 to 4);
	button: inout std_logic);
end LFSR4_5;

architecture LFSR4_5_beh of LFSR4_5 is
	signal Currstate: std_logic_vector(0 to 4);
	signal feedback, Control, Extend, STALL: std_logic; --Extend = Gate B; Control = Gate C
	signal tempu,tempt,tlen0,tlen1,variantCase: std_logic_vector(0 to 3);
	SIGNAL count: std_logic_vector(0 to 26) := (others => '0'); -- count signal length dependent of number of 1 bits used for compare


begin

Freqdiv: PROCESS(clk)
	BEGIN
		IF(count = "111111111111111111111111111") THEN -- feel free to adjust(add more 1 for slower speed, delete 1 for faster) remember to modify also count signal length above
			button <= NOT button;
			count <= (others => '0');
		ELSIF(clk = '1' and clk'EVENT) THEN
			count <= count+1;
		END IF;
	END PROCESS; 
	
	
	UpdateState: process(button, rst)
	begin
		
		if(rst = '0') then			   --Rst is active low
			Currstate <=("00000");
		elsif (button = '1' and button'event) then
			if(variant = '0') then				  --Selective shifting of register to avoid changing first bit;
				Currstate(0) <= '0';			  --This matters when we only want to use 4 bits
				Currstate(4) <= Currstate(3);
				Currstate(3) <= Currstate(2);
				Currstate(2) <= Currstate(1);
				Currstate(1) <= feedback;
			else
				Currstate <= feedback & Currstate(0 to 3);	--Straight forward shifting done for the 5-bit variant
			end if;
			output <= Currstate;
		end if;
		
		
		STALL <= (NOT looplen(0)) AND (NOT looplen(1)) AND (NOT looplen(2)) AND (NOT looplen(3)) AND (NOT looplen(4)); --By default, stalling of circuit counting is disabled and will only
																													   --enable when looplen's value is 0
		
		Extend <= (Currstate(0) OR (NOT variant)) AND Currstate(1) AND Currstate(2) AND Currstate(3); --Gate B; By default, loop is extended. To disable this, Extend AND Currstate(4)
		--Currstate(0) can be ignored when variant = '0' for the 4-bit case, thanks to '1' being absorbant element for OR gate and neutral element for AND gate
			
		
		
		IF(variant = '0') THEN
		--4 bit case
			variantCase <= "0100";
			CASE looplen is    --Connect Q4 At "AND" Gate B for 4,8,12 and 16
    			WHEN "01111" => Control <= '0'; --16 (do nothing but keep loop extended)
				tlen0 <= "0001"; tlen1 <= "0110";
				WHEN "01110" => Extend <= Extend AND Currstate(4); Control <= '0'; --15 (same as 16, but avoid extending loop into '1111' state)
				tlen0 <= "0001"; tlen1 <= "0101";				
				WHEN "01101" => Control <= (NOT Currstate(1)) AND Currstate(2) AND (NOT Currstate(3)) AND (NOT Currstate(4)); --14
				tlen0 <= "0001"; tlen1 <= "0100";
				WHEN "01100" => Control <= (NOT Currstate(1)) AND Currstate(2) AND Currstate(3) AND Currstate(4); --13
				tlen0 <= "0001"; tlen1 <= "0011";
				WHEN "01011" => Extend <= Extend AND Currstate(4); Control <= (NOT Currstate(1)) AND Currstate(2) AND Currstate(3) AND Currstate(4); --12 (13 without extension)
				tlen0 <= "0001"; tlen1 <= "0010";
				WHEN "01010" => Control <= Currstate(1) AND Currstate(2) AND (NOT Currstate(3)) AND (NOT Currstate(4)); --11
				tlen0 <= "0001"; tlen1 <= "0001";
				WHEN "01001" => Control <= Currstate(1) AND (NOT Currstate(2)) AND Currstate(3) AND Currstate(4); --10
				tlen0 <= "0001"; tlen1 <= "0000";
				WHEN "01000" => Control <= Currstate(1) AND (NOT Currstate(2)) AND (NOT Currstate(3)) AND Currstate(4); --9
				tlen0 <= "0000"; tlen1 <= "1001";
				WHEN "00111" => Extend <= Extend AND Currstate(4); Control <= Currstate(1) AND (NOT Currstate(2)) AND (NOT Currstate(3)) AND Currstate(4); --8 (9 without extension)
				tlen0 <= "0000"; tlen1 <= "1000";
				WHEN "00110" => Control <= Currstate(1) AND (NOT Currstate(2)) AND (NOT Currstate(3)) AND (NOT Currstate(4)); --7
				tlen0 <= "0000"; tlen1 <= "0111";
				WHEN "00101" => Control <= Currstate(1) AND (NOT Currstate(2)) AND Currstate(3) AND (NOT Currstate(4)); --6
				tlen0 <= "0000"; tlen1 <= "0110";
				WHEN "00100" => Control <= (NOT Currstate(1)) AND (NOT Currstate(2)) AND Currstate(3) AND (NOT Currstate(4)); --5
				tlen0 <= "0000"; tlen1 <= "0101";
				WHEN "00011" => Extend <= Extend AND Currstate(4); Control <= Currstate(1) AND Currstate(2) AND (NOT Currstate(3)) AND Currstate(4); --4
				tlen0 <= "0000"; tlen1 <= "0100";
				WHEN "00010" => Control <= (NOT Currstate(1)) AND Currstate(2) AND Currstate(3) AND (NOT Currstate(4)); --3
				tlen0 <= "0000"; tlen1 <= "0011";
				WHEN "00001" => Control <= (NOT Currstate(1)) AND Currstate(2) AND (NOT Currstate(3)) AND Currstate(4); --2
				tlen0 <= "0000"; tlen1 <= "0010";
				WHEN "00000" => tlen0 <= "0000"; tlen1 <= "0001";
				WHEN others => Control <= '0'; --Redundant
				tlen0 <= "1111"; tlen1 <= "1111";
			END CASE;
		ELSE 
		--5 bit case
		variantCase <= "0101";
			CASE looplen is    --Connect Q5 At "AND" Gate B for 5,10,14,16,18,22,27 and 31	
				WHEN "11111" => Control <= '0'; 		--32
				tlen0 <= "0011"; tlen1 <= "0010";
				WHEN "11110" => Extend <= Extend AND Currstate(4); Control <= '0'; 		--31
				tlen0 <= "0011"; tlen1 <= "0001";
				WHEN "11101" => Control <= Currstate(0) AND (NOT Currstate(1)) AND Currstate(2) AND (NOT Currstate(3)) AND (NOT Currstate(4));  		--30
				tlen0 <= "0011"; tlen1 <= "0000";
				WHEN "11100" => Control <= Currstate(0) AND (NOT Currstate(1)) AND Currstate(2) AND Currstate(3) AND Currstate(4); 		--29
				tlen0 <= "0010"; tlen1 <= "1001";
				WHEN "11011" => Control <= (NOT Currstate(0)) AND Currstate(1) AND (NOT Currstate(2)) AND (NOT Currstate(3)) AND Currstate(4);  		--28
				tlen0 <= "0010"; tlen1 <= "1000";
				WHEN "11010" => Control <= (NOT Currstate(0)) AND Currstate(1) AND (NOT Currstate(2)) AND (NOT Currstate(3)) AND Currstate(4); Extend <= Extend AND Currstate(4);  		--27
				tlen0 <= "0010"; tlen1 <= "0111";
				WHEN "11001" => Control <= (NOT Currstate(0)) AND Currstate(1) AND Currstate(2) AND (NOT Currstate(3)) AND Currstate(4); 		 --26
				tlen0 <= "0010"; tlen1 <= "0110";
				WHEN "11000" => Control <= Currstate(0) AND Currstate(1) AND (NOT Currstate(2)) AND (NOT Currstate(3)) AND Currstate(4); 		 --25
				tlen0 <= "0010"; tlen1 <= "0101";
				WHEN "10111" => Control <= (NOT Currstate(0)) AND (NOT Currstate(1)) AND Currstate(2) AND Currstate(3) AND (NOT Currstate(4));  		--24
				tlen0 <= "0010"; tlen1 <= "0100";
				WHEN "10110" => Control <= Currstate(0) AND (NOT Currstate(1)) AND (NOT Currstate(2)) AND (NOT Currstate(3)) AND (NOT Currstate(4));  		--23
				tlen0 <= "0010"; tlen1 <= "0011";
				WHEN "10101" => Control <= Currstate(0) AND (NOT Currstate(1)) AND (NOT Currstate(2)) AND (NOT Currstate(3)) AND (NOT Currstate(4)); Extend <= Extend AND Currstate(4);  		--22
				tlen0 <= "0010"; tlen1 <= "0010";
				WHEN "10100" => Control <= (NOT Currstate(0)) AND Currstate(1) AND (NOT Currstate(2)) AND Currstate(3) AND (NOT Currstate(4));  		--21
				tlen0 <= "0010"; tlen1 <= "0001";
				WHEN "10011" => Control <= Currstate(0) AND (NOT Currstate(1)) AND (NOT Currstate(2)) AND Currstate(3) AND (NOT Currstate(4));  		--20
				tlen0 <= "0010"; tlen1 <= "0000";
				WHEN "10010" => Control <= Currstate(0) AND Currstate(1) AND Currstate(2) AND (NOT Currstate(3)) AND (NOT Currstate(4));  		--19
				tlen0 <= "0001"; tlen1 <= "1001";
				WHEN "10001" => Control <= Currstate(0) AND Currstate(1) AND Currstate(2) AND (NOT Currstate(3)) AND (NOT Currstate(4)); Extend <= Extend AND Currstate(4);  		--18
				tlen0 <= "0001"; tlen1 <= "1000";
				WHEN "10000" => Control <= (NOT Currstate(0)) AND Currstate(1) AND Currstate(2) AND Currstate(3) AND (NOT Currstate(4));  		--17
				tlen0 <= "0001"; tlen1 <= "0111";
				WHEN "01111" => Control <= (NOT Currstate(0)) AND (NOT Currstate(1)) AND Currstate(2) AND (NOT Currstate(3)) AND Currstate(4); Extend <= Extend AND Currstate(4);  		--16
				tlen0 <= "0001"; tlen1 <= "0110";
				WHEN "01110" => Control <= (NOT Currstate(0)) AND Currstate(1) AND Currstate(2) AND Currstate(3) AND Currstate(4);  		--15
				tlen0 <= "0001"; tlen1 <= "0101";
				WHEN "01101" => Control <= (NOT Currstate(0)) AND Currstate(1) AND Currstate(2) AND Currstate(3) AND Currstate(4); Extend <= Extend AND Currstate(4);  		--14
				tlen0 <= "0001"; tlen1 <= "0100";
				WHEN "01100" => Control <= Currstate(0) AND Currstate(1) AND Currstate(2) AND (NOT Currstate(3)) AND Currstate(4);  		--13
				tlen0 <= "0001"; tlen1 <= "0011";
				WHEN "01011" => Control <= Currstate(0) AND (NOT Currstate(1)) AND (NOT Currstate(2)) AND Currstate(3) AND Currstate(4);  		--12
				tlen0 <= "0001"; tlen1 <= "0010";
				WHEN "01010" => Control <= (NOT Currstate(0)) AND Currstate(1) AND (NOT Currstate(2)) AND Currstate(3) AND Currstate(4);  		--11
				tlen0 <= "0001"; tlen1 <= "0001";
				WHEN "01001" => Control <= (NOT Currstate(0)) AND Currstate(1) AND (NOT Currstate(2)) AND Currstate(3) AND Currstate(4); Extend <= Extend AND Currstate(4);  		--10
				tlen0 <= "0001"; tlen1 <= "0000";
				WHEN "01000" => Control <= Currstate(0) AND (NOT Currstate(1)) AND (NOT Currstate(2)) AND (NOT Currstate(3)) AND Currstate(4);  		--9
				tlen0 <= "0000"; tlen1 <= "1001";
				WHEN "00111" => Control <= (NOT Currstate(0)) AND (NOT Currstate(1)) AND Currstate(2) AND Currstate(3) AND Currstate(4);  		--8
				tlen0 <= "0000"; tlen1 <= "1000";
				WHEN "00110" => Control <= Currstate(0) AND Currstate(1) AND (NOT Currstate(2)) AND (NOT Currstate(3)) AND (NOT Currstate(4));  		--7
				tlen0 <= "0000"; tlen1 <= "0111";
				WHEN "00101" => Control <= Currstate(0) AND Currstate(1) AND (NOT Currstate(2)) AND Currstate(3) AND Currstate(4);  		--6
				tlen0 <= "0000"; tlen1 <= "0110";
				WHEN "00100" => Control <= Currstate(0) AND Currstate(1) AND (NOT Currstate(2)) AND Currstate(3) AND Currstate(4); Extend <= Extend AND Currstate(4);  		--5
				tlen0 <= "0000"; tlen1 <= "0101";
				WHEN "00011" => Control <= (NOT Currstate(0)) AND Currstate(1) AND (NOT Currstate(2)) AND (NOT Currstate(3)) AND (NOT Currstate(4));  		--4
				tlen0 <= "0000"; tlen1 <= "0100";
				WHEN "00010" => Control <= Currstate(0) AND (NOT Currstate(1)) AND Currstate(2) AND Currstate(3) AND (NOT Currstate(4));  		--3
				tlen0 <= "0000"; tlen1 <= "0011";
				WHEN "00001" => Control <= Currstate(0) AND (NOT Currstate(1)) AND Currstate(2) AND (NOT Currstate(3)) AND Currstate(4);  		--2
				tlen0 <= "0000"; tlen1 <= "0010";
				WHEN "00000" => tlen0 <= "0000"; tlen1 <= "0001";
				WHEN others => Control <= '0'; tlen0 <= "1111"; tlen1 <= "1111"; --error case
			END CASE;
		END IF;
				CASE output is
			WHEN "11111" => tempu <= "0001"; tempt <= "0011"; --31
			WHEN "11110" => tempu <= "0000"; tempt <= "0011"; --30
			WHEN "11101" => tempu <= "1001"; tempt <= "0010"; --29
			WHEN "11100" => tempu <= "1000"; tempt <= "0010"; --28
			WHEN "11011" => tempu <= "0111"; tempt <= "0010"; --27
			WHEN "11010" => tempu <= "0110"; tempt <= "0010"; --26
			WHEN "11001" => tempu <= "0101"; tempt <= "0010"; --25
			WHEN "11000" => tempu <= "0100"; tempt <= "0010"; --24
			WHEN "10111" => tempu <= "0011"; tempt <= "0010"; --23
			WHEN "10110" => tempu <= "0010"; tempt <= "0010"; --22
			WHEN "10101" => tempu <= "0001"; tempt <= "0010"; --21
			WHEN "10100" => tempu <= "0000"; tempt <= "0010"; --20
			WHEN "10011" => tempu <= "1001"; tempt <= "0001"; --19
			WHEN "10010" => tempu <= "1000"; tempt <= "0001"; --18
			WHEN "10001" => tempu <= "0111"; tempt <= "0001"; --17
			WHEN "10000" => tempu <= "0110"; tempt <= "0001"; --16
			WHEN "01111" => tempu <= "0101"; tempt <= "0001"; --15
			WHEN "01110" => tempu <= "0100"; tempt <= "0001"; --14
			WHEN "01101" => tempu <= "0011"; tempt <= "0001"; --13
			WHEN "01100" => tempu <= "0010"; tempt <= "0001"; --12
			WHEN "01011" => tempu <= "0001"; tempt <= "0001"; --11
			WHEN "01010" => tempu <= "0000"; tempt <= "0001"; --10
			WHEN "01001" => tempu <= "1001"; tempt <= "0000"; --9
			WHEN "01000" => tempu <= "1000"; tempt <= "0000"; --8
			WHEN "00111" => tempu <= "0111"; tempt <= "0000"; --7
			WHEN "00110" => tempu <= "0110"; tempt <= "0000"; --6
			WHEN "00101" => tempu <= "0101"; tempt <= "0000"; --5
			WHEN "00100" => tempu <= "0100"; tempt <= "0000"; --4
			WHEN "00011" => tempu <= "0011"; tempt <= "0000"; --3
			WHEN "00010" => tempu <= "0010"; tempt <= "0000"; --2
			WHEN "00001" => tempu <= "0001"; tempt <= "0000"; --1
			WHEN "00000" => tempu <= "0000"; tempt <= "0000"; --0
			WHEN others => tempu <= "1111"; tempt <= "1111"; --error
			END CASE;
		
	END PROCESS;
		feedback <=(((Currstate(2) OR (NOT variant)) XNOR (Currstate(3) OR variant) XNOR Currstate(4)) XOR (Control OR Extend)) AND (NOT STALL); --as long as STALL is disabled, it will not affect feedback
		--I want to have Currstate(2) not matter when variant = '0' and Currstate(2) matter and Currstate(3) not matter when variant = '1'
		--Since 1 is neutral element in XNOR operation, I want to turn it off by making it be equal to 1, so 2 will be off when var = 0 and on when var = 1, similarly but opposite with 3
		

END LFSR4_5_beh;