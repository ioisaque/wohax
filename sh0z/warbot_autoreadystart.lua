autoreadystart_enabled = true
autoreadystart_interval = 5

local lastT = GetTickCount()

function autostart_draw()
  if (GetTickCount() - lastT) > autoreadystart_interval*1000 then
    WFXSetReady(true)
	WFXPrint("Pronto!")
	lastT = GetTickCount()
  end
end

WFXRegisterEvent(WFX_EVENTID_DRAW, "autostart_draw")