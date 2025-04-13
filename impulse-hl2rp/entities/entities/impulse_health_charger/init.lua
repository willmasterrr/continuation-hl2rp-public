AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
include('shared.lua')

function ENT:Initialize()
    self:SetModel("models/props_combine/health_charger001.mdl")

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
    local TeamWhiteList = {
        [TEAM_CP] = true,
        [TEAM_OTA] = true,
        [TEAM_COUNCIL] = true,
    }
    if TeamWhiteList[caller:Team()] then
        if self.delay < CurTime() then
            if (caller:Health() == caller:GetMaxHealth()) then
                self:EmitBudgetSound("items/medshotno1.wav")
                self.delay = CurTime() + 1
                return
            end

            self:EmitBudgetSound("items/medshot4.wav")

            caller:SetHealth(100)

            if caller:HasBrokenLegs() then
                caller:FixLegs()
            end

            caller:SendCombineMessage("BIO-GEL INJECTION SYSTEM ACTIVATED", Color(0, 255, 0))
            self.delay = CurTime() + 3
        end

    else
        caller:Notify("You must be a CP or OTA unit to use this.")
        self.delay = CurTime() + 1
    end
end