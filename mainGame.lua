-----------------------------------------------------------------------------------------
--
-- view1.lua
--
-----------------------------------------------------------------------------------------

-- 전역 변수 ☆ 수정 완료 ☆
-- 종류마다 30개는 있어야 클리어 안정권 
G.cream = 30 
G.redBean = 30
G.money = 1000

local widget = require("widget")
local composer = require( "composer" )
local scene = composer.newScene()

function scene:create( event )
	local sceneGroup = self.view
	soundBGM(2)
	
	local background = display.newImageRect("icon/bg.png", display.contentWidth, display.contentHeight)
	background.x, background.y = display.contentWidth/2, display.contentHeight/2

	local function backButtonEvent( event )
		soundPlay(7)
		print("뒤로 가기")
		-- 왜 안되지
		resetG()
		composer.removeScene("mainGame", true)
		--composer.hideOverlay("mainGame")
		composer.gotoScene("start")
	end

	local UI = display.newGroup()
	-- 뒤로 가기 버튼
	local backButton = widget.newButton( { defaultFile = "icon/back.png", 
	width = contentWidth, height = contentHeight, overFile = "icon/backDown.png", onRelease = backButtonEvent } )
	backButton.x, backButton.y = backButton.x + 75, backButton.y + 50
	UI:insert(backButton)

	-- 가판대
	local stand = display.newImageRect(UI, "icon/sale.png", 677, 1080)
	stand.x, stand.y = display.contentWidth/2 - 250, display.contentHeight/2

	-- 붕어빵 팬 배경
	local pan_bg = display.newImageRect(UI, "icon/pan_bg.png", 550*1.5, 670*1.5)
	pan_bg.x, pan_bg.y = 1485, 570

	-- 말풍선
	local balloon = display.newImageRect(UI, "icon/balloon.png", 677, 1080)
	balloon.x, balloon.y = display.contentWidth/2 - 250, display.contentHeight/2 + 65

	-- 쓰레기통 메뉴
	local trashCan = display.newImageRect(UI, "icon/trash.png", 200, 200)
	trashCan.x, trashCan.y = display.contentWidth/2, display.contentHeight - 150

	-- 스코어 (금액)
	local Score = display.newText(UI, "/ Money: "..G.money , display.contentWidth - 180, display.contentHeight/10 - 65, G.fontLight, 40)
	--Score.text = "/ Money: "..G.money

	-- 메뉴 버튼이 눌리면 실행될 이벤트 --
	local selectedFlag = 0
	local function buttonEvent( event )
		soundPlay( 7 )
		if event.target.name == "dough" then
			selectedFlag = 1
			print("반죽 선택됨, flag: "..selectedFlag)
		elseif event.target.name == "chou" then
			selectedFlag = 2
			print("슈크림 선택됨, flag: "..selectedFlag)
		elseif event.target.name == "redbean" then
			selectedFlag = 3
			print("팥앙금 선택됨, flag: "..selectedFlag)
		elseif event.target.name == "flip" then
			selectedFlag = 4
			print("뒤집기 선택됨, flag: "..selectedFlag)
		end
	end

	-- 버튼 배치 -- 
	local buttons = {}
	local buttonGroup = display.newGroup()

	for i = 1, 4 do
		buttons[i] = widget.newButton( { defaultFile = "icon/button.png", width = 200, height = 200, overFile = "icon/buttonDown.png", onRelease = buttonEvent } )
		buttons[i].x, buttons[i].y = buttons[i].x + 90, buttons[i].y - 50 + (i * 212.5) -- 위치 조정
		UI:insert(buttons[i])
	end
	buttons[1].name = "dough"
	buttons[2].name = "chou"
	buttons[3].name = "redbean"
	buttons[4].name = "flip"

	local doughIcon = display.newImageRect(UI, "icon/doughIcon.png", 150, 150)
	doughIcon.x, doughIcon.y = buttons[1].x, buttons[1].y
	local creamIcon = display.newImageRect(UI, "icon/creamIcon.png", 150, 150)
	creamIcon.x, creamIcon.y = buttons[2].x, buttons[2].y
	local redbeanIcon = display.newImageRect(UI, "icon/redbeanIcon.png", 150, 150)
	redbeanIcon.x, redbeanIcon.y = buttons[3].x, buttons[3].y
	local stickIcon = display.newImageRect(UI, "icon/stickIcon.png", 150, 150)
	stickIcon.x, stickIcon.y = buttons[4].x, buttons[4].y

	-- 필링 개수 표시
	local cream_quantity = display.newText(UI, G.cream , buttons[2].x + 60, buttons[2].y + 65, G.fontLight, 40)
	local redBean_quantity = display.newText(UI, G.redBean , buttons[3].x + 60, buttons[3].y + 65, G.fontLight, 40)

	-- 팬이 눌리면 실행될 이벤트 -- 
	local fillingId = "none" -- 유저가 만든 붕어빵이 주문과 일치하는지 체크
	local function panEvent( event ) -- 반죽을 부을 때마다 붕어빵 인스턴스 생성
		if selectedFlag == 1 then -- 반죽
			createFish(event.target.name) 
		elseif selectedFlag == 2 then -- 슈크림
			print("슈크림을 선택")
			fillingId = fillingFish(event.target.name, buttons[2].name) -- 팬의 넘버를 붕어빵 넘버로 넘겨준다. 
		elseif selectedFlag == 3 then -- 팥앙금
			print("팥앙금을 선택")
			fillingId = fillingFish(event.target.name, buttons[3].name) -- 팬의 넘버를 붕어빵 넘버로 넘겨준다. 
		elseif selectedFlag == 4 then -- 뒤집기
			print("붕어빵을 뒤집음. Id는 "..fillingId) 
			flipingFish(event.target.name, fillingId) -- 붕어의 상태와 필링을 넘겨준다.
		end
	end

	-- 시작 처리 하면서 이 주문 출력 함수도 타이머와 동시에 호출(Start())
	local orders = {} -- 그룹은 만들지 않음
	local orderText
	local order_required
	local fish_required
	local showOrder

	orders[1] = "chouFilling" -- 드래그 앤 드롭에서 비교할 String
	orders[2] = "redbeanFilling"

	local customers -- 손님 
	function rotateOrder() -- 새 주문 로테이션
		soundPlay(6)
		local num = math.random(1, 4)
		customers = display.newImageRect(UI, "icon/custom"..num..".png", 322, 288)
		customers.x, customers.y = display.contentWidth/2 - 253, display.contentHeight/2 + 142
		order_required = orders[math.random(1, 2)] -- 나중에 드래그 앤 드롭에서 비교하기 위해서 담아둠
		fish_required = math.random(2, 8) -- 나중에 드래그 앤 드롭에서 이만큼의 개수를 채웠는지 체크
		if(order_required == orders[1]) then
			orderText = "슈크림 붕어빵\n "..fish_required.."개 주세요."
		else
			orderText = "  팥 붕어빵\n "..fish_required.."개 주세요."
		end
		showOrder = display.newText(UI, orderText, display.contentWidth/2 - 245, display.contentHeight/2 - 220, G.fontLight, 75)
		showOrder:setFillColor(0)
	end

	rotateOrder()

	-- addEventListener 구문보다 위에 선언되어 있어야 한다. 
	-- 붕어빵 드래그 앤 드롭 파트
	local fish_served = 0
	local sec
	local function dragAndDrop( event )
		if ( event.phase == "began" ) then
	        display.getCurrentStage():setFocus( event.target )
	        event.target.xStart = event.target.x
	        event.target.yStart = event.target.y

	        event.target:toFront() -- 팬 말고 붕어빵이 우선적으로 선택됨
	        
	    	event.target.isFocus = true
	 	elseif ( event.phase == "moved" ) then
	 		event.target:toFront()
	        if ( event.target.isFocus ) then
	        	event.target.x = event.target.xStart + event.xDelta
	        	event.target.y = event.target.yStart + event.yDelta
	        end
	    elseif (event.phase == "ended") then
	    	if ( event.target.isFocus ) then
	    		if event.target.x < customers.x + 200 and event.target.x > customers.x - 200 -- 손님에게 드래그 하였다면 
	    			and event.target.y < customers.y + 200 and event.target.y > customers.y - 200 then
	    			print("이벤트 타겟 삭제") -- ☆ 수정 했습니다! if문 만 건드렸습니다.

					-- 손님에게 지급된 붕어빵 개수를 하나씩 추가,
	  				-- 알맞은 개수가 지급되면 다음 손님으로 로테이트
	  				-- 단, 종류가 맞아야지만 점수가 올라간다.
	    			if event.target.name == "burnt" then
	    				soundPlay(13)
	    				print("타버린 붕어빵을 건넴(시간 5초 감소)")
	    				sec = sec - 5
	    			elseif event.target.name == "right" and
	    				fillingId == order_required then
	    				soundPlay( 9 )
	    				print("알맞는 붕어빵을 건넴")
	    				fish_served = fish_served + 1
	    				print("제공한 붕어빵: "..fish_served.."개")
	    				print("남은 붕어빵: "..(fish_required - fish_served).."개")
	    			else
	    				soundPlay( 13 )
	    				print("붕어빵 종류가 맞지 않거나 아직 익지 않음")
	    				print("제공한 붕어빵: "..fillingId..", 필요한 붕어빵: "..order_required)
	    				print("남은 붕어빵: "..(fish_required - fish_served).."개")
	    			end

	    			event.target.name = "none" -- 상태 초기화
	    			display.remove(event.target)
	    			event.target:addEventListener("touch", dragAndDrop)

					if fish_served == fish_required then
						soundPlay( 5 )
						print("성공")
						G.money = G.money + 100 * fish_required
						Score.text = "/ Money: "..G.money
						fish_served = 0
						display.remove(showOrder)
						rotateOrder()
					end
				elseif event.target.x < trashCan.x + 200 and event.target.x > trashCan.x - 200 
	    			and event.target.y < trashCan.y + 200 and event.target.y > trashCan.y - 200 
	    			and event.target.name == "burnt" then
	    				soundPlay(13)
	    				print("탄 붕어빵을 버렸음")
	    				event.target.name = "none" -- 상태 초기화
	    				display.remove(event.target)
	    				event.target:addEventListener("touch", dragAndDrop)
				else -- 그 외의 공간에 드래그 하였다면
					-- event.target:toFront() -- 의미가 있는지? 
					event.target.x = event.target.xStart
					event.target.y = event.target.yStart
	    		end
            	display.getCurrentStage():setFocus( nil )
        		event.target.isFocus = false
	        end
	        display.getCurrentStage():setFocus( nil )
	        event.target.isFocus = false
	    end
	end

	-- 붕어빵 생성 -- 
	local fishes = {} -- 붕어빵 인스턴스를 담을 배열
	local fillings = {} -- 붕어빵 속 인스턴스를 담을 배열
	local fishGroup = display.newGroup()

	-- 팬 배치 -- 
	local pans = {}
	local panGroup = display.newGroup()
	local panX, panY

	for i = 1, 8 do
		pans[i] = display.newImageRect( UI, "icon/pan.png", 372, 247)
		pans[i]:addEventListener("tap", panEvent)
		pans[i].x, pans[i].y = pans[i].x + 1300, pans[i].y + (i * 225) + 15 -- 위치 조정
		pans[i].name = i

		panX, panY = pans[1].x, pans[1].y
		if (i >= 5) then 
			pans[i].x, pans[i].y = panX + 375, panY + ((i - 5) * 225) -- 위치 조정
		end
		fishes[i] = display.newImageRect(UI, "icon/fish_opa0.png", display.contentWidth/5, display.contentHeight/5)
		fishes[i].x, fishes[i].y = pans[i].x, pans[i].y
		fishes[i].name = "none"
	end

	function createFish( num )
		-- 눌린 팬의 name(==index)을 파라미터로 받아와야 한다.
		if fishes[num].name == "none" then
			print("반죽을 부음: "..num.."번째 팬")
			fishes[num] = display.newImageRect(UI, "icon/doughfish.png", display.contentWidth/5, display.contentHeight/5)
			fishes[num].x, fishes[num].y = pans[num].x, pans[num].y
			fishes[num].name = "rare"
			burnCount(num)
		end
	end

	function changeFilling( num, filling )
		if fishes[num].name ~= "none" then
			print("[changeFilling] 선택된 필링: "..filling)
			print("[changeFilling] 선택된 붕어빵: "..num)
			if filling == "chou" and G.cream > 0 then
				soundPlay( 4 )
				G.cream = G.cream - 1
				cream_quantity.text = G.cream
				fillings[num] = display.newImageRect(UI, "icon/cream2.png", display.contentWidth/6, display.contentHeight/6)
				fillingId = "chouFilling"
				fillings[num].x, fillings[num].y = pans[num].x, pans[num].y + 5
				fishes[num].name = "filled"
				print(filling.." 필링을 넣었음. id는 "..fillingId)
			elseif filling == "redbean" and G.redBean > 0 then
				soundPlay( 4 )
				G.redBean = G.redBean - 1
				redBean_quantity.text = G.redBean
				fillings[num] = display.newImageRect(UI, "icon/redbean2.png", display.contentWidth/6, display.contentHeight/6)
				fillingId = "redbeanFilling"
				fillings[num].x, fillings[num].y = pans[num].x, pans[num].y + 5
				fishes[num].name = "filled"
				print(filling.." 필링을 넣었음. id는 "..fillingId)
			else
				print("속재료가 부족함")
			end
		end
		return fillingId
	end

	local flipSec = {}
	function burnCount( num, filling ) -- 각 붕어마다 시간이 인스턴스로 관리되어야 함
		flipSec[num] = 20 -- 원하는 만큼의 초(sec)를 대입합니다.
		local function flipCounter(event)
			flipSec[num] = flipSec[num] - 1 -- 1초씩 감소
			-- print(num.."번 붕어빵 카운트: "..flipSec[num])

			-- 중복되는 코드 통일 ==> init 함수 작성하면 좋을듯
			if (fishes[num].name == "fliped") then -- fliped 상태에만 익는다.
				if (flipSec[num] < 10) then
					print("붕어빵이 알맞게 익음")
					timer.cancel(event.source) -- 이상하게도 딜레이 때문에 -6초나 되어서야 멈춤. 전체 동작에는 이상 없음. 
					display.remove(fillings[num])
					display.remove(fishes[num])
					fishes[num] = display.newImageRect(UI, "icon/rightfish.png", display.contentWidth/5, display.contentHeight/5)
					fishes[num].name = "right"
					fishes[num]:addEventListener("touch", dragAndDrop) -- if문 밖으로 꺼내면 이상하게도 null 오류가 뜸. 어쩔 수 없이 안에 넣는 것으로
				end
			end

			if(fishes[num].name ~= "none") then -- 비어 있을 때에는 동작 X 
				if(flipSec[num] == 0) then 
					soundPlay( 13 )
					print("붕어빵이 타버렸음")
					timer.cancel(event.source) -- 타이머 중지
					display.remove(fillings[num])
					display.remove(fishes[num]) 
					fishes[num] = display.newImageRect(UI, "icon/deadfish.png", display.contentWidth/5, display.contentHeight/5)
					fishes[num].name = "burnt"
					fishes[num]:addEventListener("touch", dragAndDrop)
				end
			end
			fishes[num].x, fishes[num].y = pans[num].x, pans[num].y
		end
		local time = timer.performWithDelay(1000, flipCounter, flipSec[num])
	end

	function flipingFish( num, filling )
		if fishes[num].name == "filled" then
			soundPlay( 11 )
			display.remove(fillings[num])
			display.remove(fishes[num])
			fishes[num] = display.newImageRect(UI, "icon/rarefish.png", display.contentWidth/5, display.contentHeight/5)
			fishes[num].x, fishes[num].y = pans[num].x, pans[num].y
			fishes[num].name = "fliped"
			fishes[num].id = filling -- 다시 지정
			print("id는 "..fishes[num].id)
			fishes[num]:addEventListener("touch", dragAndDrop)
			-- 카운트 시작
			print("[flipingFish] 카운트 시작")
			burnCount(num, filling)
		elseif fishes[num].name == "fliped" then -- 속을 안 넣었다면 뒤집지 않는다.
			soundPlay( 11 )
			print("[flipingFish] 카운트 초기화")
			burnCount(num, filling)
		end
	end

	function fillingFish( num, filling ) -- 팬 넘버와 필링 종류를 받아온다. 
		print("[fillingFish] "..num.."번째 칸이 선택됨")
		if fishes[num].name == "rare" then 
			fillingId = changeFilling(num, filling) -- 슈크림과 팥 따로따로 이미지 생성
		elseif fishes[num].name == "filled" then
			print("이미 필링이 있음")
		elseif fishes[num].name == "fliped" then
			print("이미 뒤집힘")
		elseif fishes[num].name == "none" then
			print("반죽을 붓지 않았음")
		end
		return fillingId
	end

	--타이머 ==> 시작 버튼을 눌러야만 동작했으면 좋겠음(startTimer로 감싸기) or 시작 버튼 있는 씬을 따로 만들기
	sec = 120
	local leftTime = display.newText(UI, "Time: 120" , display.contentWidth/2 + 545, display.contentHeight/10 - 65, G.fontLight, 40)
	leftTime:toFront()
	leftTime:setFillColor(1)
	local function Counter(event)
		sec = sec - 1

		if (sec == 10) then
			soundPlay2(8)
		end

		if (sec == 0) then
			soundPlay( 10 )
			print("시간 종료")
			timer.cancelAll() -- 원래 쓰던 것은 timer.cancel(event.source)
			if G.money >= 4000 then -- 클리어
				G.index = 3
			else -- 실패
				G.index = 2
			end
			composer.gotoScene("story") 
		end
		leftTime.text = "Time: "..sec
	end
	local time = timer.performWithDelay(1000, Counter, 120)

	--타임바
	local timeBar_bg = display.newImageRect(UI, "icon/timeBar_bg.png", 1040, 60)
	timeBar_bg.x, timeBar_bg.y = display.contentWidth/2 - 70, 40
	local timeBar = display.newRect(UI, 0, 50, 960, 20)
	timeBar.x, timeBar.y = display.contentWidth/2 - 70, 40
	timeBar:setFillColor(1, 0.3, 0.5)

	local function loseTime (event)
		timeBar.x = timeBar.x - 0.2 -- 타이머 바 고정
		timeBar.width = timeBar.width - 0.4 
		if (sec == 10) then
			timeBar:setFillColor(1, 0, 0)
		end
	end
	gameTimer = timer.performWithDelay(50, loseTime, 0)

	-- main 끝
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