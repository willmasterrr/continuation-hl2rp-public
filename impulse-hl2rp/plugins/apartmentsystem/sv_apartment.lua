-- COMMAND LIST
-- impulse_door_remove_blockterminal
-- impulse_door_set_blockterminal 1 Terminal%sHotel
-- impulse_door_setapartment true 101 1

util.AddNetworkString("NetworkApartments")

impulse.ApartmentBlocks = impulse.ApartmentBlocks or {}
impulse.TerminalBlocks = impulse.TerminalBlocks or {}

file.CreateDir("impulse/apt_doors")

local fileName = "impulse/apt_doors/" .. game.GetMap()
local fileName2 = "impulse/apt_doors/apt_terminals/" .. game.GetMap()

function impulse.Doors.SaveApartment(k)
	local fl = file.Read(fileName..".dat")

	if fl then
		local doors = util.JSONToTable(fl)

		if k:IsDoor() and k:CreatedByMap() then
			doors[k:MapCreationID()] = {
				aptdata = k:GetSyncVar(SYNC_DOOR_APARTMENT, nil),
				apartment_number = k:GetSyncVar(SYNC_DOOR_APARTMENT_NUM, nil),
				pos = k:GetPos(),
			}
		end

		print("[impulse] Saving doors to impulse/apt_doors/"..game.GetMap()..".dat | Doors saved: "..#doors)
		file.Write(fileName..".dat", util.TableToJSON(doors))

		impulse.Doors.LoadApartment()
	else
		local doors = {}

		if k:IsDoor() and k:CreatedByMap() then
			doors[k:MapCreationID()] = {
				aptdata = k:GetSyncVar(SYNC_DOOR_APARTMENT, nil),
				apartment_number = k:GetSyncVar(SYNC_DOOR_APARTMENT_NUM, nil),
				pos = k:GetPos(),
			}
		end

		print("[impulse] Saving doors to impulse/apt_doors/"..game.GetMap()..".dat | Doors saved: "..#doors)
		file.Write(fileName..".dat", util.TableToJSON(doors))

		impulse.Doors.LoadApartment()
	end
end

function impulse.Doors.LoadConnectedDoors()
	local list = impulse.Config.AptsDoors

	for k, v in pairs(list) do
		for i, r in ipairs(v.doors) do
			if i == 1 then continue end
			local entity = Entity(r)
			local ParentDoor = Entity(v.doors[1])
			local tbl = {
				["isapt"] = true,
				["terminal_id"] = 0
			}

			entity:SetSyncVar(SYNC_DOOR_APARTMENT, util.TableToJSON(tbl), true)
			if (not IsValid(ParentDoor)) then print("[Impulse] Parentdoor is invalid.. what?") continue end

			if (ParentDoor.ConnectedDoors == nil) then
				ParentDoor.ConnectedDoors = {}
				ParentDoor.ConnectedDoors[entity] = true
			else
				ParentDoor.ConnectedDoors[entity] = true
			end
		end
		-- local poop = v["doors"]
		-- local count = table.Count(poop)
		-- local ParentDoor = Entity(poop[1])

		-- -- First one in the list is the parent door
		-- for i = 1, count do
		-- 	if i == 1 then continue end
		-- 	local id = poop[i]
		-- 	local entity = Entity(id)

		-- 	local tbl = {
		-- 		["isapt"] = true,
		-- 		["terminal_id"] = 0
		-- 	}

		-- 	entity:SetSyncVar(SYNC_DOOR_APARTMENT, util.TableToJSON(tbl), true)
		-- 	print(ParentDoor.ConnectedDoors)
		-- 	if (ParentDoor.ConnectedDoors == nil) then
		-- 		ParentDoor.ConnectedDoors = {}
		-- 		ParentDoor.ConnectedDoors[entity] = true
		-- 	else
		-- 		ParentDoor.ConnectedDoors[entity] = true
		-- 	end
		-- end



		-- if (ParentDoor.ConnectedDoors) then
		-- 	-- PrintTable(ParentDoor.ConnectedDoors)
		-- end
		-- print("_")


	end
end

function impulse.Doors.LoadApartment()
	impulse.Doors.ApartmentBlocks = {}

	if file.Exists(fileName .. ".dat", "DATA") then
		local mapDoorData = util.JSONToTable(file.Read(fileName .. ".dat", "DATA"))
		local posBuffer = {}
		local posFinds = {}
		-- use position hashes so we dont take several seconds
		for doorID, doorData in pairs(mapDoorData) do
			if not doorData.pos then
				continue
			end
			posBuffer[doorData.pos.x.."|"..doorData.pos.y.."|"..doorData.pos.z] = doorID
		end

		-- try to find every door via the pos value (update safeish)
		for v,k in pairs(ents.GetAll()) do
			local p = k.GetPos(k)
			local found = posBuffer[p.x.."|"..p.y.."|"..p.z]
			if found and k:IsDoor() then
				local doorEnt = k
				local doorData = mapDoorData[found]
				local doorIndex = doorEnt:EntIndex()
				posFinds[doorIndex] = true
				if doorData.aptdata then doorEnt:SetSyncVar(SYNC_DOOR_APARTMENT, doorData.aptdata, true) end
				if doorData.apartment_number then doorEnt:SetSyncVar(SYNC_DOOR_APARTMENT_NUM, doorData.apartment_number, true) end
				impulse.ApartmentBlocks[doorEnt] = true

				print("[impulse] Door saved via pos")

			end
		end

		-- and doors we couldnt get by pos, we'll fallback to hammerID's (less update safe) (old method)
		for doorID, doorData in pairs(mapDoorData) do
			local doorEnt = ents.GetMapCreatedEntity(doorID)

			if IsValid(doorEnt) and doorEnt:IsDoor() then
				local doorIndex = doorEnt:EntIndex()

				if posFinds[doorIndex] then
					continue
				end

				if doorData.aptdata then doorEnt:SetSyncVar(SYNC_DOOR_APARTMENT, doorData.aptdata, true) end
				if doorData.apartment_number then doorEnt:SetSyncVar(SYNC_DOOR_APARTMENT_NUM, doorData.apartment_number, true) end
				impulse.ApartmentBlocks[doorEnt] = true

				print("[impulse] Warning! Added apartment door by HammerID value because it could not be found via pos. Door index: "..doorIndex..". Please investigate.")
			end
		end

		timer.Simple(3, function()
			impulse.Doors.LoadConnectedDoors()

			net.Start("NetworkApartments")
			net.WriteTable(impulse.ApartmentBlocks)
			net.Broadcast()
		end)

		posBuffer = nil
		posFinds = nil
	end

end

function PLUGIN:PlayerInitialSpawnLoaded(ply)
	timer.Simple(2, function()
		net.Start("NetworkApartments")
		net.WriteTable(impulse.ApartmentBlocks)
		net.Send(ply)
	end)
end

concommand.Add("impulse_door_setapartment", function(ply, cmd, args)
	-- impulse_door_setapartment true 101 1
	local allowlist = {
		["true"] = true,
		["false"] = true,
	}
	if (!ply:IsSuperAdmin()) or (!args[2]) then return false end
	if !allowlist[args[1]] then return false end
	if !tonumber(args[3]) then return false end

	local trace = {}
	trace.start = ply:EyePos()
	trace.endpos = trace.start + ply:GetAimVector() * 200
	trace.filter = ply
	local traceEnt = util.TraceLine(trace).Entity

	if IsValid(traceEnt) and traceEnt:IsDoor() then
	traceEnt:SetSyncVar(SYNC_DOOR_APARTMENT_NUM, tostring(args[2]), true)

	local tbl = {
		["isapt"] = tobool(args[1]),
		["terminal_id"] = tonumber(args[3])
	}

	traceEnt:SetSyncVar(SYNC_DOOR_APARTMENT, util.TableToJSON(tbl), true)

		ply:Notify("Door " .. traceEnt:EntIndex() .. " set to apartment = " .. args[2])

		impulse.Doors.SaveApartment(traceEnt)
	else
		ply:Notify("This isnt a door!")
	end
end)

-- //// BLOCK TERMINAL SIDE ///

concommand.Add("impulse_door_set_blockterminal", function(ply, cmd, args)
	-- impulse_door_set_blockterminal 1 Terminal%sHotel
	-- print("Run")
	if (! ply:IsSuperAdmin()) then return false end

	if (!tonumber(args[1])) then
		return ply:Notify("The first arg has to be a number! Its the block terminal id.")
	end

	if (!tostring(args[2])) then
		return ply:Notify("The second arg has to be a string! its the title of the block terminal.")
	end

	local trace = {}
	trace.start = ply:EyePos()
	trace.endpos = trace.start + ply:GetAimVector() * 200
	trace.filter = ply
	local traceEnt = util.TraceLine(trace).Entity

	t = args[2]
	local numPlaceholders = select(2, t:gsub("%%s", ""))
	local values = {}
	for i = 1, numPlaceholders do
		values[i] = " "
	end
	local result = string.format(t, unpack(values))

	if IsValid(traceEnt) and traceEnt:GetClass() == "impulse_blockterminal" then
		local random_id = math.random(1, 10000)

		traceEnt:SetTerminalID(tonumber(args[1]))
		traceEnt:SetTerminalTitle(result)

		if (traceEnt.ent_id) then
			return ply:Notify("Theres no support to overwrite the terminal blocks, so please remove it and add a new one to modify it!")
		end

		traceEnt.ent_id = random_id

		-- // This part saves the terminal data on a dat file

		file.CreateDir("impulse/apt_doors/apt_terminals")
		local fl = file.Read( fileName2 .. ".dat")
		if (fl) then
			-- print("1")

			fl = util.JSONToTable(fl)

			fl[traceEnt:GetClass() .. "_" .. random_id] = {
				["term_id"] = traceEnt:GetTerminalID(),
				["term_name"] = traceEnt:GetTerminalTitle(),
				["ent"] = traceEnt:GetClass(),
				["id"] = random_id,
				["angles"] = traceEnt:GetAngles(),
				["pos"] = traceEnt:GetPos()
			}	

			file.Write(fileName2 .. ".dat", util.TableToJSON(fl))
		else
			-- print("2")
			local list = {}
			list[traceEnt:GetClass() .. "_" .. random_id] = {
				["term_id"] = traceEnt:GetTerminalID(),
				["term_name"] = traceEnt:GetTerminalTitle(),
				["ent"] = traceEnt:GetClass(),
				["id"] = random_id,
				["angles"] = traceEnt:GetAngles(),
				["pos"] = traceEnt:GetPos()
			}

			file.Write(fileName2 .. ".dat", util.TableToJSON(list))
		end

		impulse.TerminalBlocks[traceEnt:GetClass() .. "_" .. traceEnt.ent_id] = {ent = traceEnt}
		-- // End

		ply:Notify("set block terminal!")
	end
end)

concommand.Add("impulse_door_remove_blockterminal", function(ply, cmd, args)
	-- impulse_door_remove_blockterminal
	-- print("Run")
	if (!ply:IsSuperAdmin()) then return false end

	local trace = {}
	trace.start = ply:EyePos()
	trace.endpos = trace.start + ply:GetAimVector() * 200
	trace.filter = ply
	local traceEnt = util.TraceLine(trace).Entity

	if IsValid(traceEnt) and traceEnt:GetClass() == "impulse_blockterminal" then
		impulse.Doors.RemoveTerminalBlock(traceEnt)
		ply:Notify("block terminal should be removed..")
	end
end)

function impulse.Doors.RemoveTerminalBlock(ent)
	local fl = impulse.TerminalBlocks
	fileName2 = "impulse/apt_doors/apt_terminals/" .. game.GetMap()
	-- print("Hi")
	if (fl[ent:GetClass() .. "_" .. ent.ent_id]) then
		local id = ent.ent_id
		-- print("Hi2")
		local newlist = {}
		local p = file.Read( fileName2 .. ".dat")
		p = util.JSONToTable(p)

		if (p[ent:GetClass() .. "_" .. id]) then
			for k, v in pairs(p) do
				if (k == ent:GetClass() .. "_" .. id) then continue end

				newlist[k] = {
					["term_id"] = v.term_id,
					["term_name"] = v.term_name,
					["ent"] = v.ent,
					["id"] = v.id,
					["angles"] = v.angles,
					["pos"] = v.pos
				}
			end

			impulse.TerminalBlocks[ent:GetClass() .. "_" .. id] = nil
			ent:Remove()
			file.Write(fileName2 .. ".dat", util.TableToJSON(newlist))
		end
	end

	-- file.Write(fileName2 .. ".dat", util.TableToJSON(list))
end

function impulse.Doors.LoadTerminalBlocks()
	fileName2 = "impulse/apt_doors/apt_terminals/" .. game.GetMap()
	local fl = file.Read( fileName2 .. ".dat")
	impulse.TerminalBlocks = impulse.TerminalBlocks or {}

	if (fl) then
		fl = util.JSONToTable(fl)
		-- PrintTable(fl)
		for k, v in pairs(fl) do
			-- print(k)
			-- PrintTable(impulse.TerminalBlocks)
			if (impulse.TerminalBlocks[v.ent .. "_" .. v.id] and impulse.TerminalBlocks[v.ent .. "_" .. v.id].ent:IsValid()) then 
				-- print("Already exists") 
				continue
			end

			local ent2 = ents.Create(v.ent)
			ent2:SetPos(v.pos)
			ent2:SetAngles(v.angles)
			ent2:Spawn()
			ent2:SetTerminalTitle(v.term_name)
			ent2:SetTerminalID(v.term_id)
			ent2:SetOwner(nil)
			ent2.ent_id = v.id
			impulse.TerminalBlocks[v.ent .. "_" .. v.id] = {ent = ent2}

		end
	end
end

timer.Simple(5, function()
	timer.Simple(1, function()
		impulse.Doors.LoadApartment()
	end)

	impulse.Doors.LoadTerminalBlocks()
end)

MsgC( Color( 83, 143, 239 ), "[impulse] Loaded Apartment Plugin\n" )