library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity lock_system is
    port (
        clock  : in  std_logic;
        enter  : in  std_logic;                      -- KEY0, active-low
        unlock : in  std_logic;                      -- KEY1, active-low
        switch : in  std_logic_vector(9 downto 0);
        led    : out std_logic_vector(2 downto 0)
    );
end lock_system;


architecture rtl of lock_system is

    constant password : std_logic_vector(9 downto 0) := "1011011001";

    type state_type is (
        IDLE,
        CHECK,
        WRONG,
        GRANTED,
        RELEASE,
        LOCKED
    );

    signal state : state_type := IDLE;

    signal tentative : integer range 0 to 3 := 0;

begin

    process(clock)
    begin
        if rising_edge(clock) then

            case state is

                -- =========================================
                -- WAITING
                -- =========================================
                when IDLE =>

                    led <= "000";

                    if enter = '0' then
                        state <= CHECK;
                    end if;


                -- =========================================
                -- CHECK PASSWORD
                -- =========================================
                when CHECK =>

                    if switch = password then
                        state <= GRANTED;
                    else
                        state <= WRONG;
                    end if;


                -- =========================================
                -- WRONG PASSWORD
                -- =========================================
                when WRONG =>

                    -- Show WRONG LED
                    led <= "100";

                    -- Count the attempt
                    if tentative < 3 then
                        tentative <= tentative + 1;
                    end if;

                    -- If this was the third attempt
                    if tentative = 2 then
                        state <= LOCKED;
                    else
                        state <= RELEASE;
                    end if;


                -- =========================================
                -- PASSWORD CORRECT
                -- =========================================
                when GRANTED =>

                    led <= "001";

                    tentative <= 0;

                    state <= RELEASE;


                -- =========================================
                -- WAIT FOR ENTER RELEASE
                -- =========================================
                when RELEASE =>


                    if enter = '1' then
                        state <= IDLE;
                    end if;


                -- =========================================
                -- LOCKED
                -- =========================================
                when LOCKED =>

                    led <= "010";

                    if unlock = '0' then
                        tentative <= 0;
                        state <= RELEASE;
                    end if;

            end case;

        end if;
    end process;

end rtl;
