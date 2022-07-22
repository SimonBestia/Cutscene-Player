--[[Cutscene Player Mod
	*By SimonBestia
	 *Special thanks to deadpoolXYZ for the cutscene table
	  *Special thanks to Altamurenza for knowledge on playing unused cutscenes
	   *Special thanks to derpy54320 for the base of the menu code (from The Cure 2)
]]

--Various stuff to store (don't touch)--
Status1 = false
Status2 = false
Status4 = false
Status5 = false
SettingsLimit = 8
if ChapterGet() == 2 then
	SettingsLimit = 7
end
PlayChap3CutsInWinter = false
RoofInFinalShowdown = false
TblRoofTopProps = {}


--Settings--
GameLang = GetLanguage() -- Needs to be commented for the mod to run on PS2, as this function doesn't exist. Language will default to English.
UseNoClip = true -- Toggle Derpy's NoClip On/Off. Will only work if you to have a "NoClip.lur" script in your Scripts.img
PS2 = false -- Same as UseNoClip, set this to true to display info for non-working cutscenes like SE ones.

main = function()

		while not SystemIsReady() and not IsStreamingBusy() and not AreaIsLoading() do
			Wait(0)
		end

		CutscenePlayer()

end

CutscenePlayer = function()

		if UseNoClip then
			LaunchScript("NoClip.lua")
		end
		if PS2 then
			LockFPS30(false)
		end

		F_SetModLanguage()
		F_SetupCuts()

		if not Selection then
			Selection = 1
		end

		while true do

			if not TextVisible then

				if not shared.PlayerInClothingManager then
					if Selection == 1 and PS2 then
						Text = StandardText.."\n\n"..Cuts[Selection].."\n\n"..UnstableText
					elseif Selection == 2 or Selection == 4 or Selection == 14 or Selection == 16 or Selection == 17 or Selection == 92 or Selection == 97 or (PS2 and (Selection == 51 or Selection == 73 or Selection == 76 or Selection == 78 or Selection == 126)) then
						Text = StandardText.."\n\n"..Cuts[Selection].."\n\n"..IncompleteText
					elseif (Selection == 34) or (Selection >= 54 and Selection <= 61 or Selection == 74 or Selection == 75) and PS2 or (Selection == 73 and not PS2) then
						Text = StandardText.."\n\n"..Cuts[Selection].."\n\n"..ExistText
					else
						Text = StandardText.."\n\n"..Cuts[Selection]
					end

					TextPrintString(Text, 0.1, 1)
					TextPrintString(SettingsInfoText.." ~t~", 0.1, 2)

					if F_IsButtonPressedWithDelayCheck(0, 0) then
						Selection = Selection - 1
						if Selection < 1 then
							Selection = table.getn(Cuts)
						end
					elseif F_IsButtonPressedWithDelayCheck(1, 0) then
						Selection = Selection + 1
						if Selection > table.getn(Cuts) then
							Selection = 1
						end
					elseif IsButtonBeingPressed(7, 0) then
						SoundPlay2D("RightBtn")
						PreviousArea = AreaGetVisible()
						X, Y, Z = PlayerGetPosXYZ()
						CameraFade(1000, 0)
						Wait(1000)
						if PlayChap3CutsInWinter then
							if Selection >= 52 and Selection <= 81 then
								PreviousChapter = ChapterGet()
								if PreviousChapter ~= 2 then
									ChapterSet(2)
								end
							end
						end
						if RoofInFinalShowdown then
							if Selection == 118 or Selection == 120 then
								F_SetupRoof()
							end
						end
						if Selection == 20 or Selection == 40 or Selection == 119 or (Selection >= 122 and Selection <= 126) then
							if Selection == 20 or Selection == 123 and PreviousArea ~= 14 then
								AreaTransitionXYZ(14, -502.28, 310.96, 31.41, true)
							elseif Selection == 40 or Selection == 119 or Selection == 126 and PreviousArea ~= 6 then
								AreaTransitionXYZ(6, -708.41, 312.53, 33.38, true)
							elseif Selection == 122 or Selection == 124 or Selection == 125 and PreviousArea ~= 2 then
								AreaTransitionXYZ(2, -628.28, -312.97, 0.00, true)
							end
							LoadCutscene(Cuts[Selection])
							CutSceneSetActionNode(Cuts[Selection])
							if not PS2 then
								LoadCutsceneSound("3-BC")
							else
								LoadCutsceneSound(Cuts[Selection])
							end
							repeat
							Wait(0)
							until IsCutsceneLoaded()
							AreaClearAllPeds()
							StartCutscene()
							CameraFade(1000, 1)
							repeat
							Wait(0)
							until IsButtonBeingPressed(7, 0)
							CameraFade(1000, 0)
							Wait(1000)
							AreaTransitionXYZ(PreviousArea, X, Y, Z)
							StopCutscene()
						else
							PlayCutsceneWithLoad(Cuts[Selection], Status1, Status2, Status4, Status5)
						end
						if PlayChap3CutsInWinter and ChapterGet() ~= PreviousChapter then
							ChapterSet(PreviousChapter)
						end
						if RoofInFinalShowdown then
							for i, Prop in TblRoofTopProps do
								DeletePersistentEntity(Prop.ID, Prop.Pool)
							end
						end
						CameraFade(1000, 1)
					elseif IsButtonBeingPressed(9, 0) then
						F_Settings()
					end
				end

			end

			if IsButtonBeingPressed(10, 0) then
				TextVisible = not TextVisible
			end

		Wait(0)
		end

end

F_SetModLanguage = function()

	--[[Add Other Languages:
		Language IDs: 1 = French, 2 = German, 4 = Spanish, 5 = British (Unused), 6 = Russian, 7 = Japanese
		 *Be as short as possible. Bully has a character limit.
		  *Do not use accents. Bully's debug text doesn't recognise most special characters.
		   *Do not translate code. It needs to be in English. (Text names and button IDs)
	]]

		if GameLang == 3 then	-- Italian
			StandardText = "Premi ~x~ per guardare:"
			CreditsText = "Autore: SimonBestia\n\nRingraziamenti Speciali:\ndeadpoolXYZ, Altamurenza & derpy54320"
			UnstableText = "Scena instabile!"
			IncompleteText = "Non ha abbastanza rimanenze.\nNon avviarla."
			ExistText = "Non esiste.\nNon avviarla."
			SettingsInfoText = "Info e Impostazioni:"
			SettingsText = "Cutscene Player Impostazioni"
			SettingsSel2Text = "Se true, la scena inizia 1 secondo prima"
			SettingsSel4Text = "Se true, il giocatore non viene teletrasportato al luogo iniziale"
			SettingsSel4Text = "Se true, il giocatore non viene teletrasportato al luogo della scena"
			BackText = "~o~ Indietro"
			ShowCreditsText = "~x~ Mostra Crediti"
			ToggleMenu = "Attiva/Disattiva Menu: ~L2~"
			ToggleMenuPS2 = "Attiva/Disattiva Menu: ~L1~"
		else	-- English
			StandardText = "Press ~x~ to play Cutscene:"
			CreditsText = "Author: SimonBestia\n\nSpecial Thanks:\ndeadpoolXYZ, Altamurenza & derpy54320"
			UnstableText = "Unstable scene!"
			IncompleteText = "Incomplete leftovers.\nDon't play."
			ExistText = "Doesn't exist.\nDon't play."
			SettingsInfoText = "Info and Settings:"
			SettingsText = "Cutscene Player Settings"
			SettingsSel2Text = "If true, cutscene starts 1 second earlier"
			SettingsSel4Text = "If true, player won't be teleported to previous position"
			SettingsSel5Text = "If true, player won't be teleported to where the cutscene takes place"
			BackText = "~o~ Back"
			ShowCreditsText = "~x~ Show Credits"
			ToggleMenu = "Toggle Menu: ~L2~"
			ToggleMenuPS2 = "Toggle Menu: ~L1~"
		end

end

function F_SetupCuts()

	Cuts = {
	"1-01",
	"1-02",
	"1-02B",
	"1-02C",
	"1-02D",
	"1-02E",
	"1-03",
	"1-04",
	"1-05",
	"1-06",
	"1-06B",
	"1-07",
	"1-08",
	"1-08B",
	"1-09",
	"1-09B",
	"1-1-02",
	"1-1-1",
	"1-1-2",
	"1-1",
	"1-10",
	"1-11",
	"1-B",
	"1-BB",
	"1-BC",
	"1-G1",
	"1-S01",
	"2-0",
	"2-01",
	"2-02",
	"2-03",
	"2-03b",
	"2-04",
	"2-04B",
	"2-05",
	"2-06",
	"2-07",
	"2-08",
	"2-09",
	"2-09A",
	"2-09B",
	"2-B",
	"2-BB",
	"2-G2",
	"2-S02",
	"2-S04",
	"2-S05",
	"2-S05B",
	"2-S05C",
	"2-S06",
	"2-S07",
	"3-0",
	"3-01",
	"3-01AA",
	"3-01AB",
	"3-01BA",
	"3-01CA",
	"3-01CB",
	"3-01DA",
	"3-01DB",
	"3-01DC",
	"3-02",
	"3-03",
	"3-04",
	"3-04B",
	"3-05",
	"3-06",
	"3-B",
	"3-BB",
	"3-BC",
	"3-BD",
	"3-G3",
	"3-R05",
	"3-R05A",
	"3-R05B",
	"3-R07",
	"3-S03",
	"3-S08",
	"3-S10",
	"3-S11",
	"3-S11C",
	"4-0",
	"4-01",
	"4-02",
	"4-03",
	"4-04",
	"4-05",
	"4-06",
	"4-B1",
	"4-B1B",
	"4-B1C",
	"4-B1C2",
	"4-B1D",
	"4-B2",
	"4-B2B",
	"4-G4",
	"4-S11",
	"4-S12",
	"4-S12B",
	"5-0",
	"5-01",
	"5-02",
	"5-02B",
	"5-03",
	"5-04",
	"5-05",
	"5-05B",
	"5-06",
	"5-07",
	"5-09",
	"5-09B",
	"5-B",
	"5-BC",
	"5-G5",
	"6-0",
	"6-02",
	"6-02B",
	"6-B",
	"6-B2",
	"6-BB",
	"6-BC",
	"candidate",
	"CS_COUNTER",
	"FX-TEST",
	"TEST",
	"weedkiller"
	}

end

function F_SetupRoof()

		-- Rooftop models
		PropID, PropPool = CreatePersistentEntity('SC1b_fence_d', 186.021, -73.3169, 35.3693, 0, 0)
		table.insert(TblRoofTopProps, {ID = PropID, Pool = PropPool})
		PropID, PropPool = CreatePersistentEntity('SC1d_lad04', 190.857, -73.0157, 35.4244, 0, 0)
		table.insert(TblRoofTopProps, {ID = PropID, Pool = PropPool})
		PropID, PropPool = CreatePersistentEntity('SC1d_bldgmain_A', 191.754, -73.3854, 51.0535, 0, 0)
		table.insert(TblRoofTopProps, {ID = PropID, Pool = PropPool})
		PropID, PropPool = CreatePersistentEntity('SC_FanBlade03', 178.574, -73.157, 23.2994, 0, 0)
		table.insert(TblRoofTopProps, {ID = PropID, Pool = PropPool})
		PropID, PropPool = CreatePersistentEntity('SC_FanBlade02', 178.57, -73.1494, 23.1368, 0, 0)
		table.insert(TblRoofTopProps, {ID = PropID, Pool = PropPool})
		PropID, PropPool = CreatePersistentEntity('FGRD_SC1b20', 186.239, -73.3414, 34.9336, 0, 0)
		table.insert(TblRoofTopProps, {ID = PropID, Pool = PropPool})
		if WeatherGet() == 2 or WeatherGet() == 5 then
			PropID, PropPool = CreatePersistentEntity('SC1d_bldgmain_wtr01', 186.087, -73.4308, 23.9015, 0, 0)
			table.insert(TblRoofTopProps, {ID = PropID, Pool = PropPool})
		end
		PropID, PropPool = CreatePersistentEntity('SC1d_roofsteps', 195.981, -79.7682, 43.6757, 0, 0)
		table.insert(TblRoofTopProps, {ID = PropID, Pool = PropPool})
		PropID, PropPool = CreatePersistentEntity('DL_SC1d_L', 189.734, -72.4095, 33.7901, 0, 0)
		table.insert(TblRoofTopProps, {ID = PropID, Pool = PropPool})
		PropID, PropPool = CreatePersistentEntity('PR_AlleyLamp', 182.208, -67.7659, 29.8164, 0, 0)
		table.insert(TblRoofTopProps, {ID = PropID, Pool = PropPool})
		PropID, PropPool = CreatePersistentEntity('pxLad3M', 181.94, -64.992, 23.2626, 0, 0)
		table.insert(TblRoofTopProps, {ID = PropID, Pool = PropPool})
		PropID, PropPool = CreatePersistentEntity('pxLad4M', 186.38, -66.1529, 26.0975, 90, 0)
		table.insert(TblRoofTopProps, {ID = PropID, Pool = PropPool})
		PropID, PropPool = CreatePersistentEntity('Ladder_5M', 184.314, -80.2621, 35.6872, 90, 0)
		table.insert(TblRoofTopProps, {ID = PropID, Pool = PropPool})
		PropID, PropPool = CreatePersistentEntity('pxLad5M', 204.592, -67.2104, 30.3007, 0, 0)
		table.insert(TblRoofTopProps, {ID = PropID, Pool = PropPool})
		PropID, PropPool = CreatePersistentEntity('Scaffold', 178.173, -73.1613, 40.1403, 0, 0)
		table.insert(TblRoofTopProps, {ID = PropID, Pool = PropPool})
		PropID, PropPool = CreatePersistentEntity('Scaffold', 178.173, -73.1613, 35.2763, 0, 0)
		table.insert(TblRoofTopProps, {ID = PropID, Pool = PropPool})
		PropID, PropPool = CreatePersistentEntity('Scaffold', 178.173, -73.1613, 30.5194, 0, 0)
		table.insert(TblRoofTopProps, {ID = PropID, Pool = PropPool})
		PropID, PropPool = CreatePersistentEntity('Ladder_3M', 181.94, -65.028, 23.2625, 0, 0)
		table.insert(TblRoofTopProps, {ID = PropID, Pool = PropPool})
		PropID, PropPool = CreatePersistentEntity('Ladder_4M', 186.435, -66.1529, 26.0975, 90, 0)
		table.insert(TblRoofTopProps, {ID = PropID, Pool = PropPool})
		PropID, PropPool = CreatePersistentEntity('pxLad5M', 184.349, -80.2622, 35.6869, -90, 0)
		table.insert(TblRoofTopProps, {ID = PropID, Pool = PropPool})
		PropID, PropPool = CreatePersistentEntity('Ladder_5M', 204.592, -67.2498, 30.301, 0, 0)
		table.insert(TblRoofTopProps, {ID = PropID, Pool = PropPool})
		PropID, PropPool = CreatePersistentEntity('Ladder_4M', 186.002, -81.7648, 23.2896, 0, 0)
		table.insert(TblRoofTopProps, {ID = PropID, Pool = PropPool})
		PropID, PropPool = CreatePersistentEntity('pxLad4M', 186.002, -81.78, 23.2896, 180, 0)
		table.insert(TblRoofTopProps, {ID = PropID, Pool = PropPool})
		PropID, PropPool = CreatePersistentEntity('pxLad3M', 197.356, -81.2369, 29.6798, 90, 0)
		table.insert(TblRoofTopProps, {ID = PropID, Pool = PropPool})
		PropID, PropPool = CreatePersistentEntity('Ladder_3M', 197.398, -81.2371, 29.6798, 90, 0)
		table.insert(TblRoofTopProps, {ID = PropID, Pool = PropPool})
		PropID, PropPool = CreatePersistentEntity('pxLad3M', 199.835, -80.9096, 32.6819, 180, 0)
		table.insert(TblRoofTopProps, {ID = PropID, Pool = PropPool})
		PropID, PropPool = CreatePersistentEntity('Ladder_3M', 199.835, -80.881, 32.6818, 0, 0)
		table.insert(TblRoofTopProps, {ID = PropID, Pool = PropPool})
		PropID, PropPool = CreatePersistentEntity('SCBell', 197.159, -75.7203, 46.4597, 0, 0)
		table.insert(TblRoofTopProps, {ID = PropID, Pool = PropPool})
		PropID, PropPool = CreatePersistentEntity('SCBell', 191.725, -75.7203, 46.4597, 0, 0)
		table.insert(TblRoofTopProps, {ID = PropID, Pool = PropPool})
		PropID, PropPool = CreatePersistentEntity('SCBell', 191.725, -73.4447, 46.4597, 0, 0)
		table.insert(TblRoofTopProps, {ID = PropID, Pool = PropPool})
		PropID, PropPool = CreatePersistentEntity('SCBell', 186.275, -73.4447, 46.4597, 0, 0)
		table.insert(TblRoofTopProps, {ID = PropID, Pool = PropPool})
		PropID, PropPool = CreatePersistentEntity('SCBell', 186.275, -71.1643, 46.4597, 0, 0)
		table.insert(TblRoofTopProps, {ID = PropID, Pool = PropPool})
		PropID, PropPool = CreatePersistentEntity('BrickPile', 203.279, -66.6406, 30.7234, 0, 0)
		table.insert(TblRoofTopProps, {ID = PropID, Pool = PropPool})
		PropID, PropPool = CreatePersistentEntity('BrickPile01', 204.748, -77.8347, 36.1466, 0, 0)
		table.insert(TblRoofTopProps, {ID = PropID, Pool = PropPool})
		PropID, PropPool = CreatePersistentEntity('BrickPile02', 186.117, -79.5076, 36.1196, 0, 0)
		table.insert(TblRoofTopProps, {ID = PropID, Pool = PropPool})
		PropID, PropPool = CreatePersistentEntity("WheelBrl", 183, -80.2706, 41.078, 0, 0)
		table.insert(TblRoofTopProps, {ID = PropID, Pool = PropPool})
		PropID, PropPool = CreatePersistentEntity("WheelBrl", 204.582, -68.668, 35.6995, 0, 0)
		table.insert(TblRoofTopProps, {ID = PropID, Pool = PropPool})
		PropID, PropPool = CreatePersistentEntity('WALKTschoolRoofOP', 186.462, -73.2229, 37.8194, 0, 0)
		table.insert(TblRoofTopProps, {ID = PropID, Pool = PropPool})
		PropID, PropPool = CreatePersistentEntity("pxTrel10M", 294.797, -18.145, 6.54785, 0, 0)
		table.insert(TblRoofTopProps, {ID = PropID, Pool = PropPool})
		PropID, PropPool = CreatePersistentEntity('SCBell2', 197.159, -73.4447, 46.4597, 0, 0)
		table.insert(TblRoofTopProps, {ID = PropID, Pool = PropPool})
		PropID, PropPool = CreatePersistentEntity('SCBell2', 197.159, -71.1643, 46.4597, 0, 0)
		table.insert(TblRoofTopProps, {ID = PropID, Pool = PropPool})
		PropID, PropPool = CreatePersistentEntity('SCBell2', 191.722, -71.1643, 46.4597, 0, 0)
		table.insert(TblRoofTopProps, {ID = PropID, Pool = PropPool})
		PropID, PropPool = CreatePersistentEntity('SCBell2', 186.275, -75.7203, 46.4597, 0, 0)
		table.insert(TblRoofTopProps, {ID = PropID, Pool = PropPool})
		PropID, PropPool = CreatePersistentEntity('NOGO_tschoolRoofOP', 186.462, -73.2229, 30.3808, 0, 0)
		table.insert(TblRoofTopProps, {ID = PropID, Pool = PropPool})

		Wait(1500)

		-- Collision and animations, copied from 6_B because I'm lazy
		PAnimSetActionNode("SCBell", 197.159, -75.7203, 46.4597, 1, "/Global/SCBELL/Idle/IdleAnimationChooser/animstart1", "Act/Props/SCBell.act")
		PAnimSetActionNode("SCBell2", 197.159, -73.4447, 46.4597, 1, "/Global/SCBELL/Idle/IdleAnimationChooser/animstart2", "Act/Props/SCBell.act")
		PAnimSetActionNode("SCBell2", 197.159, -71.1643, 46.4597, 1, "/Global/SCBELL/Idle/IdleAnimationChooser/animstart3", "Act/Props/SCBell.act")
		PAnimSetActionNode("SCBell", 191.725, -75.7203, 46.4597, 1, "/Global/SCBELL/Idle/IdleAnimationChooser/animstart4", "Act/Props/SCBell.act")
		PAnimSetActionNode("SCBell", 191.725, -73.4447, 46.4597, 1, "/Global/SCBELL/Idle/IdleAnimationChooser/animstart5", "Act/Props/SCBell.act")
		PAnimSetActionNode("SCBell2", 191.725, -71.1643, 46.4597, 1, "/Global/SCBELL/Idle/IdleAnimationChooser/animstart6", "Act/Props/SCBell.act")
		PAnimSetActionNode("SCBell2", 186.275, -75.7203, 46.4597, 1, "/Global/SCBELL/Idle/IdleAnimationChooser/animstart7", "Act/Props/SCBell.act")
		PAnimSetActionNode("SCBell", 186.275, -73.4447, 46.4597, 1, "/Global/SCBELL/Idle/IdleAnimationChooser/animstart8", "Act/Props/SCBell.act")
		PAnimSetActionNode("SCBell", 186.275, -71.1643, 46.4597, 1, "/Global/SCBELL/Idle/IdleAnimationChooser/animstart9", "Act/Props/SCBell.act")
		GeometryInstance('SCBell', false, 197.15899658203, -75.72029876709, 46.459701538086, false)
		GeometryInstance('SCBell2', false, 197.15899658203, -73.444702148438, 46.459701538086, false)
		GeometryInstance('SCBell2', false, 197.15899658203, -71.16429901123, 46.459701538086, false)
		GeometryInstance('SCBell', false, 191.72500610352, -75.72029876709, 46.459701538086, false)
		GeometryInstance('SCBell', false, 191.72500610352, -73.444702148438, 46.459701538086, false)
		GeometryInstance('SCBell2', false, 191.72500610352, -71.16429901123, 46.459701538086, false)
		GeometryInstance('SCBell2', false, 186.27499389648, -75.72029876709, 46.459701538086, false)
		GeometryInstance('SCBell', false, 186.27499389648, -73.444702148438, 46.459701538086, false)
		GeometryInstance('SCBell', false, 186.27499389648, -71.16429901123, 46.459701538086, false)

		Wait(1000)

end

F_Settings = function()

		if PS2 then
			ToggleMenu = ToggleMenuPS2
		end

		if not SettingsSelection then
			SettingsSelection = 1
		end

		if not Menu1 then
			if Menu2 or Menu3 then
			else
				Menu1 = true
			end
		end

		while true do

			if not TextVisible then
				if not shared.playerShopping then
					if Menu1 then
						text = ""
						if SettingsSelection == 0 then text = text..">" end
						text = text..SettingsText.." (1/3)\n\n"
						if SettingsSelection == 1 then text = text..">" end
						text = text.."Avoid Fade In: "..tostring(Status1).."\n"
						if SettingsSelection == 2 then text = text..">" end
						text = text.."Avoid Fade Out: "..tostring(Status2).."\n"
					elseif Menu2 then
						text = ""
						if SettingsSelection == 3 then text = text..">" end
						text = text..SettingsText.." (2/3)\n\n"
						if SettingsSelection == 4 then text = text..">" end
						text = text.."Don't Transition Back: "..tostring(Status4).."\n"
						if SettingsSelection == 5 then text = text..">" end
						text = text.."Don't Transition To: "..tostring(Status5).."\n"
					elseif Menu3 then
						text = ""
						if SettingsSelection == 6 then text = text..">" end
						text = text..SettingsText.." (3/3)\n\n"
						if ChapterGet() ~= 2 then
							if SettingsSelection == 7 then text = text..">" end
							text = text.."Roof in Final Showdown: "..tostring(RoofInFinalShowdown).."\n"
							if SettingsSelection == 8 then text = text..">" end
							text = text.."Chap. 3 Cuts in Winter: ".." "..tostring(PlayChap3CutsInWinter).."\n"
						else
							if SettingsSelection == 7 then text = text..">" end
							text = text.."Roof in Final Showdown: "..tostring(RoofInFinalShowdown).."\n"
						end
					end
					TextPrintString(text.."\n\n"..ToggleMenu, 0, 1)
					if SettingsSelection == 2 then
						bottomtext = SettingsSel2Text
					elseif SettingsSelection == 4 then
						bottomtext = SettingsSel4Text
					elseif SettingsSelection == 5 then
						bottomtext = SettingsSel5Text
					end
					if not (SettingsSelection == 2 or SettingsSelection == 4 or SettingsSelection == 5) then
						TextPrintString("\n\n"..ShowCreditsText, 0, 2)
					else
						TextPrintString(bottomtext.."\n\n"..ShowCreditsText, 0, 2)
					end

					if F_IsButtonPressedWithDelayCheck(0, 0) then
						if (SettingsSelection == 0 or SettingsSelection == 3 or SettingsSelection == 6) then
							SoundPlay2D('NavDwn')
							if Menu1 then
								Menu1 = false
								Menu2 = false
								Menu3 = true
							elseif Menu2 then
								Menu1 = true
								Menu2 = false
								Menu3 = false
							elseif Menu3 then
								Menu1 = false
								Menu2 = true
								Menu3 = false
							end
						else
							if SettingsSelection == 1 then
								Status1 = not Status1
							end
							if SettingsSelection == 2 then
								Status2 = not Status2
							end
							if SettingsSelection == 4 then
								Status4 = not Status4
							end
							if SettingsSelection == 5 then
								Status5 = not Status5
							end
							if SettingsSelection == 7 then
								RoofInFinalShowdown = not RoofInFinalShowdown
							end
							if SettingsSelection == 8 then
								PlayChap3CutsInWinter = not PlayChap3CutsInWinter
							end
						end
					elseif F_IsButtonPressedWithDelayCheck(1, 0) then
						if (SettingsSelection == 0 or SettingsSelection == 3 or SettingsSelection == 6) then
							SoundPlay2D('NavUp')
							if Menu1 then
								Menu1 = false
								Menu2 = true
								Menu3 = false
							elseif Menu2 then
								Menu1 = false
								Menu2 = false
								Menu3 = true
							elseif Menu3 then
								Menu1 = true
								Menu2 = false
								Menu3 = false
							end
						else
							if SettingsSelection == 1 then
								Status1 = not Status1
							end
							if SettingsSelection == 2 then
								Status2 = not Status2
							end
								if SettingsSelection == 4 then
								Status4 = not Status4
							end
							if SettingsSelection == 5 then
								Status5 = not Status5
							end
							if SettingsSelection == 7 then
								RoofInFinalShowdown = not RoofInFinalShowdown
							end
							if SettingsSelection == 8 then
								PlayChap3CutsInWinter = not PlayChap3CutsInWinter
							end
						end
					end
					if F_IsButtonPressedWithDelayCheck(2, 0) then
						SettingsSelection = SettingsSelection - 1
						SoundPlay2D('NavUp')
						if Menu1 then
							if (SettingsSelection < 0 or SettingsSelection > 2) then
								SettingsSelection = 2
							end
						elseif Menu2 then
							if (SettingsSelection < 3 or SettingsSelection > 5) then
								SettingsSelection = 5
							end
						elseif Menu3 then
							if (SettingsSelection < 6 or SettingsSelection > SettingsLimit) then
								SettingsSelection = SettingsLimit
							end
						end
					end
					if F_IsButtonPressedWithDelayCheck(3, 0) then
						SettingsSelection = SettingsSelection + 1
						SoundPlay2D('NavDwn')
						if Menu1 then
							if (SettingsSelection < 0 or SettingsSelection > 2) then
								SettingsSelection = 0
							end
						elseif Menu2 then
							if (SettingsSelection < 3 or SettingsSelection > 5) then
								SettingsSelection = 3
							end
						elseif Menu3 then
							if (SettingsSelection < 6 or SettingsSelection > SettingsLimit) then
								SettingsSelection = 6
							end
						end
					end
					if IsButtonBeingPressed(7, 0) then
						repeat
							TextPrintString(CreditsText.."\n\n"..BackText, 0, 2)
						Wait(0)
						until IsButtonBeingPressed(8, 0)
						SoundPlay2D("WrongBtn")
						Wait(100)
						F_Settings()
					end
					if IsButtonBeingPressed(8, 0) then
						SoundPlay2D("WrongBtn")
						main()
					end
				end
			end
			
			if IsButtonBeingPressed(10, 0) then
				TextVisible = not TextVisible
			end

		Wait(0)
		end

end