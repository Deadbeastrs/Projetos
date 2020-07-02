library IEEE; 
use IEEE.STD_LOGIC_1164.all; 
 
entity Decoder7SegToBinary is
     port(Input : in  std_logic_vector(6 downto 0);
	  Output : out std_logic_vector(6 downto 0));
end Decoder7SegToBinary; 
 
 
architecture teste of Decoder7SegToBinary is
	
begin   
        Output <= 
		  "0000001"    when (Input = "1111001") else  --1
		  "0000010"    when (Input = "0100100") else  --2
		  "0000011"    when (Input = "0110000") else  --3
		  "0000100"    when (Input = "0011001") else  --4
		  "0000101"    when (Input = "0010010") else  --5
		  "0000110"    when (Input = "0000010") else  --6
		  "0000111"    when (Input = "1111000") else  --7
		  "0001000"    when (Input = "0000000") else  --8
		  "0001001"    when (Input = "0010000") else  --9
		  "0010001"    when (Input = "0001000") else  --A
		  "0010010"    when (Input = "0000011") else  --b
		  "0010011"    when (Input = "1000110") else  --C
		  "0010100"    when (Input = "0100001") else  --D
		  "0010101"    when (Input = "0000110") else  --E
		  "0001110"    when (Input = "0111111") else  --"--"
		  "0101111"    when (Input = "1111111") else  --""
		  "0000000";                               --0
		  
end teste; 