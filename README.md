# ROLuaNes
NES Emulator that ported on ROBLOX Lua based on https://github.com/willtobyte/NES 

# disclaimer
> PLEASE NOTE; this project uses Roblox EditableMesh API, specificly uses `EditableImage:WritePixelBuffer()` API. you will need verified by an ID to use this API

the emulator src and loader was loaded inside `ReplicatedStorage.nes_emu` and the loader itself was located in  `ReplicatedStorage.nes_emu.main`.

# api usage
1. `Main.loadgame(binary_data: string)`
loads the game data (mapper 0 games, binary string) into the emulator
2.  `Main.sendKeycode(key_code: Enum.KeyCode)`
perform keycode input that allowed
3.  `Main.reset()`
reset the emulator
4. `Main.createScreen(screen: EditableImage)`
embed the emulator screen into custom ediatble image

# keycode whitelist
```
Enum.KeyCode.ButtonA - "A" BUTTON
Enum.KeyCode.ButtonB - "B" BUTTON
Enum.KeyCode.ButtonX - SELECT
Enum.KeyCode.ButtonY  - START
Enum.KeyCode.DPadUp - UP
Enum.KeyCode.DPadDown - DOWN
Enum.KeyCode.DPadLeft - LEFT
Enum.KeyCode.DPadRight - RIGHT
```

# example usage

```luau
--[[
	// LuauNES_Emulator - NES Emulator written in Luau/Lua
	
	// File: main.lua
	// Info: Main runner for the emulator
	
	// Author: @timothy1498
	// Created by: https://github.com/willtobyte for his own engine.
	// Ported to Luau by: @timothy1498
]]--

local main = require(game.ReplicatedStorage.nes_emu.main)
local eImg: EditableImage = nil

local iLabel = workspace:WaitForChild("TV + Table"):WaitForChild("RenderPart").SurfaceGui.Frame.ImageLabel

local AssetService = game:GetService("AssetService")
local UserInputService = game:GetService("UserInputService")

eImg = AssetService:CreateEditableImage({
	Size = Vector2.new(256, 240)
})

local game22 = game.ReplicatedStorage.nes_emu.get_rom_data:InvokeServer("https://example.com/experiment/kong.nes")

--// Test Game
main.loadgame(game22)
print("[INFO] Loaded game")


iLabel.ImageContent = Content.fromObject(eImg)
iLabel.ImageTransparency = 0

--// UserInput
UserInputService.InputBegan:Connect(function(input: InputObject, gameProcessedEvent: boolean)
	if gameProcessedEvent then return end
	main.sendKeycode(input.KeyCode)
end)

--// Main Loop
print("[info] Starting main loop")
main.createScreen(eImg)
```

# credits
https://github.com/willtobyte - huge thanks for him 
@timothy1498_boi - ported the emulator into luau

# license
see [LICENCE](https://github.com/TIMOTHY1498/RoLuaNES/blob/main/LICENSE) for licence information
