AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
include('shared.lua')

function ENT:Initialize()
	self:SetModel("models/Items/ammocrate_smg1.mdl")

	self:SetUseType(SIMPLE_USE)
    self:SetMoveType(MOVETYPE_NONE)
    self:SetSolid(SOLID_BBOX)
    self:PhysicsInit(SOLID_BBOX)
    self:DrawShadow(false)
    local physObj = self:GetPhysicsObject()

    self.TimeToWait = 180 -- 180
    self.GlobalDelay = CurTime()
    self.DrillDelay = CurTime()
    self.IsDrilling = false
    self:SetDrillEndTime(0)

    if (IsValid(physObj)) then
		physObj:Wake()
    end
end

function ENT:OnRemove()
end


local weplist = {
    ["ls_357"] = {amount = 94},
    ["ls_ak47"]  = {amount = 300},
    ["ls_ar2"]  = {amount = 300},
    ["ls_doublebarrel"]  = {amount = 94},
    ["ls_goldengun"]  = {amount = 94},
    ["ls_m60"]  = {amount = 300},
    ["ls_mini14"]  = {amount = 94},
    ["ls_mp7"]  = {amount = 300},
    ["ls_pewpew"]  = {amount = 94},
    ["ls_spas12"]  = {amount = 94},
    ["ls_usp"]  = {amount = 94},
}

function ENT:OnRemove()
    self:StopSound("Canister.ScrapeSmooth")
end

function ENT:StopDrill()
    if (!IsValid(self)) then return end

    self.IsDrilling = false
    self:SetDrillEndTime(0)
    self:StopSound("Canister.ScrapeSmooth")
end

function ENT:NexusRaidLoot()
    if (!IsValid(self)) then return end
    local timerid = "SpawnStuff4NexusRaid_" .. self:EntIndex()

    self:EmitSound("items/ammocrate_open.wav")
    self:ResetSequence(2)
    self:SetPlaybackRate(1)
    self:SetCycle(0)

    local Normal_SpawnableLoot = {
        "item_healthkit",
        "item_healthvial",
        "ammo_ar2",
    }

    local Rare_SpawnableLoot = {
        "cos_elitevest",
        "wep_ar2",
    }

    timer.Create(timerid, 1, math.random(3, 5), function()
        local Change = math.random(1, 500)

        self:EmitSound("items/ammocrate_close.wav")

        if Change >= 420 then
            -- print("RARE")
            impulse.Inventory.SpawnItem(table.Random(Rare_SpawnableLoot), self:GetPos() + (self:GetAngles():Up() * 15))
        else
            -- print("Normal")
            impulse.Inventory.SpawnItem(table.Random(Normal_SpawnableLoot), self:GetPos() + (self:GetAngles():Up() * 15))
        end
    end)

    timer.Simple(8, function()
        if (!IsValid(self)) then return end

        self:EmitSound("items/ammocrate_close.wav")
        self:ResetSequence(1)
        self:SetPlaybackRate(1)
        self:SetCycle(0)
    end)
end

function ENT:StartDrill(ply)
    local CpCount = #team.GetPlayers(TEAM_CP)
    local OtaCount = #team.GetPlayers(TEAM_OTA)

    if ( self.DrillDelay > CurTime() ) then
        local delta = math.Clamp(self.DrillDelay - CurTime(), 0, 999)

        ReqwestLog({
            {
                description = ply:Nick() .. "(" .. ply:SteamName() .. ")(" .. ply:SteamID() .. ") tried to drill the ammo crate, but failed due to the cooldown.",
                color = 16711680, -- Red color (in decimal)
            }
        })

        return ply:Notify("You cant drill the ammo crate around this time, please wait " .. string.FormattedTime(delta, "%02i:%02i"))
    end

    local TeamCountNeeded = {
        ["cp"] = 4,
        ["ota"] = 5,
    }

    if (CpCount < TeamCountNeeded["cp"]) or (OtaCount < TeamCountNeeded["ota"]) then

        ReqwestLog({
            {
                description = ply:Nick() .. "(" .. ply:SteamName() .. ")(" .. ply:SteamID() .. ") tried to drill the ammo crate, but failed due there not being enough units.",
                color = 16711680, -- Red color (in decimal)
            }
        })

        return ply:Notify("You cant drill the ammo crate around this time, There must be 4 CP and 5 OTA Online.")
    end

    if (!self.IsDrilling) then
        self.DrillDelay = CurTime() + 300 -- 5 minutes
        self.IsDrilling = true
        self:SetDrillEndTime(CurTime() + self.TimeToWait)
        self:EmitSound("Canister.ScrapeSmooth")
        ply:Notify("You have started drilling the ammo box.")

        ReqwestLog({
            {
                description = ply:Nick() .. "(" .. ply:SteamName() .. ")(" .. ply:SteamID() .. ") started to drill the ammo crate.",
                color = 16711680, -- Red color (in decimal)
            }
        })

        timer.Simple(self.TimeToWait + .5, function()
            if (!IsValid(self)) then return end

            self:StopDrill()
            self:NexusRaidLoot()
        end)
    end
end

function ENT:Use(activator, caller)

    if ( !caller:IsCP() ) then return end

    if ( self.IsDrilling ) then return caller:Notify("You can't use the ammo box right now.") end

    if self.GlobalDelay > CurTime() then return end

    self.GlobalDelay = CurTime() + 3

    self:EmitSound("items/ammocrate_open.wav")
    self:ResetSequence(2)
    self:SetPlaybackRate(1)
    self:SetCycle(0)
    local data = weplist[caller:GetActiveWeapon():GetClass()] or {["base"] = {amount = 1}}
    local ammo = data.amount or false

    if (ammo) then
        caller:SetAmmo(ammo, caller:GetActiveWeapon():GetPrimaryAmmoType())
    else
        caller:SetAmmo(300, caller:GetActiveWeapon():GetPrimaryAmmoType())
    end

    timer.Simple(1.5, function()
        self:EmitSound("items/ammocrate_close.wav")
        self:ResetSequence(1)
        self:SetPlaybackRate(1)
        self:SetCycle(0)
    end)

    caller:Notify("Your ammo has been restocked.")
end