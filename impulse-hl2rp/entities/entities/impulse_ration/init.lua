AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
include('shared.lua')

function ENT:Initialize()
	self:SetUseType(SIMPLE_USE)
  self:SetMoveType(MOVETYPE_NONE)
  self:SetSolid(SOLID_BBOX)
  self:PhysicsInit(SOLID_BBOX)
  self:DrawShadow(false)
  local physObj = self:GetPhysicsObject()

  if (IsValid(physObj)) then
	physObj:Wake()
	physObj:EnableMotion(true)
  end
end

local iscp = {
  [TEAM_OTA] = true,
  [TEAM_CP] = true,
  [TEAM_CA] = true,
  [TEAM_COUNCIL] = true,
}

function ENT:Use(activator, ply)
  -- if ply != self.Owner then return end

    if self.CWUMoney then
        ply:Notify("You have received " .. impulse.Config.CurrencyPrefix .. self.CWUMoney .. " in this paycheck for your services to the Universal Union.")
        ply:EmitBudgetSound("impulse/eat.wav")
        ply:GiveMoney(self.CWUMoney)

        ply.CWUMoney = nil
    else

    local CPPoints = ply:GetSyncVar(SYNC_CMBPOINTS, 0)

    local money_bonuses = {
        {10, 2},
        {20, 6},
        {40, 14},
        {60, 20},
        {80, 40},
        {100, 60},
        {120, 80},
        {140, 100},
    }

    local hunger_bonuses = {
        {10, 1},
        {20, 2},
        {40, 6},
        {60, 8},
        {80, 10},
        {100, 18},
    }

    self.Dollarss = self.money

    if self.money then

        for _, v in ipairs(money_bonuses) do
            if CPPoints > v[1] then
                self.Dollarss = self.money + v[2]
            end
        end
    end

    local ExtraHunger = 0

    for _, v in ipairs(hunger_bonuses) do
        if CPPoints > v[1] then
            ExtraHunger = v[2]
        end
    end

    -- print(self.Dollarss)
    -- print(self.money)
    -- print(ExtraHunger)

    ply:EmitBudgetSound("impulse/eat.wav")
    ply:Say("/me Eats a " .. team.GetName(self.team) .. " ration.")

    ReqwestLog({
        {
            description = ply:Nick() .. "(" .. ply:SteamName() .. ")(" .. ply:SteamID() .. ") Has gotten their ration.",
            color = 16711680, -- Red color (in decimal)
        }
    })

    if not self.money then
        ply:Notify("You have picked up a " .. team.GetName(self.team) .. " ration, but havent received any money. (OOC: You have to wait 5 minutes after changing your team to get your ration money.)")
        ply:FeedHunger(38 + ExtraHunger)
    else
        ply:Notify("You have picked up a " .. team.GetName(self.team) .. " ration and have received " .. impulse.Config.CurrencyPrefix .. self.Dollarss .. ".")
        ply:GiveMoney(self.Dollarss)

        if iscp[self.team] then
            ply:FeedHunger(50 + ExtraHunger)
        else
            ply:FeedHunger(38 + ExtraHunger)
        end
    end

    end

    self:Remove()
end