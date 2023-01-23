require 'warbot\\warbot_menu'
require 'settings\\settings'
require 'warbot\\warbot_aim'
require 'warbot\\bones'
require 'warbot\\warbot_esp'
require 'warbot\\warbot_autoattack'
require 'warbot\\warbot_autozoom'
require 'warbot\\warbot_autoreadystart'

local _print = WFXPrint
local _fmt   = string.format
Warbot       = nil

class 'CWarbot'
function CWarbot:__init()
  --- debugging options ---
  self.debugging_mouse_position = false
  self.debugging = true
  --  debugging end --
  
  -- personalization --
  self.menuTransparency = 230
  self.configFileName   = "warbot.ini"
  
  self.settings = CSettings(WFX_ADDONS_PATH.."warbot\\"..self.configFileName)
 
  -- initialize objects --
  self.font  = WFXCreateFont(10,10, FW_NORMAL, false, "Comic MS")
  self.mouse = D3DXVECTOR3(0,0,0)
  self.menu  = CMenu(0,0)
  self:createMenuComponents()
  
  self:loadSettings()
end

function CWarbot:print(txt)
  if self.debugging then _print(_fmt("Warbot >> %s\n", txt)) end
end

function CWarbot:createMenuComponents()
  self.menuItem_aimbot = self.menu:addItem("Aimbot")
    
  -- subitems do menu aimbot --
  --[[
  self.menuSubItem_aim_aggressivity_level = self.menu:addSubItem(self.menuItem_aimbot, "Agressividade: Baixo")
  self.menuSubItem_aim_aggressivity_level_r = self.menu:addButton_Right(self.menuItem_aimbot, self.menuSubItem_aim_aggressivity_level)
  self.menuSubItem_aim_aggressivity_level_l = self.menu:addButton_Left(self.menuItem_aimbot, self.menuSubItem_aim_aggressivity_level)
  --]]
  self.menuSubItem_aim_mode = self.menu:addSubItem(self.menuItem_aimbot, "Modo: "..aim_mode)
  self.menuSubItem_aim_mode_r = self.menu:addButton_Right(self.menuItem_aimbot, self.menuSubItem_aim_mode)
  self.menuSubItem_aim_mode_l = self.menu:addButton_Left(self.menuItem_aimbot, self.menuSubItem_aim_mode)
  
  self.menuSubItem_aim_only_insight = self.menu:addSubItem(self.menuItem_aimbot, "Nao mirar fora do FOV")
  
  self.menuSubItem_aim_radius = self.menu:addSubItem(self.menuItem_aimbot, "Alcance: 150")
  self.menuSubItem_aim_radius_r = self.menu:addButton_Right(self.menuItem_aimbot, self.menuSubItem_aim_radius)
  self.menuSubItem_aim_radius_l = self.menu:addButton_Left(self.menuItem_aimbot, self.menuSubItem_aim_radius)
  
  self.menuSubItem_aim_showradius = self.menu:addSubItem(self.menuItem_aimbot, "Mostrar alcance")
  
  self.menuSubItem_aim_interval = self.menu:addSubItem(self.menuItem_aimbot, string.format("Intervalo: %1.1f ms", aim_interval/1000))
  self.menuSubItem_aim_interval_r = self.menu:addButton_Right(self.menuItem_aimbot, self.menuSubItem_aim_interval)
  self.menuSubItem_aim_interval_l = self.menu:addButton_Left(self.menuItem_aimbot, self.menuSubItem_aim_interval)
    
  self.menuSubItem_aim_bone = self.menu:addSubItem(self.menuItem_aimbot, "Mirar: Corpo [PGDOWN]")
  self.menuSubItem_aim_bone_r = self.menu:addButton_Right(self.menuItem_aimbot, self.menuSubItem_aim_bone)
  self.menuSubItem_aim_bone_l = self.menu:addButton_Left(self.menuItem_aimbot, self.menuSubItem_aim_bone)
  
  self.menuSubItem_aim_melee = self.menu:addSubItem(self.menuItem_aimbot, "Mirar faca: 2 metros")
  self.menuSubItem_aim_melee_r = self.menu:addButton_Right(self.menuItem_aimbot, self.menuSubItem_aim_melee)
  self.menuSubItem_aim_melee_l = self.menu:addButton_Left(self.menuItem_aimbot, self.menuSubItem_aim_melee)
  
  self.menuSubItem_aim_melee_showradius = self.menu:addSubItem(self.menuItem_aimbot, "Mostrar alcance da faca")
    
  self.menuItem_esp = self.menu:addItem("Radar")
  -- subitems do menu esp --
  self.menuSubItem_esp_skeleton = self.menu:addSubItem(self.menuItem_esp, "Esqueleto")
  --self.menuSubItem_esp_box = self.menu:addSubItem(self.menuItem_esp, "Caixa 2D")
  self.menuSubItem_esp_distance = self.menu:addSubItem(self.menuItem_esp, "Distancia")
  self.menuSubItem_esp_name = self.menu:addSubItem(self.menuItem_esp, "Nome dos inimigos")
  --self.menuSubItem_esp_explosives = self.menu:addSubItem(self.menuItem_esp, "Explosivos")
  self.menuSubItem_esp_visible_players = self.menu:addSubItem(self.menuItem_esp, "Marcar (azul) inimigos visiveis")
  
  --self.menu:getItem(self.menuItem_esp):getSubItem(self.menuSubItem_esp_box).checkbox.is_checked = false
  --self.menu:getItem(self.menuItem_esp):getSubItem(self.menuSubItem_esp_name).checkbox.is_checked = false
  --[[
  self.menuItem_hacks = self.menu:addItem("Hacks")
  --self.menu:getItem(self.menuItem_hacks).checkbox.is_checked = false
  self.menuSubItem_hacks_norecoil = self.menu:addSubItem(self.menuItem_hacks, "Sem recuo")
  --self.menu:getItem(self.menuItem_hacks):getSubItem(self.menuSubItem_hacks_norecoil).checkbox.is_checked = false
  self.menuSubItem_hacks_nospread = self.menu:addSubItem(self.menuItem_hacks, "Sem espalhar")
  --self.menu:getItem(self.menuItem_hacks):getSubItem(self.menuSubItem_hacks_nospread).checkbox.is_checked = false
  self.menuSubItem_hacks_unlimited_run = self.menu:addSubItem(self.menuItem_hacks, "Corrida infinita")
  --self.menu:getItem(self.menuItem_hacks):getSubItem(self.menuSubItem_hacks_unlimited_run).checkbox.is_checked = false
  self.menuSubItem_hacks_unlimited_slide = self.menu:addSubItem(self.menuItem_hacks, "Deslize infinito")
  --self.menu:getItem(self.menuItem_hacks):getSubItem(self.menuSubItem_hacks_unlimited_slide).checkbox.is_checked = false
  self.menuSubItem_hacks_antiflash = self.menu:addSubItem(self.menuItem_hacks, "Anti-flash")
  --self.menu:getItem(self.menuItem_hacks):getSubItem(self.menuSubItem_hacks_antiflash).checkbox.is_checked = false
  --]]
  
  self.menuItem_automations = self.menu:addItem("Automations")
  self.menuSubItem_automations_autoattack = self.menu:addSubItem(self.menuItem_automations, "Auto Atacar")  
  self.menuSubItem_automations_autozoom_in = self.menu:addSubItem(self.menuItem_automations, "Auto Zoom In") 
  self.menuSubItem_automations_autozoom_out = self.menu:addSubItem(self.menuItem_automations, "Auto Zoom Out")
  self.menuSubItem_automations_autoreadystart = self.menu:addSubItem(self.menuItem_automations, "Auto Ready/Start")
  
  --self.menu:getItem(self.menuItem_automations):getSubItem(self.menuSubItem_automations_autozoom_in).checkbox.is_checked = false
  
  --[[self.menuSubItem_automations_autozoom_out_timeout = self.menu:addSubItem(self.menuItem_automations, "Time Auto ZoomOut: 2s")
  self.menuSubItem_automations_autozoom_out_r = self.menu:addButton_Right(self.menuItem_automations, self.menuSubItem_automations_autozoom_out_timeout)
  self.menuSubItem_automations_autozoom_out_l = self.menu:addButton_Left(self.menuItem_automations, self.menuSubItem_automations_autozoom_out_timeout)
  --]]
  --self.menu:getItem(self.menuItem_automations):getSubItem(self.menuSubItem_automations_autoattack).checkbox.is_checked = false
  --self.menu:getItem(self.menuItem_automations):getSubItem(self.menuSubItem_automations_autozoom_out).checkbox.is_checked = false
    
	--[[
  self.menuItem_magnetic = self.menu:addItem("Magnetic I [DEL]")
  self.menuSubItem_magnetic_fixed = self.menu:addSubItem(self.menuItem_magnetic, "Fixar inimigos")  
  self.menuSubItem_magnetic_only_insight = self.menu:addSubItem(self.menuItem_magnetic, "Atrair somente visiveis")
  self.menuSubItem_magnetic_ironman_priority = self.menu:addSubItem(self.menuItem_magnetic, "Prioridade ao Artlilheiro")
  --]]
  
  --self.menu:getItem(self.menuItem_magnetic).checkbox.is_checked = false
  --self.menu:getItem(self.menuItem_magnetic):getSubItem(self.menuSubItem_magnetic_fixed).checkbox.is_checked = false
  --self.menu:getItem(self.menuItem_magnetic):getSubItem(self.menuSubItem_magnetic_ironman_priority).checkbox.is_checked = true
end

local function getCheckBoxStatus(cb)
  return cb.is_checked;
end

function CWarbot:updateMenuStatus(menuId,status)
  self.menu:getItem(menuId).checkbox.is_checked = status
end

function CWarbot:updateMenuText(menuId,text)
  self.menu:getItem(menuId).text = text
end

function CWarbot:updateSubItemStatus(menuId,subItemId,status)
  self.menu:getItem(menuId):getSubItem(subItemId).checkbox.is_checked = status
end

function CWarbot:updateSubItemText(menuId,subItemId,text)
  self.menu:getItem(menuId):getSubItem(subItemId).text = text
end

function CWarbot:updateComponents()
  --aimbot
  self:updateMenuStatus(self.menuItem_aimbot, aim_enabled)  
  self:updateSubItemText(self.menuItem_aimbot, self.menuSubItem_aim_mode, "Modo: "..aim_mode)
  
  local alcance = tostring(aim_radius)
  if aim_radius == 0 then
    alcance = "OFF"
  end
  
  self:updateSubItemStatus(self.menuItem_aimbot, self.menuSubItem_aim_only_insight, aim_only_insight)
  self:updateSubItemText(self.menuItem_aimbot, self.menuSubItem_aim_radius, "Alcance: "..alcance)
  self:updateSubItemStatus(self.menuItem_aimbot, self.menuSubItem_aim_showradius, aim_can_show_radius)
  self:updateSubItemText(self.menuItem_aimbot, self.menuSubItem_aim_interval, string.format("Intervalo: %1.1f ms", aim_interval/1000))
  
  local boneName = "Cabeca"
  if aim_bone == SPINE1 then
    boneName = "Corpo"
  end
  
  self:updateSubItemText(self.menuItem_aimbot, self.menuSubItem_aim_bone, "Mirar: "..boneName)
  self:updateSubItemText(self.menuItem_aimbot, self.menuSubItem_aim_melee, string.format("Mirar faca: %1.1f metros", aim_melee_radius))
  self:updateSubItemStatus(self.menuItem_aimbot, self.menuSubItem_aim_melee_showradius, aim_can_show_melee_radius)
  
  -- radar  
  self:updateMenuStatus(self.menuItem_esp, esp_enabled)
  self:updateSubItemStatus(self.menuItem_esp, self.menuSubItem_esp_skeleton, esp_show_skeleton)
  --self:updateSubItemStatus(self.menuItem_esp, self.menuSubItem_esp_box, esp_show_2dbox)
  self:updateSubItemStatus(self.menuItem_esp, self.menuSubItem_esp_distance, esp_show_distance)
  self:updateSubItemStatus(self.menuItem_esp, self.menuSubItem_esp_name, esp_show_names)
  --self:updateSubItemStatus(self.menuItem_esp, self.menuSubItem_esp_explosives, esp_show_explosives)
  self:updateSubItemStatus(self.menuItem_esp, self.menuSubItem_esp_visible_players, esp_show_visible_players)
  
  --hacks
  --[[
  --self:updateMenuStatus(self.menuItem_hacks, WFXGetStatus(WFX_FUNCTION_ID_CHECK))
  self:updateSubItemStatus(self.menuItem_hacks, self.menuSubItem_hacks_norecoil, WFXGetStatus(WFX_FUNCTION_ID_NORECOIL))
  self:updateSubItemStatus(self.menuItem_hacks, self.menuSubItem_hacks_nospread, WFXGetStatus(WFX_FUNCTION_ID_NOSPREAD))
  self:updateSubItemStatus(self.menuItem_hacks, self.menuSubItem_hacks_unlimited_run, WFXGetStatus(WFX_FUNCTION_ID_UNLIMITED_RUN))
  self:updateSubItemStatus(self.menuItem_hacks, self.menuSubItem_hacks_unlimited_slide, WFXGetStatus(WFX_FUNCTION_ID_UNLIMITED_SLIDE))
  self:updateSubItemStatus(self.menuItem_hacks, self.menuSubItem_hacks_antiflash, WFXGetStatus(WFX_FUNCTION_ID_ANTI_FLASH_GRENADE))
  --]]
  
  --automations
  self:updateSubItemStatus(self.menuItem_automations, self.menuSubItem_automations_autoattack, autoattack_enabled)
  self:updateSubItemStatus(self.menuItem_automations, self.menuSubItem_automations_autozoom_in, autozoom_in_enabled)
  self:updateSubItemStatus(self.menuItem_automations, self.menuSubItem_automations_autozoom_out, autozoom_out_enabled)
  self:updateSubItemStatus(self.menuItem_automations, self.menuSubItem_automations_autoreadystart, autoreadystart_enabled)
end

function CWarbot:getSecKeyValue(section,key,default_var)
  local val = self.settings:loadKey(section, key)
  if val == nil then 
    val = tostring(default_var)
    self.settings:saveKey(section, key, val)
  end
  return val
end

function CWarbot:loadSettings()     
  local section = "aimbot"  
  
  aim_enabled      = self:getSecKeyValue(section,"enabled",aim_enabled) == "true"
  aim_mode         = tonumber(self:getSecKeyValue(section,"mode",aim_mode))
  aim_only_insight = self:getSecKeyValue(section,"onlyinsight",aim_only_insight) == "true"
  aim_radius       = tonumber(self:getSecKeyValue(section,"radius",aim_radius))
  aim_can_show_radius = self:getSecKeyValue(section,"canshowradius",aim_can_show_radius) == "true"
  aim_interval       = tonumber(self:getSecKeyValue(section,"interval",aim_interval))
  aim_bone = tonumber(self:getSecKeyValue(section,"bone",aim_bone))
  aim_can_show_melee_radius = self:getSecKeyValue(section,"canshowmeleeradius",aim_can_show_radius) == "true"
  aim_melee_radius = tonumber(self:getSecKeyValue(section,"meleeradius",aim_melee_radius))
    
  section = "radar"	

  self:print(string.format("loading %s settings...", section))
  
  esp_enabled = self:getSecKeyValue(section,"enabled",esp_enabled) == "true"
  esp_show_skeleton = self:getSecKeyValue(section,"showskeleton",esp_show_skeleton) == "true"
  esp_show_2dbox = self:getSecKeyValue(section,"show2dbox",esp_show_2dbox) == "true"
  esp_show_distance = self:getSecKeyValue(section,"showdistance",esp_show_distance) == "true"
  esp_show_names = self:getSecKeyValue(section,"shownames",esp_show_names) == "true" 
  esp_show_explosives = self:getSecKeyValue(section,"showexplosives",esp_show_explosives) == "true"
  esp_show_visible_players = self:getSecKeyValue(section,"showvisibleplayers",esp_show_visible_players) == "true"   
  
  section = "hacks"	
  --[[
  self:print(string.format("loading %s settings...", section))
  WFXToggle(WFX_FUNCTION_ID_NORECOIL, self:getSecKeyValue(section,"norecoil",false) == "true")
  WFXToggle(WFX_FUNCTION_ID_NOSPREAD, self:getSecKeyValue(section,"nospread",false) == "true")
  WFXToggle(WFX_FUNCTION_ID_UNLIMITED_RUN, self:getSecKeyValue(section,"unlimitedrun",false) == "true")
  WFXToggle(WFX_FUNCTION_ID_UNLIMITED_SLIDE, self:getSecKeyValue(section,"unlimitedslide",false) == "true")
  WFXToggle(WFX_FUNCTION_ID_ANTI_FLASH_GRENADE, self:getSecKeyValue(section,"antiflash",false) == "true")
  --]]
  
  section = "autoattack"	

  self:print(string.format("loading %s settings...", section))
  autoattack_enabled = self:getSecKeyValue(section,"enabled",autoattack_enabled) == "true"
    
  section = "autozoom"	

  self:print(string.format("loading %s settings...", section))
  
  autozoom_in_enabled = self:getSecKeyValue(section,"in",autozoom_in_enabled) == "true"
  autozoom_out_enabled = self:getSecKeyValue(section,"out",autozoom_out_enabled) == "true"
  
  self:print("all settings loaded")
end

function CWarbot:updateSettings()  
  local section = "aimbot"
  self:print(_fmt("updating %s settings...", section))
  self.settings:saveKey(section, "enabled", tostring(aim_enabled))
  self.settings:saveKey(section, "mode", tostring(aim_mode)) 
  self.settings:saveKey(section, "onlyinsight", tostring(aim_only_insight))
  self.settings:saveKey(section, "radius", tostring(aim_radius))
  self.settings:saveKey(section, "canshowradius", tostring(aim_can_show_radius))
  self.settings:saveKey(section, "interval", tostring(aim_interval))
  self.settings:saveKey(section, "bone", tostring(aim_bone))
  self.settings:saveKey(section, "meleeradius", tostring(aim_melee_radius))
  self.settings:saveKey(section, "canshowmeleeradius", tostring(aim_can_show_melee_radius))
  section = "radar"
  self:print(_fmt("updating %s settings...", section))
  self.settings:saveKey(section,"enabled",tostring(esp_enabled))
  self.settings:saveKey(section,"showskeleton",tostring(esp_show_skeleton))
  --self.settings:saveKey(section,"show2dbox",tostring(esp_show_2dbox))
  self.settings:saveKey(section,"showdistance",tostring(esp_show_distance))
  self.settings:saveKey(section,"shownames",tostring(esp_show_names))
  self.settings:saveKey(section,"showexplosives",tostring(esp_show_explosives))
  self.settings:saveKey(section,"showvisibleplayers",tostring(esp_show_visible_players))
  --[[section = "hacks"
  self.settings:saveKey(section,"norecoil", tostring(WFXGetStatus(WFX_FUNCTION_ID_NORECOIL)))
  self.settings:saveKey(section,"nospread", tostring(WFXGetStatus(WFX_FUNCTION_ID_NOSPREAD)))
  self.settings:saveKey(section,"unlimitedrun", tostring(WFXGetStatus(WFX_FUNCTION_ID_UNLIMITED_RUN)))
  self.settings:saveKey(section,"unlimitedslide", tostring(WFXGetStatus(WFX_FUNCTION_ID_UNLIMITED_SLIDE)))
  self.settings:saveKey(section,"antiflash", tostring(WFXGetStatus(WFX_FUNCTION_ID_ANTI_FLASH_GRENADE)))
  self:print(_fmt("updating %s settings...", section))
  --]]
  section = "autoattack"	
  self.settings:saveKey(section,"enabled", tostring(autoattack_enabled))
  self:print(string.format("loading %s settings...", section))   
  section = "autozoom"	
  self.settings:saveKey(section,"in", tostring(autozoom_in_enabled))
  self.settings:saveKey(section,"out", tostring(autozoom_out_enabled))
  self:print("settings updated")
end

function CWarbot:onDraw()  
  --[[
  if not WFXGetStatus(WFX_FUNCTION_ID_VAC) then
    self.menu:getItem(self.menuItem_magnetic).checkbox.is_checked = false
  end
    --]]
  self.menu:show(self.menuTransparency)
  if self.menu.disabled then
    return
  end
  
  self:updateComponents()
  --[[
  local mode = "PvP"
  if IsCooperativeMode() then
    mode = "PvE"
  end
  if GetPlayerActor() ~= 0 then
    mode = string.format("%d FPS - Modo: %s Horario atual: %s (END: esconder menu)", getFPS(), mode, getTime())
	myDrawText(self.font, ARGB(self.menuTransparency-50,0,255,0), self.menu.x+10, self.menu.y+50, 0, 0, mode)
  end
  --]]
end

function CWarbot:onLButtonUp()
  --self.menu:onLButtonDown(self.mouse)
    
  if self.menu.disabled then
    return
  end
  
  -- primeiro verifica se o objeto "aimbot" foi clicado
  local object = self.menu:getItem(self.menuItem_aimbot)
  if object.checkbox:onClick(self.mouse) then
    --self:onAimClick(checkbox.object.is_checked)
	aim_enabled = object.checkbox.is_checked
	
	if not aim_enabled then
	  object.canShowSubItems = false
	end
	
	self:updateSettings()
	return 1
  end  
  
  -- primeiramente vamos verificar se os itens estão sendo exibidos na tela  
  if object.canShowSubItems then  
    -- verifica todos os subitems do aimbot   
    for i = 1, #object.subItems do
      -- verifica se o botão direito do modo foi clicado
	  local subItem = object.subItems[i]
	  if subItem.id == self.menuSubItem_aim_mode then	
	    local btn = subItem:getButton(self.menuSubItem_aim_mode_r)
    	if btn:onClick(self.mouse) then
		  -- clicou em cima do objeto então muda o valor do modo
		  		  
		  aim_mode = aim_mode + 1
		  if aim_mode > 3 then
		    aim_mode = 1
		  end
		  subItem.text = "Modo: "..aim_mode
		  
		  if aim_mode == 3 then
		    aim_radius = 0
			object:getSubItem(self.menuSubItem_aim_radius).text = "Alcance: OFF"
		  else
		    aim_radius = 150
			object:getSubItem(self.menuSubItem_aim_radius).text = "Alcance: "..aim_radius
		  end
		  --[[
		  if aim_mode == 1 then
		    self.menu:getItem(self.menuItem_aimbot).text = "Aimbot I [F5]"
		  elseif aim_mode == 2 then
		    self.menu:getItem(self.menuItem_aimbot).text = "Aimbot II [F5]"
	      elseif aim_mode == 3 then
		    self.menu:getItem(self.menuItem_aimbot).text = "Aimbot III [F5]"
		  else
		    self.menu:getItem(self.menuItem_aimbot).text = "???"
		  end
		  --]]
		  
		  self:updateSettings()
		  return
	    end
		-- verifica se o botão esquerdo foi clicado
		btn = subItem:getButton(self.menuSubItem_aim_mode_l)
    	if btn:onClick(self.mouse) then
		  -- clicou em cima do objeto então muda o valor do modo
		  		  
		  aim_mode = aim_mode - 1
		  if aim_mode < 1 then
		    aim_mode = 3
		  end		  
		  subItem.text = "Modo: "..aim_mode
		  
		  if aim_mode == 3 then
		    aim_radius = 0
			object:getSubItem(self.menuSubItem_aim_radius).text = "Alcance: OFF"
		  else
		    aim_radius = 150
			object:getSubItem(self.menuSubItem_aim_radius).text = "Alcance: "..aim_radius
		  end
		  	--[[	  
		  if aim_mode == 1 then
		    self.menu:getItem(self.menuItem_aimbot).text = "Aimbot I [F5]"
		  elseif aim_mode == 2 then
		    self.menu:getItem(self.menuItem_aimbot).text = "Aimbot II [F5]"
	      elseif aim_mode == 3 then
		    self.menu:getItem(self.menuItem_aimbot).text = "Aimbot III [F5]"
		  else
		    self.menu:getItem(self.menuItem_aimbot).text = "???"
		  end
		  --]]
		  		  		  
		  self:updateSettings()
		  return
	    end
	  end
	  
	  if subItem.id == self.menuSubItem_aim_radius then 
	    local btn = subItem:getButton(self.menuSubItem_aim_radius_r)
    	if btn:onClick(self.mouse) then
		  -- clicou em cima do objeto então muda o valor do modo
		  aim_radius = aim_radius + 50
		  if aim_radius > 1000 then
		    aim_radius = 1000
		  end
		  --subItem.text = "Alcance: "..aim_radius
		  self:updateSettings()
		  return
	    end
		-- verifica se o botão esquerdo foi clicado
		btn = subItem:getButton(self.menuSubItem_aim_radius_l)
    	if btn:onClick(self.mouse) then
		  -- clicou em cima do objeto então muda o valor do modo
		  aim_radius = aim_radius - 50
		  --subItem.text = "Alcance: "..aim_radius
		  if aim_radius <= 0 then
		    aim_radius = 0
			--subItem.text = "Alcance: OFF"
		  end		  
		  self:updateSettings()
		  return
	    end
	  end
	  
	  if subItem.id == self.menuSubItem_aim_showradius then
	    if subItem.checkbox:onClick(self.mouse) then
		  aim_can_show_radius = subItem.checkbox.is_checked
		  self:updateSettings()
		  return
		end
	  end
	  
	  if subItem.id == self.menuSubItem_aim_only_insight then
	    if subItem.checkbox:onClick(self.mouse) then
		  aim_only_insight = subItem.checkbox.is_checked
		  self:updateSettings()
		  return
		end
	  end	  
	  
	  if subItem.id == self.menuSubItem_aim_interval then 
	    local btn = subItem:getButton(self.menuSubItem_aim_interval_r)
    	if btn:onClick(self.mouse) then
		  -- clicou em cima do objeto então muda o valor do modo
		  aim_interval = aim_interval + 100
		  if aim_interval > 3000 then
		    aim_interval = 3000
		  end
		  subItem.text = string.format("Intervalo: %1.1f ms", aim_interval/1000)
		  self:updateSettings()
		  return
	    end
		-- verifica se o botão esquerdo foi clicado
		btn = subItem:getButton(self.menuSubItem_aim_interval_l)
    	if btn:onClick(self.mouse) then
		  -- clicou em cima do objeto então muda o valor do modo
		  aim_interval = aim_interval - 100
		  subItem.text = string.format("Intervalo: %1.1f ms", aim_interval/1000)
		  if aim_interval <= 0 then
		    aim_interval = 0
			subItem.text = "Intervalo: OFF"
		  end
		  self:updateSettings()
		  return
	    end
	  end
	  
	  if subItem.id == self.menuSubItem_aim_bone then 
	    local btn = subItem:getButton(self.menuSubItem_aim_bone_r)
    	if btn:onClick(self.mouse) then  
		  --if subItem.text == "Mirar: Cabeca [PGDOWN]" then
		    --subItem.text = "Mirar: Corpo [PGDOWN]"
			--aim_bone = SPINE1
		  --else
		    --aim_bone = L_EYE
		    --subItem.text = "Mirar: Cabeca [PGDOWN]"
		  --end
		  
		  if aim_bone == L_EYE then
		    aim_bone = SPINE1
		  else 
		    aim_bone = L_EYE
		  end
		  
		  self:updateSettings()
		  return 1
	    end
		btn = subItem:getButton(self.menuSubItem_aim_bone_l)
    	if btn:onClick(self.mouse) then		
		  --if subItem.text == "Mirar: Cabeca [PGDOWN]" then
		    --subItem.text = "Mirar: Corpo [PGDOWN]"
			--aim_bone = SPINE1
		  --else
		    --aim_bone = L_EYE
		    --subItem.text = "Mirar: Cabeca [PGDOWN]"
		  --end
		  
		  if aim_bone == L_EYE then
		    aim_bone = SPINE1
		  else 
		    aim_bone = L_EYE
		  end
		  
		  self:updateSettings()
		  return 1
	    end
	  end	  	  

	  if subItem.id == self.menuSubItem_aim_melee then 
	  
	    local btn = subItem:getButton(self.menuSubItem_aim_melee_r)
	    if btn:onClick(self.mouse) then  
		  -- clicou em cima do objeto então muda o valor do modo
		  aim_melee_radius = aim_melee_radius + 0.5
		  if aim_melee_radius > 3.0 then
		    aim_melee_radius = 0.5
		  end
		  subItem.text = string.format("Mirar faca: %1.1f metros", aim_melee_radius)
		  self:updateSettings()
	      return
	    end

	    btn = subItem:getButton(self.menuSubItem_aim_melee_l)
		if btn:onClick(self.mouse) then  		  
		  -- clicou em cima do objeto então muda o valor do modo
		  aim_melee_radius = aim_melee_radius - 0.5		  
		  if aim_melee_radius <= 0 then
		    aim_melee_radius = 3.0
		  end
		  subItem.text = string.format("Mirar faca: %1.1f metros", aim_melee_radius)
		  self:updateSettings()
		  return
		end
	  end
		
	  if subItem.id == self.menuSubItem_aim_melee_showradius then
	    if subItem.checkbox:onClick(self.mouse) then
		  aim_can_show_melee_radius = subItem.checkbox.is_checked
		  self:updateSettings()
		  return
		end
	  end
	
	end
	--só uma lista de subitems é exibida por menu, portanto se este já está sendo exibido o próximo não estará
	return 1
  end
  
  -- esp     
  object = self.menu:getItem(self.menuItem_esp)
  if object.checkbox:onClick(self.mouse) then
    --self:onAimClick(checkbox.object.is_checked)
	esp_enabled = object.checkbox.is_checked
	
	if not esp_enabled then
	  object.canShowSubItems   = false
	end
	
	self:updateSettings()
	return 1
  end  

  if object.canShowSubItems then
    -- verifica todos os subitems do aimbot   
    for i = 1, #object.subItems do
      -- verifica se o botão direito do modo foi clicado
	  local subItem = object.subItems[i]
	  
	  if subItem.id == self.menuSubItem_esp_skeleton then
	    if subItem.checkbox:onClick(self.mouse) then
		  esp_show_skeleton = subItem.checkbox.is_checked
		  self:updateSettings()
		  return
		end		
	  end
	  
	  if subItem.id == self.menuSubItem_esp_box then
	    if subItem.checkbox:onClick(self.mouse) then
		  esp_show_2dbox = subItem.checkbox.is_checked
		  self:updateSettings()
		  return
		end
	  end
	  
	  if subItem.id == self.menuSubItem_esp_distance then
	    if subItem.checkbox:onClick(self.mouse) then
		  esp_show_distance = subItem.checkbox.is_checked
		  self:updateSettings()
		  return
		end
	  end
	  
	  if subItem.id == self.menuSubItem_esp_name then
	    if subItem.checkbox:onClick(self.mouse) then
		  esp_show_names = subItem.checkbox.is_checked
		  self:updateSettings()
		  return
		end
	  end
	  
	  if subItem.id == self.menuSubItem_esp_visible_players then
	    if subItem.checkbox:onClick(self.mouse) then
		  esp_show_visible_players = subItem.checkbox.is_checked
		  self:updateSettings()
		  return
		end
	  end	    	  	  
	  --[[
	  if subItem.id == self.menuSubItem_esp_explosives then
	    if subItem.checkbox:onClick(self.mouse) then
		  esp_show_explosives = subItem.checkbox.is_checked
		  self:updateSettings()
		  return
		end
		
	  end	    	  --]]
	end
	
	--....
	return 1
  end
  
  -- hacks
  --[[
  object = self.menu:getItem(self.menuItem_hacks)
  if object.checkbox:onClick(self.mouse) then
	if not object.checkbox.is_checked then
	  WFXToggle(WFX_FUNCTION_ID_NORECOIL, false)
	  WFXToggle(WFX_FUNCTION_ID_NOSPREAD, false)
	  WFXToggle(WFX_FUNCTION_ID_ANTI_FLASH_GRENADE, false)
	  WFXToggle(WFX_FUNCTION_ID_UNLIMITED_RUN, false)
	  WFXToggle(WFX_FUNCTION_ID_UNLIMITED_SLIDE, false)
	  
	  self.menu:getItem(self.menuItem_hacks):getSubItem(self.menuSubItem_hacks_norecoil).checkbox.is_checked = false
	  self.menu:getItem(self.menuItem_hacks):getSubItem(self.menuSubItem_hacks_nospread).checkbox.is_checked = false
	  self.menu:getItem(self.menuItem_hacks):getSubItem(self.menuSubItem_hacks_antiflash).checkbox.is_checked = false
	  self.menu:getItem(self.menuItem_hacks):getSubItem(self.menuSubItem_hacks_unlimited_run).checkbox.is_checked = false
	  self.menu:getItem(self.menuItem_hacks):getSubItem(self.menuSubItem_hacks_unlimited_slide).checkbox.is_checked = false
	  
	  object.canShowSubItems   = false
	end	
	self:updateSettings()
	return 1
  end  
  
  if object.canShowSubItems then 
    for i = 1, #object.subItems do     
	  local subItem = object.subItems[i]
	  
	  if subItem.id == self.menuSubItem_hacks_unlimited_run then
	    if subItem.checkbox:onClick(self.mouse) then
		  --subItem.checkbox.is_checked = not subItem.checkbox.is_checked
		  WFXToggle(WFX_FUNCTION_ID_UNLIMITED_RUN, subItem.checkbox.is_checked)		
          self:updateSettings()		  
		end
	  end
	  
	  if subItem.id == self.menuSubItem_hacks_unlimited_slide then
	    if subItem.checkbox:onClick(self.mouse) then
		  --subItem.checkbox.is_checked = not subItem.checkbox.is_checked
		  WFXToggle(WFX_FUNCTION_ID_UNLIMITED_SLIDE, subItem.checkbox.is_checked)
		  self:updateSettings()
		end
	  end
	  
	  if subItem.id == self.menuSubItem_hacks_norecoil then
	    if subItem.checkbox:onClick(self.mouse) then
		  WFXToggle(WFX_FUNCTION_ID_NORECOIL, subItem.checkbox.is_checked)
		  self:updateSettings()
		end
	  end
	  
	  if subItem.id == self.menuSubItem_hacks_nospread then
	    if subItem.checkbox:onClick(self.mouse) then
		  WFXToggle(WFX_FUNCTION_ID_NOSPREAD, subItem.checkbox.is_checked)
		  self:updateSettings()
		end
	  end
	  
	  if subItem.id == self.menuSubItem_hacks_antiflash then
	    if subItem.checkbox:onClick(self.mouse) then
		  WFXToggle(WFX_FUNCTION_ID_ANTI_FLASH_GRENADE, subItem.checkbox.is_checked)
		  self:updateSettings()
		end
	  end	  	  
	end
	
	--....
	return 1
  end  
  --]]
  
  
    -- automations
  object = self.menu:getItem(self.menuItem_automations)
  if object.checkbox:onClick(self.mouse) then
    if not object.checkbox.is_checked then
	  self.menu:getItem(self.menuItem_automations):getSubItem(self.menuSubItem_automations_autoattack).checkbox.is_checked = false
	  self.menu:getItem(self.menuItem_automations):getSubItem(self.menuSubItem_automations_autozoom_in).checkbox.is_checked = false
	  self.menu:getItem(self.menuItem_automations):getSubItem(self.menuSubItem_automations_autozoom_out).checkbox.is_checked = false
	  
	  autoattack_enabled       = false
	  autozoom_in_enabled      = false
	  autozoom_out_enabled     = false
	  
	  object.canShowSubItems   = false
    end
	return 1
  end

  if object.canShowSubItems then 
    for i = 1, #object.subItems do     
	  local subItem = object.subItems[i]
	  
	  if subItem.id == self.menuSubItem_automations_autoattack then
	    if subItem.checkbox:onClick(self.mouse) then
		  autoattack_enabled = subItem.checkbox.is_checked  
		  self:updateSettings()
		  return 1
		end
	  end
	  
	  if subItem.id == self.menuSubItem_automations_autozoom_in then
	    if subItem.checkbox:onClick(self.mouse) then
		  autozoom_in_enabled = subItem.checkbox.is_checked  
		  self:updateSettings()
		  return 1
		end
	  end
	  
	  if subItem.id == self.menuSubItem_automations_autozoom_out then
	    if subItem.checkbox:onClick(self.mouse) then
		  autozoom_out_enabled = subItem.checkbox.is_checked  
		  self:updateSettings()
		  return 1
		end
	  end	  
	end
	
	--...
	return 1
  end
  
  --[[
  -- magnetic  
  object = self.menu:getItem(self.menuItem_magnetic)
  if object.checkbox:onClick(self.mouse) then
    WFXToggle(WFX_FUNCTION_ID_VAC, object.checkbox.is_checked)
	object.checkbox.is_checked = WFXGetStatus(WFX_FUNCTION_ID_VAC)
	
	if not object.checkbox.is_checked then
	  object.canShowSubItems   = false
	end
	
	self:updateSettings()
	return 1
  end   
  
  if object.canShowSubItems then
    for i = 1, #object.subItems do     
	  local subItem = object.subItems[i]	  
	  
	  if subItem.id == self.menuSubItem_magnetic_fixed then
        if subItem.checkbox:onClick(self.mouse) then
		  magnetic_fixed = subItem.checkbox.is_checked
		  if magnetic_fixed then
		    magnetic_fixed_pos = GetPlayerPos(GetPlayerActor())
		  end
		end
	  end
	  
	  if subItem.id == self.menuSubItem_magnetic_only_insight then
        if subItem.checkbox:onClick(self.mouse) then
		  magnetic_only_insight = subItem.checkbox.is_checked
		end
	  end	  
	  
	  if subItem.id == self.menuSubItem_magnetic_ironman_priority then
	    if subItem.checkbox:onClick(self.mouse) then
		  magnetic_ironman_priority = subItem.checkbox.is_checked
		end
	  end
	end
	
	--...
	return 1
  end
  --]]
end

function CWarbot:onMouseMove(pos)
  self.mouse = pos
  self.menu:onMouseMove(pos)
  if self.debugging_mouse_position then
    self:print(_fmt("mouse {x: %d, y: %d}", self.mouse.x, self.mouse.y))
  end
end

function warbot_ondraw()
  Warbot:onDraw()
end

function warbot_lbuttondown()
  Warbot:onLButtonDown()
end

function warbot_lbuttonup()
  return Warbot:onLButtonUp()
end

function warbot_mousemove(pos)
  Warbot:onMouseMove(pos)
end

Warbot = CWarbot()
WFXRegisterEvent(WFX_EVENTID_DRAW, "warbot_ondraw")
WFXRegisterEvent(WFX_EVENTID_LBUTTON_UP, "warbot_lbuttonup")
WFXRegisterEvent(WFX_EVENTID_MOUSEMOVE, "warbot_mousemove")