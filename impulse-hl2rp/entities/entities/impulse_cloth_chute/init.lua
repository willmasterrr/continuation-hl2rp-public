AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
include('shared.lua')

function ENT:Initialize()
	self:SetModel("models/props_pipes/pipe03_90degree01.mdl")

	self:SetUseType(SIMPLE_USE)
    self:SetMoveType(MOVETYPE_NONE)
    self:SetSolid(SOLID_BBOX)
    self:PhysicsInit(SOLID_BBOX)
    self:DrawShadow(false)
    local physObj = self:GetPhysicsObject()
    self.Delay = CurTime()

    if (IsValid(physObj)) then
		physObj:Wake()
		physObj:EnableMotion(false)
    end
end

function ENT:Use(activator, caller)
	if not (caller:Team() == TEAM_CWU and caller:GetTeamClass() == CLASS_INDUST) then
		return caller:Notify("You have to be a Industrial CWU Worker to use this!")
	end
  	if self.Delay < CurTime() and caller:Team() == TEAM_CWU and caller:GetTeamClass() == CLASS_INDUST then
    self.Delay = CurTime() + 2

    local global_laundry_count = #ents.FindByClass("impulse_cloth")
		if global_laundry_count > 5 then
			activator:Notify("Please wash more laundry before requesting more dirty laundry.")
			return
		end

		self:EmitSound("buttons/lever5.wav")

    timer.Simple(0.8, function()
			local laundry = ents.Create("impulse_cloth")
			laundry:SetPos(self:GetPos() + Vector(0, 0, -17))
			laundry:SetStage(0)
			laundry:SetupType(0)
			laundry:Spawn()
			laundry.workers = {}
			laundry.workers[caller] = true
		end)
  end
end