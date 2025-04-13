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

    if (IsValid(physObj)) then
		physObj:Wake()
		physObj:EnableMotion(false)
    end

    self.CanWork = true
    self.Level = 1

    self.PutObject = false
    self.ObjectionList =
    {
        [1] = "scrap_glue",
        [2] = "scrap_metal",
        [3] = "scrap_screws",
    }
    self:SetWhatToUse(1)

end

local Types = { -- Initialize the types of entities
    [0] = {lvl_model = {
        [1] = {
            model = "models/gibs/manhack_gib02.mdl",
            mat = nil,
        },
        [2] = {
            model = "models/manhack.mdl",
            mat = "sprops/textures/gear_metal",
        }, 
        [3] = {
            model = "models/manhack.mdl",
            mat = "phoenix_storms/cube",
        },
        [4] = {
            model = "models/manhack.mdl",
            mat = nil,
        },
    }},
    [1] = {lvl_model = {
        [1] = {
            model = "models/hunter/misc/sphere025x025.mdl",
            mat = "phoenix_storms/metalset_1-2",
        },
        [2] = {
            model = "models/Roller.mdl",
            mat = "sprops/textures/gear_metal",
        }, 
        [3] = {
            model = "models/Roller.mdl",
            mat = "phoenix_storms/cube",
        },
        [4] = {
            model = "models/Roller.mdl",
            mat = nil,
        },
    }},
}

function ENT:Initialize_Type()
    local id = self:GetID()
    local level = self.Level
    local data = Types[id].lvl_model
    data = data[level]

    self:SetModel(data.model)
    timer.Simple(0, function() self:SetMaterial(data.mat) end)

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

    -- ["scrap_glue"] 1
    -- ["scrap_metal"] 2
    -- ["scrap_screws"] 3
    -- self.PutObject = false
    -- self.ObjectionList = "scrap_glue"

function ENT:StartTouch(ent)
    local List = self.ObjectionList
    if (List[self.Level] == ent:GetName() and not self.PutObject and not self:GetIsPuttedIn()) then
        self:SetWork(0)

        if timer.Exists(ent.timername) then
			timer.Remove(ent.timername)
		end

        ent:Remove()
        local position = self:LocalToWorld(self:OBBCenter())

        local effect = EffectData()
            effect:SetStart(position)
            effect:SetOrigin(position)
            effect:SetScale(3)
        util.Effect("GlassImpact", effect)
        self:EmitBudgetSound("physics/cardboard/cardboard_box_break" .. math.random(1,3) .. ".wav")
        self.PutObject = true
        self:SetIsPuttedIn(true)
    end
end