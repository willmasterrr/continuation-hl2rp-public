include('shared.lua')

net.Receive("ImpulseApartmentScreen", function()
	local terminal_title = net.ReadString()
	local terminal_id = net.ReadUInt(8)
	local terminal_type = net.ReadString()
	local terminal_ent = net.ReadEntity()

	local ImpulseApartmentSc = vgui.Create("ImpulseBlockTerminalScreen")
	ImpulseApartmentSc:SetTerminal(terminal_id, terminal_title, terminal_ent)

	if terminal_type == "buying" then
		ImpulseApartmentSc:BuyScreen()
	elseif terminal_type == "configuring" then
		ImpulseApartmentSc:SellScreen()
	elseif terminal_type == "officer" then
		ImpulseApartmentSc:OfficerScreen()
	else
		return
	end
end)

local PANEL = {}

function PANEL:OfficerScreen()
	local panel = self

    self:SetSize(500, 300)
    self:Center()
	self:SetSkin("combine")

	self.doThink = true
	self.startTime = CurTime()

	self.load = self:Add("DProgress")
	self.load:SetFraction(0)
    self.load:Dock(TOP)
	self.load:SetHeight(28)

	function self.load:Paint(w, h)
		surface.SetDrawColor(255, 255, 255)
		surface.DrawRect(0, 0, w, h)
		surface.SetDrawColor(22, 123, 206)
		surface.DrawRect(0, 0, self:GetFraction() * w, h)
	end

	self.lbll = self.load:Add("DLabel")
    self.lbll:SetText("RETRIEVING INHABITANTS")
    self.lbll:SetContentAlignment(5)
    self.lbll:Dock(FILL)
    self.lbll:SetTextColor(Color(0, 0, 0))
	self.lbll:SetDrawOnTop(true)

	self.scroll = vgui.Create("DScrollPanel", self)
	self.scroll:Dock(FILL)
	self.scroll:DockMargin(0, 10, 0, 0)

	LocalPlayer():SendCombineMessage("Hooking into apartment mainframe...")

	timer.Simple(3, function()
		if not IsValid(self) then return end
		self.doThink = false
		self.load:Remove()
		for k, v in pairs(ents.GetAll()) do
			local value = v:GetSyncVar(SYNC_DOOR_APARTMENT_OWNED) or false
			local ply_data = false
			if value then
				ply_data = util.JSONToTable(value)
			end

			if v:IsPlayer() and ply_data then
				local data2 = ply_data["apt_data"]
				data2 = util.JSONToTable(data2)

				if data2.terminal_id != self.TerminalID then continue end

				local banner = vgui.Create("DPanel", self.scroll)
				banner:Dock(TOP)
				banner:SetHeight(62)
				banner:SetSkin("combine")

				local name = vgui.Create("DLabel", banner)
				name:SetPos(65, 4)
				name:SetText("NAME: " .. v:Nick())
				name:SetFont("BudgetLabel")
				name:SizeToContents()

				local apt = vgui.Create("DLabel", banner)
				apt:SetPos(65, 40)
				apt:SetText("APT: " .. Entity(ply_data["apt_ent"]):GetSyncVar(SYNC_DOOR_APARTMENT_NUM, "000"))
				apt:SetFont("BudgetLabel")
				apt:SizeToContents()

				model = vgui.Create("impulseSpawnIcon", banner)
				model:SetPos(10,4)
				model:SetSize(52,52)
				model:SetModel(v:GetModel(), v:GetSkin())
				model:SetTooltip(false)
				model:SetDisabled(true)

				timer.Simple(0, function()
					if not IsValid(self) then
						return
					end

					local ent = model.Entity

					if IsValid(ent) and IsValid(v) then
						for w,d in pairs(v:GetBodyGroups()) do
							ent:SetBodygroup(d.id, v:GetBodygroup(d.id))
						end
					end
				end)

				local staticOverlay = Material("effects/tvscreen_noise002a")
				staticOverlay:SetFloat("$salpha", "0.2")
				staticOverlay:Recompute()

				local greyCol = Color(100, 100, 100, 50)
				local outlineCol = Color(0, 0, 0, 180)

				function model:PaintOver(w, h) -- remove that mouse hover effect
					surface.SetDrawColor(greyCol)
					surface.DrawRect(0, 0, w, h)

					surface.SetDrawColor(outlineCol)
					surface.DrawOutlinedRect(0, 0, w, h)
				end

				local oldPaint = model.Paint 
				local background =  Material("impulse/hl2rp/background-photo.png")
				function model:Paint(w, h)
					surface.SetDrawColor(color_white)
					surface.SetMaterial(background)
					surface.DrawTexturedRect(0, 0, w, h)

					oldPaint(self, w, h)

					surface.SetMaterial(staticOverlay)
					surface.DrawTexturedRect(0, 0, w, h)
				end
			end
		end
	end)
end

function PANEL:SellScreen()
	local panel = self
    self:SetSize(200, 170)

    self.txt = vgui.Create("DLabel", self)
	self.txt:SetPos(27, 50)
	self.txt:SetContentAlignment(5)
    self.txt:SetText("- INHABITANT MANAGEMENT -")
    self.txt:SizeToContents()

	self.add = vgui.Create("DButton", self)
	self.add:SetText("Add")
	self.add:SetSize(65, 24)
	self.add:SetPos(25, 70)
	self.add.DoClick = function()
		local popup = DermaMenu(self)

		for k, v in pairs(player.GetAll()) do
			-- print(v:HasApartment())
			if (v == LocalPlayer()) or v:HasApartment() then continue end
			local p = popup:AddOption(v:KnownName(), function()
				net.Start("impulseDoorAddApts")
				net.WriteEntity(v)
				net.SendToServer()
			end)

			p:SetIcon("icon16/user_add.png")

		end

		popup:Open()
	end

	self.remove = vgui.Create("DButton", self)
	self.remove:SetText("Remove")
	self.remove:SetSize(65, 24)
	self.remove:SetPos(108, 70)
	self.remove.DoClick = function()
		local popup = DermaMenu(self)

		for k, v in pairs(player.GetAll()) do
			local t = v:HasApartment()
			if (!t) then return end
			t = util.JSONToTable(t)
			local ent = Entity(t["apt_ent"])
			-- PrintTable(ent:GetSyncVar(SYNC_DOOR_OWNERS))
			if (v == LocalPlayer()) or (!table.HasValue(ent:GetSyncVar(SYNC_DOOR_OWNERS), v:EntIndex())) then continue end
			local p = popup:AddOption(v:KnownName(), function()
				net.Start("impulseDoorRemoveApts")
				net.WriteEntity(v)
				net.SendToServer()
			end)

			p:SetIcon("icon16/user_delete.png")
			popup:Open()

		end

	end

	self.sell = vgui.Create("DButton", self)
	self.sell:SetText("Sell Apartment")
	self.sell:SetSize(150, 24)
	self.sell:SetPos(25, 115)

	self.sell.DoClick = function()
		net.Start("impulseDoorSellApts")
		net.SendToServer()
		panel:Remove()
	end
end

function PANEL:BuyScreen()
	local panel = self
	self.select = vgui.Create("DComboBox", self)
	self.select:SetText("Purchase Apartment")
	self.select:SetSize(152, 24)
	self.select:SetPos(26, 48)
    self.select:SetColor(Color(255, 255, 255))
	local ent = self.Ent

	for k, v in pairs(ents.GetAll()) do
		local tbl = v:GetSyncVar(SYNC_DOOR_APARTMENT, false)
		if (v:IsDoor() and tbl) then
			local tbl2 = util.JSONToTable(tbl)
			if tbl2.terminal_id != ent:GetTerminalID() or v:GetSyncVar(SYNC_DOOR_OWNERS) then continue end
			self.select:AddChoice(v:GetSyncVar(SYNC_DOOR_APARTMENT_NUM, "FailedToGet"), v:EntIndex())

		end
	end

	self.purchase = vgui.Create("DButton", self)
	self.purchase:SetText("Purchase Apartment")
	self.purchase:SetSize(152, 24)
	self.purchase:SetPos(26, 100)
	self.purchase:SetDisabled(true)
	
	self.purchase.DoClick = function()
		if (!self.ApartmentBuying) then return end
		net.Start("impulseDoorBuyApts")
		net.WriteEntity(Entity(self.ApartmentBuying))
		net.SendToServer()
		panel:Remove()
	end

	self.select.OnSelect = function(a, b, value)
		local text, index = self.select:GetSelected()
		self.ApartmentBuying = index
        self.purchase:SetDisabled(false)
    end
end

function PANEL:Init()
	local w, h = ScrW(), ScrH()

	self:MakePopup()
	self:SetTitle("Block Terminal")
    self:SetSize(200, 150)
	self:Center()
	self:SetSkin("combine")
end

function PANEL:Think()
	if self.doThink then
		self.load:SetFraction(math.Clamp((CurTime() - self.startTime) / ((self.startTime + 3) - self.startTime), 0, 1) )
	end
end

function PANEL:SetTerminal(id, window_title, terminal_ent)
	self.ApartmentBuying = nil
	self.TerminalID = id
	self.windowtitle = window_title
	self.Ent = terminal_ent
	self:SetTitle(self.windowtitle or "Lorem Ipsum, Whateve Whateve, Willmaster fucked this up!")

	local panel = self
end

vgui.Register("ImpulseBlockTerminalScreen", PANEL, "DFrame")