
local WFX_ADDONS_PATH = string.gsub(string.sub(debug.getinfo(1).source, 2), "\\", "/") .. '/../'

local images_path = WFX_ADDONS_PATH .. 'imgs\\'
local direita      = CSystem():CreateImageFromFile(images_path .. 'direita.png')
local esquerda     = CSystem():CreateImageFromFile(images_path .. 'esquerda.png')
local global_id = 1

class 'CButton'
function CButton:__init(x,y,position)
  self.id   = global_id
  global_id = global_id + 1
  
  self.rect = {left=x+10, top=y+3, right=direita.Width, bottom=direita.Height}
  
  XPrint(string.format("%d,%d", self.rect.left, self.rect.top))
  
  XPrint(string.format("%d,%d", x,y))
  XPrint(string.format("%d,%d", self.rect.left, self.rect.top))
  
  if (position == "direita") then
	self.image = direita
  else
	self.image = esquerda
  end
  
  return self.id
end

function CButton:onClick(pos)
  if self:ptInRect(pos) then
    return true
  else
	return false
  end
end

function CButton:ptInRect(pt)
  return 
    pt.x > self.rect.left and
	pt.y > self.rect.top and
	pt.x < self.rect.left + self.rect.right and
	pt.y < self.rect.top  + self.rect.bottom and true or nil
end

function CButton:show()
  self.image:Draw(self.rect.left, self.rect.top, 255)
end