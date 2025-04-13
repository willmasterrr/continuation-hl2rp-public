local PANEL = {}

function PANEL:Init()
    self:SetSize(400, 400)
    self:Center()
    self:SetTitle("Example Menu")
    self:MakePopup()

    local btn = vgui.Create("DButton", self)
    btn:SetPos(10, 10)
    btn:SetSize(100, 30)
    btn:SetText("Press me!")
    
    function btn:DoClick()
        LocalPlayer():Notify("You pressed the test button!")
    end
end

vgui.Register("impulseExampleMenu", PANEL, "DFrame")
-- Call `local x = vgui.Create("impulseExampleMenu")` to load this UI in any clientside code