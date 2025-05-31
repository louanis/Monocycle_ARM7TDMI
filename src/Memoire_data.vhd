library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity memoire_data is
    port (
        clk : in std_logic; -- horloge
        rst : in std_logic; -- rst asynchrone
        DataIn : in std_logic_vector(31 downto 0); -- données à écrire
        DataOut : out std_logic_vector(31 downto 0); -- données lues
        Addr : in std_logic_vector(5 downto 0); -- adresse
        WrEn : in std_logic -- write enable
    );
end entity memoire_data;

architecture rtl of memoire_data is
    type memorytype is array(63 downto 0) of std_logic_vector(31 downto 0); -- 64 mots de 32 bits
    function init_memoire return memorytype is
        variable result : memorytype;
    begin
        for i in 63 downto 0 loop
            result(i) := (others => '0'); -- init à 0
        end loop;
        for i in 16 to 26 loop
            result(i) := x"00000001"; -- init à 1 pour les adresses 16 à 26
        end loop;
        return result;
    end function;
    signal memory : memorytype := init_memoire; -- mémoire interne
begin
    dataout <= memory(to_integer(unsigned(addr))); -- lecture asynchrone

    process(clk, rst)
    begin
        if rst = '1' then
            memory <= init_memoire; -- rst mémoire
        elsif rising_edge(clk) then
            if wren = '1' then
                memory(to_integer(unsigned(addr))) <= datain; -- écriture synchrone
            end if;
        end if;
    end process;
end architecture rtl;



