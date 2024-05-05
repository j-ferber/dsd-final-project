LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY bat_n_ball IS
    PORT (
        v_sync : IN STD_LOGIC;
        pixel_row : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
        pixel_col : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
        bat_y1 : IN STD_LOGIC_VECTOR (10 DOWNTO 0); -- current bat1 position
        bat_y2 : IN STD_LOGIC_VECTOR (10 DOWNTO 0); -- current bat2 position
        serve : IN STD_LOGIC; -- initiates serve
        red : OUT STD_LOGIC;
        green : OUT STD_LOGIC;
        blue : OUT STD_LOGIC;
        p1Score: OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
        p2Score: OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
        SW : IN STD_LOGIC
    );
END bat_n_ball;

ARCHITECTURE Behavioral OF bat_n_ball IS
    CONSTANT bsize : INTEGER := 8; -- ball size in pixels
    CONSTANT bat_w : INTEGER := 3; -- bat width in pixels
    CONSTANT bat_h : INTEGER := 40; -- bat height in pixels
    -- distance ball moves each frame
    CONSTANT ball_speed : STD_LOGIC_VECTOR (10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR (6, 11);
    SIGNAL ball_on : STD_LOGIC; -- indicates whether ball is at current pixel position
    SIGNAL bat_on1 : STD_LOGIC; -- indicates whether bat at over current pixel position
    SIGNAL bat_on2 : STD_LOGIC;
    SIGNAL game_on : STD_LOGIC := '0'; -- indicates whether ball is in play
    -- current ball position - intitialized to center of screen
    SIGNAL ball_x : STD_LOGIC_VECTOR(10 DOWNTO 0);
    SIGNAL ball_y : STD_LOGIC_VECTOR(10 DOWNTO 0);
    -- bat vertical position
    CONSTANT bat_x1 : STD_LOGIC_VECTOR(10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(75, 11);
    CONSTANT bat_x2 : STD_LOGIC_VECTOR(10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(725, 11);
    -- current ball motion - initialized to (+ ball_speed) pixels/frame in both X and Y directions
    SIGNAL ball_x_motion, ball_y_motion : STD_LOGIC_VECTOR(10 DOWNTO 0) := ball_speed;
    SIGNAL score1, score2 : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL doubleScore : STD_LOGIC;
BEGIN
    red <= NOT bat_on1; -- color setup for red ball and cyan bat on white background
    green <= NOT bat_on2;
    blue <= NOT ball_on;
    -- process to draw round ball
    -- set ball_on if current pixel address is covered by ball position
    balldraw : PROCESS (ball_x, ball_y, pixel_row, pixel_col) IS
        VARIABLE vx, vy : STD_LOGIC_VECTOR (10 DOWNTO 0); -- 9 downto 0
    BEGIN
        IF pixel_col <= ball_x THEN -- vx = |ball_x - pixel_col|
            vx := ball_x - pixel_col;
        ELSE
            vx := pixel_col - ball_x;
        END IF;
        IF pixel_row <= ball_y THEN -- vy = |ball_y - pixel_row|
            vy := ball_y - pixel_row;
        ELSE
            vy := pixel_row - ball_y;
        END IF;
        IF ((vx * vx) + (vy * vy)) < (bsize * bsize) THEN -- test if radial distance < bsize
            ball_on <= game_on;
        ELSE
            ball_on <= '0';
        END IF;
    END PROCESS;
    -- process to draw bat
    -- set bat_on if current pixel address is covered by bat position
    bat1draw : PROCESS (bat_y1, ball_y, pixel_row, pixel_col, SW) IS
        VARIABLE vx, vy : STD_LOGIC_VECTOR (10 DOWNTO 0); -- 9 downto 0
    BEGIN
        IF (SW = '0') THEN
            IF ((pixel_row >= bat_y1 - bat_h) OR (bat_y1 <= bat_h)) AND
               pixel_row <= bat_y1 + bat_h AND
               pixel_col >= bat_x1 - bat_w AND
               pixel_col <= bat_x1 + bat_w THEN
                   bat_on1 <= '1';
            ELSE
               bat_on1 <= '0';
            END IF;
        ELSE
            IF ((pixel_row >= ball_y - bat_h) OR (ball_y <= bat_h)) AND
               pixel_row <= ball_y + bat_h AND
               pixel_col >= bat_x1 - bat_w AND
               pixel_col <= bat_x1 + bat_w THEN
                   bat_on1 <= '1';
            ELSE
               bat_on1 <= '0';
            END IF;
        END IF;
    END PROCESS;
    
    bat2draw : PROCESS (bat_y1, pixel_row, pixel_col) IS
        VARIABLE vx, vy : STD_LOGIC_VECTOR (10 DOWNTO 0); -- 9 downto 0
    BEGIN
        IF ((pixel_row >= bat_y2 - bat_h) OR (bat_y2 <= bat_h)) AND
         pixel_row <= bat_y2 + bat_h AND
             pixel_col >= bat_x2 - bat_w AND
             pixel_col <= bat_x2 + bat_w THEN
                bat_on2 <= '1';
        ELSE
            bat_on2 <= '0';
        END IF;
    END PROCESS;
    
    -- process to move ball once every frame (i.e., once every vsync pulse)
    mball : PROCESS
        VARIABLE temp : STD_LOGIC_VECTOR (11 DOWNTO 0);
    BEGIN
        WAIT UNTIL rising_edge(v_sync);
        IF serve = '1' AND game_on = '0' THEN -- test for new serve
            ball_x <= conv_std_logic_vector(400, 11);
            ball_y <= conv_std_logic_vector(300, 11);
            ball_y_motion <= (NOT ball_speed) + 3; -- set vspeed to (- ball_speed) pixels
            doubleScore <= '0';
            game_on <= '1';
        ELSIF ball_y <= bsize THEN -- bounce off top wall
            ball_y_motion <= ball_speed - 2; -- set vspeed to (+ ball_speed) pixels
        ELSIF ball_y + bsize >= 600 THEN -- if ball meets bottom wall
            ball_y_motion <= (NOT ball_speed) + 2; -- set vspeed to (- ball_speed) pixels
        END IF;
        
        IF ball_x + bsize >= 800 THEN -- right wall (player 1 scores)
            IF doubleScore = '0' THEN
                score1 <= score1 + 1;
                p1Score <= score1;
                doubleScore <= '1';
            END IF;
            ball_x_motion <= (NOT ball_speed) + 1; -- set hspeed to (- ball_speed) pixels
            game_on <= '0'; -- and make ball disappear
        ELSIF ball_x <= bsize THEN -- left wall (player 2 scores)
            IF doubleScore = '0' THEN
                score2 <= score2 + 1;
                p2Score <= score2;
                doubleScore <= '1';
            END IF;
            ball_x_motion <= ball_speed; -- set hspeed to (+ ball_speed) pixels
            game_on <= '0'; -- and make ball disappear
        END IF;
        -- allow for bounce off bat1
        IF SW = '0' THEN
            IF (ball_y + bsize/2) >= (bat_y1 - bat_h) AND
             (ball_y - bsize/2) <= (bat_y1 + bat_h) AND
                 (ball_x + bsize/2) >= (bat_x1 - bat_w) AND
                 (ball_x - bsize/2) <= (bat_x1 + bat_w) THEN
                    ball_x_motion <= (ball_speed) + 1; -- set vspeed to (+ ball_speed) pixels
            END IF;
        ELSE
            IF (ball_y + bsize/2) >= (ball_y - bat_h) AND
             (ball_y - bsize/2) <= (ball_y + bat_h) AND
                 (ball_x + bsize/2) >= (bat_x1 - bat_w) AND
                 (ball_x - bsize/2) <= (bat_x1 + bat_w) THEN
                    ball_x_motion <= (ball_speed) + 1;
            END IF;
        END IF;
        -- allow for bounce off bat2
        IF(ball_y + bsize/2) >= (bat_y2 - bat_h) AND
         (ball_y - bsize/2) <= (bat_y2 + bat_h) AND
             (ball_x + bsize/2) >= (bat_x2 - bat_w) AND
             (ball_x - bsize/2) <= (bat_x2 + bat_w) THEN
                ball_x_motion <= (NOT ball_speed) + 1; -- set vspeed to (- ball_speed) pixels
        END IF;
        -- compute next ball vertical position
        -- variable temp adds one more bit to calculation to fix unsigned underflow problems
        -- when ball_y is close to zero and ball_y_motion is negative
        temp := ('0' & ball_y) + (ball_y_motion(10) & ball_y_motion);
        IF game_on = '0' THEN
            ball_y <= CONV_STD_LOGIC_VECTOR(300, 11);
        ELSIF temp(11) = '1' THEN
            ball_y <= (OTHERS => '0');
        ELSE 
            ball_y <= temp(10 DOWNTO 0); -- 9 downto 0
        END IF;
        -- compute next ball horizontal position
        -- variable temp adds one more bit to calculation to fix unsigned underflow problems
        -- when ball_x is close to zero and ball_x_motion is negative
        temp := ('0' & ball_x) + (ball_x_motion(10) & ball_x_motion);
        IF game_on = '0' THEN
            ball_x <= CONV_STD_LOGIC_VECtor(400, 11);
        ELSIF temp(11) = '1' THEN
            ball_x <= (OTHERS => '0');
        ELSE ball_x <= temp(10 DOWNTO 0);
        END IF;
    END PROCESS;
END Behavioral;
