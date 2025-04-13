AddCSLuaFile()

SWEP.Base = "ls_base_melee"

SWEP.PrintName = "Screwdriver"
SWEP.Category = "impulse HL2RP Weapons"

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.HoldType = "knife"
SWEP.NoIronsights = true
SWEP.IsAlwaysRaised = false

SWEP.WorldModel = Model("models/weapons/w_atvorka.mdl")
SWEP.ViewModel = Model("models/weapons/w_atvorka.mdl")
--models/props_c17/tools_wrench01a.mdl
SWEP.ViewModelOffset = Vector(9.635, 8.557, -8.519)
SWEP.ViewModelOffsetAng = Angle(0, 0, -20)
SWEP.ViewModelFOV = 65
SWEP.UseHands = false

SWEP.Slot = 1
SWEP.SlotPos = 99

--SWEP.LowerAngles = Angle(15, -10, -20)

SWEP.CSMuzzleFlashes = false

SWEP.Primary.Sound = Sound("weapons/knife/knife_slash1.wav")
SWEP.Primary.ImpactSound = Sound("physics/metal/metal_box_impact_bullet1.wav")
SWEP.Primary.ImpactSoundWorldOnly = true
SWEP.Primary.Recoil = 2 -- base recoil value, SWEP.Spread mods can change this
SWEP.Primary.Damage = 1 -- not used in this swep
SWEP.Primary.NumShots = 1
SWEP.Primary.HitDelay = 0.3
SWEP.Primary.Delay = 0.4
SWEP.Primary.Range = 75
SWEP.Primary.StunTime = 0.3

SWEP.IgnoreStrengthLevelUP = true
SWEP.Primary.Automatic = true
SWEP.CurTimeDelay = CurTime()



function SWEP:PrePrimaryAttack()
	if SERVER then

		local data = math.random(1, 9999)
		if data > 9900 then
			self:GetOwner():Notify("Your arm became sore from working too much..")
			self:GetOwner():SelectWeapon("impulse_hands")
		end

		if self.CurTimeDelay < CurTime() then
			self.CurTimeDelay = CurTime() + self.Primary.Delay
	
			timer.Simple(self.Primary.HitDelay, function()
				local tr = self:GetOwner():GetEyeTrace()
				local ent = tr.Entity
				if (ent:GetClass() == "impulse_crafting_work" and ent.CanWork and ent.Level != 4) then
	
					if ent.Level == 3 then
						ent.workers[self:GetOwner()] = true

						ent:SetWork(ent:GetWork() + .4)

						if ent:GetWork() >= 100 then

							ent.Level = ent.Level + 1
							ent.PutObject = false
							ent:SetIsPuttedIn(false)
	
							if ent.Level == 4 then
								ent:Initialize_Type()
								ent:SetWork(0)
								ent.CanWork = false
								ent:SetWhatToUse(4)
							else
								ent:Initialize_Type()
								ent:SetWhatToUse(ent.Level)
							end
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
			local offsetVec = Vector(7.6, -1, -2)
			local offsetAng = Angle(180, 30, 20)

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

function SWEP:ClubAttack()
	local trace = {}
	trace.start = self.Owner:GetShootPos()
	trace.endpos = trace.start + self.Owner:GetAimVector() * (self.Primary.Range or 85)
	trace.filter = self.Owner
	trace.mask = MASK_SHOT_HULL

	local boxSize = self.Primary.HullSize or 6
	trace.mins = Vector(-boxSize, -boxSize, -boxSize)
	trace.maxs = Vector(boxSize, boxSize, boxSize)

	self.Owner:LagCompensation(true)

	local tr = util.TraceHull(trace)

	self.Owner:LagCompensation(false)

	if CLIENT then
		debugoverlay.BoxAngles(tr.HitPos, trace.mins, trace.maxs, self.Owner:EyeAngles(), 5, Color(200, 0, 0, 100))
	end

	if SERVER and tr.Hit then
		hook.Run("LongswordMeleeHit", self.Owner)

		if self.Primary.ImpactSound and not self.Primary.ImpactSoundWorldOnly then
			self.Owner:EmitSound(self.Primary.ImpactSound, 100, 100, .7)
		end

		if self.Primary.ImpactEffect then
			local effect = EffectData()
			effect:SetStart(tr.HitPos)
			effect:SetNormal(tr.HitNormal)
			effect:SetOrigin(tr.HitPos)

			util.Effect(self.Primary.ImpactEffect, effect, true, true)
		end

		local ent = tr.Entity

		if IsValid(ent) then
			local newdmg = hook.Run("LongswordCalculateMeleeDamage", self.Owner, self.Primary.Damage, ent)
			hook.Run("LongswordHitEntity", self.Owner, ent)

			-- local dmg = DamageInfo()
			-- dmg:SetAttacker(self.Owner)
			-- dmg:SetInflictor(self)
			-- dmg:SetDamage(newdmg or self.Primary.Damage)
			-- dmg:SetDamageType(DMG_CLUB)
			-- dmg:SetDamagePosition(tr.HitPos)

			-- if ent:GetClass() != "prop_ragdoll" then
			-- 	dmg:SetDamageForce(self.Owner:GetAimVector() * 10000)
			-- end

			-- ent:DispatchTraceAttack(dmg, trace.start, trace.endpos)

			if SERVER and ent:IsPlayer() then
				if self.Primary.FlashTime then
					ent:ScreenFade(SCREENFADE.IN, self.Primary.FlashColour or color_white, self.Primary.FlashTime, 0)
					ent.StunTime = CurTime() + self.Primary.FlashTime
					ent.StunStartTime = CurTime()
				elseif self.Primary.StunTime then
					ent.StunTime = CurTime() + self.Primary.StunTime
					ent.StunStartTime = CurTime()
				end
			end

			if tr.MatType == MAT_FLESH then
				ent:EmitSound("Flesh.ImpactHard")

				local effect = EffectData()
				effect:SetStart(tr.HitPos)
				effect:SetNormal(tr.HitNormal)
				effect:SetOrigin(tr.HitPos)

				util.Effect("BloodImpact", effect, true, true)
			elseif tr.MatType == MAT_WOOD then
				ent:EmitSound("Wood.ImpactHard")
			elseif tr.MatType == MAT_CONCRETE then
				ent:EmitSound("Concrete.ImpactHard")
			elseif self.Primary.ImpactSoundWorldOnly then
				self.Owner:EmitSound(self.Primary.ImpactSound, 100, 100, .7)

			end
		elseif self.MeleeHitFallback and self.MeleeHitFallback(self, tr) then
			return
		elseif self.Primary.ImpactSoundWorldOnly then
			self.Owner:EmitSound(self.Primary.ImpactSound, 100, 100, .7)

		end
	end
end

function SWEP:PrimaryAttack()
	if self.PrePrimaryAttack then
		self.PrePrimaryAttack(self)
	end

	if self.Primary.HitDelay then
		timer.Simple(self.Primary.HitDelay, function()
			if IsValid(self) and IsValid(self.Owner) then
				self:ClubAttack()
				self:ViewPunch()
			end
		end)
	else
		self:ClubAttack()
		self:ViewPunch()
	end

	self:EmitSound(self.Primary.Sound)

	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)

	if self.DoFireAnim then
		self:PlayAnim(ACT_VM_PRIMARYATTACK)
	else
		self:SendWeaponAnim(ACT_VM_HITCENTER)
	end

	self.Owner:SetAnimation(PLAYER_ATTACK1)
end