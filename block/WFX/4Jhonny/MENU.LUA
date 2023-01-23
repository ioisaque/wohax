require 'AIM'
require 'BONES'
require 'COLORS'
require 'MAGNETIC'
require 'EXPLOSIVES'

x = 10
y = 10
line_space = 12

function DrawString(color, text)
  LDrawString(x,y,1,0,color,text)
  y = y + line_space 
end

function GetColor(b)
  if b then
    return DARKGREEN
  end
  return RED
end

function GetStatusText(b)
  if b then
    return ": Ligado"
  end
  return ": Desligado"
 end
 
function GetAimBoneText()
   if g_TargetBone == R_EYE or g_TargetBone == 10 then
     return "<Cabeca>"
   elseif g_TargetBone == SPINE2 or g_TargetBone == 7 then
     return "<Corpo>"
   end      
   return "desconhecido"
end;

function GetBotVacText()
   if g_BotVacId == 0 then
     return "ALL"
   elseif g_BotVacId == 1 then
     return "Iron Man"	 
   elseif g_BotVacId == 2 then
     return "CQBs"
   elseif g_BotVacId == 3 then
     return "Spec Ops"
   elseif g_BotVacId == 4 then
     return "Sniper"	
   elseif g_BotVacId == 5 then
     return "Escudos"	
   elseif g_BotVacId == 6 then
     return "Assault's"		 
   else 
   return "desconhecido"
   end    
end;

function Welcome()
HORA = os.date("%H")
	if (HORA >= '0' and HORA < '06') then
		MMS = 'Boa Madrugada'
	elseif (HORA >= '06' and HORA < '12') then
		MMS = 'Bom Dia'
	elseif (HORA >= '12' and HORA < '18') then
		MMS = "Boa Tarde"
	else
		MMS = "Boa Noite"
	end
	return MMS
end;

function GetHMS(HMS, Tipo)
	if Tipo == 'H' then
        --
        if HMS == 1 then
        return 'hora'
        else
        return 'horas'
        end
        --
	elseif Tipo == 'M' then
        --
        if HMS == 1 then
        return 'mim'
        else
        return 'mims'
        end
        --		
	elseif Tipo == 'S' then
        --
        if HMS == 1 then
        return 'seg'
        else
        return 'segs'
        end
        --
	end
end
 
function DrawMenu()
  x = 10
  y = 10
  DrawString(WHITE, "===|ESPECIAL PARA CLAS|===")
  DrawString(BLUE, "                 ")
  DrawString(GetColor(g_AimbotId ~= 0), string.format("[NUM 5] Aimbot  %d %s %s", g_AimbotId, GetAimBoneText(), GetStatusText(g_AimbotId ~= 0)))
  DrawString(BLUE, "                 ")
  DrawString(GetColor(g_IsNameESP_Enabled), string.format("[F5] ESP Name %s", GetStatusText(g_IsNameESP_Enabled)))
  DrawString(GetColor(g_IsSkeletonESP_Enabled), string.format("[F6] ESP Skeleton %s", GetStatusText(g_IsSkeletonESP_Enabled)))
  DrawString(GetColor(g_IsCircleESP_Enabled), string.format("[F7] ESP Circle %s", GetStatusText(g_IsCircleESP_Enabled)))
  DrawString(GetColor(g_IsExplosivesESP_Enabled), string.format("[F8] ESP Explosives %s", GetStatusText(g_IsExplosivesESP_Enabled)))
  DrawString(BLUE, "                 ")
  DrawString(GetColor(WFXGetStatus(WFX_FUNCTION_ID_NORECOIL)), string.format("[F9] No Recoil %s", GetStatusText(WFXGetStatus(WFX_FUNCTION_ID_NORECOIL))))
  DrawString(GetColor(WFXGetStatus(WFX_FUNCTION_ID_NOSPREAD)), string.format("[F11] No Spread %s", GetStatusText(WFXGetStatus(WFX_FUNCTION_ID_NOSPREAD))))
  DrawString(BLUE, "                 ")
  DrawString(GetColor(WFXGetStatus(WFX_FUNCTION_ID_UNLIMITED_RUN)), string.format("[NUM 1] Corrida infinita %s", GetStatusText(WFXGetStatus(WFX_FUNCTION_ID_UNLIMITED_RUN))))
  DrawString(GetColor(WFXGetStatus(WFX_FUNCTION_ID_UNLIMITED_SLIDE)), string.format("[NUM 2] Deslize infinito %s", GetStatusText(WFXGetStatus(WFX_FUNCTION_ID_UNLIMITED_SLIDE))))
  DrawString(GetColor(WFXGetStatus(WFX_FUNCTION_ID_ANTI_FLASH_GRENADE)), string.format("[NUM 3] Anti-flash %s", GetStatusText(WFXGetStatus(WFX_FUNCTION_ID_ANTI_FLASH_GRENADE))))
  DrawString(BLUE, "                 ")
  DrawString(YELLOW, "[INSERT] DESLIGAR TUDO")
  DrawString(YELLOW, "[PAGEUP] BLOQUEAR TUDO")
  DrawString(BLUE, "                 ")
if (IsCooperativeMode()) then 
  DrawString(GetColor(WFXGetStatus(WFX_FUNCTION_ID_VAC)), string.format("[DEL] Magnetic  %d  %s", g_vacId+1, GetStatusText(WFXGetStatus(WFX_FUNCTION_ID_VAC))))
  DrawString(WHITE, string.format("[HOME] Magnetic Vacing: %s", GetBotVacText()))
  DrawString(GetColor(g_IsSafeVac_Enabled), string.format("[NUM 4] Atrair somente visiveis %s", GetStatusText(g_IsSafeVac_Enabled)))
  DrawString(BLUE, "                 ")
end
  if g_playerIndex ~= nil then
    if g_IsNameESP_Enabled then
	  DrawString(WHITE, string.format("Alvo Atual: %s", GetPlayerName(g_playerIndex))) 	  
	  DrawString(BLUE, "                 ")
    end
  end
  DrawString(YELLOW, string.format("%s, tudo bem?  =]", Welcome(), string.char(227), os.date('%H')))
  DrawString(ORANGE, string.format("Agora s%so: %d %s, %d %s e %d %s.", string.char(227), os.date('%H'), GetHMS(os.date('%H'), 'H'), os.date('%M'), GetHMS(os.date('%M'), 'M'), os.date('%S'), GetHMS(os.date('%S'), 'S')))
  LDrawString(x+65,y,10,10,YELLOW, string.format(os.date('%d %b %Y')))
  DrawString(YELLOW, string.format("E Hoje e dia:"))
end