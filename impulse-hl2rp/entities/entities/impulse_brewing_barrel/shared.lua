ENT.Type = "anim"
ENT.Base = "base_anim" 
ENT.PrintName = "Brewing Barrel"
ENT.Author = "WillMaster"
ENT.Category = "impulse: HL2RP"
ENT.Spawnable = true
ENT.AdminOnly = true

ENT.HUDName = "Brewing Barrel"
ENT.HUDDesc = "Used to brew alcohol"

function ENT:SetupDataTables()
	self:NetworkVar("Int", 0, "Timer")
	self:NetworkVar("Int", 1, "EndTimer")
end