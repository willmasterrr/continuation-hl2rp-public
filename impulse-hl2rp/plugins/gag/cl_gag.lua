function PLUGIN:HUDPaint()
    local w, h = ScrW(), ScrH()
    local time = LocalPlayer():GetSyncVar(SYNC_GAGTIME)
    if time then
        draw.SimpleText("You have been gagged for: " .. string.NiceTime(tonumber(time) - os.time()) .. "!", "Impulse-Elements18", w * 1 - 4, 1, color_white, TEXT_ALIGN_RIGHT)
    end
end