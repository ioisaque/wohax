function validate_pos(pos)
  return (pos.x + pos.y + pos.z) > 0
end
	
function boneLine(player, id_start, id_end, color)
  local start_pos = WorldToScreen(GetPlayerBonePosByID(player, id_start))
  local end_pos   = WorldToScreen(GetPlayerBonePosByID(player, id_end))  
  if validate_pos(start_pos) and validate_pos(end_pos) then
    FDrawLine(start_pos.x, start_pos.y, end_pos.x, end_pos.y, 2, color)
  end
end
	
function esp(player, color)
  boneLine(player, 77,78, color)
  boneLine(player, 71,72, color)
  boneLine(player, 70,71, color)
  boneLine(player, 01,04, color)
  boneLine(player, 04,70, color)
  boneLine(player, 01,05, color)
  boneLine(player, 05,77, color)
  boneLine(player, 01,13, color)
  boneLine(player, 13,24, color)
  boneLine(player, 13,47, color)
  boneLine(player, 47,50, color)
  boneLine(player, 24,27, color)
  boneLine(player, 27,28, color)
  boneLine(player, 50,51, color)
end

function DrawBorder(x,y,w,h,px,color)
  FFillRGB(x, (y + h - px), w, px, color)
  FFillRGB(x, y, px, h, color)
  FFillRGB(x, y, w, px, color)
  FFillRGB((x + w - px), y, px, h, color)
end

function esp_box(player,color)
  local head = WorldToScreen(GetPlayerBonePosByID(player, HEAD))
  local lfoot = WorldToScreen(GetPlayerBonePosByID(player, L_FOOT))
  local rfoot = WorldToScreen(GetPlayerBonePosByID(player, R_FOOT))   
  if validate_pos(head) and validate_pos(lfoot) and validate_pos(rfoot) then    
	local x = rfoot.x 	
	if x > lfoot.x then 
	  x = lfoot.x
	end	
	local y = rfoot.y	
	if y < lfoot.y then
	  y = rfoot.y
	end	
    DrawBorder(x, head.y, math.abs(lfoot.x-rfoot.x) ,  y - head.y , 1, COLOR_GREEN)
  end  
end

function esp_name(player,color)
  local head = GetPlayerBonePosByID(player, HEAD)
  head.z = head.z + 0.5
  local screen = WorldToScreen(head)  
  if validate_pos(screen) then
    --WFXPrint(string.format("%d/%d", GetPlayerArmor(player), GetPlayerMaxHealth(player)))
    FDrawString(screen.x, screen.y, 1, 0, color, GetPlayerName(player))
  end
 end