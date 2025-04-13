util.AddNetworkString("Impulse_CreateVGUI")
util.AddNetworkString("impulseRankTerminalBecome")
util.AddNetworkString("impulseBecomeRebel")
util.AddNetworkString("impulseRemoveBOL")
util.AddNetworkString("impulseCheckBody")
util.AddNetworkString("impulseHL2RPInspectBodyComplete")
util.AddNetworkString("impulseDemoteCP")
util.AddNetworkString("impulseAchPUTCWin")
util.AddNetworkString("impulseWorkshift")

net.Receive("impulseDemoteCP", function(len, ply)
	if (ply.nextdmtcp or 0) > CurTime() then return end
	ply.nextdmtcp = CurTime() + 2

	local ent = net.ReadEntity()
	local length = net.ReadUInt(16)

	local rankcore = {
		[TEAM_CP] = {rank = RANK_SQL},
		-- [TEAM_OTA] = RANK_DVL, ota cmd soon..
	}

	if not tonumber(length) then return end
	if not IsValid(ply.CurTerminal) then return end
	if not rankcore[ply:Team()] or ply:GetTeamRank() < rankcore[ply:Team()].rank then return end
	if not ent or not IsValid(ent) or not ent:IsPlayer() or not rankcore[ent:Team()] then return end
	if ent:GetTeamRank() and ent:GetTeamRank() >= rankcore[ent:Team()].rank or ent:IsAdmin() then return end

	if ply:GetTeamRank() == RANK_SQL and (ply.cpdemotes or 0) > 3 then
		return ply:Notify("You've demoted too many units.")
	end

	if ent.impulseData.CombineBan then return ply:Notify("Target already has an active combine ban.") end

	length = length * 60

	local cTime = os.time()

	local eTime = cTime + length


	ent.impulseData.CombineBan = eTime
	ent:SaveData()

	ent:SetTeam(impulse.Config.DefaultTeam)

	local howLong = string.NiceTime(length)

	ent:Notify("You have been demoted from CP by "..ply:Nick().." you will be unable to access combine teams for "..howLong..".")
	ply:Notify("You have demoted "..ent:Nick()..". They will be unable to access combine teams for "..howLong..".")
	ply.cpdemotes = (ply.cpdemotes or 0) + 1

	hook.Run("OnCPDemoted", ply, ent)

end)

net.Receive("impulseCheckBody", function(len, ply)
    local body = net.ReadEntity()
    local killer = body.Killer or nil
    local isCp = false
    local killersname

    if (body.inspected) then
        return ply:Notify("This body was already inspected.")
    end

    if (not IsValid(killer) or not IsValid(body) or not killer:IsPlayer() or
    body:GetPos():DistToSqr(ply:GetPos()) > (400 ^ 2) or body.inspected) then return end


	if impulse.Anim.GetModelClass(body:GetModel()) == "metrocop" then
		isCp = true
	end

    local weapon = body.DmgWep or "unknown"

    --ply:GetSyncVar(SYNC_COS_HEAD) == 4

    if (IsValid(killer) and killer:IsPlayer() and not killer:IsCP() and not body.wearing_hide_mask) then
        killersname = killer:Nick()
    end



    local cantBOL = false
	if ((killer.lastDeath or 0) > (body.creationTime or 0)) or body.wearing_hide_mask then
		cantBOL = true
	end

    if (not body.NoBodycamID and killer and not body.Killer:IsDispatchBOL() and not killer:IsCP() ) and (not cantBOL) then
		body.Killer:AddDispatchBOL(10, 1200) -- assault on pt and 20 mins
		ply:Notify(killer:Nick() .. " has been automatically added to the BOL index.")
	end

    net.Start("impulseHL2RPInspectBodyComplete")
	net.WriteBool(body.FallDeath or false)
	net.WriteString(weapon)
	net.WriteString(killersname or "")
	net.WriteBool(cantBOL)
	net.Send(ply)

    body.inspected = true
end)

net.Receive("impulseRemoveBOL", function(len, ply)
    local ent = net.ReadEntity()

    if ply:IsCPCommand() then
        if (not IsValid(ent)) then return end
        ent:RemoveDispatchBOL()
        ply:Notify("You removed " .. ent:Name() .. " from the BOL list.")
    end
end)


net.Receive("impulseBecomeRebel", function(len, ply)
    local shirt_to_wear = net.ReadString()

    local rebel_list = {
        ["blue_sht"] = {shirt = 5,pants = 3},
        ["green_sht"] = {shirt = 6,pants = 3},
        ["TheKuKluzKlan"] = {shirt = 7,pants = 4},
        ["MrBeast"] = {shirt = 8,pants = 4}
    }

    if not IsValid(ply.CurLocker) or (ply:GetPos() - ply.CurLocker:GetPos()):LengthSqr() > (120 ^ 2) then return end

    if (ply:IsRebel()) then
        ply.WearingRebelOutfit = false
        ply:SetBodygroup(1, 0)
        ply:SetBodygroup(2, 0)
    else
        
        ply.WearingRebelOutfit = true

        if (rebel_list[shirt_to_wear].shirt) then
            ply:SetBodygroup(1, rebel_list[shirt_to_wear].shirt)
            ply:SetBodygroup(2, rebel_list[shirt_to_wear].pants)
        end
    end
end)

net.Receive("impulseRankTerminalBecome", function(len, ply)
    local classID = net.ReadUInt(8)
    local RankID = net.ReadUInt(8)

    if not IsValid(ply.CurCMBVendor) or ((ply:GetPos() - ply.CurCMBVendor:GetPos()):LengthSqr() > (120 ^ 2)) or (not ply:Alive()) then return end

    local w = { [TEAM_CP] = true, [TEAM_OTA] = true, }

    if ( not w[ply:Team()] ) then return end

	local classes = impulse.Teams.Data[ply:Team()].classes
	local ranks = impulse.Teams.Data[ply:Team()].ranks

	if classID and isnumber(classID) and classID > 0 and classes and classes[classID] then
        if RankID and isnumber(RankID) and RankID > 0 and ranks and ranks[RankID] then
            if ply:CanBecomeTeamClass(classID, true) and ply:CanBecomeTeamRank(RankID, true) then
                ply:SetTeamClass(classID)
                ply:SetTeamRank(RankID)

                if (ply:Team() == TEAM_CP) then
                    local city = impulse.Config.CityCode or "C17"
                    local id = math.random(1000, 9999)
                    ply:SetRPName("CP-" .. city .. "-" .. classes[classID].name .. "-" .. ranks[RankID].name .. "-" .. id, false)
                end
        
                if (ply:Team() == TEAM_OTA) then
                    local city = impulse.Config.CityCode or "C17"
                    local id = math.random(1000, 9999)
                    ply:SetRPName("OTA-" .. city .. "-" .. classes[classID].name .. "-" .. ranks[RankID].name .. "-" .. id, false)
                end

                net.Start("impulseHL2RPCombineOverlayBoot")
                net.Send(ply)

                ply:Notify("You have set your division and rank to " .. classes[classID].name .. "-" .. ranks[RankID].name)
            end
        end
	end
end)

local RationStartTimer, RationEndTimer = impulse.Config.WorkshiftTime["Start"], impulse.Config.WorkshiftTime["End"]

local function EndWorkshift(ply)
	if not impulse.WorkshiftEnabled then
		if (ply) then
			ply:Notify("There are no workshifts happening around this time.")
		end
		return
	end

	local text = "Attention Citizens, Workshift hour has ended."
	local audio

	for v,k in pairs(player.GetAll()) do
		if (ply) then
			k:SendChatClassMessage(56, text, ply)
		else
			k:SendChatClassMessage(56, text)
		end
		local data = impulse.Config.CitySounds or false
		if data and (data["cwu_end"]) then
			audio = impulse.Config.CitySounds["cwu_end"].audio
		else
			audio = "npc/overwatch/cityvoice/f_evasionbehavior_2_spkr.wav"
		end
		k:EmitSound(audio, 50, nil, nil, CHAN_USER_BASE)
	end
	if (ply) then
		ply:Notify("You have ended the workshift.")

		ReqwestLog({
			{
				description = ply:Nick() .. "(" .. ply:SteamName() .. ")(" .. ply:SteamID() .. ") has ended a workshift.",
				color = 16711680, -- Red color (in decimal)
			}
		})
	end

	if timer.Exists("Impulse.WORKSHIFT.TIMER") then
		timer.Remove("Impulse.WORKSHIFT.TIMER")
	end
	impulse.WorkshiftDelay = CurTime() + RationEndTimer
	impulse.WorkshiftEnabled = false
	-- SetGlobal2Int("ImpulseWorkshiftTimer", CurTime() - 999)
end

local function StartWorkshift(ply)
	if (impulse.WorkshiftEnabled) or (impulse.WorkshiftDelay > CurTime()) then
		ply:Notify("A workshift has already happened, please try again in " .. string.NiceTime(impulse.WorkshiftDelay - CurTime()) .. ".")
		return
	end

	local text = "Attention Citizens, Workshift hour has started."
	local audio

	for v,k in pairs(player.GetAll()) do
		print(text)
		k:SendChatClassMessage(56, text, ply)
		local data = impulse.Config.CitySounds or false
		if data and (data["cwu_start"]) then
			audio = impulse.Config.CitySounds["cwu_start"].audio
		else
			audio = "npc/overwatch/cityvoice/f_trainstation_assumepositions_spkr.wav"
		end
		k:EmitSound(audio, 50, nil, nil, CHAN_USER_BASE)
	end

	ReqwestLog({
		{
			description = ply:Nick() .. "(" .. ply:SteamName() .. ")(" .. ply:SteamID() .. ") has started a workshift.",
			color = 16711680, -- Red color (in decimal)
		}
	})

	ply:Notify("You have started a workshift.")

	timer.Create("Impulse.WORKSHIFT.TIMER", RationStartTimer, 1, function()
		EndWorkshift(nil)
	end)

	impulse.WorkshiftEnabled = true
	impulse.WorkshiftDelay = CurTime() + RationStartTimer
	SetGlobal2Int("ImpulseWorkshiftTimer", CurTime() + RationStartTimer)
end

net.Receive("impulseWorkshift", function(len, ply)
	if not IsValid(ply.CurCWUMinisterTerminal) or (ply:GetPos() - ply.CurCWUMinisterTerminal:GetPos()):LengthSqr() > (120 ^ 2) then return end
	local IsEnder = net.ReadBool()

	-- local test1 = impulse.WorkshiftDelay < CurTime()
	-- local test2 = impulse.WorkshiftDelay > CurTime()
	-- print("<" .. tostring(test1))
	-- print(">" .. tostring(test2))
	-- print("Isender " .. tostring(IsEnder))
	-- print(impulse.WorkshiftDelay)
	-- DEBUG CODE

	if IsEnder then
		EndWorkshift(ply)
	else
		StartWorkshift(ply)
	end
end)
