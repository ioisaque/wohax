require 'classic\\data'
require 'classic\\aim'
require 'classic\\esp'
require 'classic\\menu'

ReloadAmmoAt = 0

IsControlPressed = false
IsNoRecoilActive = false
IsNoSpreadActive = false
IsUnlimitedRunningActive = true

local function OnKeyPressed(key)
  if key == CBK_CONTROL then
	IsControlPressed = true
  end
  -- Hotkeys AIM
  if key == CBK_F5 then
	AimMode = AimMode + 1
	if AimMode > 2 then AimMode = 0 end
	--if AimMode == 3 then AimRadius = 0 end
  end
  if key == CBK_UP then
	AimRadius = AimRadius + 100
	if AimRadius > 600 then AimRadius = 600 end
	if AimRadius > 0 then ShowAimRadius = true end
  end  
  if key == CBK_DOWN then
	AimRadius = AimRadius - 100
	if AimRadius < 0 then AimRadius = 0 end
	if AimRadius == 0 then ShowAimRadius = false end
  end  
  if key == CBK_PGDN then
	AimTarget = AimTarget + 1
	if AimTarget > 1 then AimTarget = 0 end
  end
  if key == CBK_PGUP then
	AimAutoFire = not AimAutoFire
  end
  
  if (IsControlPressed and key == CBK_RIGHT) then
	ReloadAmmoAt = ReloadAmmoAt + 5
	if AimRadius > 50 then AimRadius = 50 end
  end  
  if (IsControlPressed and key == CBK_LEFT) then
	ReloadAmmoAt = ReloadAmmoAt - 5
	if ReloadAmmoAt < 0 then ReloadAmmoAt = 0 end
  end
  
  -- Hotkeys ESP  
  if key == CBK_F6 then
	IsEspNameAndClassActive = not IsEspNameAndClassActive
  end
  if key == CBK_F7 then
	IsEspSkeletonActive = not IsEspSkeletonActive
  end
  if key == CBK_F8 then
	IsEspClaymoreActive = not IsEspClaymoreActive
  end 
  if (IsControlPressed and key == CBK_D) then
	IsEspBarActive = not IsEspBarActive
  end
  if (IsControlPressed and key == CBK_F) then
	IsEspWeaponActive = not IsEspWeaponActive
  end
  if (IsControlPressed and key == CBK_C) then
	IsEspDistanceActive = not IsEspDistanceActive
  end
  if (IsControlPressed and key == CBK_M) then
	IsEspBoxActive = not IsEspBoxActive
  end 
  if (IsControlPressed and key == CBK_Z) then
	ShowAimRadius = not ShowAimRadius
  end 
  -- Hotkeys
  if key == CBK_F9 then
	IsNoRecoilActive = not IsNoRecoilActive
	if IsNoRecoilActive then CryBot:Toggle(FNORECOIL,true) else CryBot:Toggle(FNORECOIL,false) end
  end
  if key == CBK_F11 then
	IsNoSpreadActive = not IsNoSpreadActive
	if IsNoSpreadActive then CryBot:Toggle(FNOSPREAD,true) else CryBot:Toggle(FNOSPREAD,false) end
  end
   if (IsControlPressed and key == CBK_B) then
	IsUnlimitedRunningActive = not IsUnlimitedRunningActive
	if IsUnlimitedRunningActive then CryBot:Toggle(FUNLIMITEDRUNNING,true) else CryBot:Toggle(FUNLIMITEDRUNNING,false) end
  end
  
  if key == CBK_END then
	canShowMenu = not canShowMenu
  end
end

local function OnKeyReleased(key)
  if key == CBK_CONTROL then
	IsControlPressed = false
  end  
end

local function WndProc(msg)
  if msg.message == 0x100 then
    OnKeyPressed(msg.wParam)
  end
  if msg.message == 0x101 then
    OnKeyReleased(msg.wParam)
  end
end

function LoadTranslations(LANGUAGE)
  if LANGUAGE == "RUSSIAN" then
	-- Menu
	STR_AIMBOT 			= "AIMBOT"
	STR_AIM_HEAD		= "Глава"
	STR_AIM_BODY		= "тело"
	
	STR_AIM_FOV			= "AIM FOV"
	STR_AIM_AUTOFIRE 	= "Автошот"
	STR_AIM_AUTORELOAD 	= "Автошот"

	STR_ESP_NAME 		= "ESP ИМЯ"
	STR_ESP_SKELETON 	= "ESP скелет"
	STR_ESP_CLAYMORE 	= "ESP клеймор"
	STR_ESP_CLASS 		= "ESP Class"
	
	STR_ESP_BOX 		= "ESP коробка"
	STR_ESP_DISTANCE 	= "ESP РАССТОЯНИЕ"	
	STR_ESP_BAR 		= "ESP ЗДОРОВЬЕ, броня & боеприпасы"
	STR_ESP_WEAPON		= "ESP Weapon"

	STR_HACK_NO_RECOIL = "БЕЗ ОТДАЧИ"
	STR_HACK_NO_SPREAD = "НЕ РАЗБЕГАЙТЕСЬ"
	STR_HACK_UNLIMITED_RUNNING = "ГОНКИ INFINITE"
	
	-- Others
	STR_PLAYER_CLASS = "Player"
	STR_DISTANCE = "Distance"
	STR_AMMO = "Ammo"
	STR_MEDIC = "[Medic] -"
	STR_RIFLEMAN = "[RifleMan] -"
	STR_ENGINEER = "[Engineer] -"
	
  elseif LANGUAGE == "PORTUGUESE" then
	-- Menu
	STR_AIMBOT 			= "Aimbot"
	STR_AIM_HEAD		= "CABECA"
	STR_AIM_BODY		= "CORPO"
	
	STR_AIM_FOV			= "Zona do Aim"
	STR_AIM_AUTOFIRE 	= "Tiro Automatico"
	STR_AIM_AUTORELOAD 	= "Recarregar Automatico"
	
	STR_ESP_NAME 		= "ESP Nick e Classe"
	STR_ESP_SKELETON 	= "ESP Esqueleto"
	STR_ESP_CLAYMORE 	= "ESP Explosivos"
	STR_ESP_CLASS 		= "ESP Classe"	

	STR_ESP_BOX 		= "ESP Caixa 2D"
	STR_ESP_DISTANCE 	= "ESP Distancia"
	STR_ESP_BAR 		= "ESP Vida & Colete"
	STR_ESP_WEAPON		= "ESP Arma & Municao"
	
	STR_HACK_NO_RECOIL = "Sem Recuo"
	STR_HACK_NO_SPREAD = "Sem Espalhar"
	STR_HACK_UNLIMITED_RUNNING = "Corrida Infinita"
	
	-- Others
	STR_PLAYER_CLASS = "Jogador"
	STR_DISTANCE = "Distancia"
	STR_AMMO = "Municao"
	STR_MEDIC = "[Medico] -"
	STR_RIFLEMAN = "[Fuzileiro] -"
	STR_ENGINEER = "[Engenheiro] -"
	
  else
	-- Menu
	STR_AIMBOT 			= "Aimbot"
	STR_AIM_HEAD		= "HEAD"
	STR_AIM_BODY		= "BODY"
	
	STR_AIM_FOV			= "Aim FOV"
	STR_AIM_AUTOFIRE 	= "Auto Shot"
	STR_AIM_AUTORELOAD 	= "Auto Reload"

	STR_ESP_NAME 		= "ESP Name & Class"
	STR_ESP_SKELETON 	= "ESP Skeleton"
	STR_ESP_CLAYMORE 	= "ESP Claymore"
	STR_ESP_CLASS 		= "ESP Class"	

	STR_ESP_BOX 		= "ESP 2D Box"
	STR_ESP_DISTANCE 	= "ESP Distance"
	STR_ESP_BAR 		= "ESP Health & Armor"
	STR_ESP_WEAPON		= "ESP Weapon & Ammo"

	STR_HACK_NO_RECOIL = "No Recoil"
	STR_HACK_NO_SPREAD = "No Spread"
	STR_HACK_UNLIMITED_RUNNING = "Unlimited Running"
	
	-- Others
	STR_PLAYER_CLASS = "Player"
	STR_DISTANCE = "Distance"
	STR_AMMO = "Ammo"
	STR_MEDIC = "[Medic] -"
	STR_RIFLEMAN = "[RifleMan] -"
	STR_ENGINEER = "[Engineer] -"
  end
end

CryBot:RegisterEventListener(EVENT_WINDOWPROC, WndProc)