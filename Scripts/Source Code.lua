--[[Cutscene Player Mod
	*By SimonBestia
	 *Special thanks to deadpoolXYZ for the cutscene table
	  *Special thanks to Altamurenza for knowledge on playing unused cutscenes
]]

--Settings--
UseNoClip = true --Toggle Derpy's NoClip On/Off. Will only work if you to have a "NoClip.lur" script in your Scripts.img
PS2 = false --Same as UseNoClip, set this to true to display info for non-working cutscenes like SE ones.


main = function()

		repeat
		Wait(0)
		until SystemIsReady() and not IsStreamingBusy() and not AreaIsLoading()

		CutscenePlayer()

end

CutscenePlayer = function()

		if UseNoClip then
			LaunchScript("NoClip.lua")
		end
		if PS2 then
			LockFPS30(false)
		end

		F_SetupCuts()
		Selection = 1
		StandardText = "Press ~x~ to play Cutscene:\n\n"

		while true do

			if not shared.PlayerInClothingManager then
				if Selection == 1 and PS2 then
					Text = StandardText..Cuts[Selection].."\n1-01 is unstable!"
				elseif Selection == 17 or Selection == 97 then
					Text = StandardText..Cuts[Selection].."\nDoesn't really exist. Don't play."
				elseif Selection >= 54 and Selection <= 61 and PS2 then
					Text = StandardText..Cuts[Selection].."\nDoesn't exist. Don't play."
				else
					Text = StandardText..Cuts[Selection]
				end

				TextPrintString(Text, 0.1, 1)

				if ChapterGet() ~= 2 then
					TextPrintString("Info and Settings: ~t~", 0.1, 2)
				else
					TextPrintString("Author: SimonBestia\nSpecial Thanks: deadpoolXYZ", 0.1, 2)
				end

				if IsButtonPressed(0, 0) then
					Selection = Selection - 1
					if Selection < 1 then
						Selection = table.getn(Cuts)
					end
				elseif IsButtonPressed(1, 0) then
					Selection = Selection + 1
					if Selection > table.getn(Cuts) then
						Selection = 1
					end
				elseif IsButtonBeingPressed(7, 0) then
					PreviousArea = AreaGetVisible()
					X, Y, Z = PlayerGetPosXYZ()
					if Selection >= 52 and Selection <= 81 then
						if PlayChap3CutsInWinter then
							PreviousChapter = ChapterGet()
							if PreviousChapter ~= 2 then
								ChapterSet(2)
							end
						end
					end
					SoundPlay2D("RightBtn")
					if Selection == 20 or Selection == 40 or Selection == 119 or Selection == 122 or Selection == 123 or Selection == 124 or Selection == 125 or Selection == 126 then
						AreaDisableCameraControlForTransition(true)
						CameraFade(1000, 0)
						Wait(1000)
						if Selection == 20 or Selection == 122 and AreaGetVisible() ~= 14 then
							AreaTransitionXYZ(14, -502.28, 310.96, 31.41)
						elseif Selection == 40 or Selection == 119 or Selection == 126 and AreaGetVisible() ~= 6 then
							AreaTransitionXYZ(6, -708.41, 312.53, 33.38)
						elseif Selection == 123 or Selection == 124 or Selection == 125 and AreaGetVisible() ~= 2 then
							AreaTransitionXYZ(2, -628.28, -312.97, 0.00)
						end
						LoadCutscene(Cuts[Selection])
						CutSceneSetActionNode(Cuts[Selection])
						LoadCutsceneSound("3-BC")
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
						StopCutscene()
						AreaDisableCameraControlForTransition(false)
					else
						PlayCutsceneWithLoad(Cuts[Selection], true)
					end
					AreaTransitionXYZ(PreviousArea, X, Y, Z)
					if PlayChap3CutsInWinter then
						ChapterSet(PreviousChapter)
					end
					CameraFade(1000, 1)
				elseif IsButtonBeingPressed(9, 0) then
					F_Settings()
				end
			end

		Wait(0)
		end

end

F_SetupCuts = function()

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
	"CS_COUNTER",
	"FX-TEST",
	"TEST",
	"candidate",
	"weedkiller"
	}

end

F_Settings = function()

		if ChapterGet() ~= 2 then

			while true do

				if not shared.playerShopping then
					if not PlayChap3CutsInWinter then
						TextPrintString("Chapter 3 Cutscenes in Winter: False\n\nToggle True/False: ~x~", 0.1, 1)
					else
						TextPrintString("Chapter 3 Cutscenes in Winter: True\n\nToggle True/False: ~x~", 0.1, 1)
					end

					TextPrintString("Author: SimonBestia\nSpecial Thanks: deadpoolXYZ\nAltamurenza", 0.1, 2)

					if IsButtonBeingPressed(8, 0) then
						SoundPlay2D("WrongBtn")
						main()
					elseif IsButtonBeingPressed(7, 0) then
						if not PlayChap3CutsInWinter then
							PlayChap3CutsInWinter = true
						elseif PlayChap3CutsInWinter then
							PlayChap3CutsInWinter = false
						end
					end
				end

			Wait(0)
			end

		end

end


--STimeCycle.lur
function F_AttendedClass()
  if IsMissionCompleated("3_08") and not IsMissionCompleated("3_08_PostDummy") then
    return 
  end
  SetSkippedClass(false)
  PlayerSetPunishmentPoints(0)
end
function F_MissedClass()
  if IsMissionCompleated("3_08") and not IsMissionCompleated("3_08_PostDummy") then
    return 
  end
  SetSkippedClass(true)
  StatAddToInt(166)
end
function F_AttendedCurfew()
  if not PedInConversation(gPlayer) and not MissionActive() then
    TextPrintString("You got home in time for curfew", 4)
  end
end
function F_MissedCurfew()
  if not PedInConversation(gPlayer) and not MissionActive() then
    TextPrint("TM_TIRED5", 4, 2)
  end
end
function F_StartClass()
  if IsMissionCompleated("3_08") and not IsMissionCompleated("3_08_PostDummy") then
    return 
  end
  F_RingSchoolBell()
  local l_6_0 = PlayerGetPunishmentPoints() + GetSkippingPunishment()
end
function F_EndClass()
  if IsMissionCompleated("3_08") and not IsMissionCompleated("3_08_PostDummy") then
    return 
  end
  F_RingSchoolBell()
end
function F_StartMorning()
  F_UpdateTimeCycle()
end
function F_EndMorning()
  F_UpdateTimeCycle()
end
function F_StartLunch()
  if IsMissionCompleated("3_08") and not IsMissionCompleated("3_08_PostDummy") then
    F_UpdateTimeCycle()
    return 
  end
  F_UpdateTimeCycle()
end
function F_EndLunch()
  F_UpdateTimeCycle()
end
function F_StartAfternoon()
  F_UpdateTimeCycle()
end
function F_EndAfternoon()
  F_UpdateTimeCycle()
end
function F_StartEvening()
  F_UpdateTimeCycle()
end
function F_EndEvening()
  F_UpdateTimeCycle()
end
function F_StartCurfew_SlightlyTired()
  F_UpdateTimeCycle()
end
function F_StartCurfew_Tired()
  F_UpdateTimeCycle()
end
function F_StartCurfew_MoreTired()
  F_UpdateTimeCycle()
end
function F_StartCurfew_TooTired()
  F_UpdateTimeCycle()
end
function F_EndCurfew_TooTired()
  F_UpdateTimeCycle()
end
function F_EndTired()
  F_UpdateTimeCycle()
end
function F_Nothing()
end
function F_ClassWarning()
  if IsMissionCompleated("3_08") and not IsMissionCompleated("3_08_PostDummy") then
    return 
  end
  local l_23_0 = math.random(1, 2)
end
function F_UpdateTimeCycle()
  if not IsMissionCompleated("1_B") then
    local l_24_0 = GetCurrentDay(false)
    if l_24_0 < 0 or l_24_0 > 2 then
      SetCurrentDay(0)
    end
  end
  F_UpdateCurfew()
end
function F_UpdateCurfew()
  local l_25_0 = shared.gCurfewRules
  if not l_25_0 then
    l_25_0 = F_CurfewDefaultRules
  end
  l_25_0()
end
function F_CurfewDefaultRules()
  local l_26_0 = ClockGet()
  if l_26_0 >= 23 or l_26_0 < 6 then
    shared.gCurfew = true
  else
    shared.gCurfew = false
  end
end