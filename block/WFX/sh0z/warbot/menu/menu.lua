require 'warbot\\menu\\colors'
require 'warbot\\menu\\checkbox'
require 'warbot\\menu\\item'
require 'warbot\\menu\\button'
require 'warbot\\menu\\drawtext'

local WFX_ADDONS_PATH = string.gsub(string.sub(debug.getinfo(1).source, 2), "\\", "/") .. '/../'
local mousepos = Vec3(0,0,0)

local WFX_MENU_IMG_START  = CSystem():CreateImageFromFile(WFX_ADDONS_PATH .. 'imgs\\start.png')
local WFX_MENU_IMG_ITEMBG = CSystem():CreateImageFromFile(WFX_ADDONS_PATH .. 'imgs\\itemBG.png')
local WFX_MENU_IMG_SUB    = CSystem():CreateImageFromFile(WFX_ADDONS_PATH .. 'imgs\\sub.png')
local WFX_MENU_IMG_RIGHT  = CSystem():CreateImageFromFile(WFX_ADDONS_PATH .. 'imgs\\direita.png')
local WFX_MENU_IMG_END    = CSystem():CreateImageFromFile(WFX_ADDONS_PATH .. 'imgs\\end.png')

function PtInRec(pt,rect)
   return pt.x > rect.left and
   pt.y > rect.top and
   pt.x < rect.left + rect.right and
   pt.y < rect.top  + rect.bottom and true or nil
end

--------------------- CMenu class --------------------
class 'CMenu'
function CMenu:__init(x,y)
  local FW_EXTRABOLD = 800
  
  self.x = x
  self.y = y
  self.items = {}
  self.itemIndex = 0
  self.disabled = false
  self.subItemOpened = nil
  self.font = CSystem():CreateFont(0,7,FW_EXTRABOLD, false, "Arial")
  self.timeout = 6 --segundos
  self.showMenuHint = false
  self.last_tick = GetTickCount()
  self.last_tick_hint = GetTickCount()
end

function CMenu:drawString(x,y,text)
  myDrawText(self.font, ITEM_COLOR, x, y, 0, 0, text)
end

function drawRect(x,y,w,h,px,color)
  -- função que cria o regangulo do item
--[[  FFillRGB(x, (y + h - px), w, px, color)
  FFillRGB(x, y, px, h, color)
  FFillRGB(x, y, w, px, color)
  FFillRGB((x + w - px), y, px, h, color)--]]
end

function CMenu:debugRect(rect)
  --drawRect(rect.left, rect.top, rect.right, rect.bottom, 1, RED)
end

function CMenu:addItem(text, on_exec)
  local rect = {
    left=self.x, 
    top=self.y, -- +WFXGetImageSize(WFX_MENU_IMG_START).y
    right=WFX_MENU_IMG_ITEMBG.Width,
    bottom=WFX_MENU_IMG_ITEMBG.Height
  }
  local count = #self.items+1 
  if count > 1 then
    rect.top = self.items[count-1].rect.top+WFX_MENU_IMG_ITEMBG.Height
  end
  local item = CItem(rect, text)
  self.items[count] = item
  item:setText(text)
  item.id = count
  XPrint(string.format("Item criado '%s' {%d,%d,%d,%d} com o checkbox %d", text, rect.left, rect.top, rect.right, rect.bottom, item.id))
  return item.id
end

function CMenu:addSubItem(itemId, text)
  local r = self.items[itemId].rect  
  
  local new_rect = {
          left=self.x+180, 
		  top=r.top, 
		  right=WFX_MENU_IMG_SUB.Width, 
		  bottom=self.y+WFX_MENU_IMG_SUB.Height
		}		  
  local count = #self.items[itemId].subItems+1   
  if count > 1 then
	new_rect.top    = self.items[itemId].subItems[count-1].rect.top + WFX_MENU_IMG_SUB.Height
	new_rect.bottom = WFX_MENU_IMG_SUB.Height
  end    
  local item = CItem(new_rect, text)    
  self.items[itemId].subItems[count] = item			
  item:setText(text)
  item.id = count
  XPrint(string.format("SubItem criado {%d,%d,%d,%d} ", new_rect.left, new_rect.top, new_rect.right, new_rect.bottom))
  return item.id
end

function CMenu:addButton_Right(itemId, subItem)
  self.items[itemId].subItems[subItem].checkbox = nil 
  local r = self.items[itemId].subItems[subItem].rect  
  local button = CButton(r.left+15, r.top+8, "direita")
  self.items[itemId].subItems[subItem].buttons[#self.items[itemId].subItems[subItem].buttons+1] = button  
  return button.id
end

function CMenu:addButton_Left(itemId, subItem)
  self.items[itemId].subItems[subItem].checkbox = nil 
  local r = self.items[itemId].subItems[subItem].rect  
  local button = CButton(r.left, r.top+8, "esquerda")
  self.items[itemId].subItems[subItem].buttons[#self.items[itemId].subItems[subItem].buttons+1] = button
  return button.id
end

function CMenu:toggle()
  self.disabled = not self.disabled -- habilita e desabilita o menu
end

function CMenu:getCheckBox(item)
  return self.items[item].checkbox
end

function CMenu:getItem(itemId)
  for i = 1, #self.items do
    local item = self.items[i]
    if item.id == itemId then
	  return item
	end
  end
end

function CMenu:showSubItems(item,transparency)
  for i = 1, #item.subItems do 
    local subItem = item.subItems[i]
	WFX_MENU_IMG_SUB:Draw(subItem.rect.left, subItem.rect.top, transparency)
	subItem:drawString(subItem.rect.left+50, subItem.rect.top+10, subItem.text)
	if subItem.checkbox ~= nil then
	  subItem.checkbox:show(255)
	end
	for j = 1, #subItem.buttons do
	  subItem.buttons[j]:show()
	end
	self:debugRect(subItem.rect)
  end
end

function CMenu:showMenuItemText(item,transparency)
  self:drawString(item.rect.left+50, item.rect.top+7, item.text)
end

function CMenu:showMenuItemEnd(item, transparency)
  WFX_MENU_IMG_END:Draw(item.rect.left, item.rect.top+35, transparency)
  --[[
  if outros_enabled then
	if show_fps then myDrawText(self.font, END_INFO_COLOR, item.rect.left+10, item.rect.top+40, 0, 0, string.format("%d FPS", getFPS())) end
	if show_watch then myDrawText(self.font, END_INFO_COLOR, item.rect.left+10, item.rect.top+60, 0, 0, string.format("Horario atual: %s", getTime())) end
  end
  --]]
end

function CMenu:showMenuItemBg(item,transparency)
  WFX_MENU_IMG_ITEMBG:Draw(item.rect.left,item.rect.top, transparency)
end

function CMenu:showMenuItemCheckBox(item)
  item.checkbox:show(255)
end

function CMenu:showLogo(transparency)
  WFX_MENU_IMG_START:Draw(self.x,self.y, transparency)
end

function CMenu:show(transparency)  
  if self.disabled then 
    if self.showMenuHint then
	  myDrawText(self.font, NOT_COLOR, 20, 30, 0, 0, "Press ESC or END to show the Aimbot menu again.")	
	  if (GetTickCount() - self.last_tick_hint) > 3000 then
	    self.showMenuHint = false
	  end	
	end
 
    self.last_tick = GetTickCount()
    return 
  end
  -- a construção do menu é feita item por item, portanto aqui ele lista todos itens e os ajustam na tela. 
  self:showLogo(80)
  
  local canDisableMenu = true
  
  for i = 1, #self.items do
    local item = self.items[i]
	self:showMenuItemBg(item,transparency)
	self:showMenuItemText(item,transparency)
	self:showMenuItemCheckBox(item,transparency)
	if i == #self.items then --se for o ultimo item...
	   if outros_enabled then self:showMenuItemEnd(item,transparency) end
	end	
	if item.canShowSubItems then
	  self:showSubItems(item,transparency)	  
	  canDisableMenu = false
	  self.last_tick = GetTickCount()
	end
	--self:debugRect(item.rect)
  end

  --if canDisableMenu and canDisableMenu_ok then
    if (GetTickCount() - self.last_tick) > self.timeout*1000 then
      if not self.disabled then
	    self.disabled = true
	    self.showMenuHint = true
	    self.last_tick_hint = GetTickCount()
		self.timeout = 10 -- volta o timeout pra 10 sec
	  end
	  self.last_tick = GetTickCount()
	end
  --end
end

local openMenu = nil
local openMenuRect = {}

function CMenu:onMouseMove(pos)
  for i = 1, #self.items do 
    local item = self.items[i]	
	
	if not item.checkbox.is_checked then
	  item.canShowSubItems = false
	  goto continue
	end
	
	if not (#item.subItems > 0) then
	  goto continue 
	end
	
	item.canShowSubItems = PtInRec(pos, item.rect)
		
	if item.canShowSubItems then
	
	  local lastSubItem = item.subItems[#item.subItems]	  
	  local newrect = {
	          left=item.rect.left,
		      top=item.rect.top,
			  right=lastSubItem.rect.right,
  			  bottom=lastSubItem.rect.top + lastSubItem.rect.bottom
			}
      openMenu = item			
	  openMenuRect = newrect
	else
	  if openMenu ~= nil then
	    if not PtInRec(pos, openMenuRect) then
	      openMenu = nil
	      openMenuRect = {}
		else 
		  if openMenu.id == item.id then
		    item.canShowSubItems = true
		  end
		end
	  end
	end
	::continue::
  end
end