require 'colors'
require 'aim'
require 'bones'
require 'explosives'
require 'magnetic'

x = 10
y = 10
line_space = 12

function DrawString(color, text)
  LDrawString(x,y,1,0,color,text)
  y = y + line_space 
end

function GetColor(b)
  if b then
    return COLOR_GREEN
  end
  return COLOR_RED
end


function GetColor01(b)
  if b then
    return COLOR_YELLOW
  end
  return COLOR_RED
end




function GetStatusText(b)
  if b then
    return ""
  end
  return ""
 end

 function GetAimBoneText()
   if g_TargetBone == L_EYE then
     return "Cabeca"
   elseif g_TargetBone == SPINE2 then
     return "Corpo"
   end   
   return "desconhecido"
 end;


function DrawMenu()
  x = 10
  y = 10
  DrawString(COLOR_AQUA, "[==============[PVP]==============]")  
  DrawString(GetColor(g_AimbotId ~= 0), string.format("[F5/PAGE DOWN] Aimbot  (%d) ", g_AimbotId, (g_AimbotId ~= 0)))
  DrawString(GetColor(g_IsSkeletonESP_Enabled), string.format("[F6] Skeleton ESP %s", GetStatusText(g_IsSkeletonESP_Enabled)))
  DrawString(GetColor(WFXGetStatus(WFX_FUNCTION_ID_ENDLESS_RUNNING)), string.format("[F7] Endless running %s", GetStatusText(WFXGetStatus(WFX_FUNCTION_ID_ENDLESS_RUNNING))))
  DrawString(GetColor(WFXGetStatus(WFX_FUNCTION_ID_ANTI_FLASH_GRENADE)), string.format("[F8] Anti-flash grenade %s", GetStatusText(WFXGetStatus(WFX_FUNCTION_ID_ANTI_FLASH_GRENADE))))
  DrawString(GetColor(WFXGetStatus(WFX_FUNCTION_ID_NORECOIL)), string.format("[F9] No Recoil %s", GetStatusText(WFXGetStatus(WFX_FUNCTION_ID_NORECOIL))))
  DrawString(GetColor(WFXGetStatus(WFX_FUNCTION_ID_NOSPREAD)), string.format("[F11] No Spread %s", GetStatusText(WFXGetStatus(WFX_FUNCTION_ID_NOSPREAD))))
  --DrawString(GetColor01(g_AutoFire_Enabled), string.format("[CTRL+A] AUTO FIRE %s", GetStatusText(g_AutoFire_Enabled)))
  DrawString(GetColor(g_IsBOXESP_Enabled), string.format("[CTRL+B] 2D Box ESP %s", GetStatusText(g_IsBOXESP_Enabled)))
  DrawString(GetColor(g_IsNameESP_Enabled), string.format("[CTRL+N] ESP Name %s", GetStatusText(g_IsNameESP_Enabled)))
  DrawString(GetColor(g_IsExplosivesESP_Enabled), string.format("[CTRL+M] Explosives ESP %s", GetStatusText(g_IsExplosivesESP_Enabled)))
   if (IsCooperativeMode()) then
	DrawString(COLOR_AQUA, "[==============[COOP]==============]") 
    --DrawString(GetColor(g_IsJump_Enabled), string.format("[CTRL+J] Jump Hack %s", GetStatusText(g_IsJump_Enabled)))
	DrawString(GetColor(g_IsSafeVac_Enabled), string.format("[CTRL+S] Safe Magnetic Vac %s", GetStatusText(g_IsSafeVac_Enabled)))
	 DrawString(GetColor(WFXGetStatus(WFX_FUNCTION_ID_VAC)), string.format("[DEL] Magnetic Vac (%d) %s", g_vacId+1, GetStatusText(WFXGetStatus(WFX_FUNCTION_ID_VAC))))
	DrawString(GetColor(g_doVacIronManOnly), string.format("[CTRL+X] Puxar so Artilheiro %s", GetStatusText(g_doVacIronManOnly)))
	DrawString(GetColor(g_doDisableVacOnIronManDown), string.format("[CTRL+Z] Desativar Mag ao destroir Artilheiro %s", GetStatusText(g_doDisableVacOnIronManDown)))
 end
  DrawString(COLOR_AQUA, "[==============[Menu]==============]") 
  DrawString(COLOR_WHITE, "[END] Menu ON/OFF")
  
  LDrawString(x+149,22,22,22, COLOR_YELLOW, GetAimBoneText())

end