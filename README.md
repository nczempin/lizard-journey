# Lizard Journey

> **🗄️ Archive Notice:** This repository is being archived. The game remains playable but is no longer under active development.

## About

Lizard Journey is a 2D adventure game created for a game jam using the LÖVE framework (Love2D). You play as a lizard navigating through various environments, managing temperature and hydration while exploring the world.

## Features
- 🦎 Play as a temperature-sensitive lizard
- 🌡️ Temperature and hydration survival mechanics
- 🗺️ Tile-based world exploration
- 🎮 Classic 2D platformer controls
- 🎵 Original soundtrack

## Quick Start

### Windows (Easiest)
```bash
./run.sh  # Uses included LÖVE 0.9.1 binary
```

### macOS/Linux
1. Install LÖVE 0.9.1 from [official releases](https://github.com/love2d/love/releases/tag/0.9.1)
2. Run: `love love2d/`

### Web Version
Play online at: http://nczempin.github.io/lizard-journey/

## Controls
- **Arrow keys**: Move
- **F1**: Main menu
- **F2**: Start game  
- **F3**: Credits
- **Escape**: Pause

## Technical Details

**Built with:** LÖVE 0.9.1 (Lua game framework)

**Note:** This game requires LÖVE 0.9.1 specifically. It won't work properly with newer versions due to API changes. Migration to LÖVE 11.x was attempted but proved too complex for this archived project.

## Project Structure
```
love2d/
├── main.lua           # Entry point
├── state/             # Game states (menu, gameplay, etc.)
├── res/               # Assets (graphics, audio, shaders)
└── external/          # Third-party libraries
```

## Credits

### Development Team
- **Aldo Briessmann** - Code
- **Bernd Hildebrandt** - Graphics  
- **Francisco Pinto** - Code
- **Marcus Ihde** - Code
- **Markus Vill** - Code
- **Meral Leyla** - Sound, Music
- **Nicolai Czempin** - Code
- **Terence-Lee Davis** - Graphics

## License
The code is open source. Audio assets are licensed under CC BY-NC-ND 4.0. See individual asset files for specific licensing information.