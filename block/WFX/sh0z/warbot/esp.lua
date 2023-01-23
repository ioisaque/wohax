--[[
<description>dwqdqwdqwdwqdwqd</description>
<version>1.05</version>
<author>sh0z</author>
<website>www.wohax.com</website>
--]]

--public settings
esp_enabled = true
esp_show_skeleton = true
esp_skeleton_line_width = 3

local function GetBonePos(Entity, BoneName)
  return Entity:GetBonePos("Bip01 "..BoneName)
end

local function BoneLineTo(Entity,BoneNameFrom,BoneNameTo,Color)
  local System = CSystem()

  local p1 = GetBonePos(Entity, BoneNameFrom)
  if not System:IsPointVisible(p1) then
    return
  end

  local p2 = GetBonePos(Entity, BoneNameTo)
  if not System:IsPointVisible(p2) then
    return
  end
  
  p1 = System:ProjectToScreen(p1)
  p2 = System:ProjectToScreen(p2)

  System:Draw2DLine(p1.x, p1.y, p2.x, p2.y, esp_skeleton_line_width, Color)
end

local function ESP_Skeleton(Entity, Color)  
  BoneLineTo(Entity, "R Calf", "R Thigh", Color)
  BoneLineTo(Entity, "L Calf", "L Thigh", Color)
  BoneLineTo(Entity, "R Thigh", "L Thigh", Color)
  BoneLineTo(Entity, "Pelvis", "Head", Color)
  BoneLineTo(Entity, "Head", "L UpperArm", Color)
  BoneLineTo(Entity, "Head", "R UpperArm", Color)
  BoneLineTo(Entity, "L UpperArm", "L ForeTwist", Color)
  BoneLineTo(Entity, "R UpperArm", "R ForeTwist", Color)
  BoneLineTo(Entity, "L ForeTwist", "L Hand", Color)
  BoneLineTo(Entity, "R ForeTwist", "R Hand", Color)  
  BoneLineTo(Entity, "L Calf", "L Heel", Color)
  BoneLineTo(Entity, "R Calf", "R Heel", Color)
  --BoneLineTo(Entity, "L Heel", "L Toe0Nub01", Color)
  --BoneLineTo(Entity, "R Heel", "R Toe0Nub01", Color)
end

local function ESP_Weapon(Entity)
  local ItemEntity = Entity.inventory:GetCurrentItem()
  if ItemEntity then
    local ammoCount = 0
	if ItemEntity.weapon then
	  ammoCount = ItemEntity.weapon:GetAmmoCount()
	end
    CSystem():DrawLabel(Entity:GetPos(), 1.30, string.format("\nAmmo: %d", ammoCount), 1, 40, 100, 1)
  end
end

local function ESP_Name(Entity) 
  --[[
  local System = CSystem()
  local name = Entity.class
  if name == "Player" then
    name = Entity:GetName()
  end  
  System:DrawLabel( 
    Entity:GetPos(), 
	1.25, 
	string.format("%s (%d/%d)", name, Entity.actor:GetHealth(), Entity.actor:GetMaxHealth()), 
	1, 40, 100, 1
  );
  --]]
end

local function IsVisible(Entity)
  local System = CSystem()
  local pos = Entity:GetPos() 
  return System:RayTraceCheck(System:GetViewCameraPos(), Entity:GetBonePos("Bip01 Head"), 0, 0)
end

local function OnUpdateSurface()
  if not esp_enabled then
    return
  end
 

  local localActor = GetLocalActor()
  local System = CSystem()
    
  if not localActor then
    return
  end
  
  local gameRules = GetGameRules()
  if not gameRules then
    return
  end
  
  local Game = gameRules.game
  
  if not (Game:GetRemainingRoundTime() > 0) then
    return
  end
  
  --ESP_Weapon(localActor)
 --[[
  local Players = Game:GetPlayers()
  for i = 1, #Players do
    local Entity = Players[i]
    local actor = Entity.actor
	if actor:GetHealth() > 0 and not Game:IsSameTeam(Entity.id, localActor.id)  then
	  if IsVisible(Entity) then
	    ESP_Skeleton(Entity,ARGB(255,0,255,0))
	  else
		ESP_Skeleton(Entity,ARGB(255,255,0,0))
	  end	
	  ESP_Name(Entity)
	  ESP_Weapon(Entity)
	end	
  end--]]  
      
  --// esp bombs

  local Entities = System:GetEntities()
  for i = 1, #Entities do
    local Entity = Entities[i]
	local actor  = Entity.actor
	
	--[[
	if Entity:GetName() == "ammo" then
	  System:DrawLabel(Entity:GetPos(), 1.40, string.format("%s", Entity.class), 200, 100, 200, 1)
	end
	
	if string.find(Entity.class, "fg") ~= nil and Entity:IsActive() then
	  System:DrawLabel(Entity:GetPos(), 1.40, string.format(">> '%s'", Entity.class), 200, 100, 200, 1)
	end--]]
	
	if esp_show_skeleton and actor and actor:GetHealth() > 0 and not Game:IsSameTeam(Entity.id, localActor.id)  then
	  if IsVisible(Entity) then
	    ESP_Skeleton(Entity,ARGB(255,0,255,0))
	  else
		ESP_Skeleton(Entity,ARGB(255,255,0,0))
	  end	
	  ESP_Name(Entity)
	  --ESP_Weapon(Entity)
	end	
  end 
end

CryBot:RegisterEventListener(EVENT_UPDATE_SURFACE, OnUpdateSurface)