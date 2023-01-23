AimMode = 2
AimTarget = 2

AimRadius  = 0
ShowAimRadius = false
AimRadiusColor = ARGB(150, 255, 255, 255)

AimAutoFire = false
AimInterval = 100
AimTargetEntityID = 0

local firing = false
local aim_last_target = 0
local aim_last_target_time = 0
local Font = CSystem():CreateFont(0,7,FW_SEMIBOLD, false, "Arial")

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

local function GetClosestBoneFromCrosshair(Entity, BonePos1, BonePos2)
  local B1 = 0
  local B2 = 0

  B1 = GetDistanceFromCrosshair(BonePos1)
  B2 = GetDistanceFromCrosshair(BonePos2)
  
  if B1 - B2 > 0 then
	return BonePos2
  else
	return BonePos1	
  end
end

local function GetHeadPos(Entity)
  local vNeck = Entity:GetBonePos("Bip01 Neck")
  local vHead = Entity:GetBonePos("Bip01 Head")
  local diff  = vHead.z - vNeck.z
  vHead.z = vHead.z + (diff  * 2.0)
  return vHead
end

local function GetTargetPos(Entity)
  if AimTarget == 2 then
	return GetClosestBoneFromCrosshair(Entity, GetHeadPos(Entity), Entity:GetBonePos("Bip01 Spine2"))
  end
  if AimTarget == 1 then
    return GetHeadPos(Entity)
  end  
  return Entity:GetBonePos("Bip01 Spine2")
end

local function GetEntityAmmoCount(Entity)
  local ItemEntity = Entity.inventory:GetCurrentItem()
  local ammoCount = 0
  if ItemEntity then
	if ItemEntity.weapon then
	  ammoCount = ItemEntity.weapon:GetAmmoCount()
	end
  end
  return ammoCount
end

local function GetEntityWeapon(Entity)
  local ItemEntity = Entity.inventory:GetCurrentItem()
  if ItemEntity then
    return ItemEntity.weapon
  end
end

local function drawCircle(x,y,radius,color)
  local step = (math.pi * 2) / 200
  local count = 0
  for a = 0, math.pi*2, step do
    if count < 20 then
	  local X1 = radius * math.cos(a) + x
	  local Y1 = radius * math.sin(a) + y
	  local X2 = radius * math.cos(a + step) + x
	  local Y2 = radius * math.sin(a + step) + y
	  CSystem():Draw2DLine(X1, Y1, X2, Y2, 2, color)
	  count = count + 1
	else
	  count = 0
	end
  end
end

local function IsVisible(Entity)
  local System = CSystem()
  local pos = Entity:GetPos()
  local BoneTarget = GetTargetPos(Entity)
  return System:RayTraceCheck(System:GetViewCameraPos(), BoneTarget, 0, 0)
end

local function canTargetNext(Entity) 
  if aim_last_target ~= Entity.id then
    local t = GetTickCount() - aim_last_target_time;
    if t < AimInterval then
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

local function SetProjectileDir(vPos)
  local Actor  = GetLocalActor()
  if not Actor then
    return
  end
  local System = CSystem()
  local vector=DifferenceVectors(vPos, System:GetViewCameraPos())
  vector=NormalizeVector(vector)
  CryBot:SetProjectileDir(vector)
   return 
end

local Interval = 0

local function ReloadAmmo(Entity, ReloadAt)
  local ItemEntity = Entity.inventory:GetCurrentItem()
	if ItemEntity then
	  local AmmoCount = 0
		if ItemEntity.weapon then
		  AmmoCount = ItemEntity.weapon:GetAmmoCount()
			 if AmmoCount <= ReloadAt then
			  ItemEntity.weapon:Reload()
			 end
		end
	end
end

local function OnUpdateSurface()
  local System = CSystem()
  local localActor = GetLocalActor()
  local GameRules = GetGameRules()
  
  if AimMode == 0 then
	return
  end
  
  if not localActor or not GameRules then
    return
  end
  
  ReloadAmmo(localActor, ReloadAmmoAt)
  
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
  
  if ShowAimRadius then
    local screen = System:GetScreenResolution()
	screen.x = screen.x/2
	screen.y = screen.y/2
      drawCircle(screen.x, screen.y, AimRadius, AimRadiusColor)
  end
    
  if ((GetTickCount() - Interval) > 100) then
    --XPrint("INTERVALO")
	Interval = GetTickCount()
    return
  end
  
  local NearestEntity = nil
  
  if AimRadius == 0 then
    NearestEntity = CryBot:FindTarget(999999)
  else
    NearestEntity = CryBot:FindTarget(AimRadius)
  end

  if (NearestEntity) then    
    AimTargetEntityID = NearestEntity
	local Entity = System:GetEntity(AimTargetEntityID)
	  if AimTarget == 2 then
		System:DrawLabel(GetTargetPos(Entity), 2, string.format("X"), 1, 1, 1, 1)			
	  end
	if Entity then
	  if not AimAutoFire then
	    if firing and AimMode == 1 then	  
  	      if canTargetNext(Entity) and IsVisible(Entity) then
	        local vPos = GetTargetPos(Entity)
		    ActorLookAt(vPos)
		    aim_last_target_time = GetTickCount()
		    aim_last_target = Entity.id		  		    
		  end
		elseif firing and AimMode == 2 then
		  local vec = GetTargetPos(Entity)
		  SetProjectileDir(vec)
	    end
	  else
		  if GetEntityAmmoCount(localActor) > 0 then
		    local vPos = GetTargetPos(Entity)
			if canTargetNext(Entity) and System:RayTraceCheck(System:GetViewCameraPos(), vPos, 0, 0) then
			  if AimMode == 1 then
			    ActorLookAt(vPos)
			  end
			  aim_last_target_time = GetTickCount()
			  aim_last_target = Entity.id		  		    		  
			  localActor.actor:SimulateOnAction("attack1", 1, 1.0)
			  localActor.actor:SimulateOnAction("attack1", 2, 1.0)
			end
		  end	    
	  end
	end
  else
	AimTargetEntityID = 0
  end
end

local function OnShoot()  
  firing = true

  if AimMode < 2 then
	return
  end
  
  if not AimTargetEntityID then
    XPrint("INVALID ENTITYID")
    return
  end
  
  local System = CSystem()
  local Entity = System:GetEntity(AimTargetEntityID)
  
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
  
  local vPos = GetTargetPos(Entity)
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