
function enum(explosive,active)
  local pos = WorldToScreen(explosive)
  if (pos.x + pos.y) > 0 then
    FDrawString(pos.x, pos.y, 30, 10, COLOR_GREEN, "bomb")
  end
end

function explosives_esp()  
  if g_IsExplosivesESP_Enabled then
    EnumExplosives("enum")
  end
end