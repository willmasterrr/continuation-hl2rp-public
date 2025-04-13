util.AddNetworkString("ImpulseApartmentScreen")
AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
include('shared.lua')

function ENT:Initialize()
	self.buttons = {}

	self:SetModel("models/props_combine/breenconsole.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	self:SetTerminalTitle("hey ply, tellwilltofixthis")
	self:SetTerminalID(0)


	local physObj = self:GetPhysicsObject()
	if (IsValid(physObj)) then
		physObj:EnableMotion(false)
		physObj:Sleep()
	end
end

function ENT:Use(activator, caller)
	net.Start("ImpulseApartmentScreen")
	net.WriteString(self:GetTerminalTitle())
	net.WriteUInt(self:GetTerminalID(), 8)

	if (caller:Team() == TEAM_CP) or (caller:Team() == TEAM_OTA) then
		net.WriteString("officer")
	elseif (caller.CurApartmentDoor) then
		net.WriteString("configuring")
	else
		net.WriteString("buying")
	end

	net.WriteEntity(self)

	net.Send(activator)
end