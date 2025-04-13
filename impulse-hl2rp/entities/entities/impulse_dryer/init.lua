AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
include('shared.lua')

sound.Add({
  name = "laundrysound",
  channel = CHAN_AUTO,
  volume = 1.0,
  level = 80,
  pitch = {95, 110},
  sound = "ambient/atmosphere/pipe1.wav"
})

function ENT:Initialize()
	self:SetModel("models/props_wasteland/laundry_washer003.mdl")

	self:SetUseType(SIMPLE_USE)
    self:SetMoveType(MOVETYPE_NONE)
    self:SetSolid(SOLID_BBOX)
    self:PhysicsInit(SOLID_BBOX)
    self:DrawShadow(false)
    local physObj = self:GetPhysicsObject()

    self.delay = CurTime()
    self.Spots = {
      [1] = false,
      [2] = false,
      [3] = false,
      [4] = false,
    }
    self.worker = {
      [1] = {},
      [2] = {},
      [3] = {},
      [4] = {},
    }

    if (IsValid(physObj)) then
		physObj:Wake()
		physObj:EnableMotion(false)
    end
end

function ENT:AddDelay()
  self.delay = CurTime() + 1
end

function ENT:CanUse()
  if self.delay < CurTime() then
    return true
  else
    return false
  end
end

function ENT:CreateCloth(id)
  self:EmitSound("physics/cardboard/cardboard_box_impact_hard1.wav")
  self:EmitSound("items/ammocrate_close.wav")

  local data = self.worker[id]

  local f, r, u = self:GetForward(), self:GetRight(), self:GetUp()
  local cloth = ents.Create("impulse_cloth")
  cloth:SetPos(self:GetPos() + f * -18 + r * -16 + u * 17)
  cloth:SetAngles(self:GetAngles() + Angle(-40, -90, 0))
  cloth:SetStage(2)
  cloth:SetupType(2)
  cloth:Spawn()
  cloth.workers = data

  data = {}

  if (not self.Spots[1] and not self.Spots[2] and not self.Spots[3] and not self.Spots[4]) then
    self:StopSound("laundrysound")
  end
end

function ENT:Use(activator, caller)
  if not self:CanUse() then return end
  self:AddDelay()
  local SameSongAndDance = 0
  local d = 1

  if self:GetLaundry1() == self.LAUNDRYSTATE_DONE then
    SameSongAndDance = SameSongAndDance + d
    self:EmitBudgetSound("buttons/lever3.wav")
    self:SetLaundry1(self.LAUNDRYSTATE_DISPENSING) timer.Simple(2 * SameSongAndDance, function() self:SetLaundry1(self.LAUNDRYSTATE_EMPTY) self.Spots[1] = false self:CreateCloth(1) end)
  end
  if self:GetLaundry2() == self.LAUNDRYSTATE_DONE then
    SameSongAndDance = SameSongAndDance + d
    self:EmitBudgetSound("buttons/lever3.wav")
    self:SetLaundry2(self.LAUNDRYSTATE_DISPENSING) timer.Simple(2 * SameSongAndDance, function() self:SetLaundry2(self.LAUNDRYSTATE_EMPTY) self.Spots[2] = false self:CreateCloth(2) end)
  end
  if self:GetLaundry3() == self.LAUNDRYSTATE_DONE then
    SameSongAndDance = SameSongAndDance + d
    self:EmitBudgetSound("buttons/lever3.wav")
    self:SetLaundry3(self.LAUNDRYSTATE_DISPENSING) timer.Simple(2 * SameSongAndDance, function() self:SetLaundry3(self.LAUNDRYSTATE_EMPTY) self.Spots[3] = false self:CreateCloth(3) end)
  end
  if self:GetLaundry4() == self.LAUNDRYSTATE_DONE then
    SameSongAndDance = SameSongAndDance + d
    self:EmitBudgetSound("buttons/lever3.wav")
    self:SetLaundry4(self.LAUNDRYSTATE_DISPENSING) timer.Simple(2 * SameSongAndDance, function() self:SetLaundry4(self.LAUNDRYSTATE_EMPTY) self.Spots[4] = false self:CreateCloth(4) end)
  end
end

function ENT:Wash(id)
  self:EmitSound("items/ammocrate_close.wav")
  if id == 1 then timer.Simple(10, function() self:SetLaundry1(self.LAUNDRYSTATE_DONE) self:EmitSound("buttons/lever5.wav") end) end
  if id == 2 then timer.Simple(10, function() self:SetLaundry2(self.LAUNDRYSTATE_DONE) self:EmitSound("buttons/lever5.wav") end) end
  if id == 3 then timer.Simple(10, function() self:SetLaundry3(self.LAUNDRYSTATE_DONE) self:EmitSound("buttons/lever5.wav") end) end
  if id == 4 then timer.Simple(10, function() self:SetLaundry4(self.LAUNDRYSTATE_DONE) self:EmitSound("buttons/lever5.wav") end) end
end

function ENT:StartTouch(ent)
  if not self:CanUse() then return end
  self:AddDelay()

  if (ent:GetClass() == "impulse_cloth" and ent:GetStage() == 1) then
    for i = 1, 4 do
      if not self.Spots[i] then

        if (not self.Spots[1] and not  self.Spots[2] and not  self.Spots[3] and not  self.Spots[4]) then
          self:EmitSound("laundrysound")
        end

        local vl = self.worker[i]

        if i == 1 then self.Spots[i] = true vl = ent.workers if ent.PlayerPicker then vl[ent.PlayerPicker] = true end ent:Remove() self:SetLaundry1(self.LAUNDRYSTATE_PROCESSING) self:Wash(i) return end
        if i == 2 then self.Spots[i] = true vl = ent.workers if ent.PlayerPicker then vl[ent.PlayerPicker] = true end ent:Remove() self:SetLaundry2(self.LAUNDRYSTATE_PROCESSING) self:Wash(i) return end
        if i == 3 then self.Spots[i] = true vl = ent.workers if ent.PlayerPicker then vl[ent.PlayerPicker] = true end ent:Remove() self:SetLaundry3(self.LAUNDRYSTATE_PROCESSING) self:Wash(i) return end
        if i == 4 then self.Spots[i] = true vl = ent.workers if ent.PlayerPicker then vl[ent.PlayerPicker] = true end ent:Remove() self:SetLaundry4(self.LAUNDRYSTATE_PROCESSING) self:Wash(i) return end
      end
    end
  end
end

function ENT:OnRemove()
  self:StopSound("laundrysound")
end