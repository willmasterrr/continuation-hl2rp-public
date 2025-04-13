local warnCommand = {
    description = "Warns the specified player (reason is required).",
    requiresArg = true,
    adminOnly = true,
    onRun = function(ply, arg, rawText)
        if ply:IsAdmin() or ply:IsLeadAdmin() or ply:IsSuperAdmin() then
            local name = arg[1]
            local plyTarget = impulse.FindPlayer(name)
            local reason = ""
            for v,k in pairs(arg) do
                if v > 1 then
                    reason = reason.." "..k
                end
            end
            reason = string.Trim(reason)
            if reason == "" then
                return ply:Notify("No reason provided.")
            end
            if plyTarget and ply != plyTarget then
                VyHub.Warning:create(plyTarget:SteamID64(), reason, ply:SteamID64())                
                ply:Notify("You have warned "..plyTarget:SteamName().." for "..reason..".")
            end
        end
    end
}
impulse.RegisterChatCommand("/warn", warnCommand)

local banCommand = {
    description = "Bans the specified player from the server. (time in minutes)",
    requiresArg = true,
    adminOnly = true,
    onRun = function(ply, arg, rawText)
        if ply:IsAdmin() or ply:IsLeadAdmin() or ply:IsSuperAdmin() then
            local name = arg[1]
            local plyTarget = impulse.FindPlayer(name)
            local time = arg[2]
            if not time or not tonumber(time) then
                return ply:Notify("No time value supplied.")
            end
            time = tonumber(time)
            if time < 0 then
                return ply:Notify("Negative time values are not allowed.")
            end
            if time > 10000000 then
                time = 0
            end
            local reason = ""
            for v,k in pairs(arg) do
                if v > 2 then
                    reason = reason.." "..k
                end
            end
            reason = string.Trim(reason)
            if plyTarget and ply != plyTarget then
                if plyTarget:IsSuperAdmin() then
                    return ply:Notify("You can not ban this user.")
                end

                if not reason then
                    reason = "None"
                end

                reason = " |  Appeal at https://discord.gg/3mQQmGgbNG or make a ticket on https://continuation.vyhub.app"

                VyHub.Ban:create(plyTarget:SteamID64(), time, reason, ply:SteamID64())
                ply:Notify("You have banned "..plyTarget:SteamName().." for "..time.." minutes.")
            else
                return ply:Notify("Could not find player: "..tostring(name))
            end
        end
    end
}

impulse.RegisterChatCommand("/ban", banCommand)