ENT.Type = "anim"
ENT.Base = "base_anim" 
ENT.PrintName = "OTA NPC"
ENT.Author = "WillMaster"
ENT.Category = "impulse: HL2RP"
ENT.Spawnable = true
ENT.AdminOnly = true

ENT.HUDName = "Overwatch Transhuman Arm Officer"
ENT.HUDDesc = "Select your division and rank."

function ENT:DoAnimation()
	self:ResetSequence("idle_unarmed")
end
