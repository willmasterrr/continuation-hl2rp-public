local GiveCPWhitelist = {
    description = "Gives an player CP Rank Whitelist.",
    requiresArg = true,
    -- adminOnly = true,
    onRun = function(ply, arg, rawText)


		if (ply:Team() == TEAM_CP and ply:GetTeamClass() >= RANK_DCO) or (ply:Team() == TEAM_COUNCIL) or (ply:IsAdmin()) then
			local steamid = arg[1]
			local level = tonumber(arg[2])
			local teamid = tonumber(TEAM_CP)

			if not tonumber(level) then return end

			local query = mysql:Select("impulse_players")
			query:Select("id")
			query:Where("steamid", steamid)
			query:Callback(function(result)
				if not IsValid(ply) then
					return
				end
				if not type(result) == "table" or #result == 0 then
					ply:Notify("This Steam account has not joined the server yet or the SteamID is invalid.")
				else
					local inTable = impulse.Teams.GetWhitelist(steamid, teamid, function(exists)

						if exists then

							if level == 0 then
								local query = mysql:Delete("impulse_whitelists")
								query:Where("team", teamid)
								query:Where("steamid", steamid)
								query:Execute()

								ply:Notify(steamid .. " was removed from the whitelist successfully. ")
							else
								local query = mysql:Update("impulse_whitelists")
								query:Update("level", level)
								query:Where("team", teamid)
								query:Where("steamid", steamid)
								query:Execute()

								ply:Notify(steamid .. "'s CP whitelist has changed to level " .. level .. ".")
							end
						else
							local query = mysql:Insert("impulse_whitelists")
							query:Insert("level", level)
							query:Insert("team", teamid)
							query:Insert("steamid", steamid)
							query:Execute()	
	
							ply:Notify(steamid .. "'s CP whitelist has changed to level " .. level .. ".")
						end

						local targ = player.GetBySteamID(steamid)

						if targ and IsValid(targ) then
							targ.Whitelists[tostring(teamid)] = level
							targ:Notify("Your CP whitelist has been edited by " .. ply:SteamName() .. ".")
						end
					end)
				end
			end)

			query:Execute()
		else
			return ply:Notify("You must be a high rank to use this.")
		end
    end
}

impulse.RegisterChatCommand("/givecpwhitelist", GiveCPWhitelist)

local CleanCloths = {
    description = "Clean laundry Cloths if someone tries to be funny.",
    requiresArg = false,
    adminOnly = true,
    onRun = function(ply, arg, rawText)
		local oldvalue = #ents.FindByClass("impulse_cloth")
		for k, v in pairs(ents.FindByClass("impulse_cloth")) do
			v:Remove()
		end

		ply:Notify("Wiped " .. oldvalue .. " Cloths.")
    end
}

impulse.RegisterChatCommand("/cleancloth", CleanCloths)

local CleanSkeletons = {
    description = "Clean skeletons if someone tries to be funny.",
    requiresArg = false,
    adminOnly = true,
    onRun = function(ply, arg, rawText)
		local oldvalue = #ents.FindByClass("impulse_crafting_work")
		for k, v in pairs(ents.FindByClass("impulse_crafting_work")) do
			v:Remove()
		end

		ply:Notify("Wiped " .. oldvalue .. " Skeletons.")
    end
}

impulse.RegisterChatCommand("/cleanskeletons", CleanSkeletons)

local GiveOTAWhitelist = {
    description = "Gives an player OTA Rank Whitelist.",
    requiresArg = true,
    -- adminOnly = true,
    onRun = function(ply, arg, rawText)

		if (ply:Team() == TEAM_OTA and ply:GetTeamClass() == RANK_EOW) or (ply:Team() == TEAM_COUNCIL) or (ply:IsAdmin()) then
			local steamid = arg[1]
			local level = tonumber(arg[2])
			local teamid = tonumber(TEAM_OTA)

			if not tonumber(level) then return end

			local query = mysql:Select("impulse_players")
			query:Select("id")
			query:Where("steamid", steamid)
			
			query:Callback(function(result)
				if not IsValid(ply) then
					return
				end
				if not type(result) == "table" or #result == 0 then
					ply:Notify("This Steam account has not joined the server yet or the SteamID is invalid.")
				else
					local inTable = impulse.Teams.GetWhitelist(steamid, teamid, function(exists)

						if exists then


							if level == 0 then
								local query = mysql:Delete("impulse_whitelists")
								query:Where("team", teamid)
								query:Where("steamid", steamid)
								query:Execute()

								ply:Notify(steamid .. " was removed from the whitelist successfully. ")
							else
								local query = mysql:Update("impulse_whitelists")
								query:Update("level", level)
								query:Where("team", teamid)
								query:Where("steamid", steamid)
								query:Execute()

								ply:Notify(steamid .. "'s OTA whitelist has changed to level " .. level .. ".")
							end
						else
							local query = mysql:Insert("impulse_whitelists")
							query:Insert("level", level)
							query:Insert("team", teamid)
							query:Insert("steamid", steamid)
							query:Execute()	
	
							ply:Notify(steamid .. "'s OTA whitelist has changed to level " .. level .. ".")
						end

						local targ = player.GetBySteamID(steamid)

						if targ and IsValid(targ) then
							targ.Whitelists[tostring(teamid)] = level
							targ:Notify("Your OTA whitelist has been edited by " .. ply:SteamName() .. ".")
						end
					end)
				end
			end)

			query:Execute()
		else
			return ply:Notify("You must be a high rank to use this.")
		end
    end
}

impulse.RegisterChatCommand("/giveotawhitelist", GiveOTAWhitelist)

local GiveVICEWhitelist = {
    description = "Gives an player VICE Whitelist.",
    requiresArg = true,
    -- adminOnly = true,
    onRun = function(ply, arg, rawText)

		if (ply:Team() == TEAM_CP and ply:GetTeamClass() >= RANK_DCO) or (ply:Team() == TEAM_COUNCIL) or (ply:IsAdmin()) then
			local steamid = arg[1]
			local level = tonumber(arg[2])
			local teamid = "CP_SpecOps"

			local query = mysql:Select("impulse_players")
			query:Select("id")
			query:Where("steamid", steamid)
			query:Callback(function(result)
				if not IsValid(ply) then
					return
				end
				if not type(result) == "table" or #result == 0 then
					ply:Notify("This Steam account has not joined the server yet or the SteamID is invalid.")
				else
					local inTable = impulse.Teams.GetWhitelist(steamid, teamid, function(exists)

						if (not level) then return end

						if level > 1 then return end

						if exists then

							if level == 0 then
								local query = mysql:Delete("impulse_whitelists")
								query:Where("team", teamid)
								query:Where("steamid", steamid)
								query:Execute()

								ply:Notify(steamid .. " was removed from the VICE whitelist successfully. ")
							else
								local query = mysql:Update("impulse_whitelists")
								query:Update("level", level)
								query:Where("team", teamid)
								query:Where("steamid", steamid)
								query:Execute()

								ply:Notify(steamid .. "'s VICE whitelist has been given.")
							end
						else
							local query = mysql:Insert("impulse_whitelists")
							query:Insert("level", level)
							query:Insert("team", teamid)
							query:Insert("steamid", steamid)
							query:Execute()	
	
							ply:Notify(steamid .. "'s VICE whitelist has been given.")
						end

						local targ = player.GetBySteamID(steamid)

						if targ and IsValid(targ) then
							targ.Whitelists[tostring(teamid)] = level
							targ:Notify("Your VICE whitelist has been edited by " .. ply:SteamName() .. ".")
						end
					end)
				end
			end)

			query:Execute()
		else
			return ply:Notify("You must be a high rank to use this.")
		end
    end
}

impulse.RegisterChatCommand("/givevicewhitelist", GiveVICEWhitelist)

local MedusafyCommand = {
    description = "Turn someone into stone for no reason",
    requiresArg = false,
    superAdminOnly = true,
    onRun = function(ply, arg, rawText)
		local name = arg[1]
		local plyTarget = impulse.FindPlayer(name)

		if plyTarget then
			local ragdoll = ents.Create("prop_ragdoll")
			ragdoll:SetModel(plyTarget:GetModel())
			ragdoll:SetPos(plyTarget:GetPos())
			ragdoll:SetSkin(plyTarget:GetSkin())

			ragdoll.CanConstrain = false
			ragdoll.NoCarry = true

			for v,k in pairs(plyTarget:GetBodyGroups()) do
				ragdoll:SetBodygroup(k.id, plyTarget:GetBodygroup(k.id))
			end

			ragdoll:Spawn()
			ragdoll:SetCollisionGroup(COLLISION_GROUP_WORLD)

			local velocity = plyTarget:GetVelocity()

			for i = 0, ragdoll:GetPhysicsObjectCount() - 1 do
				local physObj = ragdoll:GetPhysicsObjectNum(i)
		
				if IsValid(physObj) then
					physObj:SetVelocity(velocity)
		
					local index = ragdoll:TranslatePhysBoneToBone(i)
		
					if index then
						local pos, ang = plyTarget:GetBonePosition(index)
		
						physObj:SetPos(pos)
						physObj:SetAngles(ang)
					end
				end
			end

			ragdoll.statue = {}
			for i = 0, ragdoll:GetPhysicsObjectCount() - 1 do
				local physObj = ragdoll:GetPhysicsObjectNum(i)
				if IsValid(physObj) then
					local index = ragdoll:TranslatePhysBoneToBone(i)
					if index then
						local c = constraint.Weld( ragdoll, ragdoll, 0, index, 0 )
						if ( c ) then
							ragdoll.statue[ index ] = constraint
						end
					end
				end
			end
			ragdoll:SetMaterial("models/props_wasteland/wood_fence01a")

			plyTarget:SetPos(Vector(-11639.460938, 2124.255615, 5671.937500))
			timer.Simple(.5, function()
				plyTarget:Kill()
			end)
		else
			ply:Notify("Couldnt find player.")
		end
    end
}

impulse.RegisterChatCommand("/medusa", MedusafyCommand)

local GiveCouncilWhitelist = {
    description = "Gives an player Council Whitelist.",
    requiresArg = false,
    adminOnly = true,
    onRun = function(ply, arg, rawText)
		local name = arg[1]
		local toggle = arg[2]
		local plyTarget = impulse.FindPlayer(name)
        local teamid = "Council_WHITELIST"

		local check = { ["true"] = true, ["false"] = true }

		if not plyTarget or not IsValid(plyTarget) then return end
		if not check[toggle] then return end

		if not plyTarget.impulseData.Whitelist then
			plyTarget.impulseData.Whitelist = {}
		end

		plyTarget.impulseData.Whitelist[teamid] = tobool(toggle) -- garbage cleanup
		plyTarget:SaveData()

		ply:Notify("Set council whitelist for " .. plyTarget:Nick() .. " to " .. tostring(toggle))
    end
}

impulse.RegisterChatCommand("/givecouncilwhitelist", GiveCouncilWhitelist)

local GiveCWUMinisterWhitelist = {
    description = "Gives an player CWU Minister Whitelist.",
    requiresArg = true,
    -- adminOnly = true,
    onRun = function(ply, arg, rawText)

		if (ply:IsCPCommand()) or (ply:Team() == TEAM_COUNCIL) or (ply:IsAdmin()) then
			local steamid = arg[1]
			local level = tonumber(arg[2])
			local teamid = "CWU_MinisterRole"

			local query = mysql:Select("impulse_players")
			query:Select("id")
			query:Where("steamid", steamid)
			query:Callback(function(result)
				if not IsValid(ply) then
					return
				end
				if not type(result) == "table" or #result == 0 then
					ply:Notify("This Steam account has not joined the server yet or the SteamID is invalid.")
				else
					local inTable = impulse.Teams.GetWhitelist(steamid, teamid, function(exists)

						if (not level) then return end

						if level > 1 then return end

						if exists then

							if level == 0 then
								local query = mysql:Delete("impulse_whitelists")
								query:Where("team", teamid)
								query:Where("steamid", steamid)
								query:Execute()

								ply:Notify(steamid .. " was removed from the CWU Minister whitelist successfully. ")
							else
								local query = mysql:Update("impulse_whitelists")
								query:Update("level", level)
								query:Where("team", teamid)
								query:Where("steamid", steamid)
								query:Execute()

								ply:Notify(steamid .. "'s CWU Minister whitelist has been given.")
							end
						else
							local query = mysql:Insert("impulse_whitelists")
							query:Insert("level", level)
							query:Insert("team", teamid)
							query:Insert("steamid", steamid)
							query:Execute()	
	
							ply:Notify(steamid .. "'s CWU Minister whitelist has been given.")
						end

						local targ = player.GetBySteamID(steamid)

						if targ and IsValid(targ) then
							targ.Whitelists[tostring(teamid)] = level
							targ:Notify("Your CWU Minister whitelist has been edited by " .. ply:SteamName() .. ".")
						end
					end)
				end
			end)

			query:Execute()
		else
			return ply:Notify("You must be a high rank to use this.")
		end
    end
}

impulse.RegisterChatCommand("/give_cwu_minister_whitelist", GiveCWUMinisterWhitelist)

local givecwuworkshiftleaderwhitelist = {
    description = "Gives an player CWU Workshift Leader Whitelist.",
    requiresArg = true,
    -- adminOnly = true,
    onRun = function(ply, arg, rawText)

		if (ply:IsCPCommand()) or (ply:Team() == TEAM_COUNCIL) or (ply:IsAdmin()) or (ply:Team() == TEAM_CWU and ply:GetTeamClass() == CLASS_MINISTER) then
			local steamid = arg[1]
			local level = tonumber(arg[2])
			local teamid = "CWU_WorkShiftLeaderRole"

			local query = mysql:Select("impulse_players")
			query:Select("id")
			query:Where("steamid", steamid)
			query:Callback(function(result)
				if not IsValid(ply) then
					return
				end
				if not type(result) == "table" or #result == 0 then
					ply:Notify("This Steam account has not joined the server yet or the SteamID is invalid.")
				else
					local inTable = impulse.Teams.GetWhitelist(steamid, teamid, function(exists)

						if (not level) then return end

						if level > 1 then return end

						if exists then

							if level == 0 then
								local query = mysql:Delete("impulse_whitelists")
								query:Where("team", teamid)
								query:Where("steamid", steamid)
								query:Execute()

								ply:Notify(steamid .. " was removed from the CWU Workshift Leader whitelist successfully. ")
							else
								local query = mysql:Update("impulse_whitelists")
								query:Update("level", level)
								query:Where("team", teamid)
								query:Where("steamid", steamid)
								query:Execute()

								ply:Notify(steamid .. "'s CWU Workshift Leader has been given.")
							end
						else
							local query = mysql:Insert("impulse_whitelists")
							query:Insert("level", level)
							query:Insert("team", teamid)
							query:Insert("steamid", steamid)
							query:Execute()	
	
							ply:Notify(steamid .. "'s CWU Workshift Leader has been given.")
						end

						local targ = player.GetBySteamID(steamid)

						if targ and IsValid(targ) then
							targ.Whitelists[tostring(teamid)] = level
							targ:Notify("Your CWU Workshift Leader has been edited by " .. ply:SteamName() .. ".")
						end
					end)
				end
			end)

			query:Execute()
		else
			return ply:Notify("You must be a high rank to use this.")
		end
    end
}

impulse.RegisterChatCommand("/give_cwu_workshift_leader_whitelist", givecwuworkshiftleaderwhitelist)

local GiveLoyalistPoints = {
    description = "Gives a player Loyalist points.",
    requiresArg = true,
    -- adminOnly = true,
    onRun = function(ply, arg, rawText)

		if (ply:IsCPCommand()) or (ply:Team() == TEAM_COUNCIL) or (ply:IsAdmin()) or (ply:Team() == TEAM_CWU and ply:GetTeamClass() == CLASS_MINISTER) then
			local steamid = arg[1]
			local target = player.GetBySteamID(steamid)
			local amount = tonumber(arg[2])
			if not tonumber(arg[2]) then return end

			ReqwestLog({
				{
					description = ply:Nick() .. "(" .. ply:SteamName() .. ")(" .. ply:SteamID() .. ") Has given " .. target:Nick() .. "(" .. target:SteamName() .. ")(" .. target:SteamID() .. ") " .. amount .. " Loyalist Points." ,
					color = 16711680, -- Red color (in decimal)
				}
			})

			target:GiveLoyalPoints(amount)
		else
			return ply:Notify("You must be a CWU Minister or CP Commander to use this.")
		end
    end
}

impulse.RegisterChatCommand("/giveloyalistpoints", GiveLoyalistPoints)

local RemoveLoyalistPoints = {
    description = "Removes a player Loyalist points.",
    requiresArg = true,
    -- adminOnly = true,
    onRun = function(ply, arg, rawText)

		if (ply:IsCPCommand()) or (ply:Team() == TEAM_COUNCIL) or (ply:IsAdmin()) or (ply:Team() == TEAM_CWU and ply:GetTeamClass() == CLASS_MINISTER) then
			local steamid = arg[1]
			local target = player.GetBySteamID(steamid)
			local amount = tonumber(arg[2])
			if not tonumber(arg[2]) then return end

			ReqwestLog({
				{
					description = ply:Nick() .. "(" .. ply:SteamName() .. ")(" .. ply:SteamID() .. ") Has removed " .. target:Nick() .. "(" .. target:SteamName() .. ")(" .. target:SteamID() .. ") " .. amount .. " Loyalist Points." ,
					color = 16711680, -- Red color (in decimal)
				}
			})

			target:RemoveLoyalPoints(amount)
		else
			return ply:Notify("You must be a CWU Minister or CP Commander to use this.")
		end
    end
}

impulse.RegisterChatCommand("/removeloyalistpoints", RemoveLoyalistPoints)

local SetLoyalistPoints = {
    description = "Set a player Loyalist points.",
    requiresArg = true,
    -- adminOnly = true,
    onRun = function(ply, arg, rawText)

		if (ply:IsCPCommand()) or (ply:Team() == TEAM_COUNCIL) or (ply:IsAdmin()) or (ply:Team() == TEAM_CWU and ply:GetTeamClass() == CLASS_MINISTER) then
			local steamid = arg[1]
			local target = player.GetBySteamID(steamid)
			local amount = tonumber(arg[2])
			if not tonumber(arg[2]) then return end

			ReqwestLog({
				{
					description = ply:Nick() .. "(" .. ply:SteamName() .. ")(" .. ply:SteamID() .. ") Has set " .. target:Nick() .. "(" .. target:SteamName() .. ")(" .. target:SteamID() .. ") " .. amount .. " Loyalist Points." ,
					color = 16711680, -- Red color (in decimal)
				}
			})

			target:SetLoyalPoints(amount)
		else
			return ply:Notify("You must be a CWU Minister or CP Commander to use this.")
		end
    end
}

impulse.RegisterChatCommand("/setloyalistpoints", SetLoyalistPoints)

local AdminMode = {
    description = "Admin Mode Funny",
    requiresArg = false,
    superAdminOnly = true,
    onRun = function(ply, arg, rawText)
		if ply.GodMode then
			local thing = ply.DefaultColor or Vector(0, 0, 0)
			ply:SetPlayerColor(thing)
			ply:GodEnable()
			ply.GodMode = false
			ply:SetModel(ply.defaultModel)
			ply:Notify("Admin Mode Disabled")
		else
			ply.DefaultColor = ply:GetPlayerColor()
			ply:SetPlayerColor(Vector(0.753, 0.133, 0.133))
			ply:GodDisable()
			ply.GodMode = true
			ply:SetModel("models/player/kleiner.mdl")
			ply:Notify("Admin Mode Activated")
		end
    end
}

impulse.RegisterChatCommand("/adminmode", AdminMode)