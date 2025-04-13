AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
include('shared.lua')

function ENT:Initialize()
    self:SetModel("models/props_lab/citizenradio.mdl")

	self:SetUseType(SIMPLE_USE)
    self:SetMoveType(MOVETYPE_NONE)
    self:SetSolid(SOLID_BBOX)
    self:PhysicsInit(SOLID_BBOX)
    self:DrawShadow(false)
    local physObj = self:GetPhysicsObject()


    if (IsValid(physObj)) then
        physObj:EnableMotion(false)
        physObj:Sleep()
    end
end

function ENT:Use(activator, caller)
    local but = self:GetNearestButton(caller)
    local old = math.Round(self:GetFrequency(), 1)

    if but == 1 then
        self:EmitBudgetSound("buttons/button9.wav", 600, 50, 90)
		self:SetFrequency(math.Clamp(math.Round((old - 1.1), 1), 80.2, 120.9))
    elseif but == 2 then
		self:EmitBudgetSound("buttons/button9.wav", 600, 50, 110)
		self:SetFrequency(math.Clamp(math.Round((old + 1.1), 1), 80.2, 120.9))
    end
end

function ENT:Transmit(ply, msg)
    local freq = math.Round(self:GetFrequency(), 1)

    if impulse.IEDS then
        for k, v in pairs(impulse.IEDS) do
            if not IsValid(v) then impulse.IEDS[v] = nil return end
    
            if v.Freq == freq then
                v:Kaboom()
            end
        end
    end

	for v,k in pairs(ents.FindByClass('impulse_radio')) do
		if k == self then
			continue
		end

        if math.Round(k:GetFrequency(), 1) == freq then
			k:Receive(msg, self, ply)
        end
	end
    self:EmitBudgetSound("ambient/levels/prison/radio_random11.wav")
	ply:SendChatClassMessage(8, msg, ply)
end

function ENT:Receive(msg, ent, ply)
    self:EmitBudgetSound("ambient/levels/prison/radio_random11.wav")

    local badRadioStrings = { "?", "%", "[]", "*", "#", "_" }
    
    for k, v in pairs(string.ToTable(msg)) do
        if v == " " then continue end
        if math.random(1, 15) > math.random(10, 15) then
            msg = string.SetChar(msg, k, table.Random( badRadioStrings ))
        end
    end

    for v,k in pairs(player.GetAll()) do
		if k:GetPos():DistToSqr(self:GetPos()) < (impulse.Config.TalkDistance ^ 2) then
			k:SendChatClassMessage(8, msg, ply)
		end
	end
end