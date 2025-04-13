AddCSLuaFile()

SWEP.Base = "ls_base_melee"

SWEP.PrintName = "Cleaver"
SWEP.Category = "impulse HL2RP Weapons"

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.HoldType = "grenade"
SWEP.NoIronsights = true

SWEP.WorldModel = Model("models/hitman6/cleaver.mdl")
SWEP.ViewModel = Model("models/hitman6/cleaver.mdl")
SWEP.ViewModelOffset = Vector(-10,0,15)
SWEP.ViewModelOffsetAng = Angle(80,0,180)
SWEP.ViewModelFOV = 65
SWEP.UseHands = false

SWEP.Slot = 4
SWEP.SlotPos = 1

SWEP.IgnoreStrengthLevelUP = true
SWEP.Primary.Automatic = true

--SWEP.LowerAngles = Angle(15, -10, -20)

SWEP.CSMuzzleFlashes = false

SWEP.Primary.Sound = Sound("weapons/iceaxe/iceaxe_swing1.wav")
SWEP.Primary.ImpactSound = Sound("npc/roller/blade_cut.wav")
SWEP.Primary.ImpactSoundWorldOnly = true
SWEP.Primary.Recoil = 4 -- base recoil value, SWEP.Spread mods can change this
SWEP.Primary.Damage = 10 -- not used in this swep
SWEP.Primary.NumShots = 1
SWEP.Primary.HitDelay = 0.3
SWEP.Primary.Delay = 0.4
SWEP.Primary.Range = 75
SWEP.Primary.StunTime = 0.3

SWEP.GoreDelay = 0
function SWEP:PrePrimaryAttack()
	if SERVER then
		if self.GoreDelay < CurTime() then
			self.GoreDelay = CurTime() + self.Primary.Delay
	
			timer.Simple(self.Primary.HitDelay, function()
				local trace = self:GetOwner():GetEyeTrace()
				local ent = trace.Entity
	
				if IsValid(ent) and ent:GetBoneCount() > 0 and ent:IsRagdoll() then
					local closestBone = nil
					local closestDist = math.huge
					local eyePos = trace.HitPos -- The exact position the player is aiming at
	
					for boneID = 0, ent:GetBoneCount() - 1 do
						local bonePos, _ = ent:GetBonePosition(boneID)
						if bonePos then
							local dist = bonePos:DistToSqr(eyePos) -- Squared distance (faster)
							if dist < closestDist then
								closestDist = dist
								closestBone = boneID
							end
						end
					end
	
					if closestBone then
						local boneName = ent:GetBoneName(closestBone)

						if boneName == "ValveBiped.forward" then
							closestBone = 6
							boneName = ent:GetBoneName(closestBone)
						end

						ent.bonelist = ent.bonelist or {}
	
						if not ent.bonelist[boneName] then
							ent.bonelist[boneName] = {hp = 16, id = closestBone, cuttedoff = false} 
						end

						local health = ent.bonelist[boneName].hp
						health = health - 1
						ent.bonelist[boneName].hp = health

						self:EmitSound(self.Primary.ImpactSound, 100, nil, nil, CHAN_USER_BASE)
						ent:EmitSound("player/pl_fallpain3.wav")

						if (ent.bonelist[boneName].hp < 1) and (not ent.bonelist[boneName].cuttedoff) then
							local bonepos = ent:GetBonePosition(ent.bonelist[boneName].id)
							ent:ManipulateBoneScale(ent.bonelist[boneName].id, Vector(0.001, 0.001, 0.001))
	
							impulse.Inventory.SpawnItem("food_suspiciousmeat", bonepos)


							ent.bonelist[boneName].cuttedoff = true

							ent:EmitSound("player/pl_fallpain1.wav")
						end
					end
				end
	
			end)
		end
	end
end

local CopyViewModelOrigin = SWEP.ViewModelFOV
function SWEP:PostDrawViewModel(viewmodel, player)
    self.ViewModelFOV = CopyViewModelOrigin + impulse.GetSetting("firstperson_fov")
end

if CLIENT then
	local WorldModel = ClientsideModel(SWEP.WorldModel)

	-- Settings...
	WorldModel:SetNoDraw(true)

	function SWEP:DrawWorldModel()
		local _Owner = self:GetOwner()

		if (IsValid(_Owner)) then
			-- Specify a good position
			local offsetVec = Vector(3.6, -3, -6)
			local offsetAng = Angle(90, 5, 90)

			local boneid = _Owner:LookupBone( "ValveBiped.Bip01_R_Hand" ) -- Right Hand
			if !boneid then return end

			local matrix = _Owner:GetBoneMatrix(boneid)
			if !matrix then return end

			local newPos, newAng = LocalToWorld(offsetVec, offsetAng, matrix:GetTranslation(), matrix:GetAngles())

			WorldModel:SetPos(newPos)
			WorldModel:SetAngles(newAng)

			WorldModel:SetupBones()
		else
			WorldModel:SetPos(self:GetPos())
			WorldModel:SetAngles(self:GetAngles())
		end

		WorldModel:DrawModel()
	end
end

function SWEP:MeleeHitFallback(tr)
	self:EmitSound("physics/metal/metal_canister_impact_hard" .. math.random(1,3) .. ".wav", 100, nil, nil, CHAN_USER_BASE)
	return false
end
