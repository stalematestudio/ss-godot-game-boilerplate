# ss-godot-game-boilerplate

Boilerplate code for developing Godot games. The base backend boring stuff that many games need but is a pain to develop.

## Running the web deployment localy

```bash
./serve.py --root build/html5/
```

## AutoLoad scripts

### Game Manager

__res://scripts/global_scripts/GameManager.gd__

This is the main game control logic. All game state control should go through it.

### Config Manager

__res://scripts/global_scripts/ConfigManager.gd__

Handles game configuration saving and loading. Holds an array of possible resolutions. Detects connected joypads.

### Audio Manager

__res://scripts/global_scripts/AudioManager.gd__

Holds references to non positional persistent AudioStreamPlayers from the Main Scene. Has the audio_bus_* indexes. And should be used for all non positional audio playbacks as in title music and user interface audio effects.

### Helpers

__res://scripts/global_scripts/Helpers.gd__

Has utility functions.
- ```RemoveChildren(p_node)``` removes all child nodes under p_node
- ```ButtonIndex2ButtonName(btn_index)``` returns mouse button name String from btn_index
- ```event_as_text(event)``` alternate InputEvent.as_text() function

## Scenes

### Main Scene ( Persistent )

__res://scenes/main.tscn__

This is the project ‘Main Scene’. It is persistent during runtime and all other scenes in a project are loaded into it at runtime. It holds nodes that should be reused by the game and not duplicated in loaded sub scenes. It holds a "WorldEnvironment" node used to reference the "Environment" and AudioStreamPlayers for non positional Music, Voice and FX playback.

- main
  - WorldEnvironment / __res://default_env.tres__ / __res://proceduralsky.tres__
  - Music_Player
  - Voice_Player
  - FX_Player

### Intro & Credits Scenes

__res://scenes/intro/intro.tscn & res://scenes/credits/credits.tscn__

The Intro and Credits Scenes both work like a slideshow and share the same control script. There is a "screens" Array that should be populated with textures. On timeout of the "event_timer" Timer the next texture from "screens" is displayed in "screen_display" TextureRect. After the end of the array GameManager.change_state("TITLE") is called to load the "Title Scene".

### Title Scene

__res://scenes/title/title.tscn__

...

### Pause Scene

__res://scenes/pause/pause.tscn__

...

### Settings Scene

__res://scenes/settings/settings.tscn__

...

### Debug Scene

__res://scenes/debug/debug.tscn__

...

### Game Scene

__res://scenes/game/game.tscn__

...