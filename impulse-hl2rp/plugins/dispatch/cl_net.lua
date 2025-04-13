impulse.DefineSetting("misc_cameranotifyduration", {name="Camera notify duration", category="Misc", type="slider", default=45, minValue=20, maxValue=140})
impulse.DefineSetting("misc_cameranotifymax", {name="Camera notify max", category="Misc", type="slider", default=3, minValue=1, maxValue=6})

net.Receive("impulseHL2RPCivilUnrestStart", function()
	surface.PlaySound("npc/overwatch/cityvoice/f_unrestprocedure1_spkr.wav")
end)

CAM_NOTIFICAITONS = CAM_NOTIFICAITONS or 0
net.Receive("impulseHL2RPCameraAlert", function()
	local pos = net.ReadVector()
	local camid = net.ReadUInt(8)
	local crime = net.ReadUInt(8)
	local ply = net.ReadEntity()
	local duration = impulse.GetSetting("misc_cameranotifyduration")
	local max = impulse.GetSetting("misc_cameranotifymax")
	local col = nil

	if crime == CRIME_BOL then
		col = 3
		surface.PlaySound("npc/overwatch/radiovoice/allteamsrespondcode3.wav")
	elseif crime == CRIME_WEAPON then
		col = 4
	elseif CAM_NOTIFICAITONS >= max then
		return
	end

	local citizen = ply

	if crime == CRIME_EVASION then
		citizen = nil
	end

	-- if not camid or not CRIME_NICENAMES[crime] then return end
	impulse.AddCombineWaypoint("CAM-"..camid.." ("..CRIME_NICENAMES[crime]..")", pos, duration, 7, col, 900, nil, nil, citizen)

	CAM_NOTIFICAITONS = CAM_NOTIFICAITONS + 1

	timer.Simple(duration, function()
		CAM_NOTIFICAITONS = CAM_NOTIFICAITONS - 1
	end)
end)

net.Receive("impulseHL2RPCameraBroken", function()
	local camera = net.ReadEntity()
	local camid = net.ReadUInt(8)

	if not IsValid(camera) then
		return
	end

	if camera:IsCameraEnabled() then
		return
	end

	surface.PlaySound("npc/overwatch/radiovoice/investigateandreport.wav")
	LocalPlayer():SendCombineMessage("CAM-"..camid.." REQUIRES IMMEDIATE SERVICE", Color(150, 154, 158))
	impulse.AddCombineWaypoint("CAM-"..camid.." REQUIRES SERVICE", camera:GetPos(), 100, 7, 5, 900)
end)

net.Receive("impulseHL2RPAmmoRaid", function()
	local box = net.ReadVector()

	surface.PlaySound("npc/overwatch/radiovoice/attention.wav")
	timer.Simple(1.8, function()
		surface.PlaySound("npc/overwatch/radiovoice/restrictedincursioninprogress.wav")
	end)

	LocalPlayer():SendCombineMessage("HIGH PRIORITY TRANMISSION INBOUND...", Color(139, 0, 0))
	timer.Simple(1, function()
		LocalPlayer():SendCombineMessage("RESTRICTED INCURSION DETECTED - ALL TEAMS RESPOND CODE 3", Color(139, 0, 0))
		impulse.AddCombineWaypoint("ILLEGAL INCURSION (RESPOND CODE 3)", box, impulse.Config.AmmoDrillTime, 6, 4, 4)
	end)
end)

local squadWaypointCol = Color(75, 155, 45, 100)
net.Receive("impulseSquadDoReinforce", function()
	local squad = net.ReadUInt(8)
	local pos = net.ReadVector()

	surface.PlaySound("npc/overwatch/radiovoice/reinforcementteamscode3.wav")

	local n = LocalPlayer():Team() == TEAM_CP and "PT" or "SQUAD"
	LocalPlayer():SendCombineMessage(n.." "..squad.." REQUESTING REINFORCEMENT", squadWaypointCol)
	impulse.AddCombineWaypoint(n.." "..squad.." REINFORCEMENT", pos, 60, 5, 2, 2)
end)

net.Receive("impulseSquadDoOrder", function()
	local text = net.ReadString()

	LocalPlayer():SendCombineMessage("NEW SQUAD OBJECTIVE:", squadWaypointCol)
	LocalPlayer():SendCombineMessage(text, squadWaypointCol)
end)

net.Receive("impulseSquadDoBlockInspection", function()
	local blockName = net.ReadString()
	local pos = net.ReadVector()

	surface.PlaySound("npc/overwatch/radiovoice/attention.wav")

	timer.Simple(0.7, function()
		surface.PlaySound("npc/overwatch/radiovoice/search.wav")

		timer.Simple(0.7, function()
			surface.PlaySound("npc/overwatch/radiovoice/residentialblock.wav")
		end)
	end)

	LocalPlayer():SendCombineMessage("SEARCH RESIDENTIAL BLOCK - "..string.upper(blockName), squadWaypointCol)
	impulse.AddCombineWaypoint("SEARCH BLOCK ("..string.upper(blockName)..")", pos, 120, 4, 2, 2)
end)

net.Receive("impulseHL2RPMedicCallRec", function()
	local caller = net.ReadEntity()

	if not IsValid(caller) then
		return
	end

	impulse.AddCombineMessage("MEDICAL ATTENTION REQUESTED FROM "..caller:Nick(), Color(168, 50, 76))
	impulse.AddCombineWaypoint("MEDICAL ATTENTION REQUESTED", caller:GetPos(), 65, 3, 5, 5, caller)
end)

net.Receive("impulseHL2RPObjectiveSend", function()
	local sender = net.ReadEntity()
	local order = net.ReadString():upper()
	
	if not IsValid(sender) then
		return
	end

	surface.PlaySound("npc/metropolice/vo/off1.wav")
	timer.Simple(0.8, function()
		surface.PlaySound("npc/overwatch/radiovoice/attention.wav")
	end)

	impulse.AddCombineMessage("INCOMING OBJECTIVE FROM "..sender:Nick(), Color(0, 107, 149))
	impulse.AddCombineMessage(order, Color(0, 107, 149))

	CP_OBJECTIVE = {
		message = order,
		endTime = CurTime() + 20,
		sender = sender:Nick()
	}
end)

net.Receive("impulseHL2RPObjectiveSendEvent", function()
	local order = net.ReadString():upper()
	local length = net.ReadUInt(8)
	
	surface.PlaySound("npc/metropolice/vo/off1.wav")
	timer.Simple(0.8, function()
		surface.PlaySound("npc/overwatch/radiovoice/attention.wav")
	end)

	impulse.AddCombineMessage("INCOMING OBJECTIVE FROM DISPATCH", Color(0, 107, 149))
	impulse.AddCombineMessage(order, Color(0, 107, 149))

	CP_OBJECTIVE = {
		message = order,
		endTime = CurTime() + length
	}
end)

net.Receive("impulseHL2RPCityCodeChange", function()
	local citycode = net.ReadUInt(4)

	if citycode < CODE_JW then
		return
	end

	CP_OBJECTIVE = nil

	timer.Simple(1.5, function()
		CP_OBJECTIVE = {
			citycode = citycode,
			endTime = CurTime() + 30
		}
	end)
end)