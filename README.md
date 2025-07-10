## snake_game_assignment
# Overview
This project implements the classic Snake game on an FPGA (specifically targeting the Basys3 board) using Verilog HDL. The game features:

VGA output (640x480 resolution)

Grid-based movement (20x20 pixel cells)

Score tracking

Collision detection (with walls and self)

Random food generation

# Features
VGA Display: 640x480 resolution with 60Hz refresh rate

Game Controls:

Up/Down/Left/Right buttons for snake direction control

Center button for reset

# Game Mechanics:

Snake grows when eating food

Score increases by 10 points per food

Game over on self-collision

Wraparound movement (snake can go through walls)

# Hardware Requirements
Basys3 FPGA board (or compatible)

VGA display

Push buttons for control

Verilog Modules
# The main module snake_game handles:

VGA timing generation

Game state management

Snake movement logic

Collision detection

Score tracking

Food generation using LFSR (Linear Feedback Shift Register)

# Parameters:
GRID_SIZE: 20 pixels (results in 32x24 grid)

INITIAL_LENGTH: 3 segments

MAX_SNAKE_LENGTH: 64 segments

GAME_SPEED: 10Hz (100ms per move)

# Color Scheme
Snake: Green (12'h0F0)

Food: Red (12'hF00)

Background: Black (12'h000)

Border: Gray (12'h888)

# Installation
Clone this repository

Open in Vivado (or compatible FPGA toolchain)

Set Basys3 as target board

Synthesize and program the FPGA

Controls
ctrl[0]: Up

ctrl[1]: Down

ctrl[2]: Left

ctrl[3]: Right

reset: Center button (resets game)

# Future Improvements
Add game start/pause functionality

Implement difficulty levels (variable speed)

Add sound effects

Display score on screen

High score tracking

# License
This project is open-source and available under the MIT License.

