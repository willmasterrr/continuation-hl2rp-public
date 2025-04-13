AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
include('shared.lua')

function ENT:Initialize()
	self:SetModel("models/props_combine/combine_dispenser.mdl")
	self:SetSolid(SOLID_BBOX)
	self:SetUseType(SIMPLE_USE)
	self:SetPlaybackRate(1)
    self.Delay = CurTime()
    self:SetLight(3)

    local mins, maxs = self:GetModelBounds()

    local x0, y0, z0 = mins.x + 21, mins.y + 20, mins.z + 8
    local x1, y1, z1 = maxs.x, maxs.y - 24, maxs.z - 35

    self:PhysicsInitConvex( {
        Vector( x0, y0, z0 ),
        Vector( x0, y0, z1 ),
        Vector( x0, y1, z0 ),
        Vector( x0, y1, z1 ),
        Vector( x1, y0, z0 ),
        Vector( x1, y0, z1 ),
        Vector( x1, y1, z0 ),
        Vector( x1, y1, z1 )
    } )

    self:EnableCustomCollisions( true )

    self:SetMoveType( MOVETYPE_VPHYSICS )
    self:SetSolid( SOLID_VPHYSICS )

    self:SetCollisionGroup(COLLISION_GROUP_PLAYER)


    local phys = self:GetPhysicsObject()
    if(IsValid(phys)) then
        phys:SetContents(CONTENTS_SOLID)
        phys:EnableMotion(false)
    end
end

local Rations = {
	[TEAM_CITIZEN] = {model = "models/weapons/w_packati.mdl"},
	[TEAM_CWU] = {model = "models/weapons/w_packatc.mdl"},
	[TEAM_CP] = {model = "models/weapons/w_packatl.mdl"},
	[TEAM_OTA] = {model = "models/weapons/w_packatm.mdl"},
	[TEAM_CA] = {model = "models/weapons/w_packatp.mdl"},
	[TEAM_COUNCIL] = {model = "models/weapons/w_packatp.mdl"},
	[TEAM_VORT] = {model = "models/weapons/w_packatb.mdl"},
}

function ENT:Use(activator, ply)
    local CanGrab = GetGlobal2Bool("ImpulseRationAvailable")

    if self.Delay > CurTime() then return end
    self.Delay = CurTime() + 1.2

    if ply.CWUMoney then
        local SavedMoney = ply.CWUMoney
        ply.CWUMoney = nil
        self:SetLight(2)

        self:EmitBudgetSound("ambient/machines/combine_terminal_idle4.wav")
        self:ResetSequence(self:LookupSequence("dispense_package"))
        self:SetSequence(self:LookupSequence("dispense_package"))

        local f = ents.Create("prop_physics")

        f:SetModel("models/weapons/w_packatp.mdl")

        f:Spawn()
        f:SetNotSolid(true)
        f:SetParent(self)
        f:Fire("SetParentAttachment", "package_attachment")

        ReqwestLog({
            {
                description = ply:Nick() .. "(" .. ply:SteamName() .. ")(" .. ply:SteamID() .. ") Has requested for their paycheck.",
                color = 16711680, -- Red color (in decimal)
            }
        })

        timer.Simple(1.8, function()
            local ration = ents.Create("impulse_ration")
            ration:SetPos(f:GetPos())
            ration:SetAngles(f:GetAngles())
            ration:SetModel("models/weapons/w_packatp.mdl")

            ration.CWUMoney = SavedMoney

            ration:Spawn()
            self:SetLight(3)
            f:Remove()
        end)
        return
    end

    if ply.RationTaken then
        self:SetLight(1)
        timer.Simple(1, function() self:SetLight(3) end)
        return ply:Notify("You've already received your daily ration.")
    end

    if CanGrab then
        local amount = impulse.Teams.Data[ply:Team()].salary
        if (not amount) then return end

        self.Delay = CurTime() + 3
        self:SetLight(2)

        ply.RationTaken = true

        ReqwestLog({
            {
                description = ply:Nick() .. "(" .. ply:SteamName() .. ")(" .. ply:SteamID() .. ") Has requested for their ration.",
                color = 16711680, -- Red color (in decimal)
            }
        })

        self:EmitBudgetSound("ambient/machines/combine_terminal_idle4.wav")
        self:ResetSequence(self:LookupSequence("dispense_package"))
        self:SetSequence(self:LookupSequence("dispense_package"))

        ply:Notify("Dispensing ration...")

        local f = ents.Create("prop_physics")

        if Rations[ply:Team()] then
            f:SetModel(Rations[ply:Team()].model)
        else
            f:SetModel("models/weapons/w_packati.mdl")
        end

        f:Spawn()
        f:SetNotSolid(true)
        f:SetParent(self)
        f:Fire("SetParentAttachment", "package_attachment")

        timer.Simple(1.8, function()
            local ration = ents.Create("impulse_ration")
            ration:SetPos(f:GetPos())
            ration:SetAngles(f:GetAngles())

            if Rations[ply:Team()] then
                ration:SetModel(Rations[ply:Team()].model)
            else
                ration:SetModel("models/weapons/w_packati.mdl")
            end

            ration.team = ply:Team()
            ration.foodlist = Rations[ply:Team()].loot
            ration.money = amount
            
            if ply.MoneyPunishment and ply.MoneyPunishment > CurTime() then
                print("Ply has ration punishment, giving no tokens on ration..")
                ration.money = false
            end

            ration:Spawn()
            self:SetLight(3)
            f:Remove()
        end)
    else
        self:SetLight(1)
        timer.Simple(1, function() self:SetLight(3) end)
        ply:Notify("The ration terminal is offline.")
    end
end