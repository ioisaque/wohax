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
  if IsCooperativeMode() then 
    boneLine(player, 4,37, color)
	boneLine(player, 36,37,color)
	boneLine(player, 37,39,color)
	boneLine(player, 39,38,color)
	
	boneLine(player, 5,40, color)
	boneLine(player, 40,41,color)
	boneLine(player, 41,43,color)
	boneLine(player, 43,42,color)
	
	boneLine(player, 14,15,color)
	boneLine(player, 15,17,color)
	boneLine(player, 17,18,color)
	boneLine(player, 18,19,color)
	
	boneLine(player, 25,26,color)
	boneLine(player, 26,28,color)
	boneLine(player, 28,29,color)
	boneLine(player, 29,30,color)
	
	boneLine(player, 10,8,color)
	boneLine(player, 8,7,color)
	boneLine(player, 7,6,color)
	boneLine(player, 6,3,color)
	boneLine(player, 3,1,color)
	
	boneLine(player, 12,14,color)
	boneLine(player, 13,25,color)
	boneLine(player, 1,4,color)
	boneLine(player, 1,5,color)
  else
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
end

function esp_circle(player,color)
  local PELVIS = GetPlayerBonePosByID(player, PELVIS)
  local screen = WorldToScreen(PELVIS) 
   if validate_pos(screen) then
   FDrawCircle(screen.x, screen.y, 20, 15, color)
   end
end

function esp_name(player,color)
  local head = GetPlayerBonePosByID(player, THROAT)
  head.z = head.z + 0.5
  local screen = WorldToScreen(head)  
  if validate_pos(screen) then 
    FDrawString(screen.x, screen.y, 1, 0, color, GetPlayerName(player))
  end
end