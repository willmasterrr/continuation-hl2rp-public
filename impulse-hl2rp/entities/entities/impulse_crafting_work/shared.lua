ENT.Type = "anim"
ENT.Base = "base_anim" 
ENT.PrintName = "CWU Make Work Entity"
ENT.Author = "WillMaster"
ENT.Category = "impulse: HL2RP"
ENT.Spawnable = true
ENT.AdminOnly = true

function ENT:SetupDataTables()
	self:NetworkVar("Int", 0, "ID")
	self:NetworkVar("Int", 2, "WhatToUse")
	self:NetworkVar("Bool", false, "IsPuttedIn")
	self:NetworkVar("Float", 1, "Work")
end