util.AddNetworkString("ImpulseUseScrapChute")

net.Receive("ImpulseUseScrapChute", function(len, ply)
	local caller = ply -- using this cause i cant be bothered
	local id = net.ReadUInt(4)
	local ent = caller.CurMachineryScrapChute
	if (not IsValid(ent)) or (id > 3) or (not ent) or (caller:GetPos():DistToSqr(ent:GetPos()) > (230 ^ 2)) then return end

	if not (caller:Team() == TEAM_CWU and caller:GetTeamClass() == CLASS_INDUST) then
		return caller:Notify("You have to be a Industrial CWU Worker to use this!")
	end

	if (not impulse.WorkshiftEnabled) then
		return caller:Notify("A workshift must be active to use this!")
	end

  	if ent.Delay < CurTime() and caller:Team() == TEAM_CWU and caller:GetTeamClass() == CLASS_INDUST then
	ent.Delay = CurTime() + 6

	ent:EmitBudgetSound("buttons/button6.wav")
	ent:EmitSound("ambient/machines/thumper_amb.wav", 100, 80)

		timer.Simple(4, function()
			ent:EmitBudgetSound("buttons/lever6.wav")
			ent:StopSound("ambient/machines/thumper_amb.wav")
			ent:CreateScrap(id)
		end)
	end
end)

AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
include('shared.lua')

function ENT:Initialize()
	self:SetModel("models/props_pipes/pipe03_90degree01.mdl")

	self:SetUseType(SIMPLE_USE)
    self:SetMoveType(MOVETYPE_NONE)
    self:SetSolid(SOLID_BBOX)
    self:PhysicsInit(SOLID_BBOX)
    self:DrawShadow(true)
	self:SetColor(Color(58, 58, 58, 255))
	self:SetRenderMode(RENDERMODE_TRANSCOLOR)
    local physObj = self:GetPhysicsObject()
    self.Delay = CurTime()

    if (IsValid(physObj)) then
		physObj:Wake()
		physObj:EnableMotion(false)
    end


end

function ENT:CreateScrap(type)
	local l = {
		[1] = {model = "models/mosi/fallout4/props/junk/components/steel.mdl", id = "scrap_metal"}, -- Metal Plates
		[2] = {model = "models/mosi/fallout4/props/junk/components/screws.mdl", id = "scrap_screws"}, -- Screws
		[3] = {model = "models/mosi/fallout4/props/junk/wonderglue.mdl", id = "scrap_glue"}, -- Glue
	}

	local ang = self:GetAngles()
	local pos = self:GetPos()
	local f, u = ang:Forward(), ang:Up()

	local w = ents.Create("prop_physics")
	w:SetModel(l[type].model)
	w:SetName(l[type].id)
	w:SetPos(pos + f * 18)
    w:Spawn()
	w.timername = "ImpulseScrapItem." .. w:EntIndex() .. "." .. l[type].id
	print(w.timername)
	timer.Create(w.timername, 60, 1, function()
		if IsValid(w) then
			w:Remove()
		end
	end)

end

function ENT:Use(activator, caller)
	caller.CurMachineryScrapChute = self
end