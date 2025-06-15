library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity MONOCYCLE is
    port (
        clk    : in std_logic;
        SW     : in std_logic_vector(9 downto 0);
        LED    : out std_logic_vector(9 downto 0);
        HEX    : out std_logic_vector(47 downto 0);
        BUTTON : in std_logic_vector (1 downto 0)
    );
end entity MONOCYCLE;


architecture rtl of MONOCYCLE is
    signal rst  : std_logic;
    signal Aff  : std_logic_vector(31 downto 0);
    signal pclk : std_logic := '1';
    signal comp : integer := 0;
begin


    process(clk)
    begin
        if rising_edge(clk) then
            if comp < 250000 then
                comp <= comp + 1;
            else
                comp <= 0;
                pclk <= not pclk;
            end if;
        end if;

    end process;
    rst <= not BUTTON(0);

    seven_seg1 : entity work.SEVEN_SEG
        port map(
            Data   => Aff(3 downto 0),
            Pol    => SW(0),
            Segout => HEX(6 downto 0)
        );

    seven_seg2 : entity work.SEVEN_SEG
        port map(
            Data   => Aff(7 downto 4),
            Pol    => SW(0),
            Segout => HEX(14 downto 8)
        );

    seven_seg3 : entity work.SEVEN_SEG
        port map(
            Data   => Aff(11 downto 8),
            Pol    => SW(0),
            Segout => HEX(22 downto 16)
        );
        
    seven_seg4 : entity work.SEVEN_SEG
        port map(
            Data   => Aff(15 downto 12),
            Pol    => SW(0),
            Segout => HEX(30 downto 24)
        );
        
    seven_seg5 : entity work.SEVEN_SEG
        port map(
            Data   => Aff(19 downto 16),
            Pol    => SW(0),
            Segout => HEX(38 downto 32)
        );
        
    seven_seg6 : entity work.SEVEN_SEG
        port map(
            Data   => Aff(23 downto 20),
            Pol    => SW(0),
            Segout => HEX(46 downto 40)
        );
        
    processor : entity work.proco
        port map(
            clk    => pclk,
            rst    => rst,
            Affout => Aff
        );


end rtl;