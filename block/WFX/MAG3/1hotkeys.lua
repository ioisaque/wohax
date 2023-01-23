require 'vk'
require 'colors'
require 'aim'
require 'explosives'
require 'wfx_def'

hotkeysObjectInitialized = false

--globals vars
IsControlPressed = false
g_canShowMenu = true
--

function OnGameWindowLostFocus(activated)
  if activated == 0 then
    IsControlPressed = false  
	--WFXPrint("window lost focus")
  end
end

function ChangeAimBone()
  if g_TargetBone == L_EYE then
    g_TargetBone = SPINE2
  else
    g_TargetBone = L_EYE
  end
end

function OnKeyUp(Key)
  --WFXPrint(string.format("KeyUp: %d", Key))
     
  if Key == VK_CONTROL then
    IsControlPressed = false
	--WFXPrint("Control up")
  end 
  
  --muda aimbot pra corpo ou cabeca
  if Key == KEY_PGDN then
    ChangeAimBone()
  end 
  
  --esconde/mostra o menu
  if Key == VK_END then
    g_canShowMenu = not g_canShowMenu
  end
  
  if IsControlPressed then	
  
  
    --Ativa/Desativa o AutoFire
   	if Key == VK_A then
    g_AutoFire_Enabled = not g_AutoFire_Enabled
    end
  
    if Key == VK_Z then
	  g_doDisableVacOnIronManDown = not g_doDisableVacOnIronManDown
	end
  
    if Key == VK_X then
	  g_doVacIronManOnly = not g_doVacIronManOnly
	end
  
    if Key == VK_S then
	  g_IsSafeVac_Enabled = not g_IsSafeVac_Enabled
	end
  
    if Key == VK_J then
	  g_IsJump_Enabled = not g_IsJump_Enabled
	  if g_IsJump_Enabled then  
	    SetActorJump(3)
	  else
	    SetActorJump(0)
	  end
	end
  
    
	 if Key == VK_B then -- 66 = 'B'
	  g_IsBOXESP_Enabled = not g_IsBOXESP_Enabled
	end  

    if Key == VK_N then -- 78 = 'N'
	  g_IsNameESP_Enabled = not g_IsNameESP_Enabled
	end  
	
    if Key == VK_M then
	  g_IsExplosivesESP_Enabled = not g_IsExplosivesESP_Enabled
    end  
	  
    --recarrega os scripts
	if Key == 13 then --enter
	  WFXReloadScripts()
	  return
    end
  end
 
  --habilita/desabilita aimbots
  if Key == VK_F5 then 
    g_AimbotId = g_AimbotId + 1
	if g_AimbotId > 3 then
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
	  else
		g_vacId = 0
		WFXToggle(WFX_FUNCTION_ID_VAC, false)
		end
	else
	  WFXRegisterEvent(WFX_EVENTID_VAC, "VacHandler")
	  WFXToggle(WFX_FUNCTION_ID_VAC, true)
	  g_vacId = 0
	end
  end

  --habilita/desabilita name esp
  if Key == VK_F6 then
    g_IsSkeletonESP_Enabled = not g_IsSkeletonESP_Enabled  
  end
  
  if Key == VK_F9 then
    local newState = not WFXGetStatus(WFX_FUNCTION_ID_NORECOIL)
	WFXToggle(WFX_FUNCTION_ID_NORECOIL, newState)
  end
  
  if Key == VK_F11 then
    local newState = not WFXGetStatus(WFX_FUNCTION_ID_NOSPREAD)
	WFXToggle(WFX_FUNCTION_ID_NOSPREAD, newState)
  end  
  
     if Key == VK_F8 then 
	  local newState = not WFXGetStatus(WFX_FUNCTION_ID_ANTI_FLASH_GRENADE)
	  WFXToggle(WFX_FUNCTION_ID_ANTI_FLASH_GRENADE, newState)
	end  
  
  
  if Key == VK_F7 then
    local newState = not WFXGetStatus(WFX_FUNCTION_ID_ENDLESS_RUNNING)
	WFXToggle(WFX_FUNCTION_ID_ENDLESS_RUNNING, newState)
  end
end

function OnKeyDown(Key)
  --WFXPrint(string.format("KeyDown: %d", Key))
  
  if Key == VK_CONTROL then
    IsControlPressed = true
  end 
end 