require 'wfx_def'

--# Global
	Looby = true
	bcast_id = 0
	player_id = 0

	--WFXAllocConsole()
	--WFXPrint("\n")
	--WFXPrint("Playerlist Script - 1.0\n\n")
--#
	
FONTE = WFXCreateFont( -- função interna do WFX para criar fonte...
          20, -- altura
		  10, -- largura
		  400, -- "peso"
		  false, -- italico (sim,não)
		  "Tahoma" -- nome da fonte
		  )  
		  
function mostrar_na_tela(x, y, texto)
  WFXDrawText(
    FONTE, 
	x, -- top
	y, -- left
	0, -- right
	0, -- bottom
	ARGB(255,0,255,68), -- cor
	texto --texto
  ) 
end

function frame_de_atualizacao()
  mostrar_na_tela(10, 20, "Working")
end

function playerlist(t)
-- Check "gameroom_join" packet
	for i = 1, #t do
		if (t[i].n == "gameroom_join") then
			--WFXPrint(string.format("Game Room Join\n\n"))	
			Looby = false
		end
	end

-- Check "gameroom_leave" packet
	for i = 1, #t do
		if (t[i].n == "gameroom_leave") then
			--WFXPrint(string.format("Game Room Leave\n\n"))
			Looby = true
		end
	end	

-- Check "gameroom_on_kicked" packet
	for i = 1, #t do
		if (t[i].n == "gameroom_on_kicked") then
			--WFXPrint(string.format("Game Room Join\n\n"))	
			Looby = true
		end
	end

-- find 'online_id' of current gameroom players in "gameroom_sync" packet
	for i = 1, #t do
		if (t[i].n == "gameroom_sync") then
			local on_id2 = t[i].t
			if on_id2 then
				for j = 1, #on_id2 do
					if on_id2[j].n == "bcast_receivers" then
						bcast_id = on_id2[j].val
						WFXPrint(string.format("R ID --> %s", on_id2[j].val))

					end
				end
			end
		end
	end

-- find 'online_id' of current players in "players" packet
	for i = 1, #t do
		if (t[i].n == "player") then
			local on_id2 = t[i].t
			if on_id2 then
				for j = 1, #on_id2 do
					if on_id2[j].n == "online_id" then
						player_id = on_id2[j].val
						WFXPrint(string.format("ALL ID --> %s", on_id2[j].val))
					end
				end
			end
		end
	end

					-- Check IDs if they are the same get info
							if (bcast_id == player_id) then

-- find 'class_id' of current players in "player" packet
	for i = 1, #t do
		local node = t[i - 1]
			if(node) and Looby == false then
				for j=1, #node.t do
					if (node.t[j].n == "class_id") then
						WFXPrint(string.format("Classe --> %s \n", node.t[j].val))
						class_id = node.t[j].val
					end
				end
			end
		--
	end

-- find 'profile_id' of current players in "player" packet
	for i = 1, #t do
		local node = t[i - 1]
			if(node) and Looby == false then
				for j=1, #node.t do
					if (node.t[j].n == "profile_id") then
						WFXPrint(string.format("Profile ID --> %s \n", node.t[j].val))
						profile_id = node.t[j].val
					end
				end
			end
		--
	end

-- find 'nickname' of current players in "player" packet
	for i = 1, #t do
		local node = t[i - 1]
			if(node) and Looby == false then
				for j=1, #node.t do
					if (node.t[j].n == "nickname") then
						WFXPrint(string.format("Nick --> %s \n", node.t[j].val))
						nickname = node.t[j].val
					end
				end
			end
		--
	end	
						end
end


-- find packets
function list_attributes(t)
  local i = #t
  while (i > 0) do
    local nome = t[i].n
	local valor = t[i].val
    WFXPrint(string.format("--> %s == '%s'", nome, valor))
	i = i - 1
  end
end

function list_nodes(t)
  local i = #t
  while (i > 0) do
    local nome = t[i].n
	if nome == "game_room" then
	  WFXPrint(string.format("'%s'", nome))
	  list_attributes(t[i].t)	
	end
	i = i - 1
  end
end

function recvdata(t)
  --list_nodes(t)
	playerlist(t)
end

WFXRegisterEvent(WFX_EVENTID_DRAW, "frame_de_atualizacao")
WFXRegisterEvent(WFX_EVENTID_RECV_DATA, "recvdata")