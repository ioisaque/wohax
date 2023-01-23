function enum(explosive,active)
  local pos = WorldToScreen(explosive)
  if (pos.x + pos.y) > 0 then
    FDrawCircle(pos.x, pos.y, 13, 6, BLUE)
	FDrawCircle(pos.x, pos.y, 20, 6, RED)
	FDrawCircle(pos.x, pos.y, 20, 2, RED)
  end
end

function explosives_esp()  
  if g_IsExplosivesESP_Enabled then
    EnumExplosives("enum")
  end
end