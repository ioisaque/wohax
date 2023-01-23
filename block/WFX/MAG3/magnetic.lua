require 'bones'
require 'wfx_def'
require 'aim'

g_vacId = 0
g_vacPos = GetPlayerPos(0)
g_UpdateView = false

function Vac(player)
  local pos = g_vacPos	
  if g_vacId == 0 then
    pos = GetPlayerPos(GetPlayerActor())
	pos.y = pos.y + 1.5
  end 	  
  SetVacPos(pos)
end

function IsIronMan(player)
  return string.find(GetPlayerName(player), "IronMan_") ~= nil
end

function IsMech(player)
  return string.find(GetPlayerName(player), "mech") ~= nil
end

function IsHelicopter(player)
  return string.find(GetPlayerName(player), "Helicopter_") ~= nil
end

g_Mech = nil
function findMechCallback(player)
  if (g_Mech == nil) and IsMech(player) then
    g_Mech = player
  end
end

function findMech()
  g_Mech = nil
  EnumPlayers("findMechCallback")
  return g_Mech
end

g_Helicopter = nil
function findHelicopterCallback(player)
  if (g_Helicopter == nil) and IsHelicopter(player) then
    g_Helicopter = player
  end
end

function findHelicopter()
  g_Helicopter = nil
  EnumPlayers("findHelicopterCallback")
  return g_Helicopter
end

function VacHandler(player)
  local actor = GetPlayerActor();
   
  if player == actor then    
  
    if g_vacId ~= 2 then
	  return
	end
  
	local vacPlayer = findMech()
	if vacPlayer == nil then 
	  vacPlayer = findHelicopter()
	end
	
	if vacPlayer == nil then
	  return
	end
	
	if not IsPlayerAlive(vacPlayer) then
	  return
	end
		
	if vacPlayer ~= nil then
	  --WFXPrint(string.format("vacPlayer name is: %s", GetPlayerName(vacPlayer)))
	  
	  pos = GetPlayerBonePosByID(vacPlayer, HEAD)
	  
	  if (pos.x + pos.y + pos.z) == 0 then
	    WFXPrint("não foi possível localizar a posição da cabeça do alvo")
		return
	  end
	  
	  if g_UpdateView then
	    LookAt(pos)
		g_UpdateView = false
	  end

	  --[[e ai gente ainda lembram das aulas de trigonometria da escola? papai sh0z sim! rs      
       formula magica para girar em volta do mech/helicoptero e encontrar um angulo mais agravável para disparar o tiro...
	     --- : raio*cosseno(angulo de visão)+posição do alvo do plano cartesiano
	  --]]
	  pos.x = g_Radious * math.cos(math.rad(g_ViewAngle)) + pos.x
	  pos.y = g_Radious * math.sin(math.rad(g_ViewAngle)) + pos.y
	  --pos.z = pos.z + 2.0
      SetVacPos(pos)
	end
	return
  end

  if g_doVacIronManOnly and IsIronMan(player) then
    if IsPlayerAlive(player) then	  
	  if g_doAimBodyOnIronManVaccing then
	    --WFXPrint("VacHandler::aim target changed to body")
		g_TargetBone = SPINE2
	  end		
	  Vac(player)
	else
	  if g_doDisableVacOnIronManDown then
	    g_vacId = 0
		WFXToggle(WFX_FUNCTION_ID_VAC, false)
	  end	  
    end
	return
  end

  if not IsPlayerAlive(player) then
    return
  end
  
  if GetPlayerTeam(actor) == GetPlayerTeam(player) then
    return
  end

  if g_IsSafeVac_Enabled then
    local pos = GetPlayerBonePosByID(player, g_TargetBone)  
	--não puxa se não estiver visivel
    if not CheckInSightFromActorView(pos) then
	  return 
	end	
	--nao puxa os bots se o player estiver usando faca
	if GetCurrentActorWeaponType() == WEAPON_ID_3RD then
	  return
	end	
	--WFXPrint(string.format("magnetic: %s", GetPlayerName(player)))
  end
	
  Vac(player)
end