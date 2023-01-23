require 'aim'
require 'explosives'
require 'menu'
require '1hotkeys'
require 'wfx_def'

function ProjectileDirHook()
  --WFXPrint("OnStartFire")
  if g_playerIndex == nil then
    --WFXPrint("target player is NULL")
    return
  end
  
  if g_AimbotId == 0 then
    return
  end
	
  local pos = GetPlayerBonePosByID(g_playerIndex, g_TargetBone)
  
  if (pos.x + pos.y + pos.z) == 0 then
    WFXPrint("invalid bone position")
    return
  end
	
  if (g_AimbotId == 2) or (g_AimbotId == 3) then
    if CheckInSightFromActorView(pos) then
	  --WFXPrint(string.format("using aim %d", g_AimbotId))
	  SetProjectileDir(pos)
    end
  end
end

function OnAction(actionId, actiovationMode, value)
  
  --WFXPrint(string.format("OnAction(%s, %d, %f)", actionId, actiovationMode, value))

  if string.find(actionId, "attack1") ~= nil then
  
    --WFXPrint("attack")
  
    if actiovationMode == 1 then
      --WFXPrint("FIRE START")
	  g_Firing = true
	  if (g_AimbotId == 1) and (g_playerIndex ~= nil) then
	    local w = GetCurrentActorWeaponType();
	    if (w == WEAPON_ID_1ST) or (w == WEAPON_ID_2ND) then
		  local pos = GetPlayerBonePosByID(g_playerIndex, g_TargetBone)	   
		  if CheckInSightFromActorView(pos) then
		    --WFXPrint("using aim 1")
			LookAt(pos)		  
		  end
		end
	  end
	else	  
	  --WFXPrint("FIRE STOP")	  
	  g_Firing = false	  
	end
  end
end

function OnDraw()
  if g_canShowMenu then
    DrawMenu()
  end
  explosives_esp()
  aim()
end

WFXRegisterEvent(WFX_EVENTID_DRAW, "OnDraw")
WFXRegisterEvent(WFX_EVENTID_PROJECTILEDIR, "ProjectileDirHook")
WFXRegisterEvent(WFX_EVENTID_ACTION, "OnAction")

WFXRegisterEvent(WFX_EVENTID_KEYDOWN, "OnKeyDown")
WFXRegisterEvent(WFX_EVENTID_KEYUP, "OnKeyUp")
--WFXRegisterEvent(WFX_EVENTID_WINDOW_LOST_FOCUS, "OnGameWindowLostFocus")
--
WFXToggle(WFX_FUNCTION_ID_NORECOIL, false)
WFXToggle(WFX_FUNCTION_ID_NOSPREAD, false)
WFXToggle(WFX_FUNCTION_ID_VAC, false)
WFXToggle(WFX_FUNCTION_ID_ANTI_FLASH_GRENADE, true)
WFXToggle(WFX_FUNCTION_ID_ENDLESS_RUNNING, true)
--SetActorJump(1)

