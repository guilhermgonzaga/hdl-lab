library ieee;
use ieee.std_logic_1164.all;

entity fulladder1 is
	port (
		a, b, cin : in std_ulogic;
		sum, cout : out std_ulogic
	);
end entity;

architecture dataflow of fulladder1 is
begin
	sum <= a xor b xor cin;
	cout <= (a and b) or (a and cin) or (b and cin);
end architecture;
