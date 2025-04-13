AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
include('shared.lua')

function ENT:Initialize()
	self:SetModel("models/dpfilms/metropolice/elite_police.mdl")

	self:SetUseType(SIMPLE_USE)
    self:SetMoveType(MOVETYPE_NONE)
    self:SetSolid(SOLID_BBOX)
    self:PhysicsInit(SOLID_BBOX)
    self:DrawShadow(false)
    local physObj = self:GetPhysicsObject()

    if (IsValid(physObj)) then
        physObj:EnableMotion(false)
        physObj:Sleep()
    end
end

function ENT:Use(activator, caller)
    if (caller:Team() != TEAM_CP ) then return end
    caller.CurCMBVendor = self
	net.Start("Impulse_CreateVGUI")
	net.WriteString("ImpulseCPRankScreen")
	net.Send(caller)
end