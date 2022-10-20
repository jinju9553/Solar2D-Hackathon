-----------------------------------------------------------------------------------------
--
-- view1.lua
--
-----------------------------------------------------------------------------------------

local widget = require( "widget" )
local composer = require( "composer" )
local scene = composer.newScene()


--

-- 뒤로가기 누를 때 씬 이동 함수
local function exit( )
	soundPlay( 7 )
	FishStart = 0
	for i = 1, 3 do
		is_bait = 0
	end
	composer.removeScene("fishing")
	composer.gotoScene("mainGame")
end


is_bait = {}

FishStart = 0

local UIGroup = display.newGroup()



function scene:create( event )
	local sceneGroup = self.view
	soundBGM( 3 )
	FishStart = 0
	for i = 1, 3 do
		is_bait[i] = 0
	end

	local fishUI = {}
	fishUI[0] = display.newRect(display.contentWidth/2, display.contentHeight/2, display.contentWidth,display.contentHeight)
	fishUI[0]:setFillColor(0.5,0.7,0.8)
	sceneGroup:insert(fishUI[0])
	fishUI[1] = display.newImage(UIGroup, "icon/backgroundfishing.png")
	fishUI[1].x, fishUI[1].y = display.contentWidth*0.5, display.contentHeight*0.5
	fishUI[2] = display.newRoundedRect(UIGroup, display.contentWidth*0.85, display.contentHeight*0.25, 450, 300, 80)
	fishUI[2].alpha = 0.2
	fishUI[3] = display.newImageRect(UIGroup, "icon/patboong2.png", 200, 150)
	fishUI[3].x, fishUI[3].y = fishUI[2].x-100, fishUI[2].y-60
	fishUI[4] = display.newImageRect(UIGroup, "icon/syuboong2.png", 200, 150)
	fishUI[4].x, fishUI[4].y = fishUI[2].x-100, fishUI[2].y+60

	local back = widget.newButton( 
		{
			defaultFile = "icon/back.png",  
			overFile = "icon/back2.png",
			width = 300*1.5, height = 120*1.5,
			onRelease = eixt
		} 
	)
	back.x, back.y = 300, 150
	UIGroup:insert(back)



	back:addEventListener("tap", exit)

	sceneGroup:insert(UIGroup)

	composer.showOverlay("fishing_setting", options)
end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase



	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen

	elseif phase == "did" and FishStart == 1 then
		local showRedBeanNum = display.newText(UIGroup, G.redBean, display.contentWidth*0.85+100, display.contentHeight*0.25 - 60,
		G.fontBold, 60)
		local showCreamNum = display.newText(UIGroup, G.cream, display.contentWidth*0.85+100, display.contentHeight*0.25 + 60,
		G.fontBold, 60)

		local cat = display.newImageRect(UIGroup, "icon/cats2.png", 500, 500)
		cat.x, cat.y = display.contentWidth*0.6, display.contentHeight*0.4
		local happyCat = display.newImageRect(UIGroup, "icon/cats2_happy.png", 500, 500)
		happyCat.x, happyCat.y = display.contentWidth*0.6, display.contentHeight*0.4
		happyCat.alpha = 0


		fishingRodX, fishingRodY = cat.x-240, cat.y+70

		FS_StartX = fishingRodX + 330/2
		FS_StartY = fishingRodY- 320/2
		FS_defaultX,FS_defaultY = FS_StartX-55, display.contentHeight*0.6
		
		local fishingString = display.newLine(UIGroup, FS_StartX, FS_StartY, FS_defaultX, FS_defaultY)
		fishingString.strokeWidth = 5
		fishingString:setStrokeColor( 0 )

		local fishingHook = display.newImageRect(UIGroup, "icon/galgori.png", 150, 150)
		fishingHook.x, fishingHook.y = FS_defaultX-16, FS_defaultY + 50
		local fishGroup = display.newGroup()
		local fishNum = 30
		local fishToRight = {} -- 15
		local fishToLeft = {} -- 15

		-- 0~1920
		local waterXstart = -1000
		local waterXend = 3000
		local waterYstart = 760
		local waterYend = display.contentHeight - 50

		if is_bait[1] == 1 then
			fishNum = fishNum*2
		end

		print("현재 물고기 수: "..fishNum)

		for i = 1, fishNum/2 do
			fishToRight[i] = display.newImage(fishGroup, "icon/boong2.png")
			fishToRight[i].x = math.random(waterXstart, waterXend)
			fishToRight[i].y = math.random(waterYstart, waterYend)
			fishToRight[i]:setFillColor(0)
			fishToRight[i].alpha = 0

			fishToLeft[i] = display.newImage(fishGroup, "icon/boong.png")
			fishToLeft[i].x = math.random(waterXstart, waterXend)
			fishToLeft[i].y = math.random(waterYstart, waterYend)
			fishToLeft[i]:setFillColor(0)
			fishToLeft[i].alpha = 0
		end

		sceneGroup:insert(fishGroup)
		-- 정렬
		UIGroup:toFront()

		--- 물고기 이동 ----------------------

		local function fishFade( fish )
			if fishNum < 5 then
				if math.random(10) < 3 then
					transition.fadeIn(fish, { time = 1500 })
				else
					transition.fadeOut(fish, { time = 1000 })
				end	
			elseif fishNum < 20 then
				if math.random(fishNum) < 5 then
					transition.fadeIn(fish, { time = 1500 })
				else
					transition.fadeOut(fish, { time = 1000 })
				end
			else
				if math.random(30) < 5 then
					transition.fadeIn(fish, { time = 1500 })
				else
					transition.fadeOut(fish, { time = 1000 })
				end
			end
			return 1000
		end

		local function fishRotate( fish )
			local function rotate( ... )
				fish.rotation = math.random(-3, 3)	
			end
			 transition.to( fish, { time = 30, onStart = rotate( ), onComplete = 
		         function( )
		                transition.to( fish, { time = 30, onStart = rotate( ), onComplete = fishRotate( fish ) } )
		         end 
	        })
		end

		local function move1( fish )
			local function moveToRight( )
				local speed = fishFade( fish )
				if fish.x >= waterXend then
					fish.x = waterXstart
				end
				local fishX = fish.x
				transition.moveTo(fish, {
					x = fish.x + math.random(200, 1000),
					y = fish.y,
					time = speed
				})

			end

	       	transition.to( fish, { time = 1000, onStart = moveToRight( ), onComplete = 
	             	function( )
	                        transition.to( fish, { time = 1000, onStart = moveToRight( ), onComplete = move1( fish ) } )
	                end 
	        })
		end

		local function move2( fish )
			local function moveToLeft( )
				local speed = fishFade( fish )
				if fish.x <= waterXstart then
					fish.x = waterXend
				end
				local fishX = fish.x
				transition.moveTo(fish, {
					x = fish.x - math.random(200, 1000),
					y = fish.y,
					time = speed
				})

			end

	       	transition.to( fish, { time = 1000, onStart = moveToLeft( ), onComplete = 
	             	function( )
	                        transition.to( fish, { time = 1000, onStart = moveToLeft( ), onComplete = move2( fish ) } )
	                end 
	        })
		end

		for i = 1, fishNum/2 do
			move1( fishToRight[i] )
			fishRotate( fishToRight[i] )
			move2( fishToLeft[i] )
			fishRotate( fishToLeft[i] )
		end

		--낚시----------------------------------
		print("그떡: "..is_bait[1].." 팥떡: ".. is_bait[2].. " 슈떡: "..is_bait[3])
		print("낚시 시작!")

		local function happy( )
			transition.fadeOut(cat, { time = 200})
			transition.fadeIn(happyCat, { time = 200})
		   --타이머
		   local sec = 1-- 원하는 만큼의 초(sec)를 대입합니다.
		   local function Counter(event)
		      sec = sec - 1 -- 1초씩 감소
		      if(sec == 0)then
		         print("시간 종료")
		         timer.cancel(event.source) -- 타이머 중지 
		         -- 이 아래에 시간이 종료되면 할 작업들을 적어줍니다.
					transition.fadeIn(cat, { time = 200})
					transition.fadeOut(happyCat, { time = 200})
		      end
		   end
		   local time = timer.performWithDelay(1000, Counter, sec) -- Counter 리스너 연결, 1초씩 시간이 줄어듭니다.
		end

		------------------------------------
		local function getFish( fish )
			transition.fadeOut(fish, { time = 1000, onComplete  = 
				function( )
	             			display.remove(fish)
	            end })
			local result
			local ran = math.random(10)
			fishNum = fishNum-1

			if math.random(3) < 2 then
				result = display.newImage("icon/boong.png")
				result.x, result.y = cat.x - 150, cat.y - 150
				result.alpha = 0.8
				result.rotation = 105
				print("그붕 획득!")
			else
				if math.random(3) <= 2 and is_bait[2] == 1 then
					happy( )
					result = display.newImage("icon/patboong.png")
					result.x, result.y = cat.x - 150, cat.y -150
					result.alpha = 0.8
					result.rotation = 105
					soundPlay( 9 )
					print("팥붕 획득!")
					G.redBean = G.redBean + 1
					showRedBeanNum.text = G.redBean
				elseif math.random(3) <= 2 and is_bait[3] == 1 then
					happy( )
					result = display.newImage("icon/syuboong.png")
					result.x, result.y = cat.x - 150, cat.y-150
					result.alpha = 0.8
					result.rotation = 105
					soundPlay( 9 )
					print("슈붕 획득!")
					G.cream = G.cream + 1
					showCreamNum.text = G.cream
				else
					result = display.newImage("icon/boong.png")
					result.x, result.y = cat.x - 150, cat.y-150
					result.alpha = 0.8
					result.rotation = 105
					print("그붕 획득!")
				end
			end
			transition.fadeOut(result, { time = 1000, onComplete  = 
				function( )
	             			display.remove(result)
	            end })
			print("현재 가진 갯수: 팥붕 "..G.redBean.."개 슈붕 "..G.cream.."개")
			print("현재 연못에 있는 물고기 수: ".. fishNum.."\n")
		end

		local function catch( event )
			if event.target.alpha > 0.5 then
				soundPlay( 7 )
				soundPlay2( 4 )
				
				transition.pause(event.target)
				event.target.alpha = 0
				fishingString.alpha = 0

				local catchGroup = display.newGroup()

				local hook = display.newImage("icon/fish_opa0.png")
				hook.x, hook.y = event.target.x, event.target.y
				hook:setFillColor(0)
				transition.fadeOut(hook, { time = 500 })
				sceneGroup:insert(hook)

				local fish = display.newImage("icon/boong.png")
				fish.x, fish.y = event.target.x-100, event.target.y+100
				fish:setFillColor(0)
				fish.alpha = 0.8
				fish.rotation = 105

				fishingHook.x, fishingHook.y = event.target.x, event.target.y

				local strGroup = display.newGroup()
				local i = 1
				local str = {}
				str[i] = display.newLine(strGroup, FS_StartX, FS_StartY, event.target.x, event.target.y -50)
				str[i].strokeWidth = 5
				str[i]:setStrokeColor( 0 )

				local function strPull( )
					if event.target.x - FS_defaultX < 10 and event.target.x - FS_defaultX > -10 then
						event.target.x = FS_defaultX
					elseif event.target.x < FS_defaultX then
						event.target.x = event.target.x + 10
					elseif event.target.x > FS_defaultX then
						event.target.x = event.target.x - 10
					end
					if event.target.y - FS_defaultY < 5 and event.target.y - FS_defaultY > -5 then
						event.target.y = FS_defaultY
					elseif	event.target.y < FS_defaultY then
						event.target.y = event.target.y + 5
					elseif event.target.y > FS_defaultY then
						event.target.y = event.target.y - 5
					end

					local function move(  )
						str[i].alpha = 0
						i = i + 1
						str[i] = display.newLine(strGroup, FS_StartX, FS_StartY, event.target.x, event.target.y)
						str[i].strokeWidth = 5
						str[i]:setStrokeColor( 0 )
						fish.x, fish.y = event.target.x-40, event.target.y+200
						fishingHook.x, fishingHook.y = event.target.x-16, event.target.y + 50
					end
					transition.to( str[i], { time = 1, onStart = move( ), onComplete = 
	             	function( )
	             			if event.target.x == FS_defaultX and event.target.y == FS_defaultY then
	             				display.remove(strGroup)
	             				display.remove(event.target)
	             				fishingString.alpha = 1
	             				getFish( fish )
	             				return 0
	             			else
	                        	transition.to( str[i], { time = 1, onComplete = strPull( ) } )
	                		end
	                end 
	       			})
				end

				strPull( )
			end
		end

		for i = 1, fishNum/2 do
			fishToRight[i]:addEventListener("tap", catch)
			fishToLeft[i]:addEventListener("tap", catch)
		end
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