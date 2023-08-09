library ieee;
use ieee.std_logic_1164.all;

entity mux4 is
	port (
		din  : in std_ulogic_vector(3 downto 0);
		sel  : in std_ulogic_vector(1 downto 0);
		dout : out std_ulogic
	);
end entity;

architecture dataflow of mux4 is
begin
	dout <= din(0) when sel(0) = '0' and sel(1) = '0' else
	        din(1) when sel(0) = '0' and sel(1) = '1' else
	        din(2) when sel(0) = '1' and sel(1) = '0' else
	        din(3) when sel(0) = '1' and sel(1) = '1';
end architecture;
