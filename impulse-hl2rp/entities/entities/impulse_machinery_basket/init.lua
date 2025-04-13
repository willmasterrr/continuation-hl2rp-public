AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
include('shared.lua')

function ENT:Initialize()
    self:SetModel("models/props_c17/oildrum001.mdl")

    timer.Simple(0, function()
        self:SetModel("models/items/item_item_crate.mdl")

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
    end)
end

function ENT:StartTouch(ent)
  if ent:GetClass() == "impulse_crafting_work" and ent.Level >= 4 then
    local reward = impulse.Config.FactoryMachineryReward

    if ent.PlayerPicker then
      ent.workers[ent.PlayerPicker] = true
    end

    for k, v in pairs(ent.workers) do
      reward = reward + 4
    end

    for i, o in pairs(ent.workers) do
      if not i.CWUMoney then
        i.CWUMoney = 0
      end

      i.CWUMoney = i.CWUMoney + reward
      i:GiveLoyalPoints(2)
    end

    for o, p in pairs(ent.workers) do
      o:Notify("You have received " .. impulse.Config.CurrencyPrefix .. reward .. " and 2 Loyalist Points for working in the workshift.")
    end

    ent:Remove()
  end
end