AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
include('shared.lua')

function ENT:Initialize()
	self:SetModel("models/Items/ammocrate_smg1.mdl")

	self:SetUseType(SIMPLE_USE)
    self:SetMoveType(MOVETYPE_NONE)
    self:SetSolid(SOLID_BBOX)
    self:PhysicsInit(SOLID_BBOX)
    self:DrawShadow(false)
    local physObj = self:GetPhysicsObject()

    self.GlobalDelay = CurTime()

    if (IsValid(physObj)) then
		physObj:Wake()
		physObj:EnableMotion(false)
    end
end

function ENT:OnRemove()
end


local weplist = {
    ["ls_357"] = {amount = 94},
    ["ls_ak47"]  = {amount = 300},
    ["ls_ar2"]  = {amount = 300},
    ["ls_doublebarrel"]  = {amount = 94},
    ["ls_goldengun"]  = {amount = 94},
    ["ls_m60"]  = {amount = 300},
    ["ls_mini14"]  = {amount = 94},
    ["ls_mp7"]  = {amount = 300},
    ["ls_pewpew"]  = {amount = 94},
    ["ls_spas12"]  = {amount = 94},
    ["ls_usp"]  = {amount = 94},
}

function ENT:Use(activator, caller)

    if self.GlobalDelay > CurTime() then return end

    self.GlobalDelay = CurTime() + 3

    self:EmitSound("items/ammocrate_open.wav")
    self:ResetSequence(2)
    self:SetPlaybackRate(1)
    self:SetCycle(0)
    local data = weplist[caller:GetActiveWeapon():GetClass()] or {["base"] = {amount = 1}}
    local ammo = data.amount or false

    if (ammo) then
        caller:SetAmmo(ammo, caller:GetActiveWeapon():GetPrimaryAmmoType())
    else
        caller:SetAmmo(300, caller:GetActiveWeapon():GetPrimaryAmmoType())
    end

    timer.Simple(1.5, function()
        self:EmitSound("items/ammocrate_close.wav")
        self:ResetSequence(1)
        self:SetPlaybackRate(1)
        self:SetCycle(0)
    end)

    caller:Notify("Your ammo has been restocked.")
end