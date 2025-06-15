library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_unite_traitement is
end tb_unite_traitement;

architecture sim of tb_unite_traitement is

    component Unite_traitement
        port(
            clk      : in std_logic;
            rst      : in std_logic;
            regWr    : in std_logic;
            RW       : in std_logic_vector(3 downto 0);
            RA       : in std_logic_vector(3 downto 0);
            RB       : in std_logic_vector(3 downto 0);
            ALUSrc   : in std_logic;
            ALUCtr   : in std_logic_vector(1 downto 0);
            MemWr    : in std_logic;
            MemToReg : in std_logic;
            Immediat : in std_logic_vector(7 downto 0);
            N        : out std_logic;
            Z        : out std_logic;
            Aff      : out std_logic_vector(31 downto 0)
        );
    end component;

    signal clk, rst, regWr, ALUSrc, MemWr, MemToReg : std_logic := '0';
    signal RW, RA, RB : std_logic_vector(3 downto 0) := (others => '0');
    signal ALUCtr : std_logic_vector(1 downto 0) := "00";
    signal Immediat : std_logic_vector(7 downto 0) := (others => '0');
    signal N, Z : std_logic;
    signal Aff : std_logic_vector(31 downto 0);

    constant clk_period : time := 10 ns;

begin

    DUT: Unite_traitement
        port map (
            clk      => clk,
            rst      => rst,
            regWr    => regWr,
            RW       => RW,
            RA       => RA,
            RB       => RB,
            ALUSrc   => ALUSrc,
            ALUCtr   => ALUCtr,
            MemWr    => MemWr,
            MemToReg => MemToReg,
            Immediat => Immediat,
            N        => N,
            Z        => Z,
            Aff      => Aff
        );

    -- Clock process
    clk_process : process
    begin
        while true loop
            clk <= '0';
            wait for clk_period / 2;
            clk <= '1';
            wait for clk_period / 2;
        end loop;
    end process;

    -- Stimulus process
    stim_proc : process
    begin
        -- Reset
        rst <= '1';
        wait for 2 * clk_period;
        rst <= '0';
        wait for clk_period;

        ------------------------------------------------------------
        -- 1. Charger R1 = 5 via ADD R0 + #5
        ------------------------------------------------------------
        RA <= "0000"; RW <= "0001"; ALUSrc <= '1'; Immediat <= x"05";
        ALUCtr <= "00"; regWr <= '1';
        wait for clk_period;
        regWr <= '0';
        wait for clk_period;

        ------------------------------------------------------------
        -- 2. Charger R2 = 3 via ADD R0 + #3
        ------------------------------------------------------------
        RA <= "0000"; RW <= "0010"; ALUSrc <= '1'; Immediat <= x"03";
        ALUCtr <= "00"; regWr <= '1';
        wait for clk_period;
        regWr <= '0';
        wait for clk_period;

        ------------------------------------------------------------
        -- 3. ADD R1 + R2 => R3
        ------------------------------------------------------------
        RA <= "0001"; RB <= "0010"; RW <= "0011";
        ALUSrc <= '0'; ALUCtr <= "00"; regWr <= '1';
        wait for clk_period;
        regWr <= '0';
        wait for clk_period;

        ------------------------------------------------------------
        -- 4. ADD R1 + #4 => R4
        ------------------------------------------------------------
        RA <= "0001"; RW <= "0100"; ALUSrc <= '1'; Immediat <= x"04";
        ALUCtr <= "00"; regWr <= '1';
        wait for clk_period;
        regWr <= '0';
        wait for clk_period;

        ------------------------------------------------------------
        -- 5. SUB R1 - R2 => R5
        ------------------------------------------------------------
        RA <= "0001"; RB <= "0010"; RW <= "0101";
        ALUSrc <= '0'; ALUCtr <= "10"; regWr <= '1';
        wait for clk_period;
        regWr <= '0';
        wait for clk_period;

        ------------------------------------------------------------
        -- 6. SUB R1 - #2 => R6
        ------------------------------------------------------------
        RA <= "0001"; RW <= "0110"; ALUSrc <= '1'; Immediat <= x"02";
        ALUCtr <= "10"; regWr <= '1';
        wait for clk_period;
        regWr <= '0';
        wait for clk_period;

        ------------------------------------------------------------
        -- 7. MOV R1 => R7 (ALU passes B unchanged)
        ------------------------------------------------------------
        RA <= "0000"; RB <= "0001"; RW <= "0111";
        ALUSrc <= '0'; ALUCtr <= "01"; regWr <= '1';
        wait for clk_period;
        regWr <= '0';
        wait for clk_period;

        ------------------------------------------------------------
        -- 8. STR R1 → MEM[0x04]
        ------------------------------------------------------------
        RA <= "0000"; RB <= "0001"; -- address = R0 + imm
        ALUSrc <= '1'; Immediat <= x"04"; ALUCtr <= "00";
        MemWr <= '1'; regWr <= '0';
        wait for clk_period;
        MemWr <= '0';
        wait for clk_period;

        ------------------------------------------------------------
        -- 9. LDR MEM[0x04] → R8
        ------------------------------------------------------------
        RA <= "0000"; RB <= "0000"; RW <= "1000";
        ALUSrc <= '1'; Immediat <= x"04"; ALUCtr <= "00";
        MemToReg <= '1'; regWr <= '1';
        wait for clk_period;
        regWr <= '0'; MemToReg <= '0';
        wait for clk_period;

        wait;
    end process;

end sim;
