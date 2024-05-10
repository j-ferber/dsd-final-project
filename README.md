# Digital System Design Final Project - Pong

Pong on Nexys A7-100T using Vivado

## Introduction

In **_Pong_**, you control one of the bats and keep the ball away from your side

- **Goal:** Keep the ball from hitting your side of the screen
- **Scoring:** There are two different scores present on the board at once
  - The left score represents the points the person controlling the left bat has scored, which means how many times the ball hit the right side
  - The right score represents the points the person controlling the right bat has scored, meaning the amount of times the ball has hit the left wall
- **Winning:** Whoever has the most points by the time you stop playing is the winner. The score can reach a maximum of 255 in hex, so the first person there also wins technically.
- **Expected Start:** Once you program the board, the game is ready to start
  - Once you hit the middle button on the board, BTNC, the ball will be served
  - If you want to completely restart the game, just reprogram the device

## Required Attachments

To play the game, you will need the following attachments:

- Nexys A7-100T Board
- 16-button keypad module [(Pmod KYPD)](https://store.digilentinc.com/pmod-kypd-16-button-keypad/) connected to the Pmod port JA
- VGA to HDMI Adapter

## How to Run

Download the following files from this repository to your computer:

- `bat_n_ball.vhd`
- `clk_wiz_0_clk_wiz.vhd`
- `clk_wiz_0.vhd`
- `keypad.vhd`
- `leddec16.vhd`
- `pong_2.vhd`
- `vga_sync.vhd`
- `pong.xdc`

After downloading the files, follow these steps:

1. Create new project on Vivado
   - Add all  `.vhd` files as source files to the project
   - Add the `.xdc` file as a constraint file to the project
   - Choose Nexys A7-100T board for the project
2. Run synthesis
3. Run implementation
4. Generate bitstream, open hardware manager, and program device Click 'Generate Bitstream' Click 'Open Hardware Manager' and click 'Open Target' then 'Auto Connect' Click 'Program Device'
5. Make sure the vga-sync and keypad module are hooked up to the Nexys board, or program will not work as expected
6. Push BTNC, middle button, to serve the ball for pong

## Input and Outputs

Image of inputs and outputs to top level file, `pong_2.vhd`

![image](https://github.com/j-ferber/dsd-final-project/assets/119906373/46e2ade3-7b12-4f69-8824-eef618ab4a2d)

- clk_in: This input is the clock used for the system clock (1)
- VGA_red, VGA_green, VGA_blue, VGA_hsync, VGA_vsync: All of these outputs are needed to display the code and colors on the screen (2)
- btnl: This input corresponds to the top button used for the input of one of the bats (Input port M18) (3)
- btnr: This input corresponds to the bottom button used for the input of one of the bats (Input port P18) (4)
- btn0: This input corresponds to the middle button used to serve the ball (Input port N17) (5)
- Auto1, Auto2: These inputs correspond to the switches used to turn on the compuer controlled mode for left and right bats (Input ports V10, U11) (6)
- SW: This vector input is used to control the speed of the ball using the 5 switches on the right side of the Nexys board (Input ports J15, L16, M13, R15, R17) (7)
- SEG7_anode: This output corresponds to the 8 different LED segments that could be lit up (8)
- SEG7_seg: This output determines what will be displayed on each anode (1, 2, 3, 4, 5, 6, 7, 8, 9, A, B, C, D, E, F) (9)
- KB_col, KB_row: These inputs are passed down to the `keypad.vhd` file to determine which key is currently being pressed on the keypad (10)

![20240509_213141](https://github.com/j-ferber/dsd-final-project/assets/119906373/21a3f75f-9ce7-4c7a-bbcf-0b667cfae1a7)

## Videos and Images of Program Running

## Modifications

### `pong_2.vhd`

_This code originated from the `pong_2.vhd` file under the alternative Lab 6_

**Initial:**

![image](https://github.com/j-ferber/dsd-final-project/assets/119906373/f438789f-c948-4b22-9451-8e2520d0e193)

![image](https://github.com/j-ferber/dsd-final-project/assets/119906373/306a473c-f00b-45b7-bf36-d67615dbb6a5)

![image](https://github.com/j-ferber/dsd-final-project/assets/119906373/97dbcf4a-d2df-4d27-9447-8897a3c3e615)

---

**Modified:**

![image](https://github.com/j-ferber/dsd-final-project/assets/119906373/d94bde10-a3b7-4fcf-af24-2fd8a0ed6f84)

![image](https://github.com/j-ferber/dsd-final-project/assets/119906373/eef690e9-4da8-45aa-8583-7ff37223e04a)

![image](https://github.com/j-ferber/dsd-final-project/assets/119906373/b223e47c-4856-4148-98ef-8dcc7cb29080)

![image](https://github.com/j-ferber/dsd-final-project/assets/119906373/1602800e-61a5-4348-acfe-7d231ebab0b4)

The changes made between the two different first files relates to the inputs and outputs to the system. We had to add:

- Switches for auto-control
- Switches for changing the ball speed
- Keyboard columns and rows to determine keypad input

The difference between the two second images shows the different signals we had to create to make sure the game works as intended. We also had to add new ports to the bat_n_ball component to correspond the the other ports we added in `bat_n_ball.vhd` (will be shown later) along with adding the keypad component. The signals we had to add are:

- A second bat position to allow us to move a second bat on the opposite side of the screen of the first one
- A second display vector, which allowed us to display different scores for each player
- Keypad signals to allow us to correctly use the keypad and track the inputs

The difference between the last image of the initial and last two images of modified code show how we implemented the movement of the bats within our code, the instantiation of the keypad component, and the way we pased down the new signals to the bat_n_ball component.

- For moving the ball, we had to make a few modifications:
  - Accounting for the second bat &rarr; To account for the second bat, we made sure we made sure the keypad is being hit and that the current value was either 1 or 7. These inputs would move the second bat at the same rate as the first bat.
  - For both bats, we had to make sure the computer mode was not on &rarr; The switches that we used to determine the computer mode for each bat made sure that the bats could not move by user input when that mode was on
- When making the bat_n_ball component, we had to add the new signals mentioned earlier as ports within the new component, which can be seen in the above image
- The last image in the modified code shows how we instantiated the keypad component, allowing us to use the keys within our gameplay

### `pong.xdc`

_This code originated from the `pong_2.xdc` file under the alternative Lab 6_

**Initial:**

![image](https://github.com/j-ferber/dsd-final-project/assets/119906373/ba6332b7-78fc-478b-9275-ff11a6c1ab94)

---

**Modified:**

![image](https://github.com/j-ferber/dsd-final-project/assets/119906373/2cd53109-f5ad-42d7-beb4-f9db3d031fc4)

![image](https://github.com/j-ferber/dsd-final-project/assets/119906373/7058a387-a3d3-439b-b57f-d832f2c29599)

The modifications to this file comprised of adding new ports on top of the original code, which consisted of us adding:

- Added the switches to control the speed of the ball and turning on/off computer mode (shown in the first modified image)
- Added the Pmod Header JA inputs to allow use of the keypad (shown in the second modified image)

### `bat_n_ball.vhd`

_The code for this file originated from the `bat_n_ball.vhd` file from Lab 6_

**Initial:**

#### Signals and Ports 

![image](https://github.com/j-ferber/dsd-final-project/assets/119906373/ddda98a2-e4ae-4bcf-9052-97474b9a11a9)

#### Bat Drawing

![image](https://github.com/j-ferber/dsd-final-project/assets/119906373/7a857cfb-812d-4d10-93cf-4e7c22780271)

#### Ball Movement

![image](https://github.com/j-ferber/dsd-final-project/assets/119906373/a463c4c0-9082-457a-b56e-06703151271c)

---

**Modified:**

#### Signals and Ports

![image](https://github.com/j-ferber/dsd-final-project/assets/119906373/d872bdbf-4673-4af6-8b54-39f1626ffd18)

#### Bat Drawing

![image](https://github.com/j-ferber/dsd-final-project/assets/119906373/b2b8d75a-5db2-487c-9465-de4423e422e3)

![image](https://github.com/j-ferber/dsd-final-project/assets/119906373/4d6af38b-c9d6-4392-b8f1-554d9d194c2d)

#### Ball Movement

![image](https://github.com/j-ferber/dsd-final-project/assets/119906373/1e50f0c3-c885-4c14-921c-fa6de719fae7)

![image](https://github.com/j-ferber/dsd-final-project/assets/119906373/4be5f8a1-1ae8-4e15-8370-ce91277426fa)

**Port Maps**

In the first images of both the initial and the modified code, the entity and main signals/constants are shown

- For the entity port map, we had to add more inputs and outputs to allow us to control features like a second score, computer mode, etc.
  - The two y positions represent the current position of the middle of each bat, these are changed using the buttons or keypad when the auto control mode is not on
  - The two auto inputs turn on/off the auto control mode
  - The SW input represents a 5 bit vecotr used to control the speed of the ball
  - The two score outputs represent the 8 bit vector that is passed down to display each players respective scores
- We had to change some of the constants and add new signals as well, such as:
  - The bat width was decreased and vertical height was increased as we want our bats to move vertically rather than horizontally like the original code
  - The two bat x-coordinates are constants that we used to place the two different bats in front of each side wall
  - The scores signals were used to update the respective players scores when either wall was hit
  - The doubleScore signal was used to make sure that only one point was added to the players whenever they scored

**Bat Drawing**

When it came to drawing the bats, we had to add another process to draw the second bat. We also had to change the way the bats were drawn depending on if the computer mode was turned on.

- The approach we took to draw the bats is as follows:
  - If the switch for the automatic mode is not flipped, then we would draw the bat based on the current location. This location would change with the inputs from the keypad or buttons.
  - If switch was flipped, we wanted the computer to play the game itself. So, we based the drawing of the bat on the current location for the ball, as this would allow the bat to follow the ball up and down the screen.
- We implemented this strategy for both bats, using the various signals created specifically for either the first bat or second bat, which can be seen in the bat drawing section under the modified section. These images also show the second process we created.

**Ball Movement**



## Summary
