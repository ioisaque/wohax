local font = CSystem():CreateFont(0,8,1000, false, "Calibri")

canShowMenu = true
local x = 10
local y = 10
local line = 17

local function DrawItem(color, text)
  font:Draw(x,y,0,0,color,text)
  y = y + line
end

local function ItemColor(b)
  if b then
    return ARGB(255,105,255,0)
  end
  return ARGB(255,225,50,50)
end

local function GetStatusText(b)
  if b then
    return ": Ligado"
  end
  return ": Desligado"
end

local function GetBoneText(AimTarget)
  if (AimTarget == 1) then
	return STR_AIM_HEAD
  else
    return STR_AIM_BODY
  end
end

function DrawMenu()
  x = 10
  y = 35
  
  if canShowMenu then
  DrawItem(ItemColor(AimMode ~= 0), string.format("[F5/PGDN] %s %d [%s] %s", STR_AIMBOT, AimMode, GetBoneText(AimTarget), GetStatusText(AimMode ~= 0)))
  DrawItem(ItemColor(ShowAimRadius), string.format("[CTRL + Z] %s %d %s", STR_AIM_FOV, AimRadius, GetStatusText(ShowAimRadius)))
  DrawItem(ItemColor(AimAutoFire), string.format("[PG UP] %s %s", STR_AIM_AUTOFIRE, GetStatusText(AimAutoFire)))
  DrawItem(ARGB(0,0,0,0), "") -- line space
  DrawItem(ItemColor(ReloadAmmoAt ~= 0), string.format("[CTRL + < >] %s [%d] %s", STR_AIM_AUTORELOAD, ReloadAmmoAt, GetStatusText(ReloadAmmoAt ~= 0)))
  DrawItem(ARGB(0,0,0,0), "") -- line space
  DrawItem(ItemColor(IsEspNameAndClassActive), string.format("[F6] %s %s", STR_ESP_NAME, GetStatusText(IsEspNameAndClassActive)))
  DrawItem(ItemColor(IsEspSkeletonActive), string.format("[F7] %s %s", STR_ESP_SKELETON, GetStatusText(IsEspSkeletonActive)))  
  DrawItem(ItemColor(IsEspClaymoreActive), string.format("[F8] %s %s", STR_ESP_CLAYMORE, GetStatusText(IsEspClaymoreActive)))
  DrawItem(ARGB(0,0,0,0), "") -- line space
  DrawItem(ItemColor(IsEspBoxActive), string.format("[CTRL + M] %s %s", STR_ESP_BOX, GetStatusText(IsEspBoxActive)))
  DrawItem(ItemColor(IsEspDistanceActive), string.format("[CTRL + C] %s %s", STR_ESP_DISTANCE, GetStatusText(IsEspDistanceActive)))
  DrawItem(ItemColor(IsEspBarActive), string.format("[CTRL + D] %s %s", STR_ESP_BAR, GetStatusText(IsEspBarActive)))
  DrawItem(ItemColor(IsEspWeaponActive), string.format("[CTRL + F] %s %s", STR_ESP_WEAPON, GetStatusText(IsEspWeaponActive)))
  DrawItem(ARGB(0,0,0,0), "") -- line space
  DrawItem(ItemColor(IsNoRecoilActive), string.format("[F9] %s %s", STR_HACK_NO_RECOIL, GetStatusText(IsNoRecoilActive)))
  DrawItem(ItemColor(IsNoSpreadActive), string.format("[F11] %s %s", STR_HACK_NO_SPREAD, GetStatusText(IsNoSpreadActive)))
  DrawItem(ItemColor(IsUnlimitedRunningActive), string.format("[CTRL + B] %s %s", STR_HACK_UNLIMITED_RUNNING, GetStatusText(IsUnlimitedRunningActive)))
  DrawItem(ARGB(0,0,0,0), "") -- line space
  DrawItem(ARGB(255,0,255,200), "ON/OFF - MENU: END")
  end
end

CryBot:RegisterEventListener(EVENT_UPDATE_SURFACE, DrawMenu)