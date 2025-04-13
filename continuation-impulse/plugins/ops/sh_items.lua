if CLIENT then
    net.Receive("impulseOpsItemSpawner", function()
        local panel = vgui.Create("DFrame")
        panel:SetSize(ScrW() / 1.5, ScrH() / 1.25)
        panel:Center()
        panel:SetTitle("Item Spawner")
        panel:MakePopup()

        local targetBox = vgui.Create("DComboBox", panel)
        targetBox:Dock(TOP)
        targetBox:SetWide(400)

        targetBox:AddChoice("Me")
        targetBox:AddChoice("Custom SteamID (Offline User)")

        for v, k in player.Iterator() do
            targetBox:AddChoice("PLAYER: "..k:Nick().." ("..k:SteamName()..")", k:SteamID())
        end

        targetBox:SetSortItems(false)

        local valuee = vgui.Create("DNumSlider", panel)
        valuee:Dock(TOP)
        valuee:SetWide(400)
        valuee:SetText( "Amount of items" )
        valuee:SetMin( 1 )
        valuee:SetMax( 50 )
        valuee:SetValue( 1 )
        valuee:SetDecimals( 0 )

        function targetBox:OnSelect(index, text, sid)
            if text == "Me" then
                panel.Selected = LocalPlayer():SteamID()
            elseif text == "Custom SteamID (Offline User)" then
                Derma_StringRequest("impulse", "Enter the SteamID (not 64 format) below:", "", function(sid)
                    if IsValid(panel) then
                        sid = string.Trim(sid, " ")
                        panel.Selected = sid
                        self:SetText("Custom SteamID ("..sid..")")
                    end
                end)
            else
                panel.Selected = sid
            end
        end

        local scroll = vgui.Create("DScrollPanel", panel)
        scroll:Dock(FILL)

        local cats = {}

        for v, k in pairs(impulse.Inventory.Items) do
            if not cats[k.Category or "Unknown"] then
                local cat = scroll:Add("DCollapsibleCategory")
                cat:Dock(TOP)
                cat:SetLabel(k.Category or "Unknown")

                cats[k.Category or "Unknown"] = vgui.Create("DTileLayout", panel)
                local layout = cats[k.Category or "Unknown"]
                layout:Dock(FILL)
                layout:SetBaseSize(128)
                layout:SetSpaceX(5)
                layout:SetSpaceY(5)
                layout:SetBorder(5)

                cat:SetContents(layout)
            end

            local btn = vgui.Create("DButton", cats[k.Category or "Unknown"])
            btn:SetText("")
            btn:SetSize(256, 128)
            btn.ItemClass = k.UniqueID

            function btn:DoClick()
                local fack = valuee:GetValue() or 1
                if not panel.Selected then
                    return LocalPlayer():Notify("No target selected.")
                end

                LocalPlayer():ConCommand("say /giveitem "..panel.Selected.." "..self.ItemClass.." "..fack)
            end

            local label = vgui.Create("DLabel", btn)
            label:SetText(k.Name .. " | " .. k.UniqueID)
            label:SetFont("Impulse-Elements14")
            label:SizeToContents()
            label:SetPos(btn:GetWide() / 2 - label:GetWide() / 2, 4)

            local mdl = vgui.Create("DModelPanel", btn)
            mdl:SetModel(Model(k.Model or "models/props_junk/watermelon01.mdl"))

            function mdl:LayoutEntity(ent)
                if k.Material then
                    ent:SetMaterial(k.Material)
                end

                if k.Skin then
                    ent:SetSkin(k.Skin)
                end
            end

            mdl:SetSize(128 - 16, 128 - 16)
            mdl:SetPos(btn:GetWide() / 2 - mdl:GetWide() / 2, 16)
            mdl:SetFOV(15)
            mdl:SetMouseInputEnabled(false)
            mdl:SetCamPos(Vector(50, 50, 50))
            mdl:SetLookAt(vector_origin)
        end
    end)
else
    util.AddNetworkString("impulseOpsItemSpawner")
end


local giveItemCommand = {
    description = "Gives a player the specified item. Use /itemspawner instead.",
    requiresArg = true,
    superAdminOnly = true,
    onRun = function(ply, arg, rawText)
        if not ply:IsSuperAdmin() then
            return
        end

        local steamid = arg[1]
        local item = arg[2]
        local howmanytimes = tonumber(arg[3]) or 1

        if not tonumber(howmanytimes) then return end

        if not item then
            return ply:Notify("No item uniqueID supplied.")
        end

        if steamid:len() > 25 then
            return ply:Notify("SteamID too long.")
        end

        local query = mysql:Select("impulse_players")
        query:Select("id")
        query:Where("steamid", steamid)
        query:Callback(function(result)
            if not IsValid(ply) then
                return
            end

            if not type(result) == "table" or #result == 0 then
                return ply:Notify("This Steam account has not joined the server yet or the SteamID is invalid.")
            end

            if not impulse.Inventory.ItemsRef[item] then
                return ply:Notify("Item: "..item.." does not exist.")
            end

            local target = player.GetBySteamID(steamid)

            for i = 1, howmanytimes do
                if target and IsValid(target) then
                    target:GiveInventoryItem(item)
                    ply:Notify("You have given "..target:Nick().." a "..item..".")
                end
            end

            if target and IsValid(target) then return end

            local impulseID = result[1].id

            impulse.Inventory.DBAddItem(impulseID, item)
            ply:Notify("Offline player ("..steamid..") has been given a "..item..".")
        end)

        query:Execute()
    end
}

impulse.RegisterChatCommand("/giveitem", giveItemCommand)

local itemSpawnerCommand = {
    description = "Opens the item spawner.",
    superAdminOnly = true,
    onRun = function(ply, arg, rawText)
        if not ply:IsSuperAdmin() then
            return
        end

        net.Start("impulseOpsItemSpawner")
        net.Send(ply)
    end
}

impulse.RegisterChatCommand("/itemspawner", itemSpawnerCommand)