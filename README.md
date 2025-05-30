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
- [LÖVE](https://love2d.org/) framework (version 11.x recommended)
- Basic understanding of Lua programming (for developers)

### Installation
1. Clone the repository:
   ```
   git clone https://github.com/nczempin/lizard-journey.git
   cd lizard-journey
   ```

2. Install LÖVE if you don't have it already:
   - Windows: Download from [love2d.org](https://love2d.org/)
   - macOS: `brew install love`
   - Linux: `sudo apt install love` or equivalent for your distribution

### Running the Game
1. Using LÖVE directly:
   ```
   love love2d/
   ```

2. Or on Windows, drag the `love2d` folder onto the `love.exe` executable

3. Alternatively, visit the online version at: http://nczempin.github.io/lizard-journey/

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
