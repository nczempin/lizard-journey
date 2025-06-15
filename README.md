# Lizard Journey: A 2D Adventure Game

## What Problem Does This Solve?
Lizard Journey is a 2D adventure game built with the LÖVE framework (Love2D) that provides an entertaining gaming experience while demonstrating game development principles in Lua. It offers players a chance to control a lizard character through various challenges and environments.

## Who Is This For?
- Casual gamers looking for a 2D adventure experience
- Lua developers interested in game development with LÖVE
- Students learning game programming concepts
- Anyone interested in exploring open-source game development

## Current Implementation Status
- ✅ Basic character movement and controls
- ✅ Game world rendering
- ✅ Simple collision detection
- 🚧 Level design and progression
- 🚧 Enemy AI and interactions
- 📋 Advanced game mechanics
- 📋 Story elements and cutscenes

## Setup Instructions

### Prerequisites
- [LÖVE](https://love2d.org/) framework version 0.9.1
- Basic understanding of Lua programming (for developers)

**Important Note:** This game has been tested exclusively with LÖVE 0.9.1. While it may work with other versions, compatibility is not guaranteed. Migration to newer versions is planned for future development.

### Installation
1. Clone the repository:
   ```
   git clone https://github.com/nczempin/lizard-journey.git
   cd lizard-journey
   ```

2. Install LÖVE 0.9.1:
   - **Windows**: The repository includes a vendored copy of LÖVE 0.9.1 for Windows in `vendor/love2d-0.9.1-win64/`. No additional installation needed!
   - **macOS/Linux**: Download LÖVE 0.9.1 from the [official releases page](https://github.com/love2d/love/releases/tag/0.9.1)
   - Note: The game should work with LÖVE 0.9.1 binaries on all platforms, though we've only tested with the Windows version

### Running the Game

#### Windows (Easy Method)
```bash
./run.sh  # Uses the vendored LÖVE 0.9.1 binary
```

#### All Platforms (With LÖVE 0.9.1 installed)
```bash
love love2d/
```

#### Alternative Methods
1. On Windows, drag the `love2d` folder onto the `love.exe` executable (version 0.9.1)
2. Visit the online version at: http://nczempin.github.io/lizard-journey/

## Project Scope

### What This IS
- A 2D adventure game featuring a lizard protagonist
- A demonstration of LÖVE/Lua game development techniques
- An open-source game project for learning and entertainment

### What This IS NOT
- Not a commercial-grade game with extensive features
- Not optimized for all platforms and screen sizes
- Not a complete game engine or framework

## Repository Structure
- `love2d/` - Main game directory for the LÖVE framework
  - `main.lua` - Entry point for the LÖVE framework
  - `conf.lua` - Configuration settings for the game
  - `player.lua` - Player character implementation
  - `level.lua` - Level design and management
  - `assets/` - Game assets (images, sounds, etc.)

## Controls
- Arrow keys: Move the lizard character
- Space: Jump/Action
- Escape: Pause/Menu

## Development Status
This is an experimental game project in active development. Contributions and feedback are welcome.
