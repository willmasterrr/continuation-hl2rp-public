AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
include('shared.lua')

function ENT:Initialize()
    self:SetModel("models/props_combine/suit_charger001.mdl")

    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(SOLID_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetUseType(SIMPLE_USE)
    local physObj = self:GetPhysicsObject()

    self.delay = CurTime()

    if (IsValid(physObj)) then
        physObj:EnableMotion(false)
    end
end

function ENT:Use(activator, caller)
    local class = impulse.Teams.Data[caller:Team()].classes
    if (not class) then return end
    local armour = class[caller:GetTeamClass()].armour
    if (caller:Team() == TEAM_OTA and armour) then
        if self.delay < CurTime() then
            if (caller:Armor() == armour) then
                self:EmitBudgetSound("items/suitchargeno1.wav")
                self.delay = CurTime() + 1
                return
            end

            self:EmitBudgetSound("items/suitchargeok1.wav")

            caller:SetArmor(armour)

            caller:SendCombineMessage("SUIT PROTECTION SYSTEM RECHARGED", Color(0, 255, 0))
            self.delay = CurTime() + 3
        end

    else
        caller:Notify("You must be a OTA unit to use this.")
        self.delay = CurTime() + 1
    end
end