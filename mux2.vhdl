library ieee;
use ieee.std_logic_1164.all;

entity mux2 is
	port (
		din  : in std_ulogic_vector(1 downto 0);
		sel  : in std_ulogic;
		dout : out std_ulogic
	);
end entity;

architecture dataflow of mux2 is
begin
	dout <= din(0) when sel = '0' else
	        din(1) when sel = '1';
end architecture;
