ENT.Type = "anim"
ENT.Base = "base_anim" 
ENT.PrintName = "Block Terminal"
ENT.Author = "WillMaster"
ENT.Category = "impulse: HL2RP"
ENT.Spawnable = true
ENT.AdminOnly = true

function ENT:SetupDataTables()
	self:NetworkVar( "Int", "TerminalID" )
	self:NetworkVar( "String", "TerminalTitle" )
end

ENT.HUDName = "City-Block Terminal"
ENT.HUDDesc = "Apartment registration system."