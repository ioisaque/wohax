
--public settings
aim_enabled  = true
aim_interval = 500
aim_radius   = 150 -- 0 = off
aim_bone = 1
aim_only_insight = true
aim_mode = 1
aim_can_show_radius = true
aim_melee_radius = 2.0
aim_can_show_melee_radius = true
automations_enabled = false
aim_melee_radius_color = ARGB(50,255,255,0)
aim_target_color = ARGB(255,255,255,102)
aim_radius_color = ARGB(50,255,255,255)
aim_target_entityid = 0

local aim_last_target = 0
local aim_last_target_time = 0
local firing = false

local function GetDistanceFromCrosshair(pos)
  local System = CSystem()
  local out = System:ProjectToScreen(pos)
    
  if out.x == 0 or out.y == 0.0 then 
    return
  end
  
  local screen = System:GetScreenResolution()
  
  if (out.x > screen.x or out.y > screen.y) then
    return
  end
  
  screen.x = screen.x/2
  screen.y = screen.y/2
  
  out.x = out.x - screen.x
  out.y = out.y - screen.y	
  
  return math.sqrt(out.x*out.x+out.y*out.y)
end

local function drawCircle(x,y,radius,color)  
  local step = (math.pi * 2) / 50
  local count = 0
  for a = 0, math.pi*2, step do
    local X1 = radius * math.cos(a) + x
	local Y1 = radius * math.sin(a) + y
	local X2 = radius * math.cos(a + step) + x
	local Y2 = radius * math.sin(a + step) + y
	CSystem():Draw2DLine(X1, Y1, X2, Y2, 1, color)
  end
end

local function show_aim_radius()
  if aim_radius == 0 then
    return
  end  
  local screen = CSystem():GetScreenResolution()    
  screen.x = screen.x/2
  screen.y = screen.y/2  
  drawCircle(screen.x, screen.y, aim_radius, ARGB(255,0,0,255))
end

local function IsVisible(Entity)
  if not aim_only_insight then  
    return true    
  end	
  local System = CSystem()
  local pos = Entity:GetPos() 
  return System:RayTraceCheck(System:GetViewCameraPos(), Entity:GetBonePos("Bip01 Head"), 0, 0)
end

local function canTargetNext(Entity) 
  if aim_last_target ~= Entity.id then
    local t = GetTickCount() - aim_last_target_time;
    if t < aim_interval then
	  --XPrint(string.format("new target: %s (%d ms).", Entity:GetName(), t))
	  return false
	end
  end
  return true
end

local function ActorLookAt(vPos)
  local Actor  = GetLocalActor()
  if not Actor then
    return
  end
  local System = CSystem()
  local vector=DifferenceVectors(vPos, System:GetViewCameraPos())
  vector=NormalizeVector(vector)
  Actor:SetDirectionVector(vector, 1)
end

local function GetHeadPos(Entity)
  local vNeck = Entity:GetBonePos("Bip01 Neck")
  local vHead = Entity:GetBonePos("Bip01 Head")
  local diff  = vHead.z - vNeck.z
  vHead.z = vHead.z + (diff  * 2.0)
  return vHead
end

local function AimGetBonePos(Entity)
  if aim_bone == 1 then
    return GetHeadPos(Entity)
  end  
  return Entity:GetBonePos("Bip01 Spine2")
end

local function OnUpdateSurface()

  if not aim_enabled then
    return
  end
 
  local System = CSystem()
  local localActor = GetLocalActor()
  local GameRules = GetGameRules()
  
  if not localActor or not GameRules then
    return
  end
  
  if not GameRules.game then
    return
  end
  
  local Game = GetGameRules().game
  
  if not (Game:GetRemainingRoundTime() > 0) then
    return
  end
  
  if not (localActor.actor:GetHealth() > 0) then
    return
  end
  
  if aim_can_show_radius then
    show_aim_radius()
  end
      
  local Entities = System:GetEntities()
  local NearestEntity = nil
  local OldDistance = 999999
  
  for i = 1, #Entities do
    local Entity = Entities[i]
	if Entity.actor and localActor.id ~= Entity.id and Entity.actor:GetHealth() > 0 and not Game:IsSameTeam(Entity.id, localActor.id) then	  
	  local BonePos = Entity:GetBonePos("Bip01 Spine2")
	  --if System:IsValidMapPos(BonePos) and System:IsPointVisible(BonePos) then	    
		local Distance = GetDistanceFromCrosshair(BonePos)				    
		local radius = aim_radius
		
		if radius == 0 then
		  radius = 999999
		end
		
		if Distance and OldDistance > Distance and Distance < radius then
		  OldDistance = Distance
		  NearestEntity = Entity
		end
	  --end
	end
  end

  if NearestEntity then    
    aim_target_entityid = NearestEntity.id
	local Entity = System:GetEntity(aim_target_entityid)
	if Entity then
	  System:DrawLabel(Entity:GetPos(), 1.3, Entity:GetName(), 0, 0, 1, 1)
	  
	  if firing and aim_mode == 1 then	  
  	    if canTargetNext(Entity) and IsVisible(Entity) then
	      local vPos = AimGetBonePos(Entity)
		  ActorLookAt(vPos)
		  aim_last_target_time = GetTickCount()
		  aim_last_target = Entity.id
	    end
	  end
	end
  else
	aim_target_entityid = 0
  end
end

local function OnShoot()  
  firing = true
  
  if not aim_target_entityid then
    XPrint("INVALID ENTITYID")
    return
  end
  
  local System = CSystem()
  local Entity = System:GetEntity(aim_target_entityid)
  
  if not Entity then 
    XPrint("INVALID ENTITY")
    return
  end
 
  if not canTargetNext(Entity) then
    return
  end
  
  if not IsVisible(Entity) then
    return
  end
  
  local vPos = AimGetBonePos(Entity)
  if System:IsValidMapPos(vPos) and System:IsPointVisible(vPos) then
    local vector=DifferenceVectors(vPos, System:GetViewCameraPos())
	vector=NormalizeVector(vector)
	CryBot:SetProjectileDir(vector)
	aim_last_target_time = GetTickCount()
	aim_last_target = Entity.id
  end
end

local function OnAttack(attack)
  if (attack == false) then
    firing = false
  end
end

local function OnAction(actionId, activationMode, value)
  if actionId == "attack1" then
    OnAttack(activationMode == 1)
  end
end

CryBot:RegisterEventListener(EVENT_ONACTION, OnAction)
CryBot:RegisterEventListener(EVENT_SHOOT, OnShoot)
CryBot:RegisterEventListener(EVENT_UPDATE_SURFACE, OnUpdateSurface)