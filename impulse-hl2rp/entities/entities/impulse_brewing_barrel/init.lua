AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
include('shared.lua')

function ENT:Initialize()
	self:SetModel("models/props_c17/woodbarrel001.mdl")
    -- self:SetModel("models/props_borealis/bluebarrel001.mdl")

    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(SOLID_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetUseType(SIMPLE_USE)
    local physObj = self:GetPhysicsObject()

    self:SetHealth(20)
    self.Recipes = {}

    if (IsValid(physObj)) then
        physObj:EnableMotion(true)
        physObj:Wake()
    end
end

function ENT:Use(activator, caller)
    local value = math.Round((math.Clamp((self:GetTimer() - CurTime()) / (self:GetTimer() - self:GetEndTimer()), 0, 1) * 100), 1)
    if value == 100 then
        if caller:IsCP() then
            return
        end


        if caller:CanHoldItem("util_moonshine", 1) then
            self:SetEndTimer(0)
            self:SetTimer(0)

            if timer.Exists(self:EntIndex()..".SoundMakerBarrel") then
                timer.Remove(self:EntIndex()..".SoundMakerBarrel")
            end

            caller:GiveInventoryItem("util_moonshine")
            caller:Notify("Moonshine bottle added to inventory.")
            self:EmitSound("impulse/craft/water/" .. math.random(1, 3) .. ".wav")
        else
            caller:Notify("You dont have enough space.")
        end
    end
end

-- types
-- 1 == water
-- 2 == spices
-- 3 == yeast

function ENT:StartBrewing()
    self:SetTimer(CurTime())
	self:SetEndTimer(CurTime() + impulse.Config.BrewingTime)

    self:EmitSound("ambient/levels/canals/toxic_slime_sizzle"..math.random(1, 4)..".wav", 70)

    timer.Create(self:EntIndex()..".SoundMakerBarrel", math.random(15, 36), 0, function()
		if IsValid(self) then
        	self:EmitSound("ambient/levels/canals/toxic_slime_sizzle"..math.random(1, 4)..".wav", 70)
		end
    end)
end

function ENT:CanPutRecipe(t)
    if t > 3 then
        return false
    end

    local data = self.Recipes

    if self:GetTimer() >= 1 then
        return false
    end

    if not data[t] then
        return true
    else
        return false
    end
end

function ENT:PutRecipe(t)
    if self:GetTimer() >= 1 then
        return
    end

    local data = self.Recipes

    if not data[t] then
        data[t] = true
    else
        return -- Already exists
    end

    if data[1] and data[2] and data[3] then
        self:StartBrewing()
        self.Recipes = {}
    end
end

function ENT:OnTakeDamage(damage)
    self:SetHealth(self:Health() - damage:GetDamage())

    if self:Health() < 25 and not self.IsIgnited then
        self.IsIgnited = true
        self:Ignite(15)

        timer.Simple(15, function()
            if not IsValid(self) then return end
            self:Explode()
        end)
    end

    if self:Health() < 0 and not self.IsExploding then
        self:Explode()
    end
end

function ENT:Explode()
    self.IsExploding = true
    local explosion = ents.Create("env_explosion")
    explosion:SetKeyValue("spawnflags", 144)
    explosion:SetKeyValue("iMagnitude", 15)
    explosion:SetKeyValue("iRadiusOverride", 256)
    explosion:SetPos(self:GetPos())
    explosion:Spawn()


    explosion:Fire("explode", "", 0)
    self:Remove()
end