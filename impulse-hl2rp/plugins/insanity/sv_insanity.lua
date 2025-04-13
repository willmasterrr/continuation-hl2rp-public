function PLUGIN:PlayerDeath(victim, inflictor, attacker)
    victim:StopInsane()
end

function PLUGIN:OnPlayerChangedTeam(ply, oldTeam, newTeam)
	if newTeam != TEAM_CITIZEN or newTeam != TEAM_CWU then
		ply:StopInsane()
	end
end

function meta:StopInsane()
	self:SetLocalSyncVar(SYNC_INSANE, nil)

    if timer.Exists("Insanity."..self:SteamID64()) then
		timer.Remove("Insanity."..self:SteamID64())
	end
end

function meta:MakeInsane()
    local timer_name = "Insanity."..self:SteamID64()

    if timer.Exists(timer_name) then return end

	self:SetLocalSyncVar(SYNC_INSANE, 1)

    timer.Create(timer_name, 160, 6, function()

        local cur = self:GetSyncVar(SYNC_INSANE, 0)

        if IsValid(self) and self:Alive() then

            if cur == 5 then
                timer.Simple(math.random(200, 600), function()
                    if IsValid(self) and self:GetSyncVar(SYNC_INSANE, false) and self:Alive() then
                        self:SetLocalSyncVar(SYNC_INSANE, cur + 1)
                    end
                end)
            else
                self:SetLocalSyncVar(SYNC_INSANE, cur + 1)

                if self:GetSyncVar(SYNC_INSANE, 0) == 2 then
                    self:AchievementGive("ach_insane")
                end
            end


        end
    end)
end