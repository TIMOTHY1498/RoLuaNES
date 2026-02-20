local module = {}

local RunService = game:GetService("RunService")

local cpu = require("./src/cpu")
local ppu = require("./src/ppu")
local input = require("./src/input")
local bus = require("./src/bus")
local mapper = require("./src/mapper")
local ppu = require("./src/ppu")

local ambatu_bass = require("./src/bus")
local color_convert = require("./asset/rbg32_color3")

local game_nes_binaryStr = script:GetAttribute("game_DATA")
	
module.loadgame = function(binary_data: string)
	script:SetAttribute("game_DATA", binary_data)
end

script:GetAttributeChangedSignal("game_DATA"):Connect(function()
	local game_nes_binaryStr2 = script:GetAttribute("game_DATA")
	
	mapper.load(game_nes_binaryStr2)
	ppu.init(mapper)
	bus.connect(mapper, ppu, input)
	cpu.init(bus)
	cpu.reset()
end)

module.reset = function()
	--connector:Disconnect()
	cpu.reset()
end

module.createScreen = function(eImg: EditableImage)
	task.spawn(function()
		RunService.Heartbeat:Connect(function()

			for scan = 1, 262 do

				-- Run some CPU work per scanline
				for i = 1, 30 do
					cpu.step()
				end
	
				ppu.run_scanline()

				if ppu.nmi_pending() then
					cpu.nmi()
					ppu.clear_nmi()
				end
			end

			if ppu.frame_complete() then
				eImg:WritePixelsBuffer(
					Vector2.zero,
					Vector2.new(256, 240),
					buffer.fromstring(ppu.get_framebuffer())
				)
			end

		end)

	end)
end

module.getOneScreenDbg = function()
	local raw = ppu.get_framebuffer()
	print(#raw)
end

module.sendKeycode = function(keycode: Enum.KeyCode)
	input.read(keycode)
end

return module
