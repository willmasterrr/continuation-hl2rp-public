AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
include('shared.lua')

function ENT:Initialize()
  self:SetModel("models/props_wasteland/laundry_cart002.mdl")

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

  if ent:GetClass() == "impulse_cloth" and ent:GetStage() == 3 then
    local reward = impulse.Config.FactoryLaundryReward

    if ent.PlayerPicker then
      ent.workers[ent.PlayerPicker] = true
    end

    local functionreward

    if impulse.WorkshiftEnabled then
        functionreward = function(ent)
            reward = reward + 6
        end
    else
        functionreward = function(ent)
            reward = reward + 2
        end
    end

    for i, o in pairs(ent.workers) do
      if not i.CWUMoney then
        i.CWUMoney = 0
      end

      i.CWUMoney = i.CWUMoney + reward
    end

    for o, p in pairs(ent.workers) do
      o:Notify("You have received " .. impulse.Config.CurrencyPrefix .. reward .. " for working in the factory.")
    end

    ent:Remove()
  end
end