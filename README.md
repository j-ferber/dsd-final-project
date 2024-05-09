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

- `adc_if.vhd`
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
![image](https://github.com/j-ferber/dsd-final-project/assets/119906373/44bf4b1c-8d36-440c-b8be-c5bc7510cf4b)

- clk_in: This input is the clock used for the system clock (1)
- VGA_red, VGA_green, VGA_blue, VGA_hsync, VGA_vsync: All of these outputs are needed to display the code and colors on the screen (2)
- btnl: This input corresponds to the top button used for the input of one of the bats (Input port M18) (3)
- btnr: This input corresponds to the bottom button used for the input of one of the bats (Input port P18) (4)
- btn0: This input corresponds to the middle button used to serve the ball (Input port N17) (5)
- SEG7_anode: This output corresponds to the 8 different LED segments that could be lit up (6)
- SEG7_seg: This output determines what will be displayed on each anode (1, 2, 3, 4, 5, 6, 7, 8, 9, A, B, C, D, E, F) (7)
- KB_col, KB_row: These inputs are passed down to the `keypad.vhd` file to determine which key is currently being pressed on the keypad (8)
- SW: This one switch input corresponds to the first switch on the left side of the Nexys board (Input port V10) (9)

### PUT IMAGE WITH LABELS HERE

## Videos and Images of Program Running

## Modifications

## Summary
