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

## Videos and Images of Program Running

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
5. Push BtNC, middle button, to serve the ball for pong

## Modifications
