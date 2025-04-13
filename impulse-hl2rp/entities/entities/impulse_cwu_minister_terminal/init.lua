AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
include('shared.lua')

function ENT:Initialize()
	self:SetModel("models/props_combine/breenconsole.mdl")

	self:SetUseType(SIMPLE_USE)
    self:SetMoveType(MOVETYPE_NONE)
    self:SetSolid(SOLID_BBOX)
    self:PhysicsInit(SOLID_BBOX)
    self:DrawShadow(false)
    local physObj = self:GetPhysicsObject()

    if (IsValid(physObj)) then
		physObj:Wake()
		physObj:EnableMotion(false)
    end
end

local AllowedTeams = {
    [TEAM_CP] = true,
    [TEAM_CWU] = true,
    [TEAM_OTA] = true,
}

function ENT:Use(activator, caller)
    if (not AllowedTeams[caller:Team()]) or (not caller:IsCWULead()) then return end
    caller:PlayGestureAnimation("g_r_type")
    caller.CurCWUMinisterTerminal = self
	net.Start("Impulse_CreateVGUI")
	net.WriteString("ImpulseCWUMinisterTerminal")
	net.Send(caller)
end