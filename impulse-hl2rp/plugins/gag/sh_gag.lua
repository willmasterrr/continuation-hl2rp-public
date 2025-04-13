function PLUGIN:CreateSyncVars()
	SYNC_GAGTIME = impulse.Sync.RegisterVar(SYNC_STRING)
end

local GagCommand = {
    description = "Gags someone.",
    requiresArg = true,
    adminOnly = true,
    onRun = function(ply, arg, rawText)
        local name = arg[1]
        local time = arg[2]
		local plyTarget = impulse.FindPlayer(name)

		if not time or not tonumber(time) then
			return ply:Notify("Please specific a valid time value in minutes.")
		end


		if plyTarget and plyTarget.impulseData then

            plyTarget:SetTimeout(time)

			ply:Notify("You have Gagged "..plyTarget:Nick()..".")
			plyTarget:Notify("You have been gagged from talking (With a microphone) by a game moderator ("..ply:SteamName()..").")
		else
			return ply:Notify("Could not find player: "..tostring(name))
		end
    end
}

impulse.RegisterChatCommand("/gag", GagCommand)

local RemoveGagCommand = {
    description = "Ungags someone.",
    requiresArg = true,
    adminOnly = true,
    onRun = function(ply, arg, rawText)
        local name = arg[1]
        local time = arg[2]
		local plyTarget = impulse.FindPlayer(name)

		if not time or not tonumber(time) then
			return ply:Notify("Please specific a valid time value in minutes.")
		end


		if plyTarget and plyTarget.impulseData then

            plyTarget:RemoveTimeout(time)

			ply:Notify("You have UnGagged "..plyTarget:Nick()..".")
			plyTarget:Notify("You have been Ungagged by a game moderator ("..ply:SteamName()..").")
		else
			return ply:Notify("Could not find player: "..tostring(name))
		end
    end
}

impulse.RegisterChatCommand("/ungag", RemoveGagCommand)