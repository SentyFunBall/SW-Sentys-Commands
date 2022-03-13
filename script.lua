joinLeaveMgs = property.checkbox("Send a chat message when a player joins or leaves", "true")
autoAuth = property.checkbox("Automatically auth players when they join", "true")
animals = property.checkbox("Allow spawning of animals", "true")
vehicles = property.checkbox("Allow spawning of vehicles", "true")
objects = property.checkbox("Allow spawning of props", "true")
dieMsg = property.checkbox("Send a chat message when a player dies", "true")
respawnWithItems = property.checkbox("Give players their items back when they respawn", "true")
tp = property.checkbox("Allow teleporting", "true")

nonAdminClamp = property.slider("Spawning clamp for non-admins", 2, 300, 1, 250)
adminClamp = property.slider("Spawning clamp for admins", 2, 300, 1, 2500)

debug = property.checkbox("Debug mode", "false")

s = server

death = {{false}}

spawnedObjects = {}
playerItems = {{0,0,0,0,0,0}}
g_savedata = {}
deathMsgs = {
	" got trolled",
	" died lmao",
	" is resting in pieces",
	" said hi to god",
	" failed to pray",
	" got smote by allah",
	" did a magic trick",
	" died to stupidity",
	" forgor to breathe",
	" forgot how their legs work",
	"'s legs got a windows error while they went down the stairs",
	" went to a better place",
	" overheated",
	" underheated",
	" was mediocre at best",
	" went from present to past tense",
	" got promoted to dead",
	" went to gods recycle bin",
	" noclipped out of reality",
	" connected to gods wifi",
	" revealed state secrets",
	" went *poof*",
	" knew too much",
	" had 0 social credits",
	" teleported bread",
	" went to canada",
	" tried to rocket jump",
	" went to nandland",
	" played russian roulette",
	" tried to run admin commands",
	" pressed alt+f4",
	" had a skill issue",
	" deleted system32",
	" caused a stack overflow",
	" was bonked",
	" turned 30",
	" went to brazil",
	" tried to escape deltars",
	" commited sudoku",
	" hit the ground to hard",
	" went too long without blinking",
	" downloaded a car",
	" tried to chop down a tree in the DMZ",
	" i forgor the death message",
	" tried to swim in lava",
	" drove a bmw",
	" tripped on a pebble",
	" discovered radiation",
	" ate a laced brownie",
	" walked into a virtual propeller",
	" uh oh'ed",
	" walked away without saying goodbye",
	" is done with this game",
	" ate too much",
	" pressed alt+f4 irl",
	" was egotistical",
	" told a bad joke",
	" got jumped",
	" asked too many questions",
	" was not in their strong suit",
	" wasn't ammused",
	" is probably a member of PETA",
	", isn't your day is it?",
	" had to give a presentation",
	" got owned by the game",
	"'s soul despawned",
	" was caught venting",
	" existed too long",
	" was not the imposter",
	" was shot in the leg",
	" met yo mama",
	" looked in the mirror",
	" supported russia",
	" went onto twitter.com",
	" reached 0 sanity",
	" was killed by a zombie",
	" listened to bad music",
	" saw WWW"
}

joinMsgs = {
	" joined, hope ya brought a gun",
	" joined, hope ya brought a rocket launcher",
	" joined, hope ya brought a flamethrower",
	" joined, hide",
	" joined the game",
	" figured out the password",
	" wants to see the madness",
	"'s sanity is going down by the second",
	" prepared the will",
	" joined, hope your vaccinated"
}

leaveMsgs = {
	" didn't like you guys",
	" left the game",
	" left, shoot 'em up!",
	" left, you can stop hiding",
	" left, at least they didn't die",
	" left, they're not dead *yet*",
	" stopped playing",
	" alt+f4'd",
}

--[[function onTick(gt)
	if tick % 300 == 0 then
		pList = s.getPlayers()
		for index in pairs(pList) do
			object_id, is_success = s.getPlayerCharacterID(pList[index].id) --> returns: object_id
			for i=0,4,1 do
				eId, is_success = s.getCharacterItem(object_id, i)
				playerItems.object_id.i = eId or 0
			end
		end
	end
end]]--

function onCreate(create)
	if create then
		g_savedata.jlm = joinLeaveMgs
		g_savedata.aa = autoAuth
		g_savedata.a = animals
		g_savedata.v = vehicles
		g_savedata.p = props
		g_savedata.dm = dieMsg
		g_savedata.nac = nonAdminClamp
		g_savedata.ac = adminClamp
		g_savedata.rwi = respawnWithItems
		g_savedata.d = debug
		g_savedata.maxOID=0
		g_savedata.dea = death
		g_savedata.tp = tp
	else
		if tablelength(g_savedata) > 1 then
			joinLeaveMgs = g_savedata.jlm
			autoAuth = g_savedata.aa
			animals = g_savedata.a
			vehicles = g_savedata.v
			props = g_savedata.p
			dieMsg = g_savedata.dm
			nonAdminClamp = g_savedata.nac
			adminClamp = g_savedata.ac
			respawnWithItems = g_savedata.rwi
			debug = g_savedata.d
			death = g_savedata.dea
			tp = g_savedata.tp
		end
	end
	while true do
		local i=g_savedata.maxOID+1
		local Matrix, is_success = s.getObjectPos(i)
		if is_success then
			if i>g_savedata.maxOID then
				--s.announce("Built in object_id", math.tointeger(i),-1)
				g_savedata.maxOID=i
			end
		else break end
	end
end

function onCustomCommand(full_message, user_peer_id, is_admin, is_auth, command, arg1, arg2, arg3, arg4, arg5)
	if command == "?spawn" then
		if arg2 ~= nil then
			if is_admin then
				numberToSpawn = clamp(tonumber(arg2),1,adminClamp)
			else
				numberToSpawn = clamp(tonumber(arg2),1,nonAdminClamp)
			end
		else 
			numberToSpawn = 1
		end
		if arg1 == nil then
			s.announce("[Senty's Commands]", "Spawn syntax: ?spawn [object to spawn] [number to spawn] op: [object type]")
			s.announce("[Senty's Commands]", "Ex: ?spawn seal 1 [Spawns 1 seal]")
		elseif arg1 == "meg" and user_peer_id == 0 then
			if animals then
				if numberToSpawn >= 1 then
					transform_matrix, is_success = s.getPlayerPos(user_peer_id)
					for i = 1, numberToSpawn, 1 do
						object_id, is_success = s.spawnAnimal(transform_matrix, 0, 11)
						table.insert(spawnedObjects, object_id)
					end
					if is_success then
						s.announce("[Senty's Commands]", "Spawned " .. numberToSpawn .. " meg(s)!")
					else 
						s.announce("[Senty's Commands]", "Failed to spawn the animal!")
					end
				else
					s.announce("[Senty's Commands]", "Please include a number: 1-25")
				end
			else
				s.announce("[Senty's Commands]", "Animal spawning is disabled!")
			end
		elseif arg1 == "seal" and is_admin then
			if animals then
				if numberToSpawn >= 1 then
					transform_matrix, is_success = s.getPlayerPos(user_peer_id)
					for i = 1, numberToSpawn, 1 do
						object_id, is_success = s.spawnAnimal(transform_matrix, 2, 1)
						table.insert(spawnedObjects, object_id)
					end
					if is_success then
						s.announce("[Senty's Commands]", "Spawned " .. numberToSpawn .. " seals(s)!")
					else 
						s.announce("[Senty's Commands]", "Failed to spawn the animal!")
					end
				else
					s.announce("[Senty's Commands]", "Please include a number: 1-25")
				end
			else
				s.announce("[Senty's Commands]", "Animal spawning is disabled!")
			end
		elseif arg1 == "whale" and is_admin then
			if animals then
				if numberToSpawn >= 1 then
					transform_matrix, is_success = s.getPlayerPos(user_peer_id)
					for i = 1, numberToSpawn, 1 do
						object_id, is_success = s.spawnAnimal(transform_matrix, 1, 1)
						table.insert(spawnedObjects, object_id)
					end
					if is_success == true then
						s.announce("[Senty's Commands]", "Spawned " .. numberToSpawn .. " whale(s)!")
					else 
						s.announce("[Senty's Commands]", "Failed to spawn the animal!")
					end
				else 
					s.announce("[Senty's Commands]", "Please include a number: 1-25")
				end
			else
				s.announce("[Senty's Commands]", "Animal spawning is disabled!")
			end
		elseif arg1 == "peg" and animals and is_admin then
			if animals then
				if numberToSpawn >= 1 then
					transform_matrix, is_success = s.getPlayerPos(user_peer_id)
					for i = 1, numberToSpawn, 1 do
						object_id, is_success = s.spawnAnimal(transform_matrix, 3, 1)
						table.insert(spawnedObjects, object_id)
					end
					if is_success == true then
						s.announce("[Senty's Commands]", "Spawned " .. numberToSpawn .. " penguin(s)!")
					else 
						s.announce("[Senty's Commands]", "Failed to spawn the animal!")
					end
				else 
					s.announce("[Senty's Commands]", "Please include a number: 1-25")
				end
			else
				s.announce("[Senty's Commands]", "Animal spawning is disabled!")
			end
		elseif arg1 == "shark" and animals and is_admin then
			if animals then
				if numberToSpawn >= 1 then
					transform_matrix, is_success = s.getPlayerPos(user_peer_id)
					for i = 1, numberToSpawn, 1 do
						object_id, is_success = s.spawnAnimal(transform_matrix, 0, 1)
						table.insert(spawnedObjects, object_id)
					end
					if is_success == true then
						s.announce("[Senty's Commands]", "Spawned " .. numberToSpawn .. " shark(s)!")
					else 
						s.announce("[Senty's Commands]", "Failed to spawn the animal!")
					end
				else 
					s.announce("[Senty's Commands]", "Please include a number: 1-25")
				end
			else
				s.announce("[Senty's Commands]", "Animal spawning is disabled!")
			end
		elseif arg1 == "object" then
			if objects then
				if arg3 ~= nil then
					transform_matrix, is_success = s.getPlayerPos(user_peer_id)
					for i = 1, numberToSpawn, 1 do
						object_id, is_success = s.spawnObject(transform_matrix, tonumber(arg3))
						table.insert(spawnedObjects, object_id)
					end
					if is_success then
						s.announce("[Senty's Commands]", "Spawned " .. numberToSpawn .. " object(s)!")
					else 
						s.announce("[Senty's Commands]", "Failed to spawn the animal!")
					end
				else
					s.announce("[Senty's Commands]", "Spawn object syntax: ?spawn object [number to spawn] [object type]")
					s.announce("[Senty's Commands]", "Ex: ?spawn object 3 13: spawns 3 office chairs")
				end
			else
				s.announce("[Senty's Commands]", "Prop spawning is disabled!")
			end
		else
			s.announce("[Senty's Commands]", "Correct types: meg, seal, whale, peg, object [object type]")
		end
	elseif command == "?despawn" and is_admin then
		failedObjects = 0
		failedAtLeast1 = false
		system_time = s.getTimeMillisec()
		count = tablelength(spawnedObjects)
		for k, v in pairs(spawnedObjects) do
			is_success = s.despawnObject(v, true)
			is_success2 = s.despawnVehicle(v, true)
			if not is_success and not is_success2 then
				failedObjects = failedObjects + 1
				failedAtLeast1 = true
				if debug then
					s.announce("[SC Debug]", "Failed obj "..v)
				end
			end
		end
		
		spawnedObjects = {}
		timer = s.getTimeMillisec() - system_time
		
		if is_success or is_success2 then
			s.announce("[Senty's Commands]", "Despawned all known objects")
			s.announce("[Senty's Commands]", "Time: ".. timer .. " ms. Objects removed: " .. count)
		end
		
		if failedAtLeast1 then
			s.announce("[Senty's Commands]", "Failed to despawn "..failedObjects.." objects! They were probably removed from the world!")
		end
	elseif command == "?veh" and is_admin then
		if vehicles then
			transform_matrix, is_success = s.getPlayerPos(user_peer_id)
			vehname = arg1
			if arg2 ~= null then vehname = vehname .. " " .. arg2 end
			if arg3 ~= null then vehname = vehname .. " " .. arg3 end
			if arg4 ~= null then vehname = vehname .. " " .. arg4 end
			if arg5 ~= null then vehname = vehname .. " " .. arg5 end
			vehicle_id, is_success = s.spawnVehicle(transform_matrix, tostring(vehname))
			if is_success == true then
				s.announce("[Senty's Commands]", "Spawned " .. vehname)
				table.insert(spawnedObjects, vehicle_id)
			else 
				s.announce("[Senty's Commands]", "Failed to spawn!")
			end
		else
			s.announce("[Senty's Commands]", "Vehicle spawning is disabled!")
		end
	elseif command == "?tp" then
		if tp then
			tpToPos, is_success = s.getPlayerPos(arg1)
			if is_success then
				s.setPlayerPos(user_peer_id, tpToPos)
			else
				s.announce("[Senty's Commands]", "An error occurred! Make sure you put in the right peer num!")
			end
		else
			s.announce("[Senty's Commands]", "Teleporting is disabled!")
		end
	elseif command == "?bring" and is_admin then
		tpToPos, is_success = s.getPlayerPos(user_peer_id)
		if is_success then
			s.setPlayerPos(tonumber(arg1), tpToPos)
		else
			s.announce("[Senty's Commands]", "An error occurred! Make sure you put in the right peer num!")
		end
	elseif command == "?kill" and is_admin and user_peer_id == 0 then
		if arg1 ~= "all" then
			arg1 = arg1 or 0
			object_id, is_success = s.getPlayerCharacterID(arg1) --> returns: object_id
			if is_success then
				s.killCharacter(object_id)
				death[arg1+1] = true
				extraCallbacks()
			else
				s.announce("[Senty's Commands]", "An error occurred! Make sure you put in the right peer num!")
			end
		else
			PLAYER_LIST = s.getPlayers()
			for index in pairs(PLAYER_LIST) do
				object_id, is_success = s.getPlayerCharacterID(PLAYER_LIST[index].id) --> returns: object_id
				if is_success then
					s.killCharacter(object_id)
					death[PLAYER_LIST[index].id+1] = true
					extraCallbacks()
				else
					s.announce("[Senty's Commands]", "An error occurred! Make sure you put in the right peer num!")
				end
			end
		end
	elseif command == "?admin" and is_admin then
		s.addAdmin(arg1)
	elseif command == "?radmin" and is_admin then
		s.removeAdmin(arg1)
	elseif command == "?debug" and is_admin then
		if arg1 == "table" then
			s.announce("[SC Debug]", "spawnedObjects = " .. table.concat(spawnedObjects))
		elseif arg1 == "savedata" then
			s.announce("[SC Debug]", "g_savedata = " .. table.concat(g_savedata))
		elseif arg1 == "settings" then
			s.announce("[SC Debug]", "jlm = " .. tostring(joinLeaveMgs) .. ", aa = " .. tostring(autoAuth) .. ", a = " .. tostring(animals) .. ", v = " .. tostring(vehicles) .. ", p = " .. tostring(objects) .. ", dm = " .. tostring(dieMsg) .. ", nac = " .. nonAdminClamp .. ", ac = " .. adminClamp)
		elseif arg1 == "toggle" then
			debug = not debug
			g_savedata.d = debug
			s.announce("[SC Debug]","Changed debug to "..tostring(debug))
		else
			s.announce("[SC Debug]", "Valid args: table, savedata, settings, toggle")
		end
	elseif command == "?changelog" then
		s.announce("[Senty's Commands]", "v1.3: Changelog, random death messages, fixed some bugs, items respawn on death")
		s.announce("[Senty's Commands]", "v1.3.5: more death messages, fixed ?bring, added random join and leave messages")
	elseif command == "?help" then
		s.announce("[Senty's Commands]", "Valid commands: help, changelog, debug, spawn, veh, despawn, tp, gren, admin, radmin, kill")
	elseif command == "?gren"  and is_admin then
		transform_matrix, is_success = s.getPlayerPos(user_peer_id)
		for i = 1, 25, 1 do
			object_id, is_success = s.spawnObject(transform_matrix, 67)
			table.insert(spawnedObjects, object_id)
		end
	elseif command == "?met" and is_admin then
		transform_matrix,is_success = s.getPlayerPos(user_peer_id)
		s.spawnExplosion(transform_matrix, arg1)
	end
end

function onPlayerDie(steam_id, name, peer_id, is_admin, is_auth)
	if dieMsg then
		num = math.random(1, #deathMsgs)
		s.announce("[Senty's Commands]", string.lower(name) .. deathMsgs[num])
	end
	if respawnWithItems then
		death[peer_id+1] = true
		object_id, is_success = s.getPlayerCharacterID(peer_id)
		for i=1,6,1 do
			eId, is_success = s.getCharacterItem(object_id, i)
			if is_success then
				playerItems[peer_id+1][i] = eId
			end
			if debug then s.announce("[SC Debug]", "Stored item " .. eId .. " from slot " .. i) end
		end
	end
end

function onPlayerRespawn(peer_id)
	if respawnWithItems then
		object_id, is_success = s.getPlayerCharacterID(peer_id)
		death[peer_id+1] = false
		for i=1,6,1 do
			eId = playerItems[peer_id+1][i]
			Int = 0
			Float = 100
			
			if eId == 9 then Int = 4 elseif eId == 11 then Int = 4 elseif eId == 12 then Int = 4 elseif eId == 13 then Int = 1 elseif eId == 14 then Int = 4 elseif eId == 31 then Int = 1 elseif eId == 33 then Int = 4 elseif eId == 35 then Int = 17 elseif eId == 36 then Int = 17 elseif eId == 37 then Int = 40 elseif eId == 39 then Int = 30 elseif eId == 41 then Int = 1 end
			if eId == 10 then Float = 9 elseif eId == 26 then Float = 250 elseif eId == 27 then Float = 400 end
			
			is_success = s.setCharacterItem(object_id, i, eId, false, Int, Float)
			if is_success and debug then
				s.announce("[SC Debug]", "Recovered item " .. playerItems[peer_id+1][i] .. " into slot " .. i)
			end
		end
	end
end

function onPlayerJoin(steam_id, name, peer_id, is_admin, is_auth)
	if joinLeaveMgs then
		num = math.random(1, #joinMsgs)
		s.announce("[Senty's Commands]", string.lower(name) .. joinMsgs[num] .." (type ?help for command list)")
	end
	if autoAuth then
		s.addAuth(peer_id)
	end
	if respawnWithItems then
		playerItems[peer_id+1] = {0,0,0,0,0,0}
		death[peer_id+1] = false
	end
end

function onPlayerLeave(steam_id, name, peer_id, is_admin, is_auth)
	if joinLeaveMgs then
		num = math.random(1, #leaveMsgs)
		s.announce("[Senty's Commands]", string.lower(name) .. leaveMsgs[num])
	end
end

function clamp(val, min, max)
  return math.max(min, math.min(max, val))
end

function tablelength(T)
	local count = 0
	for _ in pairs(T) do count = count + 1 end
	return count
end
	
	
--credit to woe here
function onObjectSpawn(object_id,peer_id) --use this like any other callback.
	if debug then
		s.announce("[SC Debug]", "object_id: "..math.tointeger(object_id)..", peer_id: "..math.tointeger(peer_id),-1)
	end
	is_success = s.despawnObject(object_id, true)
	if is_success and debug then
		s.announce("[SC Debug]", "object " .. object_id .. " despawned")
	end
end

function extraCallbacks()
	while true do
		local peer_id=-1
		local object_id=g_savedata.maxOID+1
		local MatrixO, is_success = s.getObjectPos(object_id)
		if is_success then
			if object_id>g_savedata.maxOID then
				PLAYER_LIST = s.getPlayers()
				for index, data in pairs(PLAYER_LIST) do
					local MatrixP, is_success = s.getPlayerPos(data.id)
					local distanceOP = 25
					if matrix.distance(MatrixO, MatrixP)<distanceOP then
						peer_id=data.id
						distanceOP=matrix.distance(MatrixO, MatrixP)
					end
				end
				onObjectSpawn(object_id,peer_id)
				g_savedata.maxOID=object_id
				peer_id=-1
			end
		else break end
	end
end

function onTick(gt)
	if respawnWithItems then
		for key, value in ipairs(playerItems) do
			if death[key] == true then
				extraCallbacks()
			end
		end
	end
end