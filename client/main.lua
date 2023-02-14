ESX, MenuIsOpen = nil, false 

CreateThread(function()
    while ESX == nil do 
        TriggerEvent("esx:getSharedObject", function(obj) 
            ESX = obj 
        end)
        Wait(10)
    end
end)

local HairList, EyebrowsList, BeardList, EyesColorList, MolesList, AgestList, SunDamageList = {}, {}, {} ,{} , {} ,{}, {}
local HairIndex, EyebrowsIndex, ArmsIndex, BeardIndex, EyesColorIndex, MolesIndex, AgestIndex, SunDamageIndex = 1, 1, 1, 1, 1, 1, 1, 1

CreateThread(function()
    for i = 0, 73 do
        table.insert(HairList, i)
    end
    for i = 0, 32 do
        table.insert(EyebrowsList, i)
    end
    for i = 0, 27 do
        table.insert(BeardList, i)
    end
    for i = 0, 30 do
        table.insert(EyesColorList, i)
    end
    for i = 0, 16 do
        table.insert(MolesList, i)
    end
    for i = 0, 13 do
        table.insert(AgestList, i)
    end
    for i = 0, 9 do
        table.insert(SunDamageList, i)
    end
end)

CharCreatorMenu = RageUI.CreateMenu(CreatorSettings.CreatorTitle, CreatorSettings.CreatorSubtitle)
CharCreatorHeritageMenu = RageUI.CreateSubMenu(CharCreatorMenu, CreatorSettings.CreatorTitle, CreatorSettings.CreatorSubtitle)
CharCreatorAppearanceMenu = RageUI.CreateSubMenu(CharCreatorMenu, CreatorSettings.CreatorTitle, CreatorSettings.CreatorSubtitle)
CharCreatorClothesMenu = RageUI.CreateSubMenu(CharCreatorMenu, CreatorSettings.CreatorTitle, CreatorSettings.CreatorSubtitle)
CharCreatorFeaturesMenu = RageUI.CreateSubMenu(CharCreatorMenu, CreatorSettings.CreatorTitle, CreatorSettings.CreatorSubtitle)
CharCreatorIdentityMenu = RageUI.CreateSubMenu(CharCreatorMenu, CreatorSettings.CreatorTitle, CreatorSettings.CreatorSubtitle)
CharCreatorMenu:AddInstructionButton({"~INPUT_VEH_FLY_ROLL_RIGHT_ONLY~", "Tourner votre personnage à droite"})
CharCreatorMenu:AddInstructionButton({"~INPUT_VEH_FLY_ROLL_LEFT_ONLY~", "Tourner votre personnage à gauche"})
CharCreatorHeritageMenu:AddInstructionButton({"~INPUT_VEH_FLY_ROLL_RIGHT_ONLY~", "Tourner votre personnage à droite"})
CharCreatorHeritageMenu:AddInstructionButton({"~INPUT_VEH_FLY_ROLL_LEFT_ONLY~", "Tourner votre personnage à gauche"})
CharCreatorAppearanceMenu:AddInstructionButton({"~INPUT_VEH_FLY_ROLL_RIGHT_ONLY~", "Tourner votre personnage à droite"})
CharCreatorAppearanceMenu:AddInstructionButton({"~INPUT_VEH_FLY_ROLL_LEFT_ONLY~", "Tourner votre personnage à gauche"})
CharCreatorClothesMenu:AddInstructionButton({"~INPUT_VEH_FLY_ROLL_RIGHT_ONLY~", "Tourner votre personnage à droite"})
CharCreatorClothesMenu:AddInstructionButton({"~INPUT_VEH_FLY_ROLL_LEFT_ONLY~", "Tourner votre personnage à gauche"})
CharCreatorFeaturesMenu:AddInstructionButton({"~INPUT_VEH_FLY_ROLL_RIGHT_ONLY~", "Tourner votre personnage à droite"})
CharCreatorFeaturesMenu:AddInstructionButton({"~INPUT_VEH_FLY_ROLL_LEFT_ONLY~", "Tourner votre personnage à gauche"})
CharCreatorMenu.Closable = false 
CharCreatorFeaturesMenu.EnableMouse = true 
CharCreatorClothesMenu.EnableMouse = true 
CharCreatorAppearanceMenu.EnableMouse = true 

CharCreatorHeritageMenu.Closed = function()
    SetCamActiveWithInterp(PrincipalCam, BodyCam, 2500, true, true)
end

CharCreatorFeaturesMenu.Closed = function()
    SetCamActiveWithInterp(PrincipalCam, BodyCam, 2500, true, true)
end

CharCreatorAppearanceMenu.Closed = function()
    SetCamActiveWithInterp(PrincipalCam, BodyCam, 2500, true, true)
end

function OpenCharCreatorMenu()
    if MenuIsOpen then
        MenuIsOpen = false
        RageUI.Visible(CharCreatorMenu, false)
    else
        MenuIsOpen = true
        RageUI.Visible(CharCreatorMenu, true)
        CurrentIdentitySex, CreatorSettings.IdentitySex = "m", "Masculin"
        createPlayerBoard()
        Wait(5000)
        CreateThread(function()
            while MenuIsOpen do
                setupPlayer()
                turnPlayer()
                RageUI.IsVisible(CharCreatorMenu, function()
                    RageUI.List("Modèles", CreatorSettings.PlayerSex, CreatorSettings.PlayerSex.Index, "Déterminer le sexe du personnage", {}, true, {
                        onListChange = function(Index)
                            CreatorSettings.PlayerSex.Index = Index
                            if Index == 1 then
                                TriggerEvent('skinchanger:change', 'sex', 0)
                                CurrentIdentitySex = "m"
                                CreatorSettings.IdentitySex = "Masculin"
                            elseif Index == 2 then
                                TriggerEvent('skinchanger:change', 'sex', 1)
                                Wait(50)
                                CurrentIdentitySex = "f"
                                CreatorSettings.IdentitySex = "Féminin"
                            end
                            TriggerEvent('skinchanger:change', 'glasses_1', -1)
                        end
                    })
                    RageUI.Button("Hérédité", "Déterminer l'héritage du personnage.", {}, true, {
                        onSelected = function()
                            createFaceCam()
                        end
                    },CharCreatorHeritageMenu)
                    RageUI.Button("Traits du visage", "Traits du personnage.", {}, true, {
                        onSelected = function()
                            createFaceCam()
                        end
                    },CharCreatorFeaturesMenu)
                    RageUI.Button("Apparence", "Déterminer l'apparence du personnage.", {}, true, {
                        onSelected = function()
                            createFaceCam()
                        end
                    },CharCreatorAppearanceMenu)
                    RageUI.Button("Vêtements", "Déterminer la tenue du personnage.", {}, true, {},CharCreatorClothesMenu)
                    RageUI.Button("Informations", "Déterminer l'identité du personnage.", {}, true, {},CharCreatorIdentityMenu)
                end)
                RageUI.IsVisible(CharCreatorHeritageMenu, function()
                    RageUI.Window.Heritage(CreatorSettings.MomList.Index, CreatorSettings.DadList.Index)
                    RageUI.List("Père", CreatorSettings.DadList, CreatorSettings.DadList.Index, false, {}, true, {
                        onListChange = function(Index)
                            CreatorSettings.DadList.Index = Index
                            TriggerEvent('skinchanger:change', 'dad', CreatorSettings.DadList.Index)
                        end
                    })
                    RageUI.List("Mère", CreatorSettings.MomList, CreatorSettings.MomList.Index, false, {}, true, {
                        onListChange = function(Index)
                            CreatorSettings.MomList.Index = Index
                            TriggerEvent('skinchanger:change', 'mom', CreatorSettings.MomList.Index)
                        end
                    })
                    RageUI.UISliderHeritage("Ressemblance", CreatorSettings.Similarity, false, {
                        onSliderChange = function(Float, Index)
                            CreatorSettings.Similarity = Index
                            CreatorSettings.SkinMixData = Index*10
                            TriggerEvent('skinchanger:change', 'face_md_weight', CreatorSettings.SkinMixData)
                        end
                    })                      
                    RageUI.UISliderHeritage("Couleur de peau", CreatorSettings.SkinColor, false, {
                        onSliderChange = function(Float, Index)
                            CreatorSettings.SkinColor = Index
                            CreatorSettings.SkinMixData = Index*10
                            TriggerEvent('skinchanger:change', 'skin_md_weight', CreatorSettings.SkinMixData)
                        end
                    })
                end)
                RageUI.IsVisible(CharCreatorAppearanceMenu, function()
                    RageUI.List('Coiffure', HairList, HairIndex , nil, {}, true, {
                        onListChange = function(Index)
                            HairIndex = Index
                            TriggerEvent('skinchanger:change', 'hair_1', HairIndex)
                        end
                    })
                    RageUI.List('Sourcils', EyebrowsList, EyebrowsIndex , nil, {}, true, {
                        onListChange = function(Index)
                            EyebrowsIndex = Index
                            TriggerEvent('skinchanger:change', 'eyebrows_1', EyebrowsIndex)
                        end
                    })
                    RageUI.List('Barbes', BeardList, BeardIndex , nil, {}, true, {
                        onListChange = function(Index)
                            BeardIndex = Index
                            TriggerEvent('skinchanger:change', 'beard_1', BeardIndex)
                        end
                    })
                    RageUI.List('Couleurs des yeux', EyesColorList, EyesColorIndex , nil, {}, true, {
                        onListChange = function(Index)
                            EyesColorIndex = Index
                            TriggerEvent('skinchanger:change', 'eye_color', EyesColorIndex)
                        end
                    })
                    RageUI.List('Taches de rousseur', MolesList, MolesIndex , nil, {}, true, {
                        onListChange = function(Index)
                            MolesIndex = Index
                            TriggerEvent('skinchanger:change', 'moles_1', MolesIndex)
                        end
                    })
                    RageUI.List('Rides', AgestList, AgestIndex, nil, {}, true, {
                        onListChange = function(Index)
                            AgestIndex = Index
                            TriggerEvent('skinchanger:change', 'age_1', AgestIndex)
                        end
                    })
                    RageUI.List('Coups de soleil', SunDamageList, SunDamageIndex , nil, {}, true, {
                        onListChange = function(Index)
                            SunDamageIndex = Index
                            TriggerEvent('skinchanger:change', 'sun_1', SunDamageIndex)
                        end
                    })
                    RageUI.ColourPanel("Couleur Principale", RageUI.PanelColour.HairCut, CreatorSettings.HairColor[1], CreatorSettings.HairColor[2], {
                        onColorChange = function(MinimumIndex, CurrentIndex)
                            CreatorSettings.HairColor[1] = MinimumIndex
                            CreatorSettings.HairColor[2] = CurrentIndex
                            TriggerEvent('skinchanger:change', 'hair_color_1', CreatorSettings.HairColor[2])
                        end
                    }, 1)
                    RageUI.ColourPanel("Couleur Secondaire", RageUI.PanelColour.HairCut, CreatorSettings.HairSecondaryColor[1], CreatorSettings.HairSecondaryColor[2], {
                        onColorChange = function(MinimumIndex, CurrentIndex)
                            CreatorSettings.HairSecondaryColor[1] = MinimumIndex
                            CreatorSettings.HairSecondaryColor[2] = CurrentIndex
                            TriggerEvent('skinchanger:change', 'hair_color_2', CreatorSettings.HairSecondaryColor[2])
                        end
                    }, 1)         
                    RageUI.ColourPanel("Couleur des sourcils", RageUI.PanelColour.HairCut, CreatorSettings.EyesbrowColor[1], CreatorSettings.EyesbrowColor[2], {
                        onColorChange = function(MinimumIndex, CurrentIndex)
                            CreatorSettings.EyesbrowColor[1] = MinimumIndex
                            CreatorSettings.EyesbrowColor[2] = CurrentIndex
                            TriggerEvent('skinchanger:change', 'eyebrows_3', CreatorSettings.EyesbrowColor[2])
                        end
                    }, 2)
                    RageUI.PercentagePanel(CreatorSettings.Percentage[1], 'Opacité', '0%', '100%', {
                        onProgressChange = function(Percentage)
                            CreatorSettings.Percentage[1] = Percentage
                            TriggerEvent('skinchanger:change', 'eyebrows_2',Percentage*10)
                        end
                    }, 2)  
                    RageUI.ColourPanel("Couleur de barbe", RageUI.PanelColour.HairCut, CreatorSettings.BeardColor[1], CreatorSettings.BeardColor[2], {
                        onColorChange = function(MinimumIndex, CurrentIndex)
                            CreatorSettings.BeardColor[1] = MinimumIndex
                            CreatorSettings.BeardColor[2] = CurrentIndex
                            TriggerEvent('skinchanger:change', 'beard_3', CreatorSettings.BeardColor[2])
                        end
                    }, 3)               
                    RageUI.PercentagePanel(CreatorSettings.Percentage[2], 'Opacité', '0%', '100%', {
                        onProgressChange = function(Percentage)
                            CreatorSettings.Percentage[2] = Percentage
                            TriggerEvent('skinchanger:change', 'beard_2',Percentage*10)
                        end
                    }, 3)  
                    RageUI.PercentagePanel(CreatorSettings.Percentage[3], 'Opacité', '0%', '100%', {
                        onProgressChange = function(Percentage)
                            CreatorSettings.Percentage[3] = Percentage
                            TriggerEvent('skinchanger:change', 'moles_2',Percentage*10)
                        end
                    }, 5)   
                    RageUI.PercentagePanel(CreatorSettings.Percentage[4], 'Opacité', '0%', '100%', {
                        onProgressChange = function(Percentage)
                            CreatorSettings.Percentage[4] = Percentage
                            TriggerEvent('skinchanger:change', 'age_2',Percentage*10)
                        end
                    }, 6) 
                    RageUI.PercentagePanel(CreatorSettings.Percentage[5], 'Opacité', '0%', '100%', {
                        onProgressChange = function(Percentage)
                            CreatorSettings.Percentage[5] = Percentage
                            TriggerEvent('skinchanger:change', 'sun_2',Percentage*10)
                        end
                    }, 7)
                end)
                RageUI.IsVisible(CharCreatorClothesMenu, function()
                    for k,v in pairs(CreatorSettings.ClothesList) do 
                        RageUI.Button(v.name, false, {}, true, {
                            onSelected = function()
                                local forEquip
                                if GetEntityModel(GetPlayerPed(-1)) == GetHashKey("mp_m_freemode_01") then
                                    forEquip = v["male"]
                                elseif GetEntityModel(GetPlayerPed(-1)) == GetHashKey("mp_f_freemode_01") then
                                    forEquip = v["female"]
                                end
                                TriggerEvent('skinchanger:getSkin', function(skin)
                                    TriggerEvent('skinchanger:loadClothes', skin, forEquip)
                                end)
                                Wait(125)
                                ESX.ShowNotification(("Vous avez choisit la tenue : ~b~%s~s~."):format(v.name))
                                TriggerEvent('skinchanger:getSkin', function(skin)
                                    TriggerServerEvent('esx_skin:save', skin)
                                end)
                            end,
                        })
                    end
                end)
                RageUI.IsVisible(CharCreatorFeaturesMenu, function()
                    RageUI.Button("Nez", false , {}, true , {}) -- 1
                    RageUI.Button("Profil du nez", false , {}, true , {}) -- 2
                    RageUI.Button("Pointe du nez", false , {}, true , {}) -- 3
                    RageUI.Button("Sourcils", false , {}, true , {}) -- 4
                    RageUI.Button("Pommettes", false , {}, true , {}) -- 5
                    RageUI.Button("Joues", false , {}, true , {}) -- 6
                    RageUI.Button("Yeux", false , {}, true , {}) -- 7
                    RageUI.Button("Lèvres", false , {}, true , {}) -- 8
                    RageUI.Button("Mâchoire", false , {}, true , {}) -- 9
                    RageUI.Button("Menton", false , {}, true , {}) -- 10
                    RageUI.Button("Forme de menton", false , {}, true , {}) -- 11
                    RageUI.Button("Épaisseur du cou", false , {}, true , {}) -- 12
                    RageUI.Grid(CreatorSettings.GridPanels.defaultnose.x, CreatorSettings.GridPanels.defaultnose.y, 'Haut', 'Bas', 'Étroit', 'Large', {
                        onPositionChange = function(IndexX, IndexY, X, Y)
                            CreatorSettings.GridPanels.defaultnose.x = IndexX
                            CreatorSettings.GridPanels.defaultnose.y = IndexY
                            TriggerEvent('skinchanger:change', 'nose_1', IndexX*10)
                            TriggerEvent('skinchanger:change', 'nose_2', IndexY*10)
                        end
                    }, 1)
                    RageUI.Grid(CreatorSettings.GridPanels.defaultnose1.x, CreatorSettings.GridPanels.defaultnose1.y, 'Courber', 'Incurver', 'Long', 'Court', {
                        onPositionChange = function(IndexX, IndexY, X, Y)
                            CreatorSettings.GridPanels.defaultnose1.x = IndexX
                            CreatorSettings.GridPanels.defaultnose1.y = IndexY
                            TriggerEvent('skinchanger:change', 'nose_3', IndexX*10)
                            TriggerEvent('skinchanger:change', 'nose_4', IndexY*10)
                        end
                    }, 2)
                    RageUI.Grid(CreatorSettings.GridPanels.defaultnose2.x, CreatorSettings.GridPanels.defaultnose2.y, 'Haut', 'Bas', 'Court', 'Long', {
                        onPositionChange = function(IndexX, IndexY, X, Y)
                            CreatorSettings.GridPanels.defaultnose2.x = IndexX
                            CreatorSettings.GridPanels.defaultnose2.y = IndexY
                            TriggerEvent('skinchanger:change', 'nose_5', IndexX*10)
                            TriggerEvent('skinchanger:change', 'nose_6', IndexY*10)
                        end
                    }, 3)
                    RageUI.Grid(CreatorSettings.GridPanels.defaulteyebrow.x, CreatorSettings.GridPanels.defaulteyebrow.y, 'Haut', 'Bas', 'Extérieur', 'Intérieur', {
                        onPositionChange = function(IndexX, IndexY, X, Y)
                            CreatorSettings.GridPanels.defaulteyebrow.x = IndexX
                            CreatorSettings.GridPanels.defaulteyebrow.y = IndexY
                            TriggerEvent('skinchanger:change', 'eyebrows_5', IndexX*10)
                            TriggerEvent('skinchanger:change', 'eyebrows_6', IndexY*10)
                        end
                    }, 4)
                    RageUI.Grid(CreatorSettings.GridPanels.defaultcheeks.x, CreatorSettings.GridPanels.defaultcheeks.y, 'Haut', 'Bas', 'Creuser', 'Gonfler', {
                        onPositionChange = function(IndexX, IndexY, X, Y)
                            CreatorSettings.GridPanels.defaultcheeks.x = IndexX
                            CreatorSettings.GridPanels.defaultcheeks.y = IndexY
                            TriggerEvent('skinchanger:change', 'cheeks_1', IndexX*10)
                            TriggerEvent('skinchanger:change', 'cheeks_2', IndexY*10)
                        end
                    }, 5)
                    RageUI.Grid(CreatorSettings.GridPanels.defaultcheeks1.x, CreatorSettings.GridPanels.defaultcheeks1.y, 'Gonfler', 'Creuser', 'Gauche', 'Droite', {
                        onPositionChange = function(IndexX, IndexY, X, Y)
                            CreatorSettings.GridPanels.defaultcheeks1.x = IndexX
                            CreatorSettings.GridPanels.defaultcheeks1.y = IndexY
                            TriggerEvent('skinchanger:change', 'cheeks_3', IndexY*10)
                        end
                    }, 6)
                    RageUI.Grid(CreatorSettings.GridPanels.defaulteyeopen.x, CreatorSettings.GridPanels.defaulteyeopen.y, 'Haut', 'Bas', 'Ouvert', 'Fermer', {
                        onPositionChange = function(IndexX, IndexY, X, Y)
                            CreatorSettings.GridPanels.defaulteyeopen.x = IndexX
                            CreatorSettings.GridPanels.defaulteyeopen.y = IndexY
                            TriggerEvent('skinchanger:change', 'eye_squint', IndexX*10)
                        end
                    }, 7)
                    RageUI.Grid(CreatorSettings.GridPanels.defaultlips.x, CreatorSettings.GridPanels.defaultlips.y, 'Haut', 'Bas', 'Épais', 'Mince', {
                        onPositionChange = function(IndexX, IndexY, X, Y)
                            CreatorSettings.GridPanels.defaultlips.x = IndexX
                            CreatorSettings.GridPanels.defaultlips.y = IndexY
                            TriggerEvent('skinchanger:change', 'lip_thickness', IndexX*10)
                        end
                    }, 8)
                    RageUI.Grid(CreatorSettings.GridPanels.defaultjaw.x, CreatorSettings.GridPanels.defaultjaw.y, 'Rond', 'Carré', 'Étroit', 'Large', {
                        onPositionChange = function(IndexX, IndexY, X, Y)
                            CreatorSettings.GridPanels.defaultjaw.x = IndexX
                            CreatorSettings.GridPanels.defaultjaw.y = IndexY
                            TriggerEvent('skinchanger:change', 'jaw_1', IndexX*10)
                            TriggerEvent('skinchanger:change', 'jaw_2', IndexY*10)
                        end
                    }, 9)
                    RageUI.Grid(CreatorSettings.GridPanels.defaultchin.x, CreatorSettings.GridPanels.defaultchin.y, 'Haut', 'Bas', 'Profond', 'Extérieur', {
                        onPositionChange = function(IndexX, IndexY, X, Y)
                            CreatorSettings.GridPanels.defaultchin.x = IndexX
                            CreatorSettings.GridPanels.defaultchin.y = IndexY
                            TriggerEvent('skinchanger:change', 'chin_1', IndexX*10)
                            TriggerEvent('skinchanger:change', 'chin_2', IndexY*10)
                        end
                    }, 10)
                    RageUI.Grid(CreatorSettings.GridPanels.defaultchin1.x, CreatorSettings.GridPanels.defaultchin1.y, 'Haut', 'Bas', 'Rond', 'Carré', {
                        onPositionChange = function(IndexX, IndexY, X, Y)
                            CreatorSettings.GridPanels.defaultchin1.x = IndexX
                            CreatorSettings.GridPanels.defaultchin1.y = IndexY
                            TriggerEvent('skinchanger:change', 'chin_3', IndexX*10)
                            TriggerEvent('skinchanger:change', 'chin_4', IndexY*10)
                        end
                    }, 11)
                    RageUI.Grid(CreatorSettings.GridPanels.defaultneck.x, CreatorSettings.GridPanels.defaultneck.y, 'Haut', 'Bas', 'Mince', 'Épais', {
                        onPositionChange = function(IndexX, IndexY, X, Y)
                            CreatorSettings.GridPanels.defaultneck.x = IndexX
                            CreatorSettings.GridPanels.defaultneck.y = IndexY
                            TriggerEvent('skinchanger:change', 'neck_thickness', IndexX*10)
                        end
                    }, 12)
                end)
                RageUI.IsVisible(CharCreatorIdentityMenu, function()
                    RageUI.Button("Prénom", false, {RightLabel = CreatorSettings.IdentityFirstName}, true, {
                        onSelected = function()
                            local IdentityFirstName = input("IdentityFirstName", "Entrez votre ~b~prénom~s~ :", "", 25)
                            if IdentityFirstName ~= nil then 
                                CreatorSettings.IdentityFirstName = ""..IdentityFirstName
                                CurrentIdentityFirstName = IdentityFirstName
                            end
                        end
                    })
                    RageUI.Button("Nom", false, {RightLabel = CreatorSettings.IdentityLastName}, true, {
                        onSelected = function()
                            local IdentityLastName = input("IdentityLastName", "Entrez votre ~b~nom~s~ :", "", 25)
                            if IdentityLastName ~= nil then 
                                CreatorSettings.IdentityLastName = ""..IdentityLastName
                                CurrentIdentityLastName = IdentityLastName
                            end
                        end
                    })
                    RageUI.Button("Sexe", false, {RightLabel = CreatorSettings.IdentitySex}, true, {})
                    RageUI.Button("Taille", false, {RightLabel = CreatorSettings.IdentityHeight}, true, {
                        onSelected = function()
                            local IdentityHeight = input("IdentityHeight", "Entrez votre ~b~taille~s~ (140/200) :", "", 3)
                            if IdentityHeight ~= nil then 
                                IdentityHeight = tonumber(IdentityHeight)
                                if type(IdentityHeight) == 'number' then
                                    CreatorSettings.IdentityHeight = ""..IdentityHeight.." cm"
                                    CurrentIdentityHeight = IdentityHeight
                                end
                            end
                        end
                    })
                    RageUI.Button("Date de naissance", false, {RightLabel = CreatorSettings.IdentityDDN}, true, {
                        onSelected = function()
                            local IdentityDDN = input("IdentityDDN", "Entrez votre ~b~date de naissance~s~ (jour/mois/année) :", "", 10)
                            if IdentityDDN ~= nil then 
                                CreatorSettings.IdentityDDN = ""..IdentityDDN
                                CurrentIdentityDDN = IdentityDDN                            
                            end
                        end
                    })
                    if not CreatorSettings.EnableRandomSpawn then 
                        RageUI.List("Lieux d'apparation", CreatorSettings.ApparationList, CreatorSettings.ApparationList.Index , nil, {}, true, {
                            onListChange = function(Index)
                                CreatorSettings.ApparationList.Index = Index 
                            end
                        })
                    end
                    if CurrentIdentityHeight ~= nil and CurrentIdentityDDN ~= nil and CurrentIdentitySex ~= nil and CurrentIdentityFirstName ~= nil and CurrentIdentityLastName ~= nil then 
                        RageUI.Button("~g~Confirmer", false, {RightBadge = RageUI.BadgeStyle.Tick}, true, {
                            onSelected = function()
                                finishedCreation()
                                deletePlayerBoard()
                            end
                        })
                    else
                        RageUI.Button("~g~Confirmer", false, {RightLabel = "→"}, false, {})
                    end
                end)
                Wait(1)
            end
        end)
    end
end

