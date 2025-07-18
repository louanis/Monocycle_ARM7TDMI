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
    type memoiretype is array(63 downto 0) of std_logic_vector(31 downto 0); -- 64 mots de 32 bits
    signal memoire : memoiretype := (others => (others => '0')); -- mémoire interne
begin
    dataout <= memoire(to_integer(unsigned(addr))); -- lecture asynchrone

    process(clk, rst)
    begin
        if rst = '1' then
            memoire <= (others => (others => '0')); -- rst mémoire
            memoire(32) <= "00000000000000001111111111111111";
        elsif rising_edge(clk) then
            if wren = '1' then
                memoire(to_integer(unsigned(addr))) <= datain; -- écriture synchrone
            end if;
        end if;
    end process;
end architecture rtl;



