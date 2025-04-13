AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
include('shared.lua')

function ENT:Initialize()
	self:SetModel("models/props_wasteland/controlroom_desk001b.mdl")

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

function ENT:StartTouch(ent)
  if (ent:GetClass() == "impulse_cloth" and ent:GetStage() == 2) then
    ent.CanFold = true
  end
end

function ENT:EndTouch(ent)
  if (ent:GetClass() == "impulse_cloth" and ent:GetStage() == 2) then
    ent.CanFold = false
  end
end