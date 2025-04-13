include('shared.lua')
local black = Color(0, 0, 0)
local fore = Color(255, 140, 0)

function ENT:Draw()
	self:DrawModel()

    if not self.GetDrillEndTime then
		return
	end


	if self:GetDrillEndTime() == 0 then
		if IsValid(self.Drill) then
			timer.Simple(0, function() 
                if IsValid(self.Drill) then 
                    self.Drill:Remove() 
                    hook.Remove("PostDrawTranslucentRenderables", "drillsssss")
                end 
            end)
		end

		return
	end

    local entPos = self:GetPos()
	local entAng = self:GetAngles()
    local pos = self:GetPos()
    local ang = self:GetAngles()

    pos = pos + (ang:Forward() * 26.5)
    pos = pos + (ang:Up() * 1.5)
    pos = pos + (ang:Right() * -19.5)

	ang:RotateAroundAxis(entAng:Up(), 180)

    if IsValid(self.Drill) then return end
    self.Drill = ents.CreateClientProp()
    self.Drill:SetModel("models/pd2_drill/drill.mdl")
    self.Drill:SetPos(pos)
    self.Drill:SetAngles(ang)
    self.Drill:SetParent(self)
    self.Drill:Spawn()

	hook.Add("PostDrawTranslucentRenderables", "drillsssss", function()

        if not IsValid(self) then
            return hook.Remove("PostDrawTranslucentRenderables", "drillsssss")
        end

        local entPos = self:GetPos()
        local entAng = self:GetAngles()
        local pos = self:GetPos()
        local ang = self:GetAngles()
        
        pos = pos + (ang:Up() * 9)
        pos = pos + (ang:Forward() * 19.8)
        pos = pos + (ang:Right() * -9.8)

        ang:RotateAroundAxis(entAng:Right(), 90)
        ang:RotateAroundAxis(entAng:Up(), 150)
        ang:RotateAroundAxis(entAng:Forward(), -90)

        cam.Start3D2D(pos, ang, 0.07)
            surface.SetDrawColor(black)
            surface.DrawRect(0, 0, 105, 85)

            draw.DrawText("TIME LEFT:", "DebugFixed", 7, 4, fore, TEXT_ALIGN_LEFT)
            local delta = math.Clamp(self:GetDrillEndTime() - CurTime(), 0, 999)
            draw.DrawText(string.FormattedTime(delta, "%02i:%02i:%02i"), "DebugFixed", 7, 21, fore, TEXT_ALIGN_LEFT)
        cam.End3D2D()
    end)


    -- cam.Start3D2D(pos, ang, 0.07)
    --     surface.SetDrawColor(black)
    --     surface.DrawRect(0, 0, 105, 85)

    --     draw.DrawText("TIME LEFT:", "DebugFixed", 7, 4, fore, TEXT_ALIGN_LEFT)
    --     local delta = math.Clamp(self:GetDrillEndTime() - CurTime(), 0, 999)
    --     draw.DrawText(string.FormattedTime(delta, "%02i:%02i:%02i"), "DebugFixed", 7, 21, fore, TEXT_ALIGN_LEFT)
    -- cam.End3D2D()
end