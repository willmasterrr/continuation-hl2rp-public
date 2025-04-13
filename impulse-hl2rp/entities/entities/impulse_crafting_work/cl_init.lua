include('shared.lua')

local Types = {
    [0] = {name = "Manhack"},
    [1] = {name = "Rollermine"},
}

local Descriptions = {
    [1] = "Glue",
    [2] = "Scrap Metal",
    [3] = "Screws",
    [4] = "FUkC",
}

local Descriptions2 = {
    [1] = "Hammer Needed!",
    [2] = "Wrench Needed!",
    [3] = "Screwdriver Needed!",
    [4] = "FUkC",
}

function ENT:Draw()
    self:DrawModel()
    self.HUDName = Types[self:GetID()].name
    if (self:GetWhatToUse() == 4) then
        self.HUDDesc = "Finished!"
    else
        -- print(self:GetWhatToUse(), Descriptions[self:GetWhatToUse()])
        if not self:GetIsPuttedIn() then
            self.HUDDesc =  "(" .. Descriptions[self:GetWhatToUse()] .. " Needed!) - " .. math.floor(self:GetWork()) .. "%"
        else
            self.HUDDesc =  "(" .. Descriptions2[self:GetWhatToUse()] .. ") - " .. math.floor(self:GetWork()) .. "%"
        end
    end
end