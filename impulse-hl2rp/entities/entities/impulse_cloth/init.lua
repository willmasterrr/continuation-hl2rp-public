AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
include('shared.lua')

function ENT:Initialize()
  self:SetModel("models/props_junk/garbage_bag001a.mdl")
	self:SetMaterial("models/props_c17/FurnitureFabric003a")

	self:SetUseType(SIMPLE_USE)
    self:SetMoveType(MOVETYPE_NONE)
    self:SetSolid(SOLID_BBOX)
    self:PhysicsInit(SOLID_BBOX)
    self:DrawShadow(false)
    local physObj = self:GetPhysicsObject()

    if (IsValid(physObj)) then
		physObj:EnableMotion(true)
		physObj:Wake()
  end
end

function ENT:Use(activator, caller)
    if self.CanFold then
      self:SetStage(3)
      self:SetupType(3)
      self.CanFold = false
		  self:EmitSound("physics/cardboard/cardboard_box_break3.wav")
      self.workers[ply] = true
    end
end

function ENT:SetupType(id)
    if id == 0 then
	    self:SetColor(Color(153, 132, 73))
    elseif id == 1 then
	    self:SetColor(Color(164, 164, 164))
    elseif id == 2 then
	    self:SetColor(Color(255, 255, 255))
    elseif id == 3 then
        self:SetColor(Color(255, 255, 255))
        self.isFolded = true
        self:SetModel("models/props_junk/garbage_newspaper001a.mdl")
    end
end