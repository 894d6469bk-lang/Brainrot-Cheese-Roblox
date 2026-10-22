--!strict
--[[
	Main.server.lua
	Entry point - just requires the services so they start running
]]

require(script.Parent.Services.PlayerService)
require(script.Parent.Services.BrainrotService)
require(script.Parent.Services.MonetizationService)

print("🦧 Brainrot Cheese server is LIVE. Time to rot brains and make cheese.")
