AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
include('shared.lua')

function ENT:Initialize()
	self:SetModel("models/hunter/blocks/cube075x1x025.mdl")
	local pos = self:GetPos()
	local angles = self:GetAngles()
	local f, r, u = angles:Forward(), angles:Right(), angles:Up()
	angles:RotateAroundAxis(r, 90)
	angles:RotateAroundAxis(u, 90)

	self.d = ents.Create("prop_physics")
	self.d:SetModel("models/props_combine/combine_dispenser.mdl")
	self.d:SetParent(self)
	self.d:SetPos(pos - r * 8)
	self.d:SetAngles(angles)
	self.d:Spawn()
    self.d:DrawShadow(false)
	-- self.d:SetPlaybackRate(1)

	self:SetUseType(SIMPLE_USE)
    self:SetMoveType(MOVETYPE_NONE)
    self:SetSolid(SOLID_BBOX)
    self:PhysicsInit(SOLID_BBOX)
    self:DrawShadow(false)
	self:SetColor(Color(58, 58, 58, 0))
	self:SetRenderMode(RENDERMODE_TRANSCOLOR)
    local physObj = self:GetPhysicsObject()
    self.Delay = CurTime()

    if (IsValid(physObj)) then
		physObj:Wake()
		physObj:EnableMotion(false)
    end
end

function ENT:OnRemove()
	if IsValid(self.d) then
		self.d:Remove()
	end
end

function ENT:Use(activator, caller)
	if not (caller:Team() == TEAM_CWU and caller:GetTeamClass() == CLASS_INDUST) then
		return caller:Notify("You have to be a Industrial CWU Worker to use this!")
	end

	if (not impulse.WorkshiftEnabled) then
		return caller:Notify("A workshift must be active to use this!")
	end

  	if self.Delay < CurTime() and caller:Team() == TEAM_CWU and caller:GetTeamClass() == CLASS_INDUST then
    self.Delay = CurTime() + 10

    local global_skeleton_count = #ents.FindByClass("impulse_crafting_work")
		if global_skeleton_count > 3 then
			activator:Notify("Please finish the other skeletons before requesting more.")
			return
		end

		self:EmitBudgetSound("buttons/button16.wav")
		self:EmitSound("ambient/machines/thumper_amb.wav", 100, 140)

    timer.Simple(8, function()
			-- self.d:ResetSequence(self.d:LookupSequence("dispense_package"))
        	-- self.d:SetSequence(self.d:LookupSequence("dispense_package"))
			self:EmitBudgetSound("buttons/lever5.wav")
			self:StopSound("ambient/machines/thumper_amb.wav")

			local pos = self:GetPos()
			local angles = self:GetAngles()
			local f, r, u = angles:Forward(), angles:Right(), angles:Up()
			local sk = ents.Create("impulse_crafting_work")

			sk:SetPos(pos + r * -10 + u * 15)
			sk:Spawn()
			sk:SetID(math.random(0, 1))
			sk:Initialize_Type()

			sk.workers = {}
			sk.workers[caller] = true
		end)
  end
end