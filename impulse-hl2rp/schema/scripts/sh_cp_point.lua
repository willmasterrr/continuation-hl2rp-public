
if SERVER then
    local function SaveToDatabase(ply)
        ply.impulseData.CMBPoints = ply:GetSyncVar(SYNC_CMBPOINTS, 0)
        ply:SaveData()
    end

    function SCHEMA:PlayerInitialSpawnLoaded(ply)
        if !ply.impulseData then
            return ply:SetSyncVar(SYNC_CMBPOINTS, 0, true)
        end

        local point = ply.impulseData.CMBPoints or 0
        ply:SetSyncVar(SYNC_CMBPOINTS, point, true)
    end

    function meta:SetLoyalPoints(value)
        self:SetSyncVar(SYNC_CMBPOINTS, value, true)

        ReqwestLog({
            {
                description = self:Nick() .. "(" .. self:SteamName() .. ")(" .. self:SteamID() .. ") had his Loyalist Points set to " .. value .. ".",
                color = 16711680, -- Red color (in decimal)
            }
        })

        SaveToDatabase(self)
    end

    function meta:GiveLoyalPoints(value)
        local points = self:GetSyncVar(SYNC_CMBPOINTS) or 0
        points = points + value
        self:SetSyncVar(SYNC_CMBPOINTS, points, true)

        ReqwestLog({
            {
                description = self:Nick() .. "(" .. self:SteamName() .. ")(" .. self:SteamID() .. ") has received " .. value .. " Loyalist Points.",
                color = 16711680, -- Red color (in decimal)
            }
        })

        SaveToDatabase(self)
    end

    function meta:RemoveLoyalPoints(value)
        local points = self:GetSyncVar(SYNC_CMBPOINTS) or 0
        points = points - value

        if points < 0 then points = 0 end

        ReqwestLog({
            {
                description = self:Nick() .. "(" .. self:SteamName() .. ")(" .. self:SteamID() .. ") had " .. value .. " removed from his Loyalist Points.",
                color = 16711680, -- Red color (in decimal)
            }
        })

        self:SetSyncVar(SYNC_CMBPOINTS, points, true)

        SaveToDatabase(self)
    end
end