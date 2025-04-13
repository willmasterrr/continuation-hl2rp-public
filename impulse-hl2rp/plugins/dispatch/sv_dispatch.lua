util.AddNetworkString("impulseHL2RPDispatchAnnounce")
util.AddNetworkString("impulseHL2RPDispatchCityCode")
util.AddNetworkString("impulseHL2RPCivilUnrestStart")
util.AddNetworkString("impulseHL2RPMedicCall")
util.AddNetworkString("impulseHL2RPMedicCallRec")
util.AddNetworkString("impulseHL2RPObjectiveSet")
util.AddNetworkString("impulseHL2RPObjectiveSend")
util.AddNetworkString("impulseHL2RPObjectiveSendEvent")
util.AddNetworkString("impulseHL2RPCityCodeChange")

net.Receive("impulseHL2RPDispatchAnnounce", function(len, ply)
	if not ply:IsCP() then
		return
	end
	
	if (nextDispatchSay or 0) > CurTime() then
		return ply:Notify("Wait a while before broadcasting another announcement.")
	end

	if not IsValid(ply.CurTerminal) then
		return
	end

	nextDispatchSay = CurTime() + 14

	local index = net.ReadUInt(8)

	if not impulse.Config.DispatchLines[index] then
		return
	end

	if ply:Team() == TEAM_CA or ply:IsCPCommand() then
		impulse.Dispatch.Announce(index)
		ply:Notify("Dispatch announcement sent.")
		hook.Run("OnDispatchAnnounce", ply, index)
	end
end)

local nextCityCodeChange = nextCityCodeChange or 0
net.Receive("impulseHL2RPDispatchCityCode", function(len, ply)
	if not ply:IsCP() then
		return
	end

	if not IsValid(ply.CurTerminal) then
		return
	end

	if nextCityCodeChange > CurTime() then
		return ply:Notify("You must wait "..string.NiceTime(nextCityCodeChange - CurTime()).." before changing the city code as it was recently changed.")
	end

	local code = net.ReadUInt(4)

	if not impulse.Dispatch.CityCodes[code] then
		return
	end

	if ply:Team() != TEAM_CA then
		if not ply:IsCPCommand() then
			return
		end
	end

	if code == 4 and not ply:IsSuperAdmin() then
		return
	end

	if code == impulse.Dispatch.GetCityCode() then
		return
	end

	local codeData = impulse.Dispatch.CityCodes[code]

	if code == 2 then
		net.Start("impulseHL2RPCivilUnrestStart")
		net.Broadcast()
	end

	for v,k in pairs(player.GetAll()) do
		if k:IsCP() then
			k:SendCombineMessage("CITY CODE STATUS UPDATE: "..codeData[1], codeData[2])
		end
	end

	if code == 1 or code == 2 then
		for v,k in pairs(player.GetAll()) do
			if k:Team() == TEAM_CP then
				if k:GetTeamClass() and k:GetTeamClass() == CLASS_VICE then
					continue
				end
				
				if k:GetTeamClass() and ((k:GetTeamClass() == CLASS_UNION and k:GetTeamRank() < RANK_I1) or k:GetTeamClass() != CLASS_UNION) then
					if k:HasInventoryItem("wep_smg") then
						k:TakeInventoryItemClass("wep_smg")
					end
				end
			end
		end
	end

	if code == 1 then
		for v,k in pairs(player.GetAll()) do
			if k:Team() == TEAM_CP then
				if k:GetTeamClass() and k:GetTeamClass() == CLASS_VICE then
					continue
				end
				
				if k:GetTeamClass() and k:GetTeamClass() != CLASS_GRID then
					if k:HasInventoryItem("cos_riothelmet") then
						k:TakeInventoryItemClass("cos_riothelmet")
					end
				end
			end
		end
	end


	nextCityCodeChange = CurTime() + 90

	impulse.Dispatch.SetCityCode(code)
	impulse.Dispatch.SetupCityCode(code)

	ply:Notify("You have changed the city code to: "..codeData[1]..".")

	local rf = RecipientFilter()
	rf:AddRecipientsByTeam(TEAM_CP)
	rf:AddRecipientsByTeam(TEAM_OTA)

	net.Start("impulseHL2RPCityCodeChange")
	net.WriteUInt(code, 4)
	net.Send(rf)

	hook.Run("OnCityCodeChanged", ply, codeData[1])
end)

net.Receive("impulseHL2RPMedicCall", function(len, ply)
	if not ply:IsCP() then
		return
	end
	
	if (ply.nextCPMedicCall or 0) > CurTime() then return end
	ply.nextCPMedicCall = CurTime() + 90

	if ply:Health() > 90 then
		return
	end

	local rf = RecipientFilter()
	rf:AddPlayer(ply)

	for v,k in pairs(player.GetAll()) do
		if k:Team() != TEAM_CP then
			continue
		end

		local class = k:GetTeamClass()

		if class and class == CLASS_HELIX then
			rf:AddPlayer(k)
		end
	end

	net.Start("impulseHL2RPMedicCallRec")
	net.WriteEntity(ply)
	net.Send(rf)
end)

net.Receive("impulseHL2RPObjectiveSet", function(len, ply)
	if (ply.nextCPObjSet or 0) > CurTime() then return end
	ply.nextCPObjSet = CurTime() + 1
	if ply:Team() != TEAM_CP then
		return
	end

	if not ply:GetTeamClass() or not ply:GetTeamRank() then
		return
	end

	local rank = ply:GetTeamRank()

	if rank < RANK_DCO then
		return
	end

	if (HL2RP_NEXT_CPOBJECTIVE or 0) > CurTime() then
		return ply:Notify("Please wait a while before sending a new objective.")
	end

	local order = string.Trim(string.sub(net.ReadString(), 1, 72), " ")

	if order == "" then
		return
	end

	local rf = RecipientFilter()
	rf:AddRecipientsByTeam(TEAM_CP)
	rf:AddRecipientsByTeam(TEAM_OTA)

	net.Start("impulseHL2RPObjectiveSend")
	net.WriteEntity(ply)
	net.WriteString(order)
	net.Send(rf)

	HL2RP_NEXT_CPOBJECTIVE = CurTime() + 60

	ply:Notify("Objective sent to all units.")
end)