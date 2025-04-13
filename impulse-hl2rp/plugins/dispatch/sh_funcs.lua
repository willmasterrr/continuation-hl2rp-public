function impulse.Dispatch.AnnounceBlockSearch(block)
    impulse.Dispatch.Announce(3)
    block:Notify("Your block is under civil inspection, Assume your inspection position.")

    for v,k in pairs(team.GetPlayers(TEAM_CP)) do
        timer.Simple(2, function()
            k:SendCombineMessage("ALL AVAILABLE PROTECTION TEAMS, PREPARE FOR RESIDENTIAL INSPECTION OF ".. string.upper(block.name), Color(216, 159, 45))
        end)
    end

    timer.Simple(30, function()
        impulse.Dispatch.Announce(4)
    end)
end

function impulse.Dispatch.Manhunt(ply)
    if !IsValid(ply) then return end
    ply.IsWanted = true
   -- ply:Notify("You are being hunted. Report yourself to civil authorities or attempt to hide.") don't think its appropriate to notify the player
    impulse.Dispatch.Announce(5)
    for v,k in pairs(team.GetPlayers(TEAM_CP)) do
        timer.Simple(2, function()
            k:SendCombineMessage("ALL PROTECTION TEAM MEMBERS, ".. string.upper(ply:GetName()) .." HAS BEEN MARKED 'POS', BOL FOR TARGET.")
        end)
    end
    timer.Simple(60, function()
        if IsValid(ply) && ply.IsWanted then
            impulse.Dispatch.Announce(6)
        end
    end)
end

impulse.Dispatch.CityCodes = {
    [1] = {"CIVIL", Color(0, 255, 0)},
    [2] = {"CIVIL UNREST", Color(255, 165, 0)},
    [3] = {"JUDGEMENT WAIVER", Color(255, 0, 0)},
    [4] = {"AUTONOMOUS JUDGEMENT", Color(139, 0, 0)}
}

CODE_CIVIL = 1
CODE_UNREST = 2
CODE_JW = 3
CODE_AJ = 4

CRIME_ANTCIITIZEN = 1
CRIME_VORT = 2
CRIME_WEAPON = 3
CRIME_CONTRABAND = 4
CRIME_EVASION = 5
CRIME_CURFEW = 6
CRIME_BOL = 7

CRIME_NICENAMES = {
	[CRIME_ANTCIITIZEN] = "Anti-Citizen",
	[CRIME_CONTRABAND] = "Possession of Controband",
	[CRIME_VORT] = "Unregistered Biotic",
	[CRIME_WEAPON] = "High Tier Contraband",
	[CRIME_EVASION] = "Surveillance Evasion",
	[CRIME_CURFEW] = "Curfew Violation",
	[CRIME_BOL] = "BOL Target"
}

function impulse.Dispatch.GetCityCode()
    return GetGlobalInt("CityCode", 1)
end

local function findAndFire(pos)
    for v,k in pairs(ents.FindByClass("func_button")) do
        if pos:DistToSqr(k:GetPos()) < (9 ^ 2) then
            k:Fire("use")
        end
    end
end

local nextCityCodeSetup = 0
function impulse.Dispatch.SetupCityCode(code)
    local lastCityCode = LAST_CITYCODE or 1

    if code == lastCityCode then
        return
    end

    if nextCityCodeSetup > CurTime() then
        return
    end

    local doWait = false

    if lastCityCode == 3 then
        if impulse.Config.JWDirectOff then
            ents.FindByName(impulse.Config.JWDirectOff)[1]:Fire("use")
        elseif impulse.Config.JWButtonPos then
            findAndFire(impulse.Config.JWOffButtonPos or impulse.Config.JWButtonPos)
            doWait = true
        end
    elseif lastCityCode == 4 then
        if impulse.Config.AJDirectOn then
            ents.FindByName(impulse.Config.AJDirectOff)[1]:Fire("use")
        elseif impulse.Config.AJButtonPos then
            findAndFire(impulse.Config.AJOffButtonPos or impulse.Config.AJButtonPos)
            doWait = true
        end
    end

    timer.Simple((doWait and 31) or 2, function()
        if code == 3 then
            if impulse.Config.JWDirectOn then
                ents.FindByName(impulse.Config.JWDirectOn)[1]:Fire("use")
            elseif impulse.Config.JWButtonPos then
                findAndFire(impulse.Config.JWButtonPos)
            end
        end
        
        if code == 4 then
            if impulse.Config.AJDirectOn then
                ents.FindByName(impulse.Config.AJDirectOn)[1]:Fire("use")
            elseif impulse.Config.AJButtonPos then
                findAndFire(impulse.Config.AJButtonPos)
            end
        end
    end)

    LAST_CITYCODE = code
    nextCityCodeSetup = CurTime() + 68
end

function impulse.Dispatch.SetCityCode(code)
    return SetGlobalInt("CityCode", code)
end