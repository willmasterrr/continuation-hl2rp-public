function PLUGIN:PlayerChangedTeam(ply, old, new)
	if ply:GetSyncVar(SYNC_SQUAD_ID) then
		ply:SetSyncVar(SYNC_SQUAD_ID, nil, true)
	end

	if ply:GetSyncVar(SYNC_SQUAD_LEADER) then
		ply:SetSyncVar(SYNC_SQUAD_LEADER, nil, true)
	end
end

function PLUGIN:PlayerChangeClass(ply)
	if ply:GetSyncVar(SYNC_SQUAD_ID) then
		ply:SetSyncVar(SYNC_SQUAD_ID, nil, true)
	end

	if ply:GetSyncVar(SYNC_SQUAD_LEADER) then
		ply:SetSyncVar(SYNC_SQUAD_LEADER, nil, true)
	end
end

function PLUGIN:PlayerChangeRank(ply)
	if ply:GetSyncVar(SYNC_SQUAD_ID) then
		ply:SetSyncVar(SYNC_SQUAD_ID, nil, true)
	end

	if ply:GetSyncVar(SYNC_SQUAD_LEADER) then
		ply:SetSyncVar(SYNC_SQUAD_LEADER, nil, true)
	end
end


if timer.Exists("impulseSquadThink") then
	timer.Remove("impulseSquadThink")
end

local squadExpireIndex = squadIndex or {}
timer.Create("impulseSquadThink", 10, 0, function()
	local temp = {}
	local temp2 = {}

	for v,k in pairs(team.GetPlayers(TEAM_CP)) do
		local squad = k:GetSyncVar(SYNC_SQUAD_ID)

		if squad then
			temp[squad] = true

			if k:GetSyncVar(SYNC_SQUAD_LEADER) then
				temp2[squad] = true
			end
		end
	end

	for v,k in pairs(temp) do
		if not temp2[v] then
			if not timer.Exists("impulseSquadExpireCP"..v) then
				timer.Create("impulseSquadExpireCP"..v, impulse.Config.SquadExpiryTime, 1, function() -- eww this is rushed and hacky
					local leaderFound = false
					for a,b in pairs(team.GetPlayers(TEAM_CP)) do
						if b:GetSyncVar(SYNC_SQUAD_ID, -1) == v and b:GetSyncVar(SYNC_SQUAD_LEADER) then
							leaderFound = true
						end
					end

					if not leaderFound then
						for a,b in pairs(team.GetPlayers(TEAM_CP)) do
							if b:GetSyncVar(SYNC_SQUAD_ID, -1) == v then
								b:SetSyncVar(SYNC_SQUAD_ID, nil, true)
								b:SetSyncVar(SYNC_SQUAD_LEADER, nil, true)

								b:Notify("Your squad has been disbanded as the leader was not replaced in time.")
							end
						end
					end
				end)
			end
		end
	end
end)

util.AddNetworkString("impulseSquadMake")
util.AddNetworkString("impulseSquadJoin")
util.AddNetworkString("impulseSquadLeave")
util.AddNetworkString("impulseSquadKick")
util.AddNetworkString("impulseSquadClaim")
util.AddNetworkString("impulseSquadAction")

util.AddNetworkString("impulseSquadDoReinforce")
util.AddNetworkString("impulseSquadDoBlockInspection")
util.AddNetworkString("impulseSquadDoMove")
util.AddNetworkString("impulseSquadDoOrder")

net.Receive("impulseSquadMake", function(len, ply)
	if (ply.nextSquadDo or 0) > CurTime() then return end
	ply.nextSquadDo = CurTime() + 1

	if not ply:Alive() then
		return
	end

	if not ply:SquadCanMake() then
		return
	end

	local lowestFree = 1
	local squads = {}
	local biggestSquad = 0

	for v,k in pairs(team.GetPlayers(ply:Team())) do
		local squad = k:GetSyncVar(SYNC_SQUAD_ID)

		if not squad then
			continue
		end

		squads[squad] = true

		if squad > biggestSquad then
			biggestSquad = squad
		end
	end

	for i=1, biggestSquad + 1 do
		if not squads[i] then
			lowestFree = i
			break
		end
	end
	
	ply:SetSyncVar(SYNC_SQUAD_LEADER, true, true)
	ply:SetSyncVar(SYNC_SQUAD_ID, lowestFree, true)

	local n = ply:Team() == TEAM_CP and "PT" or "squad"
	ply:Notify("You have created a new "..n..".")
end)

net.Receive("impulseSquadLeave", function(len, ply)
	if (ply.nextSquadDo or 0) > CurTime() then return end
	ply.nextSquadDo = CurTime() + 1

	if not ply:Alive() then
		return
	end

	if not ply:GetSquad() then
		return
	end

	if ply:GetSyncVar(SYNC_SQUAD_LEADER) then
		ply:SetSyncVar(SYNC_SQUAD_LEADER, nil, true)
	end

	ply:SetSyncVar(SYNC_SQUAD_ID, nil, true)

	local n = ply:Team() == TEAM_CP and "PT" or "squad"
	ply:Notify("You have left your "..n..".")
end)

net.Receive("impulseSquadJoin", function(len, ply)
	if (ply.nextSquadDo or 0) > CurTime() then return end
	ply.nextSquadDo = CurTime() + 1

	if not ply:Alive() then
		return
	end

	local squadId = net.ReadUInt(8)
	if not ply:SquadCanJoin(squadId) then
		return
	end
	
	ply:SetSyncVar(SYNC_SQUAD_ID, squadId, true)
end)

net.Receive("impulseSquadClaim", function(len, ply)
	if (ply.nextSquadDo or 0) > CurTime() then return end
	ply.nextSquadDo = CurTime() + 1

	if not ply:Alive() then
		return
	end

	if not ply:SquadCanClaim() then
		return
	end
	
	ply:SetSyncVar(SYNC_SQUAD_LEADER, true, true)
end)


net.Receive("impulseSquadKick", function(len, ply)
	if (ply.nextSquadDo or 0) > CurTime() then return end
	ply.nextSquadDo = CurTime() + 1

	if not ply:Alive() then
		return
	end

	local meHaveSquad, mySquad = ply:GetSquad()

	if not meHaveSquad then
		return
	end

	if not ply:GetSyncVar(SYNC_SQUAD_LEADER) then
		return
	end

	local targ = net.ReadEntity()

	if not targ:IsPlayer() then
		return
	end
	
	local themHaveSquad, theirSquad = targ:GetSquad()

	if not themHaveSquad then
		return
	end
	
	if mySquad != theirSquad then
		return
	end
	
	targ:SetSyncVar(SYNC_SQUAD_ID, nil, true)

	local n = ply:Team() == TEAM_CP and "PT" or "squad"
	targ:Notify("You have been kicked from your "..n.." by "..ply:Nick()..".")
	ply:Notify("You have kicked "..targ:Nick().." from your "..n..".")
end)

local cooldowns = {}
local actionDos = {
	["reinforce"] = function(ply, squad, targ, isOrder)
		if isOrder then
			return
		end

		local tag = ply:SteamID().."reinforce"..targ
		if (cooldowns[tag] or 0) > CurTime() then 
			return ply:Notify("Please wait a while before doing this again...")
		else
			cooldowns[tag] = nil
		end

		cooldowns[tag] = CurTime() + 70

		if targ == squad then
			return
		end

		for v,k in pairs(team.GetPlayers(ply:Team())) do
			if k:GetSyncVar(SYNC_SQUAD_ID, -1) == targ then
				net.Start("impulseSquadDoReinforce")
				net.WriteUInt(squad, 8)
				net.WriteVector(ply:GetPos())
				net.Send(k)
			end
		end

		ply:Notify("Reinforcement requested.")
	end,
	["custom"] = function(ply, squad, targ, isOrder)
		if not isOrder then
			return
		end

		local tag = ply:SteamID().."order"..targ
		if (cooldowns[tag] or 0) > CurTime() then 
			return ply:Notify("Please wait a while before doing this again...")
		else
			cooldowns[tag] = nil
		end

		cooldowns[tag] = CurTime() + 6

		local text = string.sub(net.ReadString(), 1, 85)

		for v,k in pairs(team.GetPlayers(ply:Team())) do
			if k:GetSyncVar(SYNC_SQUAD_ID, -1) == targ then
				net.Start("impulseSquadDoOrder")
				net.WriteString(text)
				net.Send(k)
			end
		end

		ply:Notify("Order sent.")
	end,
	["block"] = function(ply, squad, targ, isOrder)
		if not isOrder then
			return
		end

		local tag = ply:SteamID().."order"..targ
		if (cooldowns[tag] or 0) > CurTime() then 
			return ply:Notify("Please wait a while before doing this again...")
		else
			cooldowns[tag] = nil
		end

		cooldowns[tag] = CurTime() + 90

		local blockID = net.ReadUInt(8)
		local block = impulse.Config.ApartmentBlocks[blockID]

		if not block then
			return
		end

		local firstDoor = block.apartments[1].doors[1]

		if not firstDoor then
			return
		end
		
		local door = Entity(game.MaxPlayers() + firstDoor)

		if not IsValid(door) then
			return
		end

		for v,k in pairs(team.GetPlayers(ply:Team())) do
			if k:GetSyncVar(SYNC_SQUAD_ID, -1) == targ then
				net.Start("impulseSquadDoBlockInspection")
				net.WriteString(block.name)
				net.WriteVector(door:GetPos())
				net.Send(k)
			end
		end

		ply:Notify("Block inspection sent.")
	end,
	["disband"] = function(ply, squad, targ, isOrder)
		if not isOrder then
			return
		end

		local tag = ply:SteamID().."order"..targ
		if (cooldowns[tag] or 0) > CurTime() then 
			return ply:Notify("Please wait a while before doing this again...")
		else
			cooldowns[tag] = nil
		end

		cooldowns[tag] = CurTime() + 5

		local n = ply:Team() == TEAM_CP and "PT" or "squad"

		for v,k in pairs(team.GetPlayers(ply:Team())) do
			if k:GetSyncVar(SYNC_SQUAD_ID, -1) == targ then
				k:SetSyncVar(SYNC_SQUAD_ID, nil, true)

				if k:GetSyncVar(SYNC_SQUAD_LEADER) then
					k:SetSyncVar(SYNC_SQUAD_LEADER, false, true)
				end

				k:Notify("A commander has disbanded your "..n..".")
			end
		end

		ply:Notify(n.." disbanded.")
	end
}
net.Receive("impulseSquadAction", function(len, ply)
	if (ply.nextSquadDo or 0) > CurTime() then return end
	ply.nextSquadDo = CurTime() + 1

	if not ply:Alive() then
		return
	end

	local isOrder = net.ReadBool()
	local meHaveSquad, mySquad

	if isOrder then
		if ply:Team() != TEAM_CP then
			return
		end
		
		local rank = ply:GetTeamRank()

		if rank < RANK_SQL then
			return
		end
	else
		meHaveSquad, mySquad = ply:GetSquad()

		if not meHaveSquad then
			return
		end

		if not ply:GetSyncVar(SYNC_SQUAD_LEADER) then
			return
		end
	end

	local action = net.ReadString()

	if string.len(action) > 255 then
		return
	end
		
	if not actionDos[action] then
		return
	end

	local targ = net.ReadUInt(8)

	actionDos[action](ply, mySquad, targ, isOrder)
end)