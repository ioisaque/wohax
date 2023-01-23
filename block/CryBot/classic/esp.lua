-- Global
IsEspNameAndClassActive = true
IsEspSkeletonActive = true
IsEspClaymoreActive = true

IsEspBoxActive = false
IsEspDistanceActive = true
IsEspBarActive = true
IsEspWeaponActive = true

local function GetBonePos(Entity, BoneName)
  return Entity:GetBonePos("Bip01 "..BoneName)
end

local function IsVisible(Entity)
  local System = CSystem()
  local pos = Entity:GetPos() 
  return System:RayTraceCheck(System:GetViewCameraPos(), Entity:GetBonePos("Bip01 Head"), 0, 0)
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

  System:Draw2DLine(p1.x, p1.y, p2.x, p2.y, 2.5, Color)
end

local function ESP_Skeleton(Entity, Color)  
  BoneLineTo(Entity, "R Calf", "R Thigh", Color) -- Coxa Direita
  BoneLineTo(Entity, "L Calf", "L Thigh", Color) -- Coxa Esquerda

  BoneLineTo(Entity, "L Calf", "L Heel", Color) -- Panturrilha Esquerda
  BoneLineTo(Entity, "R Calf", "R Heel", Color) -- Panturrilha Direita

  BoneLineTo(Entity, "R Thigh", "L Thigh", Color) -- Quadril
  BoneLineTo(Entity, "Pelvis", "Head", Color) -- Coluna

  BoneLineTo(Entity, "L UpperArm", "L ForeTwist", Color) -- Braço Esquerdo
  BoneLineTo(Entity, "R UpperArm", "R ForeTwist", Color) -- Braço Direito

  BoneLineTo(Entity, "L ForeTwist", "L Hand", Color) -- Ante Braço Esquerdo
  BoneLineTo(Entity, "R ForeTwist", "R Hand", Color) -- Ante Braço Direito

  BoneLineTo(Entity, "Head", "L UpperArm", Color) -- Ombro Esquerdo
  BoneLineTo(Entity, "Head", "R UpperArm", Color) -- Ombro Direito

--  BoneLineTo(Entity, "L Heel", "L Toe0Nub01", Color) -- Pé Esquerdo
--  BoneLineTo(Entity, "R Heel", "R Toe0Nub01", Color) -- Pé Direito
end

local function ESP_Health(Entity)
  local System = CSystem()
  local EBP = GetBonePos(Entity, "Head")

  local BarWeight = 4  
  local BgBarColor = ARGB(170,0,0,0)
  local BarColor = ARGB(200,222,0,0)
  
  EBP = System:ProjectToScreen(EBP)
  EBP.x = EBP.x+15
  EBP.y = EBP.y-17
  
  local MaxHealth = Entity.actor:GetMaxHealth()
  local Health = Entity.actor:GetHealth()
  
  
  if ((Entity.class == "Player") or (Entity.class == "Soldier")) then
    --if (MaxHealth > 100 and Health <= 100) then   MaxHealth = 100 end 
  elseif (Entity.class == "HeavyGunner") then
    BarWeight = 10
	--Health = Health*5
	--MaxHealth = MaxHealth/10
	--XPrint(string.format("%d/%d", Health, MaxHealth))
  end
  
  if (MaxHealth > 100 and Health <= 100) then   MaxHealth = 100 else end 

  Health = Health/1.3
  MaxHealth = MaxHealth/1.3
  
  System:Draw2DLine(EBP.x, EBP.y, EBP.x+MaxHealth, EBP.y, BarWeight, BgBarColor);
  System:Draw2DLine(EBP.x, EBP.y, EBP.x+Health, EBP.y, BarWeight, BarColor);
end

local function ESP_Armor(Entity)
  local System = CSystem()
  local EBP = GetBonePos(Entity, "Head")
  
  local BgBarColor = ARGB(170,0,0,0)
  local BarColor = ARGB(200,0,85,255)
  
  EBP = System:ProjectToScreen(EBP)
  EBP.x = EBP.x+15
  EBP.y = EBP.y-10
  
  local MaxArmor = Entity.actor:GetMaxArmor()
  local Armor = Entity.actor:GetArmor()
  
  if (MaxArmor > 100 and Armor <= 100) then MaxArmor = 100 end
  
  Armor = Armor/1.3
  MaxArmor = MaxArmor/1.3
  
  System:Draw2DLine(EBP.x, EBP.y, EBP.x+MaxArmor, EBP.y, 3, BgBarColor);
  System:Draw2DLine(EBP.x, EBP.y, EBP.x+Armor, EBP.y, 3, BarColor);
end

local function GetPlayerClassByWeapon(wpcls)
  local class = "Unknow"
  if string.find(wpcls, "sr") ~= nil then
	class = "[Sniper] -"
  elseif ((string.find(wpcls, "smg") ~= nil) or (string.find(wpcls, "ak") ~= nil)) then
	class = STR_ENGINEER	
  elseif ((string.find(wpcls, "shg") ~= nil) or (string.find(wpcls, "mk") ~= nil) or (string.find(wpcls, "df") ~= nil)) then
	class = STR_MEDIC
  elseif ((string.find(wpcls, "ar") ~= nil) or (string.find(wpcls, "mg") ~= nil) or (string.find(wpcls, "ap") ~= nil)) then
	class = STR_RIFLEMAN	
  else
	class = ""
  end
  return class
end

local function ESP_NameAndClass(Entity, pos)
  local ItemEntity = Entity.inventory:GetCurrentItem()
  if ItemEntity then
   local CLS = GetPlayerClassByWeapon(ItemEntity.class)  
    CSystem():DrawLabel(pos, 1.30, string.format("%s %s", CLS, Entity:GetName()), 0, 25, 15, 1)
  end
end

local function GetWeaponName(class)
 local Weapons = {["sr17"] = "AMP DSR-1", ["sr12_clr01"] = "Tavor STAR-21 Navy Blue", ["sr03"] = "ALPINE", ["sr22"] = "SIG 550", ["sr26"] = "Walther WA 2000", ["sr06"] = "H&K SL8", ["sr05"] = "XM8 Sharpshooter", ["sr16"] = "Barrett M988", ["sr01"] = "VSS Vintorez", ["sr15"] = "Barrett M107", ["sr30"] = "QBU-88", ["sr25"] = "ACR SPR", ["sr23"] = "M16 SPR Custom", ["sr13_crown02"] = "MK14 EBR Crown", ["sr04_crown02"] = "AS50 Crown", ["sr08"] = "Chey Tac M200", ["kn04_hlw01"] = "[Melee] Army Knife Anti-Ciborgue", ["kn01"] = "[Melee] Executor Knife", ["ak01"] = "[ArmorKit]", ["ak02"] = "[ArmorKit]", ["ak03"] = "[ArmorKit]", ["ap01"] = "[Ammo Pack]", ["ap02"] = "[Ammo Pack]", ["ap03"] = "[Ammo Pack]", ["df01"] = "[Defibrillator]", ["df02"] = "[Defibrillator]", ["df03"] = "[Defibrillator]", ["mk01"] = "[Medkit]", ["mk02"] = "[Medkit]", ["mk03"] = "[Medkit]", ["kn05"] = "[Melee] Sapper Shovel", ["kn10"] = "[Melee] S&W Survival Tanto Blade", ["kn04"] = "[Melee] Army Knife", ["kn02"] = "[Melee] Ultra Marine", ["pt22"] = "[Pistol] FN Five-seveN", ["pt04"] = "[Pistol] Calico M900", ["pt02"] = "[Pistol] COLT Phyton Elite", ["pt15"] = "[Pistol] Beretta M93R", ["pt16"] = "[Pistol] M1911A1", ["pt07"] = "[Pistol] Beretta M9", ["pt26"] = "[Pistol] Mateba Autorevolver", ["pt03"] = "[Pistol] H&K USP", ["pt08"] = "[Pistol] Daewoo K5", ["pt21_crown02"] = "[Pistol] Glock 18c Crown", ["pt01_crown02"] = "[Pistol] Desert Eagle Crown", ["pt05"] = "[Pistol] Browning High Power", ["pt06"] = "[Pistol] Steyr M9A1", ["pt25"] = "[Pistol] Rhino 60DS", ["mg02"] = "[LMG] MG4", ["mg03"] = "[LMG] H&K Daewoo K3", ["mg04"] = "[LMG] RPK", ["mg05"] = "[LMG] XM8", ["mg06"] = "[LMG] H&K MG36", ["mg12"] = "[LMG] M60E4", ["mg21"] = "[LMG] M16A2 LMG", ["ar01"] = "Tavor TAR-21", ["ar02"] = "M4A1", ["ar03"] = "AUG A3", ["ar04"] = "AK-103", ["ar05"] = "XM8", ["ar06"] = "H&K G36K", ["ar07"] = "CALICO M955A", ["ar08"] = "SIG 551", ["ar09"] = "Daewoo K2", ["ar10"] = "FN F2000", ["ar11_crown02"] = "FN SCAR-H Crown", ["ar13"] = "Famas F1", ["ar16_crown02"] = "Type 97 Crown", ["ar17"] = "Galil AR", ["ar23"] = "AS-'VAL'", ["smg01"] = "H&K MP7", ["smg02"] = "Mini Uzi", ["smg03"] = "Kriss Super V", ["smg03_crown02"] = "Kriss Super V Crown", ["smg05"] = "Calico M960A", ["smg06"] = "AK-9", ["smg07"] = "H&K G36C", ["smg09"] = "FN P90", ["smg11"] = "AUG A3 9mm XS", ["smg12"] = "Daewoo K1", ["smg13"] = "M4 CQB", ["smg15"] = "MPA 10SST-X", ["smg17_crown02"] = "H&K UMP Crown", ["smg18"] = "PP-19 Bizon", ["smg23"] = "SIG 552", ["smg24"] = "B&T MP-9", ["smg26"] = "Beretta MX4 Storm", ["smg30"] = "J9 9mm", ["shg02"] = "Jackhammer", ["shg03"] = "Saiga", ["shg04"] = "VEPR", ["shg06"] = "SPAS-12", ["shg07_crown02"] = "Saiga Bullpup Crown", ["shg08_crown02"] = "Mossberg 500 Custom Crown", ["shg09"] = "Remington 870 CB", ["shg10"] = "MC 255 12", ["shg11"] = "Cobray Striker", ["shg12"] = "Hawk Pump", ["shg13"] = "Kel-Tec Shotgun", ["shg15"] = "Beneli Nova Tactical", ["shg22"] = "Beneli M4 Super 90", ["shg26"] = "UTAS UTS-15", ["shg27"] = "SRM 1216", ["shg28"] = "Franchi SPAS-15", ["shg30"] = "Anakon Semi-Auto"}
  
  if Weapons[class] == nil then
   return class
  end

 return Weapons[class]
end

local function ESP_Weapon(Entity, pos)
  local ItemEntity = Entity.inventory:GetCurrentItem()
  if ItemEntity then
    local weapon = GetWeaponName(ItemEntity.class)
	local ammoCount = 0
	if ItemEntity.weapon then
	  ammoCount = ItemEntity.weapon:GetAmmoCount()
	end
	if ((string.find(weapon, "fg") ~= nil) or (string.find(weapon, "grenade") ~= nil)) then
	  CSystem():DrawLabel(pos, 1.50, string.format("\nGRANADA!"), 1, 0, 0, 1)	
	else
	  CSystem():DrawLabel(pos, 1.30, string.format("\n%s: %d", weapon, ammoCount), 1, 118, 160, 1)
	end
  end
end

local function OnUpdateSurface()
  local localActor = GetLocalActor()
  local System = CSystem()
  
  if not localActor then
    return
  end
  
  local gameRules = GetGameRules()
  if not gameRules then
    --return
  end
  
  local Game = gameRules.game
  
  if not (Game:GetRemainingRoundTime() > 0) then
    --return
  end
  
  local Entities = System:GetEntities()  
	for i = 1, #Entities do
      local Entity = Entities[i]
	  local actor  = Entity.actor
	  
		if not Game:IsSameTeam(Entity.id, localActor.id) then
		 local name = Entity:GetName()
		 
		 if IsEspClaymoreActive and name == "ammo" then
		   local vec = Entity:GetPos()
		   local pos = System:ProjectToScreen(vec)
		    CryBot:Draw2DBox(Entity, 2.5, ARGB(255,55,180,0))
			System:DrawLabel(Entity:GetPos(), 1.40, string.format("Claymore: %1.0fm", Entity:GetDistance(localActor.id)), 1, 0, 0, 1)
		 end
		  
		 if actor and actor:GetHealth() > 0 then
		  local HeadPos = GetBonePos(Entity, "Head")
		  HeadPos.x = HeadPos.x + 1	

		  if IsEspNameAndClassActive then
		    ESP_NameAndClass(Entity, HeadPos)
		  end		  

		  if IsEspWeaponActive then
			ESP_Weapon(Entity, HeadPos)
		  end
		  
		  local VisibilityColor = ARGB(255,255,255,255)			
			if IsVisible(Entity) then
			  VisibilityColor = ARGB(130,0,255,200)
			else
			  VisibilityColor = ARGB(130,255,0,0)
			end
		 
		  if IsEspSkeletonActive then
			ESP_Skeleton(Entity, VisibilityColor)
		  end
		  
		  if IsEspBoxActive then
			CryBot:Draw2DBox(Entity, 2, VisibilityColor)
		  end

		  if IsEspDistanceActive then 
		    System:DrawLabel(HeadPos, 1.25, string.format("\n\n%s: %1.0fm", STR_DISTANCE, Entity:GetDistance(localActor.id)), 1, 1, 1, 1)
	      end
		  
		  if IsEspBarActive then
			local TargetEntity = System:GetEntity(AimTargetEntityID)
			  if TargetEntity then
				ESP_Health(TargetEntity)
				ESP_Armor(TargetEntity)
			end
		  end		
		 end
		end
	end  
end

CryBot:RegisterEventListener(EVENT_UPDATE_SURFACE, OnUpdateSurface)