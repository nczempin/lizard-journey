# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Lizard Journey is a 2D adventure game built with LÖVE2D (version 0.9.1) written in Lua. The game features a lizard protagonist with temperature and hydration mechanics, tile-based world exploration, and various gameplay systems.

## Running the Game

```bash
# Run the game (requires LÖVE2D installed)
love love2d/

# On Windows: drag the love2d folder onto love.exe
```

No build process is required - this is a pure Lua/LÖVE2D project.

## Core Architecture

### State Management (FSM-based)
- **Entry Point**: `love2d/main.lua` → `love2d/game.lua`
- **State Controller**: `love2d/state/states.lua`
- **States**: init → main_menu → gameplay/paused → credits
- **Global Keys**: F1 (main menu), F2 (start game), F3 (credits)

### Game World System
- **World**: `love2d/state/gameplay/world.lua` - 128x128 tile-based map with multiple rendering layers
- **Pawn**: `love2d/state/gameplay/pawn.lua` - Character entity with physics, temperature, and water mechanics
- **Fire System**: Temperature sources that affect nearby pawns
- **Pathfinding**: Integrated Jumper library supporting A*, BFS, DFS, Dijkstra, JPS algorithms

### Resource Management
- **Graphics**: `love2d/res/gfx/` - Sprites, tilesets, GUI elements
- **Audio**: `love2d/res/music/` and `love2d/res/sfx/` - Licensed under CC BY-NC-ND 4.0
- **Fonts**: `love2d/res/fonts/` - Alagard font family
- **Shaders**: `love2d/res/shader/` - Custom GLSL for tileset rendering

### External Libraries
All third-party libraries are in `love2d/external/`:
- **GUI System**: Custom implementation with buttons, checkboxes, combo boxes
- **TEsound**: Enhanced audio management
- **TSerial**: Lua serialization
- **Jumper**: Pathfinding algorithms
- **FSM**: Finite State Machine implementation

## Key Game Mechanics

### Temperature System
- Ambient temperature affects lizard protagonist
- Fire sources create heat zones
- Temperature management is crucial for survival

### Hydration System  
- Water resource management
- Affects character performance and survival

### Movement & Physics
- 8-directional sprite animations
- Tile-based collision detection
- Digging mechanics implementation

## Mission System

Missions are defined in `love2d/data/map/` as INI files:
- Define spawn points, towers, objectives
- Currently 3 missions implemented
- Mission selection via `love2d/data/menu/`

## Development Commands

Since this is a LÖVE2D project, standard development involves:
```bash
# Run with console output (debugging)
love love2d/ --console

# The console is already enabled in conf.lua
```

## Code Organization Patterns

### Adding New States
1. Create state file in `love2d/state/`
2. Register in `states.lua` state machine
3. Implement required callbacks: init(), enter(), update(dt), draw(), keypressed(key)

### Adding Game Entities
1. Extend or create new entity in `love2d/state/gameplay/`
2. Integrate with world.lua update/draw cycles
3. Handle collision detection if needed

### Audio Integration
- Use TEsound library for all audio playback
- Place music in `res/music/`, effects in `res/sfx/`
- Respect CC BY-NC-ND 4.0 license for audio assets

## Important Implementation Notes

### Coordinate System
- World uses tile-based coordinates (128x128 grid)
- Screen coordinates for rendering (800x600 window)
- Layer system for depth ordering

### Save/Load System
- TSerial library available for serialization
- No save system currently implemented

### Performance Considerations
- LÖVE2D 0.9.1 is an older version (current is 11.x)
- Shader-based tileset rendering for efficiency
- Pathfinding can be expensive on large maps

## Current Development Status

Implemented:
- Core game loop and state management
- Basic character movement and controls
- World rendering with tile system
- Temperature and hydration mechanics
- Audio system with background music
- Menu and credits screens

In Progress:
- Level design and progression
- Enemy AI and interactions

Not Started:
- Advanced game mechanics
- Story elements and cutscenes
- Save/load functionality

## Development Memories
- Put a timeout around any calls to love, so I do not have to quit the application manually