local ACTIVATE_PLAYTEST = false -- just to avoid it

if (ACTIVATE_PLAYTEST) then

local rebelzonecommand = {
    description = "Teleports the player to the rebel zone.",
    requiresArg = false,
    onRun = function(ply, arg, rawText)
	
		if (!ply:IsCP()) then
			opsGoto(ply, Vector(-8671.818359, 8266.410156, -402.681396))
		else
			for v,k in pairs(player.GetAll()) do
				if k:IsAdmin() then
					k:AddChatText(Color(135, 206, 235), "[ops] "..ply:SteamName().." ATTEMPTED AS A CP.. to teleport to the rebel zone.")
				end
			end
			return
		end
	
		for v,k in pairs(player.GetAll()) do
			if k:IsAdmin() then
				k:AddChatText(Color(135, 206, 235), "[ops] "..ply:SteamName().." teleported to the rebel zone.")
			end
		end
    end
}

impulse.RegisterChatCommand("/rebelzone", rebelzonecommand)

local cpzonecommand = {
    description = "Teleports the player to the cp zone.",
    requiresArg = false,
    onRun = function(ply, arg, rawText)
	
		if (ply:IsCP()) then
			opsGoto(ply, Vector(-3761.808594, 6445.662109, -132.968689))
		else
			for v,k in pairs(player.GetAll()) do
				if k:IsAdmin() then
					k:AddChatText(Color(135, 206, 235), "[ops] "..ply:SteamName().." ATTEMPTED AS A REBEL.. to teleport to the cp zone.")
				end
			end
			return
		end
	
		for v,k in pairs(player.GetAll()) do
			if k:IsAdmin() then
				k:AddChatText(Color(135, 206, 235), "[ops] "..ply:SteamName().." teleported to the cp zone.")
			end
		end
    end
}

impulse.RegisterChatCommand("/cpzone", cpzonecommand)

end