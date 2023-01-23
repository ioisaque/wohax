require 'wfx_def'

VK_CONTROL = 17

local isControlPressed = false

function warbot_reloader_ActivateApp(activated)
  if activated == 0 then
    isControlPressed = false
  end
end

function warbot_reloader_OnKeyDown(Key)
  if Key == VK_CONTROL then
    isControlPressed = true
  end
end

function warbot_reloader_OnKeyUp(Key)  
  if Key == 13 and isControlPressed then
    WFXReloadScripts()  
  end

  if Key == VK_CONTROL then
    isControlPressed = false
  end
end

WFXRegisterEvent(WFX_EVENTID_KEYDOWN, "warbot_reloader_OnKeyDown")
WFXRegisterEvent(WFX_EVENTID_KEYUP, "warbot_reloader_OnKeyUp")
WFXRegisterEvent(WFX_EVENTID_ACTIVATEAPP, "warbot_reloader_ActivateApp")