local ITEM = {}

ITEM.UniqueID = "item_ied"
ITEM.Name = "Radio Frequency IED"
ITEM.Desc =  "Can cause remotely triggered explosions."
ITEM.Category = "Tools"
ITEM.Model = Model("models/weapons/w_c4_planted.mdl")
ITEM.FOV = 10.308022922636
ITEM.CamPos = Vector(-0.57306587696075, -91.117477416992, 98.567337036133)
ITEM.NoCenter = true
ITEM.Weight = 4

ITEM.Droppable = true
ITEM.DropOnDeath = false

ITEM.Illegal = true
ITEM.CanStack = false

ITEM.UseName = "Place"
ITEM.UseWorkBarTime = 1
ITEM.UseWorkBarName = "Placing..."
ITEM.UseWorkBarFreeze = true
ITEM.UseWorkBarSound = "weapons/c4/c4_plant.wav"

function ITEM:OnUse(ply, door)
	local freqs = {82.4, 87.9, 104.4, 115.4}
	local trace = {}
	trace.start = ply:EyePos()
	trace.endpos = trace.start + ply:GetAimVector() * 85
	trace.filter = ply

	local tr = util.TraceLine(trace)

	impulse.IEDS = impulse.IEDS or {}

	local ied = ents.Create("impulse_usable")
	ied:SetModel(self.Model)
	ied:SetPos(tr.HitPos)
	ied:SetAngles(ply:GetAngles())

	local phys = ied:GetPhysicsObject()

	if phys and IsValid(phys) then
		phys:SetMass(20)	
	end

	local freq = freqs[math.random(1, #freqs)]

	ied.Placer = ply
	ied.Freq = freq

	function ied:Use(ply)
		if self.Placer == ply then
			if ply:IsCP() then
				return
			end
			
			if not ply:CanHoldItem("item_ied") then
				return ply:Notify("You don't have enough space to pickup this item.")
			end
			
			ply:GiveInventoryItem("item_ied")
			ply:Notify("You have disarmed and picked up the IED.")
			table.RemoveByValue(impulse.IEDS, self)

			self:Remove()
		end
	end

	function ied:Kaboom()
		self:EmitSound("weapons/c4/c4_beep1.wav", 90)
		table.RemoveByValue(impulse.IEDS, self)

		game.AddParticles( "particles/fire_01.pcf" )
		PrecacheParticleSystem( "explosion_silo" )

		timer.Simple(1.5, function()
			if not IsValid(self) then
				return
			end

			local es = ents.Create("prop_physics")
			es:SetModel("models/props_c17/oildrum001.mdl")
			es:Spawn()
			es:SetPos(self:GetPos())
			es:SetRenderMode(RENDERGROUP_TRANSLUCENT)
			es:SetColor(Color(0, 0, 0, 0))
			es:SetMoveType(MOVETYPE_NONE)
			es:SetSolid(SOLID_NONE)
			es:PhysicsInit(SOLID_NONE)
			es:SetCollisionGroup(COLLISION_GROUP_WORLD)
			local es_phys = es:GetPhysicsObject()
			if IsValid(phys) then
				es_phys:EnableMotion(false) -- Stops it from moving
				es_phys:Sleep() -- Puts it to sleep to save performance
			end

			for k, v in pairs(ents.FindInSphere(self:GetPos(), 2500)) do
				if v:IsPlayer() and v:IsValid() then
					v:EmitSound("ambient/explosions/explode_2.wav", 50, nil, nil, CHAN_USER_BASE)
					v:EmitSound("music/stingers/hl1_stinger_song27.mp3", 50, nil, nil, CHAN_USER_BASE)
				end
			end

			-- ParticleEffect( "explosion_silo", self:GetPos(), Angle( 0, 0, 0 ) )
			ParticleEffectAttach("explosion_silo", PATTACH_ABSORIGIN, es, 0)

			for i = 1, 80 do
				local molotovfire = ents.Create("env_fire")
				molotovfire:SetPos(self:GetPos() + Vector(math.Rand(-240, 240), math.Rand(-240, 240), 0))
				molotovfire:SetKeyValue("firesize", "64")
				molotovfire:SetKeyValue("damagescale", "5")
				molotovfire:SetOwner(self.Placer)
				molotovfire:Spawn()
	
				if i <= 3 then
					molotovfire.emitter = true
					molotovfire:EmitSound("fire_medium")
					molotovfire:EmitSound("ambient/fire/ignite.wav")
				end
	
				molotovfire:Fire("StartFire", "", 0)

				timer.Simple(30, function()
					if IsValid(molotovfire) then
						if molotovfire.emitter then
							molotovfire:StopSound("fire_medium")
						end

						molotovfire:Remove()
					end
				end)
			end

			timer.Simple(30, function()
				es:Remove()
			end)


		    local debris = {}

	        for i=1,30 do
	        	local flyer = ents.Create("prop_physics")
				local x_rad = math.random(1, 90)
				local y_rad = math.random(1, 90)
				local z_rad = math.random(1, 90)
	        	flyer:SetPos(self:GetPos() + Vector(x_rad, y_rad, z_rad))

	        	if i > 4 then
	        		flyer:SetModel("models/props_debris/wood_chunk08b.mdl")
	        	else
	        		flyer:SetModel("models/combine_helicopter/bomb_debris_"..math.random(2, 3)..".mdl")
	        	end

	        	flyer:Spawn()
	        	flyer:Ignite(30)

	        	local phys = flyer:GetPhysicsObject()

	        	if phys and IsValid(phys) then
	        		phys:SetVelocity(Vector(math.random(-150, 150), math.random(-150, 150), math.random(-150, 150)))
	        	end

	        	table.insert(debris, flyer)
	        end


	        timer.Simple(40, function()
		        for v,k in pairs(debris) do
		        	if IsValid(k) then
		        		k:Remove()
		        	end
		        end
		    end)

			local explodeEnt = ents.Create("env_explosion")
	        explodeEnt:SetPos(self:GetPos())


	        if IsValid(self.Placer) then
	        	explodeEnt:SetOwner(self.Placer)
				explodeEnt.IsIED = true
	        end

	        explodeEnt:Spawn()
	        explodeEnt:SetKeyValue("iMagnitude", "325")
	        explodeEnt:Fire("explode", "", 0)

	        local fire = ents.Create("env_fire")
	        fire:SetPos(self:GetPos())
	        fire:Spawn()
	        fire:Fire("StartFire")

	        timer.Simple(60, function()
	        	if IsValid(fire) then
	        		fire:Remove()
	        	end
	        end)

			local effectData = EffectData()
			effectData:SetOrigin(self:GetPos())
			util.Effect("Explosion", effectData)

	        self:EmitSound("weapons/c4/c4_explode1.wav", 500)
	        self:EmitSound("weapons/c4/c4_exp_deb1.wav", 125)
	        self:EmitSound("weapons/c4/c4_exp_deb2.wav", 125)
	        self:EmitSound("ambient/atmosphere/terrain_rumble1.wav", 108)

	        for v,k in pairs(player.GetAll()) do
	        	k:SurfacePlaySound("ambient/levels/streetwar/city_battle7.wav")
	        end

	        util.ScreenShake(self:GetPos(), 4, 2, 2.5, 100000)

	        self:Remove()

	        local pos = self:GetPos()

	        timer.Simple(1, function()
	        	for v,k in pairs(ents.FindByClass("prop_ragdoll")) do
	        		if k:GetPos():DistToSqr(pos) < (1200 ^ 2) then
	        			k:Ignite(40)
	        		end
	        	end
	        end)
	    end)
	end

	ied:Spawn()

	table.insert(impulse.IEDS, ied)

	ply:Notify("IED touch-off frequency is "..freq..".")

	return true
end

impulse.RegisterItem(ITEM)
