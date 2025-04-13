include('shared.lua')

local PANEL = {}

local rebel_list = {
	["blue_sht"] = {shirt = 5,pants = 3},
	["green_sht"] = {shirt = 6,pants = 4},
	["TheKuKluzKlan"] = {shirt = 7,pants = 5},
	["MrBeast"] = {shirt = 8,pants = 2}
}

local NotAllow = {
	[5] = true,
	[6] = true,
	[7] = true,
	[8] = true,
}

function PANEL:Init()
	self:SetSize(300, 500)
	self:SetTitle("Locker")
	self:MakePopup()
	self:Center()

	self.start = 0
	self.canthink = false

	self.Shirt = "green_sht"

	local panel = self

	self.change = vgui.Create("DButton", self)
	self.change:Dock(BOTTOM)
	self.change:DockMargin(18, 0, 18, 18)
	self.change:SetHeight(50)
	self.change:SetText("Change Clothes")
	self.change:SetDisabled(false)

	self.bar = vgui.Create("DProgress", self)
	self.bar:Dock(BOTTOM)
	self.bar:DockMargin(18, 0, 18, 0)
	self.bar:SetHeight(6)
	self.bar:SetFraction(0)

	self.mdl = vgui.Create("impulseModelPanel", self)
	self.mdl:SetPos(25, 50)
	self.mdl:SetSize(250, 300) 
	self.mdl:SetModel(LocalPlayer():GetModel(), LocalPlayer():GetSkin())
	self.mdl:MoveToBack()
	self.mdl:SetCursor("arrow")
	self.mdl:SetFOV(self.mdl:GetFOV() - 19)
 	function self.mdl:LayoutEntity(ent)
 		ent:SetAngles(Angle(0, 43, 0))
 	end

	timer.Simple(0, function()
		if not IsValid(self.mdl) then
			return
		end

		local ent = self.mdl.Entity

		if IsValid(ent) then
			for v,k in pairs(LocalPlayer():GetBodyGroups()) do
				ent:SetBodygroup(k.id, k.num) -- tf????
			end
		end
	end)

	self.type = vgui.Create("DComboBox", self)
	self.type:Dock(BOTTOM)
	self.type:DockMargin(18, 0, 18, 8)
	self.type:SetHeight(24)
	self.type:SetText("Select Outfit")

	-- print(NotAllow[LocalPlayer():GetBodygroup(1)])
	if NotAllow[LocalPlayer():GetBodygroup(1)] then
		self.type:SetDisabled(true)
	end

	self.type:AddChoice("Green", "green_sht", false)
	self.type:AddChoice("Blue", "blue_sht", false)
	self.type:AddChoice("Medical White", "TheKuKluzKlan", false)
	self.type:AddChoice("Medical Cyan", "MrBeast", false)

	function self.type:OnSelect(index, value, data)
		panel.Shirt = data
		local dat = rebel_list[data]
		if (dat) then
			local p = panel.mdl.Entity
			p:SetBodygroup(1, dat.shirt)
			p:SetBodygroup(2, dat.pants)
		end

		panel.change:SetDisabled(false)
	end

	function self.change:DoClick()
		if !IsValid(panel) then return end

		panel.change:SetDisabled(true)
		panel.type:SetDisabled(true)
		surface.PlaySound("ambient/materials/squeeker2.wav")

		panel.canthink = true
		panel.start = CurTime()

		timer.Simple(2.05, function()
			if !IsValid(panel) then return end

			net.Start("impulseBecomeRebel")
			net.WriteString(panel.Shirt)
			net.SendToServer()

			panel:Close()
			LocalPlayer():Notify("You have changed clothes.")
		end)
	end

	function self.bar:Think()
		if (panel.canthink) then
			panel.bar:SetFraction(math.Clamp((CurTime() - panel.start) / ((panel.start + 2) - panel.start), 0, 1) )
		end
	end
end

vgui.Register("ImpulseLockerScreen", PANEL, "DFrame")