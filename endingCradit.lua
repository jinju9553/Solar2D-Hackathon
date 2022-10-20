-----------------------------------------------------------------------------------------
--
-- view1.lua
--
-----------------------------------------------------------------------------------------

local widget = require( "widget" )
local composer = require( "composer" )
local scene = composer.newScene()

function scene:create( event )
	local sceneGroup = self.view
	soundBGM(5)

	local UI = display.newGroup()

	local UI_x = display.contentWidth/2
	local UI_y = display.contentHeight/2
	local deltaY = 200

	local overText = display.newText(UI, "두근두근 양갱이의 붕어빵가게",UI_x, UI_y, G.fontBold, 130)
	UI_y  = UI_y + deltaY*5
	local g1 = display.newText(UI, "| Producer |", UI_x, UI_y, G.fontLight, 70)
	UI_y  = UI_y + deltaY
	local n1 = display.newText(UI, " 팥트라슈 ", UI_x, UI_y, G.fontLight, 80)
	UI_y  = UI_y + deltaY*3
	local g2 = display.newText(UI, "| Programmer |", UI_x, UI_y, G.fontLight, 70)
	UI_y  = UI_y + deltaY*2
	local n2 = display.newText(UI, "  Kim Ji Yeon\nLee Do Hyeon\n   Lee Jin Ju\n    Heo Ji ye\n", UI_x, UI_y, G.fontLight, 80)
	UI_y  = UI_y + deltaY*3
	local g3 = display.newText(UI, "| Designer & BGM |", UI_x, UI_y, G.fontLight, 70)
	UI_y  = UI_y + deltaY
	local n3 = display.newText(UI, "Yu Hee Jin", UI_x, UI_y, G.fontLight, 80)
	UI_y  = UI_y + deltaY*3
	local g4 = display.newText(UI, "| Thanks to |", UI_x, UI_y, G.fontLight, 70)
	UI_y  = UI_y + deltaY
	local n4 = display.newText(UI, "Yang Gang", UI_x, UI_y, G.fontLight, 80)
	-- all objects must be added to group (e.g. self.view)
	--sceneGroup:insert( background )
	--sceneGroup:insert( title )

	sceneGroup:insert(UI)

	local function gotoStart(  )

		composer.removeScene( "endCradit" )
	    composer.gotoScene("start")
	end
	local sec = 2
   local function Counter(event)
      sec = sec - 1 -- 1초씩 감소

      if(sec == 0)then
         print("시간 종료")
         --timer.cancel(event.source) 
            transition.moveTo(UI, {
					y = UI_y - deltaY * 45,
					time = 13400,
					onComplete = gotoStart})
	     --메인 화면으로 돌아감
      end
   end
   local time = timer.performWithDelay(1000, Counter, sec)

end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen
	elseif phase == "did" then
		-- Called when the scene is now on screen
		-- 
		-- INSERT code here to make the scene come alive
		-- e.g. start timers, begin animation, play audio, etc.
	end	
end

function scene:hide( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if event.phase == "will" then
		-- Called when the scene is on screen and is about to move off screen
		--
		-- INSERT code here to pause the scene
		-- e.g. stop timers, stop animation, unload sounds, etc.)
	elseif phase == "did" then
		-- Called when the scene is now off screen
	end
end

function scene:destroy( event )
	local sceneGroup = self.view
	
	-- Called prior to the removal of scene's "view" (sceneGroup)
	-- 
	-- INSERT code here to cleanup the scene
	-- e.g. remove display objects, remove touch listeners, save state, etc.
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene