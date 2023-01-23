require 'bones'
require 'wfx_def'
require 'aim'

g_vacId = 0
g_vacPos = GetPlayerPos(0)

function IsIronMan(player)
  return string.find(GetPlayerName(player), "IronMan_") ~= nil
end

function IsCQB(player)
  return string.find(GetPlayerName(player), "Shotgun_") ~= nil
end

function IsSpecops(player)
  return string.find(GetPlayerName(player), "Specops_") ~= nil
end

function IsAssault(player)
  return string.find(GetPlayerName(player), "Assault_") ~= nil
end

function IsSniper(player)
  return string.find(GetPlayerName(player), "Sniper_") ~= nil
end

function IsEscudo(player)
  return string.find(GetPlayerName(player), "ShieldBearer_") ~= nil
end

function IsDemo(player)
  return string.find(GetPlayerName(player), "CT_Demoman") ~= nil
end

function Vac(player)
  local pos = g_vacPos	
  if g_vacId == 0 then
    pos = GetPlayerPos(GetPlayerActor())
	pos.y = pos.y + 1.5
  end 	  
  SetVacPos(pos)
end

function VacHandler(player)
  local actor = GetPlayerActor();

  if player == actor then
    return
  end
		
		if not check_enemy then
			if g_BotVacId == 0 and IsPlayerAlive(player) and IsEnemy(player) then 	
				Vac(player)
			end
        elseif check_enemy then		
			if g_BotVacId == 0 and IsPlayerAlive(player) and not IsEnemy(player) then
				Vac(player)
			end
		end
		
	    if g_BotVacId == 1 and IsIronMan(player) and IsPlayerAlive(player) then
			Vac(player)
		elseif g_BotVacId == 2 and IsCQB(player) and IsPlayerAlive(player) then
			Vac(player)
	    elseif g_BotVacId == 3 and IsSpecops(player) and IsPlayerAlive(player) then
			Vac(player)
	    elseif g_BotVacId == 4 and IsSniper(player) and IsPlayerAlive(player) then
			Vac(player)
	    elseif g_BotVacId == 5 and IsEscudo(player) and IsPlayerAlive(player) then
			Vac(player)
	    elseif g_BotVacId == 6 and IsDemo(player) and IsPlayerAlive(player) then
			Vac(player)			
        else
			return
		end
	
		
  if not IsPlayerAlive(player) then
    return
  end
  
  if not check_enemy then
		if GetPlayerTeam(actor) == GetPlayerTeam(player) then
			return
		end
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