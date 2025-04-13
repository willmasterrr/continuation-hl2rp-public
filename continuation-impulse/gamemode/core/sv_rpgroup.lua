--- Handles the creation and editing of player groups
-- @module Group

local DEFAULT_RANKS = pon.encode({
	["Owner"] = {
		[1] = true,
		[2] = true,
		[3] = true,
		[4] = true,
		[5] = true,
		[6] = true,
		[8] = true,
		[99] = true
	},
	["Member"] = {
		[0] = true,
		[1] = true,
		[2] = true
	}
})

function impulse.Group.DBCreate(name, ownerid, maxsize, maxstorage, ranks, callback)
	impulse.Group.IsNameUnique(name, function(unique)
		if unique then
			local query = mysql:Insert("impulse_rpgroups")
			query:Insert("ownerid", ownerid)
			query:Insert("name", name)
			query:Insert("type", 1)
			query:Insert("maxsize", maxsize)
			query:Insert("maxstorage", maxstorage)
			query:Insert("ranks", ranks and pon.encode(ranks) or DEFAULT_RANKS)
			query:Callback(function(result, status, id)
				if callback then
					callback(id)
				end
			end)

			query:Execute()
		else
			callback()
		end
	end)
end

function impulse.Group.DBRemove(groupid)
	local query = mysql:Delete("impulse_rpgroups")
	query:Where("id", groupid)
	query:Execute()

	impulse.Group.LoadPublicData()
end

function impulse.Group.DBRemoveByName(name)
	local query = mysql:Delete("impulse_rpgroups")
	query:Where("name", name)
	query:Execute()

	impulse.Group.LoadPublicData()
end

function impulse.Group.DBAddPlayer(steamid, groupid, rank, callback)
	local query = mysql:Update("impulse_players")
	query:Update("rpgroup", groupid)
	query:Update("rpgrouprank", rank or impulse.Group.GetDefaultRank(name))
	query:Where("steamid", steamid)
	query:Callback(function()
		if callback then
			callback()
		end
	end)
	query:Execute()
end

function impulse.Group.DBRemovePlayer(steamid, groupid)
	local query = mysql:Update("impulse_players")
	query:Update("rpgroup", 0)
	query:Update("rpgrouprank", "")
	query:Where("steamid", steamid)
	query:Execute()
end

function impulse.Group.DBRemovePlayerMass(groupid)
	local query = mysql:Update("impulse_players")
	query:Update("rpgroup", 0)
	query:Update("rpgrouprank", "")
	query:Where("rpgroup", groupid)
	query:Execute()
end

function impulse.Group.DBUpdatePlayerRank(steamid, rank)
	local query = mysql:Update("impulse_players")
	query:Update("rpgrouprank", rank)
	query:Where("steamid", steamid)
	query:Execute()
end

function impulse.Group.DBPlayerRankShift(groupid, rank, newrank)
	local query = mysql:Update("impulse_players")
	query:Update("rpgrouprank", newrank)
	query:Where("rpgroup", groupid)
	query:Where("rpgrouprank", rank)
	query:Execute()
end

function impulse.Group.DBUpdateRanks(groupid, ranks)
	local query = mysql:Update("impulse_rpgroups")
	query:Update("ranks", pon.encode(ranks))
	query:Where("id", groupid)
	query:Execute()
end

function impulse.Group.DBUpdateMaxMembers(groupid, max)
	local query = mysql:Update("impulse_rpgroups")
	query:Update("maxsize", max)
	query:Where("id", groupid)
	query:Execute()
end

function impulse.Group.DBUpdateData(groupid, data)
	local query = mysql:Update("impulse_rpgroups")
	query:Update("data", pon.encode(data))
	query:Where("id", groupid)
	query:Execute()
end

function impulse.Group.ComputeMembers(name, callback)
	local id = impulse.Group.Groups[name].ID

	local query = mysql:Select("impulse_players")
	query:Select("steamid")
	query:Select("rpname")
	query:Select("rpgroup")
	query:Select("rpgrouprank")
	query:Where("rpgroup", id)
	query:Callback(function(result)
		local members = {}
		local membercount = 0

		if type(result) == "table" and #result > 0 then
			for v,k in pairs(result) do
				membercount = membercount + 1
				members[k.steamid] = {Name = k.rpname, Rank = k.rpgrouprank or impulse.Group.GetDefaultRank(name)}
			end
		end

		impulse.Group.Groups[name].Members = members
		impulse.Group.Groups[name].MemberCount = membercount

		if callback then
			callback()
		end
	end)

	query:Execute()
end

function impulse.Group.ColorNetwork(name)
	local group = impulse.Group.Groups[name]

	for k, v in pairs(player.GetAll()) do
		if v:GetSyncVar(SYNC_GROUP_NAME, false) != name then continue end

		v:SetSyncVar(SYNC_GROUP_COL, util.TableToJSON(group["Data"]["Col"]), true)
	end
end

function impulse.Group.RankShift(name, from, to)
	local group = impulse.Group.Groups[name]

	impulse.Group.DBPlayerRankShift(group.ID, from, to)

	for v,k in pairs(group.Members) do
		if k.Rank == from then
			local ply = player.GetBySteamID(v)

			impulse.Group.Groups[name].Members[v].Rank = to

			if IsValid(ply) then
				ply:GroupAdd(name, to, true)
			else
				impulse.Group.NetworkMemberToOnline(name, v)
			end
		end
	end

	impulse.Group.NetworkRankToOnline(name, to)
end

function impulse.Group.GetDefaultRank(name)
	local data = impulse.Group.Groups[name]

	for v,k in pairs(data.Ranks) do
		if k[0] then
			return v
		end
	end

	return "Member"
end

function impulse.Group.SetMetaData(name, info, col)
	local grp = impulse.Group.Groups[name]
	local id = grp.ID
	local data = grp.Data or {}

	data.Info = info or grp.Data.Info
	data.Col = col or (grp.Data.Col and Color(grp.Data.Col.r, grp.Data.Col.g, grp.Data.Col.b)) or nil

	impulse.Group.Groups[name].Data = data
	impulse.Group.DBUpdateData(id, data)

	impulse.Group.ColorNetwork(name)
end

function impulse.Group.NetworkMetaData(to, name)
	local grp = impulse.Group.Groups[name]

	net.Start("impulseGroupMetadata")
	net.WriteString(grp.Data.Info or "")

	if grp.Data.Col then
		net.WriteColor(Color(grp.Data.Col.r, grp.Data.Col.g, grp.Data.Col.b))
	else
		net.WriteColor(Color(0, 0, 0))
	end

	net.Send(to)
end

function impulse.Group.NetworkMetaDataToOnline(name)
	local grp = impulse.Group.Groups[name]

	local rf = RecipientFilter()

	for v,k in pairs(player.GetAll()) do
		local x = k:GetSyncVar(SYNC_GROUP_NAME, nil)

		if x and x == name then
			rf:AddPlayer(k)
		end
	end

	net.Start("impulseGroupMetadata")
	net.WriteString(grp.Data.Info or "")
	net.WriteColor(grp.Data.Col or Color(0, 0, 0))
	net.Send(rf)
end

function impulse.Group.NetworkMember(to, name, sid)
	local member = impulse.Group.Groups[name].Members[sid]

	net.Start("impulseGroupMember")
	net.WriteString(sid)
	net.WriteString(member.Name)
	net.WriteString(member.Rank)
	net.Send(to)
end

function impulse.Group.NetworkMemberToOnline(name, sid)
	local member = impulse.Group.Groups[name].Members[sid]

	local rf = RecipientFilter()

	for v,k in pairs(player.GetAll()) do
		local x = k:GetSyncVar(SYNC_GROUP_NAME, nil)

		if x and x == name then
			rf:AddPlayer(k)
		end
	end

	net.Start("impulseGroupMember")
	net.WriteString(sid)
	net.WriteString(member.Name)
	net.WriteString(member.Rank)
	net.Send(rf)
end

function impulse.Group.NetworkMemberRemoveToOnline(name, sid)
	local rf = RecipientFilter()

	for v,k in pairs(player.GetAll()) do
		local x = k:GetSyncVar(SYNC_GROUP_NAME, nil)

		if x and x == name then
			rf:AddPlayer(k)
		end
	end

	net.Start("impulseGroupMemberRemove")
	net.WriteString(sid)
	net.Send(rf)
end

function impulse.Group.NetworkAllMembers(to, name)
	local members = impulse.Group.Groups[name].Members

	for v,k in pairs(members) do
		impulse.Group.NetworkMember(to, name, v)
	end
end

function impulse.Group.NetworkRanksToOnline(name)
	local ranks = impulse.Group.Groups[name].Ranks
	local data = pon.encode(ranks)
	local rf = RecipientFilter()

	for v,k in pairs(player.GetAll()) do
		local x = k:GetSyncVar(SYNC_GROUP_NAME, nil)

		if x and x == name then
			if k:GroupHasPermission(5) or k:GroupHasPermission(6) then
				rf:AddPlayer(k)
			end
		end
	end

	net.Start("impulseGroupRanks")
	net.WriteUInt(#data, 32)
	net.WriteData(data, #data)
	net.Send(rf)
end

function impulse.Group.NetworkRank(name, to, rankName)
	local rank = impulse.Group.Groups[name].Ranks[rankName]
	local data = pon.encode(rank)

	net.Start("impulseGroupRank")
	net.WriteString(rankName)
	net.WriteUInt(#data, 32)
	net.WriteData(data, #data)
	net.Send(to)
end

function impulse.Group.NetworkRankToOnline(name, rankName)
	local rank = impulse.Group.Groups[name].Ranks[rankName]
	local data = pon.encode(rank)
	local rf = RecipientFilter()

	for v,k in pairs(player.GetAll()) do
		local x = k:GetSyncVar(SYNC_GROUP_NAME, nil)
		local r = k:GetSyncVar(SYNC_GROUP_RANK, nil)

		if x and x == name and r == rank then
			if k:GroupHasPermission(5) or k:GroupHasPermission(6) then
				continue
			end

			rf:AddPlayer(k)
		end
	end

	net.Start("impulseGroupRank")
	net.WriteString(rankName)
	net.WriteUInt(#data, 32)
	net.WriteData(data, #data)
	net.Send(rf)
end

function impulse.Group.NetworkRanks(to, name)
	local ranks = impulse.Group.Groups[name].Ranks
	local data = pon.encode(ranks)

	net.Start("impulseGroupRanks")
	net.WriteUInt(#data, 32)
	net.WriteData(data, #data)
	net.Send(to)
end

local function postCompute(self, name, col, rank, skipDb)
	if not IsValid(self) then
		return
	end

	impulse.Group.NetworkMemberToOnline(name, self:SteamID())

	self:SetSyncVar(SYNC_GROUP_NAME, name, true)
	self:SetSyncVar(SYNC_GROUP_RANK, rank, true)
	self:SetSyncVar(SYNC_GROUP_COL, util.TableToJSON(col), true)

	if not skipDb then
		impulse.Group.NetworkAllMembers(self, name)
	end

	if self:GroupHasPermission(5) or self:GroupHasPermission(6) then
		impulse.Group.NetworkRanks(self, name)
	else
		impulse.Group.NetworkRank(name, self, rank)
	end

	impulse.Group.NetworkMetaData(self, name)
end

function meta:GroupAdd(name, rank, skipDb)
	local id = impulse.Group.Groups[name].ID
	local col = Color(255, 255, 255)
	local rank = rank or impulse.Group.GetDefaultRank(name)
	PrintTable(col)
	if not skipDb then
		impulse.Group.DBAddPlayer(self:SteamID(), id, rank)
	end

	impulse.Group.ComputeMembers(name, function()
		postCompute(self, name, col, rank, skipDb)
	end)
end

function meta:GroupRemove(name)
	local id = impulse.Group.Groups[name].ID
	local sid = self:SteamID()

	impulse.Group.DBRemovePlayer(sid)
	impulse.Group.ComputeMembers(name)
	impulse.Group.NetworkMemberRemoveToOnline(name, sid)

	self:SetSyncVar(SYNC_GROUP_NAME, nil, true)
	self:SetSyncVar(SYNC_GROUP_RANK, nil, true)
	self:SetSyncVar(SYNC_GROUP_COL, nil, true)
end

function impulse.Group.IsNameUnique(name, callback)
	local query = mysql:Select("impulse_rpgroups")
	query:Select("name")
	query:Where("name", name)
	query:Callback(function(result)
		if type(result) == "table" and #result > 0 then
			return callback(false)
		else
			return callback(true)
		end
	end)

	query:Execute()
end

function impulse.Group.Load(id, onLoaded)
	local query = mysql:Select("impulse_rpgroups")
	query:Select("ownerid")
	query:Select("name")
	query:Select("type")
	query:Select("maxsize")
	query:Select("maxstorage")
	query:Select("ranks")
	query:Select("data")
	query:Where("id", id)
	query:Callback(function(result)
		if type(result) == "table" and #result > 0 then
			local data = result[1]

			if impulse.Group.Groups[data.name] then
				return onLoaded(data.name)
			end

			impulse.Group.Groups[data.name] = {
				ID = id,
				OwnerID = data.ownerid,
				Type = data.type,
				MaxSize = data.maxsize,
				MaxStorage = data.maxstorage,
				Ranks = pon.decode(data.ranks),
				Data = (data.data and pon.decode(data.data) or {})
			}

			if onLoaded then
				onLoaded(data.name)
			end
		end
	end)

	query:Execute()
end


-- Syncs Data with all client
function impulse.Group.LoadPublicData()
	local impulseGroupPublicGroupsData = {}

	for k, v in pairs(impulse.Group.Groups) do
		impulseGroupPublicGroupsData[k] = {}

		impulseGroupPublicGroupsData[k]["Data"] = {}
		impulseGroupPublicGroupsData[k]["Data"]["Col"] = v["Data"]["Col"]

		impulseGroupPublicGroupsData[k]["ID"] = v["ID"]
		impulseGroupPublicGroupsData[k]["OwnerID"] = v["OwnerID"]
	end

	SetGlobalString("impulse.Group.PublicGroups", util.TableToJSON(impulseGroupPublicGroupsData))
end

if not GetGlobalString("impulse.Group.PublicGroups", false) then
	impulse.Group.LoadPublicData()
end

function impulse.Group.SetWarData(name, starter, enemy)
	local starter_grp = impulse.Group.Groups[name]
	local enemy_name = enemy:GetSyncVar(SYNC_GROUP_NAME, nil)

	if not enemy_name then
		return
	end

	local enemy_grp = impulse.Group.Groups[name]

	local starter_id = starter_grp.ID
	local enemy_id = enemy_grp.ID

	local starter_data = starter_grp.Data or {}
	local enemy_data = enemy_grp.Data or {}

	-- data.Info = info or grp.Data.Info
	-- data.Col = col or (grp.Data.Col and Color(grp.Data.Col.r, grp.Data.Col.g, grp.Data.Col.b)) or nil

	impulse.Group.Groups[name].Data = starter_data
	impulse.Group.DBUpdateData(starter_id, starter_data) -- Starter of the war data

	impulse.Group.Groups[enemy_name].Data = enemy_data
	impulse.Group.DBUpdateData(enemy_id, enemy_data) -- Enemy of the war data
end

function meta:GroupLoad(groupid, rank)
	impulse.Group.Load(groupid, function(name)
		if not IsValid(self) then
			return
		end

		impulse.Group.ComputeMembers(name, function()
			if not IsValid(self) then
				return
			end

			impulse.Group.NetworkAllMembers(self, name)

			if self:GroupHasPermission(5) or self:GroupHasPermission(6) then
				impulse.Group.NetworkRanks(self, name)
			end

			impulse.Group.NetworkMetaData(self, name)
		end)

		if rank then
			if not impulse.Group.Groups[name].Ranks[rank] then
				rank = impulse.Group.GetDefaultRank(name)
				impulse.Group.DBUpdatePlayerRank(self:SteamID(), rank)
			end
		end

		rank = rank or impulse.Group.GetDefaultRank(name)
		-- local col = impulse.Group.Groups[name]["Data"]["Col"]
		-- PrintTable(impulse.Group.Groups[name]["Data"]["Col"])
		self:SetSyncVar(SYNC_GROUP_NAME, name, true)
		self:SetSyncVar(SYNC_GROUP_RANK, rank, true)
		-- self:SetSyncVar(SYNC_GROUP_COL, nil, true)

		impulse.Group.NetworkRank(name, self, rank)

		if self:IsDonator() and self:GroupHasPermission(99) and impulse.Group.Groups[name].MaxSize < impulse.Config.GroupMaxMembersVIP then
			impulse.Group.DBUpdateMaxMembers(groupid, impulse.Config.GroupMaxMembersVIP)
			impulse.Group.Groups[name].MaxSize = impulse.Config.GroupMaxMembersVIP
		end

		impulse.Group.LoadPublicData()
	end)
end