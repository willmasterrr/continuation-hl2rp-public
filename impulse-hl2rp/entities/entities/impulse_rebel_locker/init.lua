AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
include('shared.lua')

function ENT:Initialize()
	self:SetModel("models/props_wasteland/controlroom_storagecloset001a.mdl")

    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(SOLID_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetUseType(SIMPLE_USE)
    local physObj = self:GetPhysicsObject()

    if (IsValid(physObj)) then
        physObj:EnableMotion(false)
    end
end

function ENT:Use(activator, caller)
    if (caller:Team() != TEAM_CITIZEN ) then return end
    caller.CurLocker = self
	net.Start("Impulse_CreateVGUI")
	net.WriteString("ImpulseLockerScreen")
	net.Send(caller)
end