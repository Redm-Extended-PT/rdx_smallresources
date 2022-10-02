local MapAnim = false

Citizen.CreateThread(function()
	while true do
		Wait(0)
		local playerPed = PlayerPedId()
		if IsAppActive(`MAP`) ~= 0 and not MapAnim  then
			SetCurrentPedWeapon(playerPed, GetHashKey('WEAPON_UNARMED'), true) -- unarm player
			MapAnim  = true
			SortirMap()
			Wait(2000)
			local player = PlayerPedId()
            local coords = GetEntityCoords(player) 
            local props = CreateObject(GetHashKey("s_twofoldmap01x_us"), coords.x, coords.y, coords.z, 1, 0, 1)
            prop = props
            SetEntityAsMissionEntity(prop,true,true)
            RequestAnimDict("mech_carry_box")
            while not HasAnimDictLoaded("mech_carry_box") do
            Citizen.Wait(100)
            end
            Citizen.InvokeNative(0xEA47FE3719165B94, player,"mech_carry_box", "idle", 1.0, 8.0, -1, 31, 0, 0, 0, 0)
            Citizen.InvokeNative(0x6B9BBD38AB0796DF, prop,player,GetEntityBoneIndexByName(player,"SKEL_L_Finger12"), 0.20, 0.00, -0.15, 180.0, 190.0, 0.0, true, true, false, true, 1, true)
		end
        if IsAppActive(`MAP`) ~= 1 and MapAnim  then
		MapAnim  = false
        RangerMap()
		ClearPedSecondaryTask(GetPlayerPed(PlayerId()))
     	DetachEntity(prop,false,true)
        ClearPedTasks(player)
        DeleteObject(prop)
		end
	end
end)

function SortirMap()
    local ped = PlayerPedId()
	Animation(ped, "mech_inspection@mini_map@satchel", "enter")
end

function RangerMap()
    local ped = PlayerPedId()
	Animation(ped, "mech_inspection@two_fold_map@satchel", "exit_satchel")
end

function Animation(ped, dict, name)
    if not DoesAnimDictExist(dict) then
      return
    end
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
    Citizen.Wait(0)
    end
    TaskPlayAnim(ped, dict, name, -1.0, -0.5, 2000, 1, 0, true, 0, false, 0, false)
    RemoveAnimDict(dict)
end

Citizen.CreateThread(function()
    while true do
        Wait(0)
        SetPlayerWeaponDamageModifier(GetPlayerIndex(),Config.WeaponDmg)
        SetPlayerMeleeWeaponDamageModifier(GetPlayerIndex(),Config.MeleeDmg)
    end
end)

-- DensityMultiplier = 0.1

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        
        -- Peds
        Citizen.InvokeNative(0xAB0D553FE20A6E25,Config.Traffic.pedFrequency) -- SetAmbientPedDensityMultiplierThisFrame
        Citizen.InvokeNative(0x7A556143A1C03898,Config.Traffic.pedFrequency) -- SetScenarioPedDensityMultiplierThisFrame
        -- 0x95423627A9CA598E SetScenarioPedDensityThisFrame(configHash ) 
        --Valid configs:
        -- BLACKWATER
        -- DEFAULT
        -- NEWBORDEAUX
        -- RHODES
        -- STRAWBERRY
        -- TUMBLEWEED
        -- VALENTINE
        -- VANHORN

        -- Humans
        Citizen.InvokeNative(0xBA0980B5C0A11924,Config.Traffic.pedFrequency) -- SetAmbientHumanDensityMultiplierThisFrame
        Citizen.InvokeNative(0x28CB6391ACEDD9DB,Config.Traffic.pedFrequency) -- SetScenarioHumanDensityMultiplierThisFrame

        -- Animals
        Citizen.InvokeNative(0xC0258742B034DFAF,Config.Traffic.animalFrequency) -- SetAmbientAnimalDensityMultiplierThisFrame
        Citizen.InvokeNative(0xDB48E99F8E064E56,Config.Traffic.animalFrequency) -- SetScenarioAnimalDensityMultiplierThisFrame

        -- Vehicules
        Citizen.InvokeNative(0xFEDFA97638D61D4A,Config.Traffic.trafficFrequency) -- SetParkedVehicleDensityMultiplierThisFrame
        Citizen.InvokeNative(0x1F91D44490E1EA0C,Config.Traffic.trafficFrequency) -- SetRandomVehicleDensityMultiplierThisFrame
        Citizen.InvokeNative(0x606374EBFC27B133,Config.Traffic.trafficFrequency) -- SetVehicleDensityMultiplierThisFrame

    end 
end)