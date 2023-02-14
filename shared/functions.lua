local personalBoard, board_model, overlay_model = {}, GetHashKey("prop_police_id_board"), GetHashKey("prop_police_id_text")

function input(entryTitle, textEntry, inputText, maxLength)
    AddTextEntry(entryTitle, textEntry)
    DisplayOnscreenKeyboard(1, entryTitle, "", inputText, "", "", "", maxLength)
	blockinput = true
    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
        Citizen.Wait(0)
    end
    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult()
        Citizen.Wait(500)
		blockinput = false
        return result
    else
        Citizen.Wait(500)
		blockinput = false
        return nil
    end
end

function setupPlayer()
    SetEntityHealth(PlayerPedId(), 200)
    local pCoords = GetEntityCoords(PlayerPedId())
    local dist = #(pCoords - vector3(402.91, -996.54, -99.0))
    if dist > 2 then 
        SetEntityCoords(PlayerPedId(), 402.91818237305, -996.54797363281,-99.000259399414)
        SetEntityHeading(PlayerPedId(), 180.0)
    elseif dist <= 2 then 
        FreezeEntityPosition(PlayerPedId(), true)
    end
end

function createFaceCam()
    PlaySoundFrontend(-1, "Zoom_In", "MUGSHOT_CHARACTER_CREATION_SOUNDS", 0, 0, 1)
    FaceCam = CreateCamWithParams('DEFAULT_SCRIPTED_CAMERA', 402.92, -1000.72, -98.45, 0.0, 0.0, 360.0, 10.0, false, 0)        
    SetCamActiveWithInterp(FaceCam, PrincipalCam, 2500, true, true)
end

function createCreatorCam(actions)
    TriggerEvent('skinchanger:change', 'glasses_1', -1)
    if actions == true then
        DisplayRadar(false)
        SetEntityCoords(PlayerPedId(), 402.91818237305, -996.54797363281,-99.000259399414)
        SetEntityHeading(PlayerPedId(), 180.0)
        Wait(1000)
        TriggerServerEvent("cxCreator:setPlayerToBucket")
        BodyCam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", CreatorSettings.BodyCam.x, CreatorSettings.BodyCam.y, CreatorSettings.BodyCam.z, 0.00, 0.00, 0.00, CreatorSettings.BodyCam.fov, false, 0)
        SetCamActive(BodyCam, true)
        RenderScriptCams(true, false, 2000, true, true) 
        Wait(500)
        PrincipalCam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", CreatorSettings.PrincipalCam.x, CreatorSettings.PrincipalCam.y, CreatorSettings.PrincipalCam.z, 0.00, 0.00, 0.00, 40.00, false, 0)
        PointCamAtCoord(PrincipalCam, 402.99, -998.02, -99.00)
        SetCamActiveWithInterp(PrincipalCam, BodyCam, 5000, true, true)
        ClearPedTasks(PlayerPedId())
        RequestAnimDict("mp_character_creation@customise@male_a")
        while not HasAnimDictLoaded("mp_character_creation@customise@male_a") do
            Wait(1)
        end
        TaskPlayAnim(GetPlayerPed(-1), "mp_character_creation@customise@male_a", "loop", 3.0, -1.0, -1, 2, 0, 0, 0, 0)
        OpenCharCreatorMenu()
    end
    if actions == false then
        RenderScriptCams(false, false, 0, 1, 0)
        DestroyCam(PrincipalCam, false)
        DisplayRadar(true)
    end
end

function getRandomSpawnPoint()
    local random = math.random(1, #CreatorSettings.SpawnPoint)
    return CreatorSettings.SpawnPoint[random]
end

function finishedCreation()
    CreateThread(function()
        PlaySoundFrontend(-1, "CHARACTER_SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
        TriggerServerEvent("cxCreator:AddIdentityToPlayer", CurrentIdentityFirstName, CurrentIdentityLastName, CurrentIdentitySex, CurrentIdentityDDN, CurrentIdentityHeight)
        TriggerEvent('skinchanger:getSkin', function(skin)
            TriggerServerEvent('esx_skin:save', skin)                                    
        end)
        RageUI.CloseAll()
        MenuIsOpen = false 
        ClearDrawOrigin()
        ClearFocus()
        RenderScriptCams(false, false, 0, 1, 0)
        DestroyCam(IdentityCam, false)
        StartAudioScene("MP_LEADERBOARD_SCENE")
        if not IsPlayerSwitchInProgress() then
            SwitchOutPlayer(PlayerPedId(), 0, 1)
        end
        while GetPlayerSwitchState() ~= 5 do
            Wait(0)
            SetCloudHatOpacity(0.02)
            HideHudAndRadarThisFrame()
            SetDrawOrigin(0.0, 0.0, 0.0, 0)
        end
        SetCloudHatOpacity(0.02)
        HideHudAndRadarThisFrame()
        SetDrawOrigin(0.0, 0.0, 0.0, 0)
        Wait(0)
        DoScreenFadeOut(0)
        SetCloudHatOpacity(0.02)
        HideHudAndRadarThisFrame()
        SetDrawOrigin(0.0, 0.0, 0.0, 0)
        Wait(0)
        SetCloudHatOpacity(0.02)
        HideHudAndRadarThisFrame()
        SetDrawOrigin(0.0, 0.0, 0.0, 0)
        DoScreenFadeIn(500)
        while not IsScreenFadedIn() do
            Wait(0)
            SetCloudHatOpacity(0.02)
            HideHudAndRadarThisFrame()
            SetDrawOrigin(0.0, 0.0, 0.0, 0)
        end
        if not CreatorSettings.EnableRandomSpawn then 
            SetEntityCoords(PlayerPedId(), CreatorSettings.SpawnPoint[CreatorSettings.ApparationList.Index].x, CreatorSettings.SpawnPoint[CreatorSettings.ApparationList.Index].y, CreatorSettings.SpawnPoint[CreatorSettings.ApparationList.Index].z)
            SetEntityHeading(PlayerPedId(), CreatorSettings.SpawnPoint[CreatorSettings.ApparationList.Index].h)
        else
            local randomPosition = getRandomSpawnPoint()
            SetEntityCoords(PlayerPedId(), randomPosition.x, randomPosition.y, randomPosition.z)
            SetEntityHeading(PlayerPedId(), randomPosition.h)
        end
        local timer = GetGameTimer()
        while true do
            SetCloudHatOpacity(0.02)
            HideHudAndRadarThisFrame()
            SetDrawOrigin(0.0, 0.0, 0.0, 0)
            Wait(0)
            if GetGameTimer() - timer > 5000 then
                SwitchInPlayer(PlayerPedId())
                SetCloudHatOpacity(0.02)
                HideHudAndRadarThisFrame()
                SetDrawOrigin(0.0, 0.0, 0.0, 0)
                while GetPlayerSwitchState() ~= 12 do
                    Wait(0)
                    SetCloudHatOpacity(0.02)
                    HideHudAndRadarThisFrame()
                    SetDrawOrigin(0.0, 0.0, 0.0, 0)
                    FreezeEntityPosition(PlayerPedId(), false)
                end
                break
            end
        end
        StopAudioScene("MP_LEADERBOARD_SCENE")
        DisplayRadar(true)
        ESX.ShowNotification(CreatorSettings.EndingMessage)
        TriggerServerEvent("cxCreator:setPlayerToNormalBucket")
    end)
end

function turnPlayer()
    local Control1, Control2 = IsDisabledControlPressed(1, 108), IsDisabledControlPressed(1, 109)
    if Control1 or Control2 then
        SetEntityHeading(PlayerPedId(), Control1 and GetEntityHeading(PlayerPedId()) - 2.0 or Control2 and GetEntityHeading(PlayerPedId()) + 2.0)
	end
end

function loadScaleform(scaleform)
	local handle = RequestScaleformMovie(scaleform)
	if handle ~= 0 then
		while not HasScaleformMovieLoaded(handle) do
			Wait(0)
		end
	end
	return handle
end

function createRenderModel(name, model)
	local handle = 0
	if not IsNamedRendertargetRegistered(name) then
		RegisterNamedRendertarget(name, 0)
	end
	if not IsNamedRendertargetLinked(model) then
		LinkNamedRendertarget(model)
	end
	if IsNamedRendertargetRegistered(name) then
		handle = GetNamedRendertargetRenderId(name)
	end
	return handle
end

function callMethodScaleform(scaleform, method, ...)
	local t
	local args = { ... }
	BeginScaleformMovieMethod(scaleform, method)
	for k, v in ipairs(args) do
		t = type(v)
		if t == 'string' then
			PushScaleformMovieMethodParameterString(v)
		elseif t == 'number' then
			if string.match(tostring(v), "%.") then
				PushScaleformMovieFunctionParameterFloat(v)
			else
				PushScaleformMovieFunctionParameterInt(v)
			end
		elseif t == 'boolean' then
			PushScaleformMovieMethodParameterBool(v)
		end
	end
	EndScaleformMovieMethod()
end

function createPlayerBoard()
    CreateThread(function()
        board_scaleform = loadScaleform("mugshot_board_01")
        handle = createRenderModel("ID_Text", overlay_model)
        while handle do
            SetTextRenderId(handle)
            Set_2dLayer(4)
            Citizen.InvokeNative(0xC6372ECD45D73BCD, 1)
            DrawScaleformMovie(board_scaleform, 0.405, 0.37, 0.81, 0.74, 255, 255, 255, 255, 0)
            Citizen.InvokeNative(0xC6372ECD45D73BCD, 0)
            SetTextRenderId(GetDefaultScriptRendertargetRenderId())
            Citizen.InvokeNative(0xC6372ECD45D73BCD, 1)
            Citizen.InvokeNative(0xC6372ECD45D73BCD, 0)
            Wait(0)
        end
    end)
    Wait(220)
    RequestModel(board_model)
    while not HasModelLoaded(board_model) do Wait(0) end
    RequestModel(overlay_model)
    while not HasModelLoaded(overlay_model) do Wait(0) end
    personalBoard.board = CreateObject(board_model, GetEntityCoords(PlayerPedId()), false, true, false)
    personalBoard.overlay = CreateObject(overlay_model, GetEntityCoords(PlayerPedId()), false, true, false)
    AttachEntityToEntity(personalBoard.overlay, personalBoard.board, -1, 4103, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
    ClearPedWetness(PlayerPedId())
    ClearPedBloodDamage(PlayerPedId())
    ClearPlayerWantedLevel(PlayerId())
    SetCurrentPedWeapon(PlayerPedId(), GetHashKey("weapon_unarmed"), 1)
    AttachEntityToEntity(personalBoard.board, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 28422), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0, 0, 0, 0, 2, 1)
    callMethodScaleform(board_scaleform, 'SET_BOARD', CreatorSettings.Board.FirstText, CreatorSettings.Board.SecondText, CreatorSettings.Board.ThirdText, '' , 0, 15)
end

function deletePlayerBoard()
    DeleteEntity(personalBoard.board)
    DeleteEntity(personalBoard.overlay)
    DeleteEntity(personalBoard.board)
    DeleteEntity(personalBoard.overlay)
end

RegisterNetEvent("cxCreator:CharCreator")
AddEventHandler("cxCreator:CharCreator", function()
    createCreatorCam(true)
end)