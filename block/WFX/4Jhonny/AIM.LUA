require 'WFX_DEF'
require 'COLORS'
require 'BONES'
require 'ESP'
require 'VK'

g_oldWeaponId = 0
g_playerIndex = nil
g_oldDistance = 99999.0
g_Firing = false
g_TargetBone = R_EYE
g_BotVacId = 0
g_AimbotId = 1
g_doBotVacOnly = true
g_IsExplosivesESP_Enabled = true
g_IsSkeletonESP_Enabled = true
g_IsCircleESP_Enabled = true
g_IsNameESP_Enabled = true
g_IsSafeVac_Enabled = false

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
  
  -- pega a posicao do corpo
    local bone = g_TargetBone
    
  if IsCooperativeMode() then
    if bone == R_EYE then
	  bone = 10
	elseif bone == SPINE2 then
	  bone = 7
	end
  end
  
  local pos = GetPlayerBonePosByID(player, bone)
  
  if (pos.x + pos.y + pos.z) == 0 then
    WFXPrint("aim.lua::invalid bone position")
    return
  end  

	if bone == 10 then
	  pos.z = pos.z + 0.1
	end
  
  local color = RED

  if CheckInSightFromActorView(pos) then
    color = DARKGREEN
  end

  --adicionei a funcao de ESP aqui pois se fizer outro loop pra listar os players no "esp.lua" consumirá mais o CPU
  if g_IsSkeletonESP_Enabled then
	esp(player, color)
  end
	
  if g_IsCircleESP_Enabled then
    esp_circle(player,AQUA)
  end
  
  if g_IsNameESP_Enabled then
    esp_name(player,DARKGREEN)
  end

  if g_AimbotId == 2 then
    if IsHelicopter(player) then
	  return
	end	
    if color == DARKGREEN then
	  g_playerIndex = player
	end	
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
    local bone = g_TargetBone
    
  if IsCooperativeMode() then
    if bone == R_EYE then
	  bone = 10
	elseif bone == SPINE2 then
	  bone = 7
	end
  end

  local head = GetPlayerBonePosByID(g_playerIndex, bone)
  local pos = WorldToScreen(head)
  
  	if bone == 10 then
	  pos.z = pos.z + 0.1
	end
	
  FDrawCircle(pos.x, pos.y, 4, 8, YELLOW)
end
  
function aim()  
  g_playerIndex = nil
  g_oldDistance = 99999.0  
  EnumPlayers("EnumCallback")
  
  local w = GetCurrentActorWeaponType();
     
  if g_playerIndex ~= nil then
  
  if g_IsSkeletonESP_Enabled then MarkPlayer(player) end

  if not g_AimbotId == 1 then
	 return
  end
	
    if g_Firing then
	  if (w == WEAPON_ID_1ST) or (w == WEAPON_ID_2ND) then
	    local pos = GetPlayerBonePosByID(g_playerIndex, g_TargetBone)
		if CheckInSightFromActorView(pos) then
	      LookAt(pos)
		end
	  end
	end
  end
end