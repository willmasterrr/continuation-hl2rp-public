surface.CreateFont("ApartmentDoorFont", {
    font = "BodoniXT",
    size = 30,
    weight = 800,
    antialias = true,
    shadow = true,
})
local doorCache = LocalPlayer().doorCache

net.Receive("NetworkApartments", function()
    local tbl = net.ReadTable()
    impulse.ApartmentBlocks = tbl
    doorCache = nil
end)

local textColor = Color(127, 89, 53, 255)
local isValid = IsValid
local cam = cam
local drawSimpleText = draw.SimpleText
hook.Add("PostDrawOpaqueRenderables", "APARTMENTDRAW", function()
    if (not impulse.ApartmentBlocks) then
        return
    end
    if not doorCache then
        doorCache = {}
        for v,k in pairs(impulse.ApartmentBlocks) do
            -- print(v:GetSyncVar(SYNC_DOOR_APARTMENT, "."))
            if v:GetSyncVar(SYNC_DOOR_APARTMENT, nil) then
                doorCache[v] = true
            end
        end
    end

    for v,k in pairs(doorCache) do
        local door = v
        local name = door:GetSyncVar(SYNC_DOOR_APARTMENT_NUM) or "Failed to return"
        if !isValid(v) or v:GetNoDraw() then
            continue
        end

        local doorPos = door:GetPos()
        local doorAng = door:GetAngles()

        local pos = door:GetPos()
        local ang = door:GetAngles()

        pos = pos + ang.Forward(ang) * 2
        pos = pos + ang.Right(ang) * -23
        pos = pos + ang.Up(ang) * 25

        ang.RotateAroundAxis(ang, doorAng.Up(doorAng), 90)
        ang.RotateAroundAxis(ang, doorAng.Right(doorAng), -90)

        cam.Start3D2D(pos, ang, 0.2)
            drawSimpleText(name, "ApartmentDoorFont", 0, 0, textColor, TEXT_ALIGN_CENTER)
        cam.End3D2D()

        ang.RotateAroundAxis(ang, doorAng.Right(doorAng), 180)
        ang.RotateAroundAxis(ang, doorAng.Forward(doorAng), 180)

        pos = pos + ang.Up(ang) * 3.1

        cam.Start3D2D(pos, ang, 0.2)
            drawSimpleText(name, "ApartmentDoorFont", 0, 0, textColor, TEXT_ALIGN_CENTER)
        cam.End3D2D()
    end
end)