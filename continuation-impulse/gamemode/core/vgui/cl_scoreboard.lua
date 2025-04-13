local PANEL = {}
timer.Simple(1, function() if not impulse.GetSetting("hud_original_hud") then

	function PANEL:Init()
		self:SetSize(ScrW(), ScrH())
		self:Center()
		-- self:SetTitle("Scoreboard")
		-- self:ShowCloseButton(false)
		-- self:SetDraggable(false)
		self:MakePopup()
		 self:MoveToFront()
		local w, h = ScrW(), ScrH()
	
		local panelfuck = vgui.Create("DPanel", self)
		panelfuck:SetSize(w * .5, h * .8)
		panelfuck:Center()
	
		 self.scrollPanel = vgui.Create("DScrollPanel", panelfuck)
		self.scrollPanel:Dock(FILL)
		self.scrollPanel:DockMargin(14,14,14,14)
	
		local darkCol = Color(30,30,30,100)
	
		function panelfuck:Paint(w, h)
			draw.RoundedBox(18, 0, 0, w, h, darkCol)
		end
	
		local playerList = player.GetAll()
		table.sort(playerList, function(a,b)
			return a:Team() > b:Team()
		end)
		
		for v,k in pairs(playerList) do
			if k:IsAdmin() and k:GetSyncVar(SYNC_INCOGNITO, false) then
				continue
			end
	
			local playerCard = self.scrollPanel:Add("impulseScoreboardCard")
			playerCard:SetPlayer(k)
			playerCard:SetHeight(60)
			playerCard:Dock(TOP)
			playerCard:DockMargin(6,1,6,1)
		end
	
	end
	
	local gradient = Material("gui/gradient_up")
	local col = Color(75, 16, 87, 124)
	function PANEL:Paint(w, h)
		impulse.blur(self, 10, 20, 255)
		surface.SetDrawColor(col)
		surface.SetMaterial(gradient)
		surface.DrawTexturedRect(0, 0, w, h)
	end	

	vgui.Register("impulseScoreboard", PANEL, "DPanel")

else

	function PANEL:Init()
		self:SetSize(SizeW(900), SizeH(900))
		self:Center()
		self:SetTitle("Scoreboard")
		self:ShowCloseButton(false)
		self:SetDraggable(false)
		self:MakePopup()
		self:MoveToFront()

		self.scrollPanel = vgui.Create("DScrollPanel", self)
		self.scrollPanel:Dock(FILL)

		local playerList = player.GetAll()
		table.sort(playerList, function(a,b)
			return a:Team() > b:Team()
		end)

		for v,k in pairs(playerList) do
			if k:IsAdmin() and k:GetSyncVar(SYNC_INCOGNITO, false) then
				continue
			end

			local playerCard = self.scrollPanel:Add("impulseScoreboardCard")
			playerCard:SetPlayer(k)
			playerCard:SetHeight(60)
			playerCard:Dock(TOP)
			playerCard:DockMargin(0,0,0,0)
		end

	end
	vgui.Register("impulseScoreboard", PANEL, "DFrame")

end end)


