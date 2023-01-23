require 'AIM'
require 'VK'
require 'COLORS'
require 'WFX_DEF'
require 'EXPLOSIVES'

--globals vars
IsControlPressed = false
g_canShowMenu = true
block = false
--

function ChangeAimBone()
  if g_TargetBone == R_EYE then
	g_TargetBone = SPINE2
  else
	g_TargetBone = R_EYE   
  end
 end

function OnKeyUp(Key)
      
  if Key == VK_CONTROL then
    IsControlPressed = false
  end 

  if Key == KEY_PGUP then
	block = not block
  end

  if not block then
  
  --esconde/mostra o menu
  if Key == VK_END then
    g_canShowMenu = not g_canShowMenu
  end
 
  --muda aimbot pra corpo ou cabeca
  if Key == KEY_PGDN then
    ChangeAimBone()
  end 

  --habilita/desabilita aimbots
  if Key == VK_NUMPAD5 then 
    g_AimbotId = g_AimbotId + 1
	if g_AimbotId > 2 then
	  g_AimbotId = 0	  
	end
  end

  --habilita/desabilita magnetic
  if Key == VK_DEL then
    local newState = WFXGetStatus(WFX_FUNCTION_ID_VAC)
	if newState then 
	  if g_vacId == 0 then
	    g_vacId = 1
		g_vacPos = GetPlayerPos(GetPlayerActor())
		g_vacPos.y = g_vacPos.y + 1.5
	  elseif g_vacId == 1 then
        g_vacId = 0
        WFXToggle(WFX_FUNCTION_ID_VAC, false)
      end
	else
	  WFXRegisterEvent(WFX_EVENTID_VAC, "VacHandler")
	  WFXToggle(WFX_FUNCTION_ID_VAC, true)
	  g_vacId = 0
	end
  end

  --change bot vacing
  if Key == 38 then 
    g_BotVacId = g_BotVacId + 1
	if g_BotVacId > 6 then
	  g_BotVacId = 0	  
	end
  end

  if Key == 40 then 
    g_BotVacId = g_BotVacId - 1
	if g_BotVacId < 0 then
	  g_BotVacId = 6	  
	end
  end
  
  if Key == 36 then
    g_BotVacId = 0
  end
  
  --habilita/desabilita name esp
   if Key == VK_F5 then
	g_IsNameESP_Enabled = not g_IsNameESP_Enabled
   end   
  
  if Key == VK_F6 then
    g_IsSkeletonESP_Enabled = not g_IsSkeletonESP_Enabled  
  end

  if Key == VK_F7 then
    g_IsCircleESP_Enabled = not g_IsCircleESP_Enabled
  end
   
   if Key == VK_F8 then
    g_IsExplosivesESP_Enabled = not g_IsExplosivesESP_Enabled
   end  
  
  if Key == VK_F9 then
    local newState = not WFXGetStatus(WFX_FUNCTION_ID_NORECOIL)
	WFXToggle(WFX_FUNCTION_ID_NORECOIL, newState)
  end
  
  if Key == VK_F11 then
    local newState = not WFXGetStatus(WFX_FUNCTION_ID_NOSPREAD)
	WFXToggle(WFX_FUNCTION_ID_NOSPREAD, newState)
  end

  if Key == VK_NUMPAD1 then
    local newState = not WFXGetStatus(WFX_FUNCTION_ID_UNLIMITED_RUN)
    WFXToggle(WFX_FUNCTION_ID_UNLIMITED_RUN, newState)
  end
  
  if Key == VK_NUMPAD2 then
    local newState = not WFXGetStatus(WFX_FUNCTION_ID_UNLIMITED_SLIDE)
    WFXToggle(WFX_FUNCTION_ID_UNLIMITED_SLIDE, newState)
  end
  
  if Key == VK_NUMPAD3 then
    local newState = not WFXGetStatus(WFX_FUNCTION_ID_ANTI_FLASH_GRENADE)
    WFXToggle(WFX_FUNCTION_ID_ANTI_FLASH_GRENADE, newState)
  end

  if Key == VK_NUMPAD4 then
    g_IsSafeVac_Enabled = not g_IsSafeVac_Enabled
  end
  
  if Key == 45 then -- 45 = 'INSERT'
	g_IsNameESP_Enabled = false
	g_IsSkeletonESP_Enabled = false
	g_IsExplosivesESP_Enabled = false
		WFXToggle(WFX_FUNCTION_ID_NORECOIL, false)
		WFXToggle(WFX_FUNCTION_ID_UNLIMITED_RUN, false)
		WFXToggle(WFX_FUNCTION_ID_UNLIMITED_SLIDE, false)
		WFXToggle(WFX_FUNCTION_ID_ANTI_FLASH_GRENADE, false)
		WFXToggle(WFX_FUNCTION_ID_NOSPREAD, false)
		WFXToggle(WFX_FUNCTION_ID_VAC, false)
	g_IsCircleESP_Enabled = false
	g_canShowMenu = false
	g_AutoFire_Enabled = false
	g_AimbotId = 0
   end
  end
end

function OnKeyDown(Key)
  if Key == VK_CONTROL then
    IsControlPressed = true
  end 
end 

WFXRegisterEvent(WFX_EVENTID_KEYDOWN, "OnKeyDown")
WFXRegisterEvent(WFX_EVENTID_KEYUP, "OnKeyUp")