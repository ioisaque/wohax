require 'AIM'
require 'EXPLOSIVES'
require 'MENU'
require '1HOTKEYS'
require 'WFX_DEF'

function ProjectileDirHook()
  if g_playerIndex == nil then
    return
  end
  
  if g_AimbotId < 1 then
    return
  end
    
    local bone = g_TargetBone
    
  if IsCooperativeMode() then
    if bone == R_EYE then
	  bone = 10
	elseif bone == SPINE2 then
	  bone = 7
	end
  end
  
  local pos = GetPlayerBonePosByID(g_playerIndex, bone)
  
  if (pos.x + pos.y + pos.z) == 0 then
    WFXPrint("invalid bone position")
    return
  end

	if bone == 10 then
	  pos.z = pos.z + 0.1
	end
  
  if g_AimbotId == 2 then
    if CheckInSightFromActorView(pos) then
	  SetProjectileDir(pos)
    end
  end
end

function OnAction(actionId, actiovationMode, value)

  if g_AimbotId ~= 1 then
	return
  end

  if actionId == "attack1" then
    if actiovationMode == 1 then
	  g_Firing = true
	else
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

-- defined in 1hotkeys.lua
WFXRegisterEvent(WFX_EVENTID_KEYDOWN, "OnKeyDown")
WFXRegisterEvent(WFX_EVENTID_KEYUP, "OnKeyUp")

--
WFXToggle(WFX_FUNCTION_ID_NORECOIL, false)
WFXToggle(WFX_FUNCTION_ID_NOSPREAD, false)
WFXToggle(WFX_FUNCTION_ID_VAC, false)
WFXToggle(WFX_FUNCTION_ID_ANTI_FLASH_GRENADE, true)
WFXToggle(WFX_FUNCTION_ID_UNLIMITED_RUN, true)
WFXToggle(WFX_FUNCTION_ID_UNLIMITED_SLIDE, true)