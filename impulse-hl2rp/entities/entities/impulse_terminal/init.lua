AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
include('shared.lua')
util.AddNetworkString("ImpulseTerminalScreenOpen")

function ENT:Initialize()
	self:SetModel("models/props_combine/combine_interface001.mdl")

    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(SOLID_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetUseType(SIMPLE_USE)
    local physObj = self:GetPhysicsObject()

    if (IsValid(physObj)) then
        physObj:EnableMotion(false)
    end
end

local TeamWhitelist = {
    [TEAM_OTA] = true,
    [TEAM_CP] = true,
    [TEAM_CA] = true,
    [TEAM_COUNCIL] = true,
}
function ENT:Use(activator, caller)
    local arrester = caller.ArrestedDragging
    if ( not TeamWhitelist[caller:Team()] ) then return end
    if (caller:Team() == TEAM_OTA or caller:Team() == TEAM_CP) and (not caller:GetTeamRank()) then return end
    caller.CurTerminal = self
	net.Start("ImpulseTerminalScreenOpen")

    if arrester and arrester:IsPlayer() then
        net.WriteEntity(arrester)
    else
        net.WriteEntity(nil)
    end

	net.Send(caller)
end