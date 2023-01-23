require 'esp'
require 'vk'
require 'colors'
require 'bones'

SCRIPT_AIMBOT_ID_CROSSHAIR_MOVE          = 1
SCRIPT_AIMBOT_ID_CROSSHAIR_NOMOVE_NORMAL = 2
SCRIPT_AIMBOT_ID_CROSSHAIR_NOMOVE_360    = 3

g_oldWeaponId = 0
g_playerIndex = nil
g_oldDistance = 99999.0
g_Firing = false
g_TargetBone = SPINE2
g_IsExplosivesESP_Enabled = true
g_IsSkeletonESP_Enabled = true
g_IsBOXESP_Enabled = false
g_AimbotId = SCRIPT_AIMBOT_ID_CROSSHAIR_NOMOVE_NORMAL
g_IsNameESP_Enabled = true
g_IsJump_Enabled = false
g_IsSafeVac_Enabled = true 
g_doVacIronManOnly = true -- puxar só artilheiro
g_doDisableVacOnIronManDown = true -- desabilitar aimbot quando o artilheiro for destruido
g_doAimBodyOnIronManVaccing = true -- mudar aimbot pro corpo quando o artilheiro estiver sendo sugado
g_ViewAngle = 90.0
g_Radious = 8.0

function OnWeaponChange(newWeaponId)
  --WFXPrint(string.format("New Weapon is: %d", newWeaponId))
  --[[if newWeaponId == WEAPON_ID_2ND then
    WFXPrint("changed to head")
    g_TargetBone = L_EYE
  end--]]
end

function OnTargetChange(newTargetPlayer)
  --PlayAction("attack1", 2, 0.0)
  --WFXPrint(string.format("New target is: %s", GetPlayerName(newTargetPlayer)))
end

function IsEnemy(player)
  return GetPlayerTeam(player) ~= GetPlayerTeam(GetPlayerActor())
end

g_IsFreeForAll = false

function IsFreeForAllEnum(player)
  if IsEnemy(player) then
    g_IsFreeForAll = false
  end
end

function IsFreeForAll()
  g_IsFreeForAll = true
  EnumPlayers("IsFreeForAllEnum")
  return g_IsFreeForAll
end

function IsHelicopter(player)
  return string.find(GetPlayerName(player), "Helicopter_") ~= nil
end

function GetDistanceFromCrosshair(pos)
  local out = WorldToScreen(pos)
  if (out.x + out.y + out.z) > 0 then
    local screen = GetScreenResolution()
	screen.x = screen.x/2
	screen.y = screen.y/2
	return math.sqrt((out.x - screen.x) ^ 2 + ((out.y) - (screen.y)))
  end
  return 99999.0
end
	
function EnumCallback(player)

  -- verifica se o player é o proprio char
  if player == GetPlayerActor() then
    return
  end
  
  -- verifica se o player está vivo
  if not IsPlayerAlive(player) then
    return
  end
     
  -- verifica se o player é inimigo  
  if not IsFreeForAll() then
    if not IsEnemy(player) then    
      return
	end
  elseif IsCooperativeMode() then
    return
  end
  
  --WFXPrint(string.format("%s",  player))
  
         
  -- pega a posicao do corpo
  local pos = GetPlayerBonePosByID(player, g_TargetBone)
  
  if (pos.x + pos.y + pos.z) == 0 then
    WFXPrint("aim.lua::invalid bone position")
    return
  end  
  
  --WFXPrint(string.format("0x%x", player))
  --WFXPrint(string.format("%f %f %f", pos.x, pos.y, pos.z))
  
  local color = COLOR_RED
    
  if CheckInSightFromActorView(pos) then
    color = COLOR_BLUE
  end
      
  --adicionei a funcao de ESP aqui pois se fizer outro loop pra listar os players no "esp.lua" consumirá mais o CPU
  if g_IsSkeletonESP_Enabled then
    esp(player, color)
  end
  
  --WFXPrint(string.format("%s", GetPlayerName(player)))
    
  if g_IsBOXESP_Enabled then
    esp_box(player,color)
  end
  
  if g_IsNameESP_Enabled then
    esp_name(player,COLOR_GREEN)
  end
 
  if g_AimbotId == SCRIPT_AIMBOT_ID_CROSSHAIR_NOMOVE_360 then --se aim 3
    -- se for helicoptero nao mira com o aim 3
    if IsHelicopter(player) then
	  return
	end
	
    if color == COLOR_BLUE then
	  g_playerIndex = player
	  --WFXPrint(string.format("target is: %s", GetPlayerName(player)))	 
	end
    return	
  end
  
  --g_playerIndex = player
  
  -- pega a distancia do alvo ate a mira
  local dist = GetDistanceFromCrosshair(pos) 
    
  --WFXPrint(string.format("%f", dist))
  
  if dist ~= 99999.0 then
    --WFXPrint(string.format("%f", dist))
	-- se estiver mais proximo que o antigo, salva o alvo
	if dist < g_oldDistance then
	  g_oldDistance = dist
	  g_playerIndex = player
    end
  end
 
end

function MarkPlayer(player)
  local head = GetPlayerBonePosByID(g_playerIndex, g_TargetBone)
  local pos = WorldToScreen(head)
  FDrawCircle(pos.x, pos.y, 4, 8, COLOR_GREEN)
end
  
local old_tick = 0
  
function Fire()
  if (GetTickCount() - old_tick) > 100 then    
    PlayAction("attack1", 1, 1.0)
	PlayAction("attack1", 2, 0.0)
	old_tick = GetTickCount()
  end
end
  
function aim()  
  g_playerIndex = nil
  g_oldDistance = 99999.0  
  EnumPlayers("EnumCallback")
    
  --screen = GetScreenResolution()
  --FDrawString(screen.x/2, screen.y/2 - 50, 30, 10, COLOR_BLUE, string.format("angle is %f :: radious is %f", g_ViewAngle, g_Radious))

  local w = GetCurrentActorWeaponType();
  
  if w ~= g_oldWeaponId then
    OnWeaponChange(w)
	g_oldWeaponId = w
  end
    
  if g_playerIndex ~= nil then
     
    if g_playerIndex ~= g_oldPlayerIndex then
	  OnTargetChange(g_playerIndex)
	  g_oldPlayerIndex = g_playerIndex
	end
  
    if g_IsNameESP_Enabled then
	  if g_AimbotId == SCRIPT_AIMBOT_ID_CROSSHAIR_NOMOVE_360 then
	  
	    if (w == WEAPON_ID_1ST) or (w == WEAPON_ID_2ND) then
		  Fire()
		end
	  
	    screen = GetScreenResolution()
	    FDrawString(screen.x/2, screen.y/2, 30, 10, COLOR_BLUE, string.format("Shoot!!! player '%s' is visible at the Aim3 FOV!", GetPlayerName(g_playerIndex)))
	  else
	    MarkPlayer(player) 
	  end
	end
    if g_Firing and (g_AimbotId == SCRIPT_AIMBOT_ID_CROSSHAIR_MOVE) then
	  if (w == WEAPON_ID_1ST) or (w == WEAPON_ID_2ND) then
	    local pos = GetPlayerBonePosByID(g_playerIndex, g_TargetBone)
		if CheckInSightFromActorView(pos) then
	      LookAt(pos)
		end
	  end
	end
  end

end