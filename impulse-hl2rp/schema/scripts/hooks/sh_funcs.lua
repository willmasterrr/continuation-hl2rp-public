local Illegal_Torso = {
    [3] = true, -- Salvaged OTA Ballistic Vest
    [9] = true -- Elite Vest
}
local Illegal_Helmet = {
    [1] = true, -- Combat Gas Mask
    [7] = true -- Mk III Helmet
}
local Illegal_Face =  {
    [4] = true, -- Face Wrap
}

local Illegal_Weapons = {
    ["ls_357"] = true,
    ["ls_ak47"] = true,
    ["ls_ar2"] = true,
    ["ls_axe"] = true,
    ["ls_abracadabra"] = true,
    ["ls_doublebarrel"] = true,
    ["ls_flashbang"] = true,
    ["ls_goldengun"] = true,
    ["ls_m60"] = true,
    ["ls_mini14"] = true,
    ["ls_molotov"] = true,
    ["ls_mp7"] = true,
    ["ls_pewpew"] = true,
    ["ls_pickaxe"] = true,
    ["ls_spas12"] = true,
    ["ls_stunstick"] = true,
    ["ls_teargas"] = true,
    ["ls_theclobberer"] = true,
    ["ls_thumpthump"] = true,
    ["ls_usp"] = true,
}

function meta:HasGasMask()

    if self:GetSyncVar(SYNC_COS_FACE) == 1 then
        return true
    else
        return false
    end

end

function meta:IsRebel()
    for k, v in ipairs(impulse.Config.RebelSuits) do
        for num, id in ipairs(v.id) do
            if (self:GetBodygroup(v.body) == id) then
                return true
            end
        end
    end

    return false
end

function meta:IsRebelSmart()
    for k, v in ipairs(impulse.Config.RebelSuits) do
        for num, id in ipairs(v.id) do
            if (self:GetBodygroup(v.body) == id) then
                return true
            end
        end
    end

    if Illegal_Helmet[self:GetSyncVar(SYNC_COS_HEAD)] then
        return true
    end

    if Illegal_Face[self:GetSyncVar(SYNC_COS_FACE)] then
        return true
    end

    if Illegal_Torso[self:GetSyncVar(SYNC_COS_CHEST)] then
        return true
    end

    return false
end

local Illegal_Helmet_Camera = {
    [1] = true, -- Combat Gas Mask
    -- [4] = true, -- Face Wrap
    [7] = true -- Mk III Helmet
}

function meta:IsRebel_CAMERA()
    local isCriminal = false
	local idKnown = true
	local firstCrime
	local crimes = {}

    if self:IsCP() then
		return false, false, {}
	end

    if idKnown and self:IsDispatchBOL() then
		isCriminal = true
		firstCrime = firstCrime or CRIME_BOL
		crimes[CRIME_BOL] = true
        -- return isCriminal, idKnown, crimes, firstCrime
	end

    if (self:GetSyncVar(SYNC_COS_FACE) == 4) then
        idKnown = false
        firstCrime = firstCrime or CRIME_CONTRABAND
		crimes[CRIME_CONTRABAND] = true
        -- return isCriminal, idKnown, crimes, firstCrime
    end

    if Illegal_Helmet_Camera[self:GetSyncVar(SYNC_COS_HEAD)] then
		isCriminal = true
		firstCrime = firstCrime or CRIME_WEAPON
		crimes[CRIME_WEAPON] = true
        -- return isCriminal, idKnown, crimes, firstCrime
    end

    if Illegal_Torso[self:GetSyncVar(SYNC_COS_CHEST)] then
		isCriminal = true
		firstCrime = firstCrime or CRIME_WEAPON
		crimes[CRIME_WEAPON] = true
        -- return isCriminal, idKnown, crimes, firstCrime
    end

    if Illegal_Weapons[self:GetActiveWeapon():GetClass()] then
        isCriminal = true
		firstCrime = firstCrime or CRIME_WEAPON
		crimes[CRIME_WEAPON] = true
        -- return isCriminal, idKnown, crimes, firstCrime
    end

    for k, v in ipairs(impulse.Config.RebelSuits) do
        for num, id in ipairs(v.id) do
            if (self:GetBodygroup(v.body) == id) then
                isCriminal = true
                firstCrime = firstCrime or CRIME_ANTCIITIZEN
                crimes[CRIME_ANTCIITIZEN] = true
	            -- return isCriminal, idKnown, crimes, firstCrime

            end
        end
    end

    return isCriminal, idKnown, crimes, firstCrime
end

function meta:IsCPCommand()
    if !self:IsCP() then return end

    if self:Team() == TEAM_COUNCIL then
        return true
    end

    if !impulse.Teams.Data[self:Team()].ranks then return false end

    local div = impulse.Teams.Data[self:Team()].ranks[self:GetTeamRank()]

    if (!div) then return false end

    if (div.IsCPCommander) then
        return true
    else
        return false
    end

end

function meta:IsCWULead()

    if (self:Team() == TEAM_CWU and self:GetTeamClass() == CLASS_WORKSHIFT_LEADER) or (self:Team() == TEAM_CWU and self:GetTeamClass() == CLASS_MINISTER) then
        return true
    end

    if self:IsCPCommand() then
        return true
    end

    return false
end

function meta:GetDigits()
    local l = {[TEAM_COUNCIL] = true, [TEAM_CA] = true,}
	if not self:IsCP() or l[self:Team()] or not self:IsValid() then return end
	local digits = string.Right(self:Name(), 4)
	digits = tonumber(digits)

	if digits and isnumber(digits) then
		return digits
	end
end