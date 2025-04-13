AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
include('shared.lua')

function ENT:Initialize()
    self:SetModel("models/props_junk/cardboard_box003b.mdl")

    self:SetUseType(SIMPLE_USE)
    self:SetMoveType(MOVETYPE_NONE)
    self:SetSolid(SOLID_BBOX)
    self:PhysicsInit(SOLID_BBOX)
    self:DrawShadow(false)
    local physObj = self:GetPhysicsObject()

    if (IsValid(physObj)) then
        physObj:Wake()
        physObj:EnableMotion(false)
    end
end

function ENT:Use(activator, caller)
    if (caller:Team() == TEAM_CWU and caller:GetTeamClass() == CLASS_INDUST) then
        if caller:HasWeapon("ls_wrench") then
            caller:StripWeapon("ls_wrench")
            caller:StripWeapon("ls_screwdriver")
            caller:StripWeapon("ls_hammer")
            caller:Notify("You putted back your tools.")
        else
            if impulse.WorkshiftEnabled then
                caller:Give("ls_wrench")
                caller:Give("ls_screwdriver")
                caller:Give("ls_hammer")
                caller:Notify("You grabbed your tools.")
            else
                caller:Notify("A workshift must happen to use this.")
            end
        end
    else
        caller:Notify("You have to be an industrial CWU to use this!")
    end
end