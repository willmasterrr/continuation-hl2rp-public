-- Taken for Half-Life 2 Tools addon (https://steamcommunity.com/sharedfiles/filedetails/?id=104619813), and adapted for impulse Event Manager
function MakeHeadcrabCanister( model, pos, ang, keyFire, keyOpen, keySpawn, fire_immediately, headcrab, count, speed, time, height, damage, radius, duration, spawnflags, smoke )
	if ( tobool( smoke ) ) then duration = -1 end

	fire_immediately = fire_immediately or false
	headcrab = headcrab or 0
	count = count or 6
	speed = speed or 3000
	time = time or 5
	height = height or 0
	damage = damage or 150
	radius = radius or 750
	duration = duration or 30
	spawnflags = 8192

	keyOpen = keyOpen or -1
	keyFire = keyFire or -1
	keySpawn = keySpawn or -1

	local env_headcrabcanister = ents.Create( "env_headcrabcanister" )
	if ( !IsValid( env_headcrabcanister ) ) then return false end
	env_headcrabcanister:SetPos( pos )
	env_headcrabcanister:SetAngles( ang )
	env_headcrabcanister:SetKeyValue( "HeadcrabType", headcrab )
	env_headcrabcanister:SetKeyValue( "HeadcrabCount", count )
	env_headcrabcanister:SetKeyValue( "FlightSpeed", speed )
	env_headcrabcanister:SetKeyValue( "FlightTime", time )
	env_headcrabcanister:SetKeyValue( "StartingHeight", height )
	env_headcrabcanister:SetKeyValue( "Damage", damage )
	env_headcrabcanister:SetKeyValue( "DamageRadius", radius )
	env_headcrabcanister:SetKeyValue( "SmokeLifetime", duration )
	env_headcrabcanister:SetKeyValue( "spawnflags", spawnflags )
	env_headcrabcanister:Spawn()
	env_headcrabcanister:Activate()

	if ( tobool( fire_immediately ) ) then env_headcrabcanister:Fire( "FireCanister" ) end

	table.Merge( env_headcrabcanister:GetTable(), {
		keyFire = keyFire,
		keyOpen = keyOpen,
		keySpawn = keySpawn,
		fire_immediately = fire_immediately,
		headcrab = headcrab,
		count = count,
		speed = speed,
		time = time,
		height = height,
		damage = damage,
		radius = radius,
		duration = duration,
		spawnflags = spawnflags,
		smoke = smoke
	} )

	DoPropSpawnedEffect( env_headcrabcanister )

	return env_headcrabcanister
end
