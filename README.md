# ⚔️ PokeBattle 8086

A feature-rich Pokémon Battle Simulator written entirely in **8086 Assembly Language**. This project demonstrates complex logic, custom UI rendering, and a robust battle engine running in a 16-bit DOS environment.

## 👥 Contributors & Features

This project was built by a team of 3 students, each owning distinct modules:

| Feature Set | Student Name | Student ID |
| :--- | :--- | :--- |
| **Menu & Navigation** | Shafi Ahmed Adib | 23101307 |
| **Selection System** | Shafi Ahmed Adib | 23101307 |
| **Battle Engine** | Farhan Zarif | 23301692 |
| **Move System** | Farhan Zarif | 23301692 |
| **Battle UI** | Amrin Hoque Yeana | 23301091 |
| **Victory & Stats** | Amrin Hoque Yeana | 23301091 |

---

## 🎮 Key Features

### 1. Authentic Battle Mechanics
*   **Type Effectiveness**: Fire > Grass > Water. (Super Effective / Not Effective).
*   **Status Conditions**: Poison, Burn, Paralysis, Sleep, Freeze.
*   **Move Accuracy & Crits**: Calculated using pseudo-random number generation.

### 2. Custom Visuals
*   **Boxed UI**: Clean, retro-styled text interface with borders.
*   **HP Bars**: Dynamic block-based health bars (`[#######---]`).
*   **Battle Log**: Clear, turn-by-turn action logging.

### 3. Pokemon Roster
Choose from 6 iconic Pokemon, each with unique stats and moves:
1.  **Pikachu** (Electric)
2.  **Bulbasaur** (Grass)
3.  **Charmander** (Fire)
4.  **Squirtle** (Water)
5.  **Eevee** (Normal)
6.  **Snorlax** (Normal)

---

## 🚀 How to Run

1.  **Assembler**: Use **EMU8086** (or MASM/TASM with compatible linker).
2.  **Compilation**:
    *   Open `FINALPROJECT341.asm` in EMU8086.
    *   Click **Emulate**.
    *   Click **Run**.
3.  **Controls**:
    *   `1-4`: Select Move
    *   `5`: Heal (Potion)
    *   `6`: Switch Pokemon
    *   Input numbers for Menu/Selection.

---

## 📂 Documentation

For a detailed technical breakdown, logic flowcharts, and code analysis, please refer to [Documentation.md](Documentation.md).
