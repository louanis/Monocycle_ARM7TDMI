library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Tb_ALU_RegBench is
end entity;

architecture behavior of Tb_ALU_RegBench is

    -- COMPONENTS
    component RegisterARM
        port (
            CLK   : in std_logic;
            Reset : in std_logic;
            W     : in std_logic_vector(31 downto 0);
            RA    : in std_logic_vector(3 downto 0);
            RB    : in std_logic_vector(3 downto 0);
            RW    : in std_logic_vector(3 downto 0);
            WE    : in std_logic;
            A     : out std_logic_vector(31 downto 0);
            B     : out std_logic_vector(31 downto 0)
        );
    end component;

    component ALU
        port (
            A  : in std_logic_vector(31 downto 0);
            B  : in std_logic_vector(31 downto 0);
            OP : in std_logic_vector(1 downto 0);
            S  : out std_logic_vector(31 downto 0);
            N  : out std_logic;
            Z  : out std_logic
        );
    end component;

    -- SIGNALS
    signal CLK    : std_logic := '0';
    signal RST    : std_logic := '1';
    signal W      : std_logic_vector(31 downto 0);
    signal RA, RB : std_logic_vector(3 downto 0);
    signal RW     : std_logic_vector(3 downto 0);
    signal WE     : std_logic := '0';
    signal A, B   : std_logic_vector(31 downto 0);

    -- ALU
    signal S      : std_logic_vector(31 downto 0);
    signal N, Z   : std_logic;
    signal ALUOP  : std_logic_vector(1 downto 0);

    constant CLK_PERIOD : time := 10 ns;

begin

    -- CLOCK
    clk_process : process
    begin
        while true loop
            CLK <= '0'; wait for CLK_PERIOD / 2;
            CLK <= '1'; wait for CLK_PERIOD / 2;
        end loop;
    end process;

    -- REGISTER BANK
    REG_BANK: RegisterARM
        port map (
            CLK   => CLK,
            Reset => RST,
            W     => W,
            RA    => RA,
            RB    => RB,
            RW    => RW,
            WE    => WE,
            A     => A,
            B     => B
        );

    -- ALU
    UALU: ALU
        port map (
            A  => A,
            B  => B,
            OP => ALUOP,
            S  => S,
            N  => N,
            Z  => Z
        );

    -- STIMULUS
    stim_proc : process
    begin
        -- Reset
        RST <= '1'; wait for 20 ns;
        RST <= '0'; wait for 20 ns;

        -- R(1) := R(15) = 0x30
        W  <= X"00000030";
        RW <= "0001"; WE <= '1';
        wait for CLK_PERIOD;
        WE <= '0';

        -- R(1) := R(1) + R(15)
        RA <= "0001"; RB <= "1111"; wait for 10 ns;
        ALUOP <= "00"; -- ADD
        wait for 10 ns;
        W <= S;
        RW <= "0001"; WE <= '1';
        wait for CLK_PERIOD;
        WE <= '0';

        -- R(2) := R(1) + R(15)
        RA <= "0001"; RB <= "1111"; wait for 10 ns;
        ALUOP <= "00";
        wait for 10 ns;
        W <= S;
        RW <= "0010"; WE <= '1';
        wait for CLK_PERIOD;
        WE <= '0';

        -- R(3) := R(1) - R(15)
        RA <= "0001"; RB <= "1111"; wait for 10 ns;
        ALUOP <= "10"; -- SUB
        wait for 10 ns;
        W <= S;
        RW <= "0011"; WE <= '1';
        wait for CLK_PERIOD;
        WE <= '0';

        -- R(5) := R(7) - R(15)
        RA <= "0111"; RB <= "1111"; wait for 10 ns;
        ALUOP <= "10";
        wait for 10 ns;
        W <= S;
        RW <= "0101"; WE <= '1';
        wait for CLK_PERIOD;
        WE <= '0';

        wait;

    end process;

end behavior;
