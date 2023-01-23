require 'warbot\\warbot'

-- global variables
local flakes_path = WFXGetPath().."add-ons\\fireworks\\images\\"

local g_flake_img1 = WFXLoadImage(flakes_path.."fw1.png")
local g_flake_img2 = WFXLoadImage(flakes_path.."fw2.png")
local g_flake_img3 = WFXLoadImage(flakes_path.."fw3.png")
local g_flake_img4 = WFXLoadImage(flakes_path.."fw4.png")
local g_rocket     = WFXLoadImage(flakes_path.."rocket.png")

local g_flakes_quantity = 100
local g_lastSeed = GetTickCount() + 1234
local _print = WFXPrint
local _fmt   = string.format
---

class 'CSnowFlake'

local _cos = math.cos
local _sin = math.sin

function CSnowFlake:snowInit()
  self.shot = {
    x = _cos(self.flake.angle) * self.flake.initial_force,
	y = -_sin(self.flake.angle) * self.flake.initial_force
  }  
  self.wind_effect = {
    x = _cos(self.wind.angle) * self.wind.speed,
	y = (-(_sin(self.wind.angle) * self.wind.speed)) + self.flake.weight
  }
end

function CSnowFlake:getSeed()   
  local seed = GetTickCount()+1 + g_lastSeed+1 + os.time() + 1
  g_lastSeed = seed + 5
  return seed
end

function CSnowFlake:__init(img,x,y,fire_angle,fire_weight, wind_angle, wind_speed, power)
  self.img  = img  
  self.tick = 0
  
  self.flake = {angle  = math.rad(fire_angle), weight = fire_weight, initial_force = power }
  self.wind  = {angle = math.rad(wind_angle), speed = wind_speed}
    
  self:snowInit()
  self.x = x
  self.y = y
  
  self.initialpos = {self.x,self.y}
end

function CSnowFlake:draw(x,y)
  if not Warbot.menu.disabled then
    local transparency = 255--math.random(100,230)
    WFXDrawImage(self.img, D3DXVECTOR3(x,y,0), transparency)
	--myDrawText(Warbot.font, ARGB(255,255,255,255), x, y-10, 0, 0, string.format("%d %f", self.tick, GetScreenResolution().y))
  end
end

function CSnowFlake:randpos()
  math.randomseed( self:getSeed() )
  local r = GetScreenResolution()
  return {x = math.random(r.x), y = math.random(r.y)}
end

function CSnowFlake:move()  
  local this = self
  local shot = this.shot
  local wind_effect = this.wind_effect
  local flake = this
  local screenw = GetScreenResolution().y + 0.0
  local screenh = GetScreenResolution().x + 0.0
  
  if flake.y >= screenw or (flake.x < 0 or flake.x > screenh) then
    --flake.x = self:randpos().x
	--flake.y = 20--self:randpos().y
	
	--self.wind.speed = _fmt("0.00%02d\n", math.random(1,9))
	
    this:snowInit()
    return
  end

  this:draw(flake.x, flake.y)

  shot.x = shot.x + wind_effect.x
  shot.y = shot.y + wind_effect.y
  
  flake.x = flake.x + shot.x
  flake.y = flake.y + shot.y
  
  this.tick = this.tick + 1
end

--[[
local flakes1 = {}
local flakes2 = {}
local flakes3 = {}

for i = 1, 70 do --]]
--  flakes1[#flakes1+1] = CSnowFlake(
  --                          g_flake_img1, --[[variavel que contem a imagem do floco, o valor desta variável é atribuido no inicio do script--]]
	--						-1, --[[ -1 = posição vertical randomica onde o floco de neve irá aparecer inicialmente --]]
		--					20  --[[ 20 = cordenada horizontal (Y) da tela onde o floco de neve irá aparecer inicialmente --]]
			--			)  
--end
--[[
for i = 1, 15 do
  flakes2[#flakes2+1] = CSnowFlake(g_flake_img2, -1, 20) 
end

for i = 1, 5 do
  flakes3[#flakes3+1] = CSnowFlake(g_flake_img3, -1, 20) 
end
--]]

math.randomseed( os.time() )

local fire = nil

function init()
  fire = CSnowFlake(g_rocket,
  400,  -- initial x
  400, -- initial y
  90, -- fire angle
  0.0090, -- fire weight
  95, -- wind angle
  0.0005 + _fmt("0.00%02d\n", math.random(1,9)), -- wind speed
  2.5 -- initial power
  )
end

init()

local fires = {}

function animate_fires(fire_vector)
  local done = true
  for i = 1, #fire_vector do
    f = fire_vector[i]
    f:move()
	if f.y < GetScreenResolution().y then
	  done = false
	end
  end
  
  if done and fire.tick > 200 then
    fires = {}
    init()
  end
end

function fireworks_draw()  
  if fire.tick < 200 then
    fire:move() 
  else
    if #fires == 0 then 
      fires[1] = CSnowFlake(g_flake_img1, fire.x, fire.y, 320, 0.0020, 95, 0.0001, 0.5)
	  fires[2] = CSnowFlake(g_flake_img2, fire.x, fire.y, 290, 0.0020, 95, 0.0001, 0.5)
	  fires[3] = CSnowFlake(g_flake_img3, fire.x, fire.y, 260, 0.0020, 95, 0.0001, 0.5)
	  fires[4] = CSnowFlake(g_flake_img4, fire.x, fire.y, 230, 0.0020, 95, 0.0001, 0.5)
	  fires[5] = CSnowFlake(g_flake_img1, fire.x, fire.y, 200, 0.0020, 95, 0.0001, 0.5)
	  fires[6] = CSnowFlake(g_flake_img2, fire.x, fire.y, 170, 0.0020, 95, 0.0001, 0.5)
	  fires[7] = CSnowFlake(g_flake_img1, fire.x, fire.y, 140, 0.0020, 95, 0.0001, 0.5)
	  fires[8] = CSnowFlake(g_flake_img2, fire.x, fire.y, 110, 0.0020, 95, 0.0001, 0.5)
	  fires[9] = CSnowFlake(g_flake_img3, fire.x, fire.y, 80, 0.0020, 95, 0.0001, 0.5)
	  fires[10] = CSnowFlake(g_flake_img4, fire.x, fire.y, 50, 0.0020, 95, 0.0001, 0.5)
	  fires[11] = CSnowFlake(g_flake_img1, fire.x, fire.y, 30, 0.0020, 95, 0.0001, 0.5)
	  fires[12] = CSnowFlake(g_flake_img2, fire.x, fire.y, 10, 0.0020, 95, 0.0001, 0.5)
    end   
  end
  animate_fires(fires)
  --animate_flakes(flakes2)
  --animate_flakes(flakes3)
end

--
WFXRegisterEvent(WFX_EVENTID_DRAW, "fireworks_draw")