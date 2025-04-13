AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
include('shared.lua')

sound.Add( {
	name = "WashingSound",
	channel = CHAN_AUTO,
	volume = 0.5,
	level = 80,
	pitch = { 95, 110 },
	sound = "ambient/machines/laundry_machine1_amb.wav"
} )

function ENT:Initialize()
	self:SetModel("models/props_wasteland/laundry_dryer002.mdl")

	self:SetUseType(SIMPLE_USE)
    self:SetMoveType(MOVETYPE_NONE)
    self:SetSolid(SOLID_BBOX)
    self:PhysicsInit(SOLID_BBOX)
    self:DrawShadow(false)
    local physObj = self:GetPhysicsObject()
    self:SetIsWashing(false)
    self.workerdata = {}

    if (IsValid(physObj)) then
		physObj:Wake()
		physObj:EnableMotion(false)
  end
end

function ENT:StartTouch(ent)
  if self:GetIsWashing() then return end

  if (ent:GetClass() == "impulse_cloth" and ent:GetStage() == 0) then
    self:SetIsWashing(true)
    self.workerdata = ent.workers
    if ent.PlayerPicker then
      self.workerdata[ent.PlayerPicker] = true
    end
    ent:Remove()
    self:EmitSound("WashingSound")

    timer.Simple(20, function() -- 20
      if self:IsValid() then
        self:StopSound("WashingSound")
        self:SetIsWashing(false)
        local cloth = ents.Create("impulse_cloth")
        cloth:SetPos(self:GetPos() + self:GetForward() * 20)
        cloth:SetStage(1)
        cloth:SetupType(1)
        cloth:Spawn()
        cloth.workers = self.workerdata
      end
    end)
  end
end