
local REBEL_Footsteps = {
    "npc/footsteps/hardboot_generic1.wav",
    "npc/footsteps/hardboot_generic2.wav",
    "npc/footsteps/hardboot_generic3.wav",
    "npc/footsteps/hardboot_generic4.wav",
    "npc/footsteps/hardboot_generic5.wav",
    "npc/footsteps/hardboot_generic6.wav"
}

local Footsteps_Sounds = {
    [TEAM_OTA] = {
        "npc/combine_soldier/gear1.wav",
        "npc/combine_soldier/gear2.wav",
        "npc/combine_soldier/gear3.wav",
        "npc/combine_soldier/gear4.wav",
        "npc/combine_soldier/gear5.wav",
        "npc/combine_soldier/gear6.wav",
    },

    [TEAM_CP] = {
        "npc/metropolice/gear1.wav",
        "npc/metropolice/gear2.wav",
        "npc/metropolice/gear3.wav",
        "npc/metropolice/gear4.wav",
        "npc/metropolice/gear5.wav",
        "npc/metropolice/gear6.wav",
    },

    [TEAM_VORT] = {
        "npc/vort/vort_foot1.wav",
        "npc/vort/vort_foot2.wav",
        "npc/vort/vort_foot3.wav",
        "npc/vort/vort_foot4.wav",
    },

}

-- note: npc/footsteps/hardboot_generic1.wav for rebels
function SCHEMA:PlayerShouldGetHungry(ply)
    return ply:Team() != TEAM_OTA
end

local BodygroupList = {}

for k, v in ipairs(impulse.Config.RebelSuits) do
    for num, id in ipairs(v.id) do
        BodygroupList[id] = true
    end
end

local footstep_vol = 42

function SCHEMA:PlayerFootstep(ply, pos, foot, sound, volume, filter)
    if not ply.WalkDelay then
        ply.WalkDelay = CurTime()
    end

    if ply.WalkDelay > CurTime() then return end

    if ply:IsSprinting() then
        footstep_vol = 90
        ply.WalkDelay = CurTime()
    else
        footstep_vol = 42
        ply.WalkDelay = CurTime() + .4
    end


    if (ply:GetVelocity():Length() >= 80) then

        if Footsteps_Sounds[ply:Team()] then
            -- ply:EmitSound(table.Random(Footsteps_Sounds[ply:Team()]), 80, 100, footstep_vol )
            ply:EmitSound(table.Random(Footsteps_Sounds[ply:Team()]), footstep_vol, nil, nil, nil, nil, 1)
        elseif BodygroupList[ply:GetBodygroup(1)] then -- cant be bothered
            -- ply:EmitSound(table.Random(REBEL_Footsteps), 80, 100, footstep_vol )
            ply:EmitSound(table.Random(REBEL_Footsteps), footstep_vol, nil, nil, nil, nil, 1)
        end

    end

    return false -- Don't allow default footsteps, or other addon footsteps
end

function SCHEMA:PlayerJailed(ply)
	if ply:Team() == TEAM_VORT and ply:GetModel() == "models/vortigaunt.mdl" then
		ply:SetModel("models/vortigaunt_slave.mdl")
	end

	if ply:GetSyncVar(SYNC_DISPATCH_BOL, nil) then
		ply:RemoveDispatchBOL()
	end
end

function SCHEMA:PlayerChangedTeam(ply, oldTeam, newTeam)
    if (oldTeam == TEAM_CP) or (oldTeam == TEAM_OTA) then
        ply:SetRPName(ply:GetSavedRPName(), false)
    end
end


local Citizen_Hurt = {
    "vo/npc/male01/pain01.wav",
    "vo/npc/male01/pain02.wav",
    "vo/npc/male01/pain03.wav",
    "vo/npc/male01/pain04.wav",
    "vo/npc/male01/pain05.wav",
    "vo/npc/male01/pain06.wav",
    "vo/npc/male01/pain07.wav",
    "vo/npc/male01/pain08.wav",
    "vo/npc/male01/pain09.wav",
}
local Female_Citizen_Hurt = {
    "vo/npc/female01/pain01.wav",
    "vo/npc/female01/pain02.wav",
    "vo/npc/female01/pain03.wav",
    "vo/npc/female01/pain04.wav",
    "vo/npc/female01/pain05.wav",
    "vo/npc/female01/pain06.wav",
    "vo/npc/female01/pain07.wav",
    "vo/npc/female01/pain08.wav",
    "vo/npc/female01/pain09.wav",
}


local HurtList = {

    [TEAM_OTA] = {
        "npc/combine_soldier/pain1.wav",
        "npc/combine_soldier/pain2.wav",
        "npc/combine_soldier/pain3.wav"
    },

    [TEAM_CP] = {
		"npc/metropolice/pain1.wav",
		"npc/metropolice/pain2.wav",
		"npc/metropolice/pain3.wav",
		"npc/metropolice/pain4.wav"
    },

    [TEAM_VORT] = {
        "vo/npc/vortigaunt/vortigese02.wav",
        "vo/npc/vortigaunt/vortigese03.wav",
        "vo/npc/vortigaunt/vortigese04.wav",
        "vo/npc/vortigaunt/vortigese05.wav",
        "vo/npc/vortigaunt/vortigese06.wav",
        "vo/npc/vortigaunt/vortigese07.wav",
    },

    [TEAM_CA] = {
        "vo/npc/male01/pain01.wav",
        "vo/npc/male01/pain02.wav",
        "vo/npc/male01/pain03.wav",
        "vo/npc/male01/pain04.wav",
        "vo/npc/male01/pain05.wav",
        "vo/npc/male01/pain06.wav",
        "vo/npc/male01/pain07.wav",
        "vo/npc/male01/pain08.wav",
        "vo/npc/male01/pain09.wav",
    },

}

function SCHEMA:PlayerHurt(victim, attacker, healthremaining, damagetaken)

    if (victim.nexthurtpain or 0) > CurTime() then return end

    if (HurtList[victim:Team()]) then
        victim:EmitSound(table.Random(HurtList[victim:Team()]), 80, 100, 12)
    elseif (victim:IsFemale()) then
        victim:EmitSound(table.Random(Female_Citizen_Hurt), 80, 100, 12)
    else
        victim:EmitSound(table.Random(Citizen_Hurt), 80, 100, 12)
    end

	victim.nexthurtpain = CurTime() + 0.33
end

local DeathSounds = {

    [TEAM_VORT] = {
        "vo/npc/vortigaunt/vortigese09.wav",
    },

    [TEAM_CP] = {
        "npc/metropolice/die1.wav",
        "npc/metropolice/die2.wav",
        "npc/metropolice/die3.wav",
        "npc/metropolice/die4.wav",
    },

    [TEAM_OTA] = {
        "npc/combine_soldier/die1.wav",
        "npc/combine_soldier/die2.wav",
        "npc/combine_soldier/die3.wav",
    },
}

function SCHEMA:DoPlayerDeath( victim, attacker, dmg )
    local inflictor = dmg:GetInflictor()

    if DeathSounds[victim:Team()] then
        victim:EmitSound(table.Random(DeathSounds[victim:Team()]), 80, 100, 12)
    elseif (victim:IsFemale()) then
        victim:EmitSound(table.Random(Female_Citizen_Hurt), 80, 100, 12)
    else
        victim:EmitSound(table.Random(Citizen_Hurt), 80, 100, 12)
    end

    if victim.cpdemotes then
        victim.cpdemotes = 0
    end

    victim:StopSound("npc/vort/attack_charge.wav") -- just incase

    if victim:GetMoney() >= 20000 then
        victim:AchievementGive("ach_costlydeath")
    end

    local invWeight = victim.InventoryWeight or 0

    if invWeight >= 15 then
        victim:AchievementGive("ach_deadweight")
    end


    if victim:IsCP() and inflictor.MolotovOwner then
        local ownah = inflictor.MolotovOwner
        ownah:AchievementGive("ach_scrombine")
    end

    if IsValid(attacker) and attacker:IsPlayer() then

        if victim:SteamID64() == "76561198347207730" then -- is will
            attacker:AchievementGive("ach_willmaster")
        end

        if victim:Team() == TEAM_COUNCIL then
            attacker:AchievementGive("ach_council_kill")
        end

        if victim:SteamID64() == "76561198353657587" then -- is 2freele
            attacker:AchievementGive("ach_johnlaw")
        end

        if victim:Team() == TEAM_OTA and attacker:Health() == 1 then
            attacker:AchievementGive("ach_closeshave")
        end

        if victim:GetXP() <= 30 then
            attacker:AchievementGive("ach_bambikiller")
        end

        if victim:Team() == TEAM_CA and attacker:GetSyncVar(SYNC_COS_FACE, false) == 4 then
            attacker:AchievementGive("ach_unknownkiller")
        end

        if inflictor and IsValid(inflictor) and victim:GetPos():DistToSqr(attacker:GetPos()) >= 15500047.7401 then -- 100m in unrooted src units
			attacker:AchievementGive("ach_quickshot")
		end
        if attacker:GetActiveWeapon():GetClass() == "ls_pickaxe" and victim:Team() == TEAM_CP then
            if not attacker.AmountOfCMBPickaxe then
                attacker.AmountOfCMBPickaxe = 0
            end
    
            attacker.AmountOfCMBPickaxe = attacker.AmountOfCMBPickaxe + 1
    
            local timername = attacker:SteamID64() .. ".PickaxeCPCounter"
    
            if not timer.Exists(timername) then
                timer.Create(timername, 240, 1, function()
                    attacker.AmountOfCMBPickaxe = 0
                end)
            end
    
            if attacker.AmountOfCMBPickaxe >= 3 then
                attacker:AchievementGive("ach_clobberer")
            end
        end
    
        if inflictor.IsIED and victim:IsCP() then
            if not attacker.AmountOfCMBIed then
                attacker.AmountOfCMBIed = 0
            end
    
            attacker.AmountOfCMBIed = attacker.AmountOfCMBIed + 1
    
            local timername = attacker:SteamID64() .. ".IEDCmbCounter"
    
            if timer.Exists(timername) then timer.Remove(timername) end
    
            timer.Create(timername, 20, 1, function()
                attacker.AmountOfCMBIed = 0
            end)
    
            if attacker.AmountOfCMBIed >= 5 then
                attacker:AchievementGive("ach_thumb")
            end
    
        end

        if attacker and (victim != attacker) and not attacker:Alive() then
            attacker:AchievementGive("ach_fromthegrave")
        end
    end

end

local attacker
function SCHEMA:ScalePlayerDamage(ply, hitgroup, dmginfo)
    attacker = dmginfo:GetAttacker()

    if (ply:IsCP() and ply:GetSyncVar(SYNC_COS_HEAD) == 2 ) then -- 2 is the id for the riot helmet
        if attacker:GetActiveWeapon().Base == "ls_base_melee" then
            dmginfo:ScaleDamage(0.85)
        end
    end

    -- straight up stolen from the landis files, sorry nick and vin!
    if ply.HasOTAVest and (hitgroup == HITGROUP_CHEST or hitgroup == HITGROUP_STOMACH) then -- makeshift rebel vest
		dmginfo:ScaleDamage(0.55)
        ply:EmitSound("player/kevlar" .. math.Round(1, 4) .. ".wav")
	-- elseif ply.HasEliteOTAVest and (hitgroup == HITGROUP_CHEST or hitgroup == HITGROUP_STOMACH) then -- makeshift rebel vest
	-- 	dmginfo:ScaleDamage(0.4)
	elseif ply.HasHelmet and hitgroup == HITGROUP_HEAD then
		dmginfo:ScaleDamage(0.7)
        ply:EmitSound("player/bhit_helmet-1.wav")
	end
end

local team_radiostyle = {[TEAM_CP] = true, [TEAM_OTA] = true}

function SCHEMA:ChatClassMessageSend(classID, message, ply)
	if message == "!eprotect" and not ply:IsAdmin() then return "" end

    local sound_list = {}

    if (not ply:Alive()) then return message end

    if team_radiostyle[ply:Team()] then 
        message = "<:: " .. message .. " ::>"
    end

    for _, definition in ipairs(impulse.Voice.GetClass(ply)) do
		local sounds, message = impulse.Voice.GetVoiceList(definition.class, message)

        if (sounds) then

            if (definition.onModify) then
				if (definition.onModify(ply, sounds, classID, message) == false) then
					continue
				end
			end
            for i, w in ipairs(sounds) do
                table.insert(sound_list, i, w[1])
            end

            local queue = 0

            for i = 1, #sound_list do
                timer.Simple(queue, function()
                    if IsValid(ply) then
                        ply:EmitSound(sound_list[i], 80, 100, 1)
                    end
                end)
                queue = queue + SoundDuration(sound_list[i]) + .22
            end

            return message
        end
    end

    return message
end

function SCHEMA:OnRadgollCreation(ragdoll, ply, attacker)

	if not IsValid(attacker) or not attacker:IsPlayer() then return end

	if ply == attacker then return end

    local GoldenGuns = {
        ["ls_pewpew"] = true,
        ["ls_goldengun"] = true
    }

	if GoldenGuns[attacker:GetActiveWeapon():GetClass()] then
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
        ragdoll:SetMaterial("gold_tool/australium")
	end
end
local wep_chance = 74
local ammo_chance = 56
function SCHEMA:PlayerDropDeathItems(victim, attacker, pos, dropped, inv)
    if (victim:Team() == TEAM_CP or victim:Team() == TEAM_OTA) and (victim:GetTeamClass() != nil) then
        local random = math.random(1, 100)
        local MainItemToDrop

        for k, v in ipairs(inv) do
            if (v.class == "wep_pistol") then
                MainItemToDrop = v.class
            elseif (v.class == "wep_shotgun") then
                MainItemToDrop = v.class
            elseif (v.class == "wep_smg") then
                MainItemToDrop = v.class
            elseif (v.class == "wep_357") then
                MainItemToDrop = v.class
            end
        end

        impulse.Inventory.SpawnItem("util_combinescrap", pos)

        -- // // // // // // // // //
        -- // DEBUG STUFF // // // //
        -- // // // // // // // // //
        -- print(random)
        -- if random >= ammo_chance then
        --     print("ammo true")
        -- end

        -- if random >= wep_chance then
        --     print("weapon true")
        -- end
        -- // // // // // // // // //
        -- // // // // // // // // //

        if MainItemToDrop == "wep_smg" then
            if random >= ammo_chance then
                impulse.Inventory.SpawnItem("ammo_smg", pos)
            elseif random >= wep_chance then
                impulse.Inventory.SpawnItem("wep_smg", pos)
            end
        elseif MainItemToDrop == "wep_pistol" then
            if random >= ammo_chance then
                impulse.Inventory.SpawnItem("ammo_pistol", pos)
            elseif random >= wep_chance then
                impulse.Inventory.SpawnItem("wep_pistol", pos)
            end
        elseif MainItemToDrop == "wep_357" then

            -- local RevolverChance = math.random(1, 100)

            if random >= ammo_chance then
                impulse.Inventory.SpawnItem("ammo_357", pos)
            elseif random >= wep_chance then
                impulse.Inventory.SpawnItem("wep_357", pos)
            end
        elseif MainItemToDrop == "wep_shotgun" then

            if random >= ammo_chance then
                impulse.Inventory.SpawnItem("ammo_buckshot", pos)
            elseif random >= wep_chance then
                impulse.Inventory.SpawnItem("wep_shotgun", pos)
            end

        end

        if (victim:Team() == TEAM_OTA) then
            if random >= 90 then
                impulse.Inventory.SpawnItem("util_ruinedotavest", pos)
            end
        end

    end
end



function SCHEMA:ChatStateChanged(ply, state, istyping)
    if (ply:Team() == TEAM_CP) then

        if istyping then
            ply:EmitSound("npc/metropolice/vo/on" .. math.random(1, 2) .. ".wav", 85, 100, 1)
        else
            ply:EmitSound("npc/metropolice/vo/off" .. math.random(1, 4) .. ".wav", 85, 100, 1)
        end
    elseif (ply:Team() == TEAM_OTA) then

        if istyping then
            ply:EmitSound("npc/combine_soldier/vo/on" .. math.random(1,2) .. ".wav", 85, 100, 1)
        else
            ply:EmitSound("npc/combine_soldier/vo/off" .. math.random(1,3) .. ".wav", 85, 100, 1)
        end
    end
end

-- Workshift System

if (not GetGlobal2Int("ImpulseWorkshiftTimer", false)) then
    print("making impulseworkshifttimer")
    SetGlobal2Int("ImpulseWorkshiftTimer", 0)
end
impulse.WorkshiftDelay = impulse.WorkshiftDelay or CurTime()
impulse.WorkshiftEnabled = impulse.WorkshiftEnabled or false

-- Ration System

if (not GetGlobal2Int("ImpulseRationTimer", false)) then
    print("making impulesrationtimer")
    SetGlobal2Int("ImpulseRationTimer", 0)
end

if (GetGlobal2Bool("ImpulseRationAvailable", "nil") == "nil") then
    print("making impulesrationavailable")
    SetGlobal2Bool("ImpulseRationAvailable", false)
end

local function StartRation()
    local text = "Attention Citizens, the ration distribution center is now open."
    local audio

    for v,k in pairs(player.GetAll()) do

        k.RationTaken = false

        k:SendChatClassMessage(56, text)

        local data = impulse.Config.CitySounds or false

        if data and (data["ration_start"]) then
            audio = impulse.Config.CitySounds["ration_start"].audio
        else
            audio = "npc/overwatch/cityvoice/f_confirmcivilstatus_1_spkr.wav"
        end

        k:EmitSound(audio, 50, nil, nil, CHAN_USER_BASE)
    end


end

local function EndRation()
    local text = "Attention Citizens, the ration distribution center is now closed."
    local audio

    for v,k in pairs(player.GetAll()) do

        k:SendChatClassMessage(56, text)

        local data = impulse.Config.CitySounds or false

        if data and (data["ration_end"]) then
            audio = impulse.Config.CitySounds["ration_end"].audio
        else
            audio = "npc/overwatch/cityvoice/f_ceaseevasionlevelfive_spkr.wav"
        end

        k:EmitSound(audio, 50, nil, nil, CHAN_USER_BASE)
    end

end

function SCHEMA:GravGunOnPickedUp(ply, ent)
    if ent:GetClass() == "impulse_cloth" then
        ent.PlayerPicker = ply
    end
end

function SCHEMA:Think()


    -- Ration Think
    if not GetGlobal2Bool("ImpulseRationAvailable") then
        if GetGlobal2Int("ImpulseRationTimer") < CurTime() then -- Ration On
            SetGlobal2Int("ImpulseRationTimer", CurTime() + impulse.Config.RationTimeBeforeEnding)
            -- SetGlobal2Int("ImpulseRationTimer", CurTime() + 800)
            SetGlobal2Bool("ImpulseRationAvailable", true)

            StartRation()
        end

    else
        if GetGlobal2Int("ImpulseRationTimer") < CurTime() then -- Ration Off
            SetGlobal2Int("ImpulseRationTimer", CurTime() + impulse.Config.RationTime)
            -- SetGlobal2Int("ImpulseRationTimer", CurTime() + 1)
            SetGlobal2Bool("ImpulseRationAvailable", false)

            EndRation()
        end
    end

end

function SCHEMA:CanPlayerChangeTeam(ply, newTeam)
    if ply.WasCouncil then
        ply:SetBodyGroups("0000000000")
        ply:ManipulateBoneScale(6, Vector(1, 1, 1))
        ply.WasCouncil = nil
    end

    if newTeam == TEAM_COUNCIL then
        if not ply.impulseData.Whitelist then return false end

        if not ply.impulseData.Whitelist["Council_WHITELIST"] then return false end

        if ply.impulseData and ply.impulseData.Whitelist then
            local retun = ply.impulseData.Whitelist["Council_WHITELIST"]
            if retun then
                timer.Simple(0, function()
                    ply:SetBodygroup(1, 2)
                    ply:SetBodygroup(2, 1)

                    ply.WasCouncil = true
                end)
            else
                return false
            end

        end
    end

	if impulse.Teams.Data[newTeam].cp and ply.impulseData and ply.impulseData.CombineBan then
		local endTime = ply.impulseData.CombineBan
		local curTime = os.time()

		if endTime > curTime then
			ply:Notify("You can not become this team as you have an active combine ban that will remain for "..string.NiceTime(endTime - curTime)..".")
			return false
		else
			ply.impulseData.CombineBan = nil -- garbage cleanup
			ply:SaveData()
		end
	end

    ply.MoneyPunishment = CurTime() + 300
    -- print("Money punishment " .. ply.MoneyPunishment)
end

local dancers = {}
hook.Add("PlayerShouldTaunt", "Achievement_Taunt", function(ply, act)
    if act == 1642 then
        local pos = table.insert(dancers, ply)

        timer.Simple(12, function()
            dancers[pos] = nil
        end)

        if table.Count(dancers) > 14 then
            for v,k in pairs(dancers) do
                if IsValid(k) then
                    k:AchievementGive("ach_party")
                end
            end

            dancers = {}
        end
    end
end)

hook.Add("PlayerCraftItem", "impulseAchCraft", function(ply, class)
    if class == "wep_axe" then
        ply:AchievementGive("ach_axe")
    end
end)

hook.Add("PlayerPurchaseDoor", "PurchaseApart", function(ply, door)
    ply:AchievementGive("ach_apt")
end)

hook.Add("PlayerGetXP", "impulseAchXP", function(ply, amount)
    ply:AchievementCheck("ach_addict")
end)

net.Receive("impulseAchPUTCWin", function(len, ply)
    if not ply.wtfisthisvin and ply.beenSetup then
        ply.wtfisthisvin = true
        ply:AchievementGive("ach_pickupthatcan")
    end
end)

hook.Add("PlayerAddSkillXP", "impulseAchXP", function(ply)
    ply:AchievementCheck("ach_jackofalltrades")
end)

function SCHEMA:PlayerInitialSpawnLoaded(ply)
    if ply.impulseData and ply.impulseData.WarData then
        net.Start("impulseGroupBroadcastWarData")
        net.WriteString(ply.impulseData.WarData)
        net.Send(ply)
    end

    if ply.impulseData and not ply.impulseData.HadXPReset then
		ply.impulseData.HadXPReset = true
        ply:SaveData()

        if ply:GetXP() > 100 then
            ply:SetXP(100)
            ply:Notify("Due to a decision change in the server, your XP has been reset back to 100.")
        end
    end

    if ply.impulseFirstJoin and ply.impulseFirstJoin < 1742745600 then -- unix epoch of 11/24/2019 (release first 30ish hours)
        ply:AchievementGive("ach_dayone")
    end
end

BmDVendor = BmDVendor or nil

if timer.Exists("BmDSpawner.Impulse") then
    timer.Remove("BmDSpawner.Impulse")
end

timer.Create("BmDSpawner.Impulse", 600, 0, function()
    if !impulse.Config.DealerLocations then return end
    local vendorid = {["vendor"] = "bmd"}
    local value = table.Random(impulse.Config.DealerLocations)

    if IsValid(BmDVendor) then
        BmDVendor:Remove()
    end

    timer.Simple(0, function()
        BmDVendor = ents.Create("impulse_vendor")
        BmDVendor:SetPos(value.pos)
        BmDVendor:SetAngles(value.ang)
        BmDVendor.impulseSaveKeyValue = vendorid
        BmDVendor:Spawn()
    end)

end)

util.AddNetworkString("PlayGestureAnimation")

function meta:PlayGestureAnimation(value)

	net.Start("PlayGestureAnimation")
	net.WriteEntity(self)
	net.WriteString(value)
	net.Broadcast()
end

-- function SCHEMA:PlayerUse(ply, ent)
-- end