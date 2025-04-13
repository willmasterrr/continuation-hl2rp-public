function PLUGIN:PostSetupPlayer(ply)
    if ply.impulseData.Gagged then
        ply:SetSyncVar(SYNC_GAGTIME, ply.impulseData.Gagged, true)

        timer.Create(ply:SteamID64() .. ".GagCheck", 1, 0, function()
            if not ply.impulseData.Gagged then timer.Remove() end

            local endTime = ply.impulseData.Gagged
            local curTime = os.time()

            if not endTime or not curTime then return end

            if endTime < curTime then
                ply:RemoveTimeout()
            end
        end)
    end
end

function PLUGIN:PlayerDisconnected(ply)
    if timer.Exists(ply:SteamID64() .. ".GagCheck") then
        timer.Remove(ply:SteamID64() .. ".GagCheck")
    end
end

function meta:SetTimeout(mins)
    local time = tonumber(mins)
    time = time * 60

    local curT = os.time()
    local endT = curT + time

    
    self.impulseData.Gagged = endT
    self:SetSyncVar(SYNC_GAGTIME, self.impulseData.Gagged, true)

    self:SaveData()

    timer.Create(self:SteamID64() .. ".GagCheck", 1, 0, function()
        if not self.impulseData.Gagged and timer.Exists(self:SteamID64() .. ".GagCheck") then timer.Remove(self:SteamID64() .. ".GagCheck") end

        local endTime = self.impulseData.Gagged
        local curTime = os.time()


        if not endTime or not curTime then return end

        if endTime < curTime then
            self:RemoveTimeout()
        end
    end)
end

function meta:RemoveTimeout()
    
    self.impulseData.Gagged = nil
    self:SetSyncVar(SYNC_GAGTIME, nil, true)

    self:Notify("Your gag timeout has expired.")

    self:SaveData()
end

function PLUGIN:PlayerCanHearPlayersVoice(listener, talker)
    if talker.impulseData and talker.impulseData.Gagged then
        return false
    end
end