# 🐍 Snake Game on FPGA (Basys3)

## 🔍 Overview
This project implements the classic **Snake Game** on an FPGA development board (specifically, the **Basys3** by Digilent) using **Verilog HDL**. It provides a complete graphical experience with real-time input controls, collision detection, and food generation—all rendered using **VGA output**.

---

## 🎮 Game Features

- **VGA Display:** 640x480 resolution @ 60Hz refresh rate  
- **Grid-based Movement:** 32x24 grid using 20x20 pixel cells  
- **Control Interface:**
  - Arrow buttons (Up/Down/Left/Right) to move the snake
  - Center button to reset the game  
- **Gameplay Mechanics:**
  - Snake grows upon eating food
  - Each food item adds **+10 points**
  - Game ends on self-collision
  - **Wraparound** support: snake can pass through screen edges

---

## 🔧 Hardware Requirements

- ✅ **Basys3 FPGA Board** (or compatible board with VGA output)
- ✅ **VGA Monitor** (640x480 resolution)
- ✅ **5 Onboard Push Buttons** for directional control and reset

---

## 🧠 Verilog Design Overview

### 📦 Main Module: `snake_game.v`
Handles core logic:
- VGA signal timing
- Snake movement
- Grid collision detection
- Score tracking
- Game state transitions
- Random food generation (via LFSR)

### 📐 Design Parameters

| Parameter         | Description                              |
|------------------|------------------------------------------|
| `GRID_SIZE`       | 20 pixels per cell                       |
| `GRID_WIDTH`      | 32 columns (640 / 20)                    |
| `GRID_HEIGHT`     | 24 rows (480 / 20)                       |
| `INITIAL_LENGTH`  | 3 snake segments                         |
| `MAX_SNAKE_LENGTH`| 64 segments                              |
| `GAME_SPEED`      | 10 Hz (100 ms per move)                  |

---

## 🎨 Color Scheme (12-bit RGB)

| Element       | Color Name | RGB (Hex) |
|---------------|------------|-----------|
| Snake         | Green      | `12'h0F0` |
| Food          | Red        | `12'hF00` |
| Background    | Black      | `12'h000` |
| Grid Border   | Gray       | `12'h888` |

---

## ⌨️ Controls Mapping

| Button | Direction | Input Signal |
|--------|-----------|--------------|
| BTN0   | Up        | `ctrl[0]`    |
| BTN1   | Down      | `ctrl[1]`    |
| BTN2   | Left      | `ctrl[2]`    |
| BTN3   | Right     | `ctrl[3]`    |
| BTNC   | Reset     | `reset`      |

---

## 🚀 Setup & Installation

1. Clone this repository:
   ```bash
   git clone https://github.com/yourusername/snake_game_fpga.git
   cd snake_game_fpga
   ```
2. Open the project in **Xilinx Vivado** (or compatible FPGA toolchain).
3. Set the **target board** to **Basys3**.
4. Synthesize and implement the design.
5. Connect the VGA cable and configure button inputs.
6. Program the FPGA and enjoy the game!

---

## 🧩 Future Improvements

- [ ] Game **Start/Pause** toggle
- [ ] Multiple **Difficulty Levels** (increase speed)
- [ ] Add **Sound Effects** using Pmod Audio
- [ ] Real-time **Score Display** on VGA
- [ ] **High Score** Tracking with persistent memory

---

## 📜 License

This project is open-source and available under the [MIT License](https://opensource.org/licenses/MIT).  
Feel free to use, modify, and distribute it freely.

---

## 🙌 Acknowledgments

- Inspired by the original Snake game from Nokia phones.
- Developed as part of an academic project on FPGA-based game design.

---

