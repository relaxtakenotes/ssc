-- Thank god for sublime text and it's easy keybinds...
-- I'd never do any of this with my own bare hands
local player_stepsoundtime_ladder = 0
local player_stepsoundtime_water = 0
local player_stepsoundtime_run = 0
local player_stepsoundtime_walk = 0
local player_stepsoundtime_slowwalk = 0
local player_speed_walk = 0
local player_speed_run = 0
local player_speed_slowwalk = 0
local player_speed_maxspeed = 0
local player_speed_ducking = 0
local player_speed_unducking = 0
local player_speed_crouched_walk = 0

hook.Add("PlayerStepSoundTime", "apply_custom_playerstepsoundtime", function(ply, iType, bWalking)
	player_stepsoundtime_ladder = GetConVarNumber("sv_player_stepsoundtime_ladder")
	player_stepsoundtime_water = GetConVarNumber("sv_player_stepsoundtime_water")
	player_stepsoundtime_run = GetConVarNumber("sv_player_stepsoundtime_run")
	player_stepsoundtime_walk = GetConVarNumber("sv_player_stepsoundtime_walk")
	player_stepsoundtime_slowwalk = GetConVarNumber("sv_player_stepsoundtime_slowwalk")
	player_stepsoundtime_crouch_separate = GetConVarNumber("sv_player_stepsoundtime_crouch_separate")

	local fStepTime = 350
	local fMaxSpeed = ply:GetMaxSpeed()

	if (iType == STEPSOUNDTIME_NORMAL || iType == STEPSOUNDTIME_WATER_FOOT) then
		if (fMaxSpeed <= player_speed_slowwalk) then
			fStepTime = player_stepsoundtime_slowwalk
		elseif (fMaxSpeed <= player_speed_walk) then
			fStepTime = player_stepsoundtime_walk
		else
			fStepTime = player_stepsoundtime_run
		end
	elseif (iType == STEPSOUNDTIME_ON_LADDER) then
		fStepTime = player_stepsoundtime_ladder
	elseif (iType == STEPSOUNDTIME_WATER_KNEE) then
		fStepTime = player_stepsoundtime_water
	end
	
	-- Step slower if crouching
	if (ply:Crouching() && player_stepsoundtime_crouch_separate != 0) then
		fStepTime = player_stepsoundtime_crouch_separate
	elseif ply:Crouching() && player_stepsoundtime_crouch_separate == 0 then 
		fStepTime = fStepTime + 50
	end

	return fStepTime
end)

hook.Add("PlayerFootstep", "apply_custom_player_speed", function(ply, pos, foot, sound, volume, rf)
	player_speed_walk = GetConVarNumber("sv_player_speed_walk")
	player_speed_run = GetConVarNumber("sv_player_speed_run")
	player_speed_slowwalk = GetConVarNumber("sv_player_speed_slowwalk")
	player_speed_maxspeed = GetConVarNumber("sv_player_speed_maxspeed")
	player_speed_ducking = GetConVarNumber("sv_player_speed_ducking")
	player_speed_unducking = GetConVarNumber("sv_player_speed_unducking")
	player_speed_crouched_walk = GetConVarNumber("sv_player_speed_crouched_walk")
	player_speed_ladder = GetConVarNumber("sv_player_speed_ladder")
	ply:SetWalkSpeed(player_speed_walk)
	ply:SetSlowWalkSpeed(player_speed_slowwalk)
	ply:SetUnDuckSpeed(player_speed_unducking)
	ply:SetDuckSpeed(player_speed_ducking)
	ply:SetRunSpeed(player_speed_run)
	ply:SetMaxSpeed(player_speed_maxspeed)
	ply:SetCrouchedWalkSpeed(player_speed_crouched_walk)
	ply:SetLadderClimbSpeed(player_speed_ladder)
end)

if GetConVarNumber("sv_player_speed_override_weapons") == 1 then
	hook.Remove("SetupMove", "ArcCW_SetupMove")
	hook.Remove("SetupMove", "tfa_setupmove")
end
