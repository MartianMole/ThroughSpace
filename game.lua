system.activate( "multitouch" )
local composer = require( "composer" )

local scene = composer.newScene()

local physics = require "physics"
physics.start()
physics.setGravity(0, 0)
local widget = require("widget")
local myButton
local lives = 3
local score = 0
local died = false

local wallTable = {}
local placeTable = {}

local enemy1
local enemy2
local enemy3
local enemy4

local minusOne

local enemyLaser2
local enemyLaser3

local ship

local enemyStrelLoopTimer
local enemyFasLoopTimer
local gameLoopTimer

local livesText
local scoreText

local backGroup
local mainGroup
local uiGroup

--button
local fire

--audio
local musicTrack
local lose
local shipFireSound



local function createWall()

    local whichWall = math.random(1, 4)
    local size = math.random(100, 240)

    if(whichWall == 1) then
        local wallOne = display.newImageRect(mainGroup, "png/wall1.png", size, size)
        wallOne.x = display.contentWidth + 400
        wallOne.y = 0
        physics.addBody(wallOne, "dynamic", {radius = size / 2, bounce = 0.8})
        wallOne.myName = "wall"
        wallOne:setLinearVelocity(-200, 0)
        table.insert(wallTable, wallOne)

    elseif(whichWall == 2) then
        wallTwo = display.newImageRect(mainGroup, "png/wall2.png", size, size)
        wallTwo.x = display.contentWidth + 400
        wallTwo.y = 0
        physics.addBody(wallTwo, "dynamic", {radius = size / 2, bounce = 0.8})
        wallTwo.myName = "wall"
        wallTwo:setLinearVelocity(-200, 0)
        table.insert(wallTable, wallTwo)

    elseif(whichWall == 3) then
        wallThree = display.newImageRect(mainGroup, "png/wall3.png", size, size)
        wallThree.x = display.contentWidth + 400
        wallThree.y = display.contentHeight
        physics.addBody(wallThree, "dynamic", {radius = size / 2, bounce = 0.8})
        wallThree.myName = "wall"
        wallThree:setLinearVelocity(-200, 0)
        table.insert(wallTable, wallThree)

    else
        wallFour = display.newImageRect(mainGroup, "png/wall4.png", size, size)
        wallFour.x = display.contentWidth + 400
        wallFour.y = display.contentHeight
        physics.addBody(wallFour, "dynamic", {radius = size / 2, bounce = 0.8})
        wallFour.myName = "wall"
        wallFour:setLinearVelocity(-200, 0)
        table.insert(wallTable, wallFour)

    end

end



local yy --enemy position



local function createEnemy2Laser()
    local newEnemyLaser = display.newImageRect("png/enemyLaser2.png", 20, 7)
    physics.addBody(newEnemyLaser, "dynamic", {isSensor = true})
    newEnemyLaser.isBullet = true
    newEnemyLaser.myName = "wall"

    newEnemyLaser.x = enemy2.x
    newEnemyLaser.y = enemy2.y
    audio.play(enemyLaser)
    transition.to(newEnemyLaser, {x = -300, time = 600, onComplete = function() display.remove(newEnemyLaser) end})

end



local function createEnemy3Laser()
    local newEnemyLaser = display.newImageRect("png/enemyLaser3.png", 20, 7)
    physics.addBody(newEnemyLaser, "dynamic", {isSensor = true})
    newEnemyLaser.isBullet = true
    newEnemyLaser.myName = "wall"

    newEnemyLaser.x = enemy3.x
    newEnemyLaser.y = enemy3.y

    transition.to(newEnemyLaser, {x = -300, time = 600, onComplete = function() display.remove(newEnemyLaser) end})
end



local function createStrelEnemy()

    local strelEnemy = math.random(1, 2)
    local placeStrelEnemy = math.random(3)

    if(placeStrelEnemy == 1) then
        yy = display.contentHeight / 3
    elseif(placeStrelEnemy == 2) then
        yy = display.contentCenterY
    else
        yy = display.contentHeight - display.contentHeight / 3
    end
    if(strelEnemy == 1) then
        enemy2 = display.newImageRect(mainGroup, "png/enemy2.png", 75, 100)
        enemy2.x = display.contentWidth + 300
        enemy2.y = yy
        enemy2.myName = "enemy"
        physics.addBody(enemy2, "dynamic", {radius = 50})
        transition.to(enemy2, {x = display.contentWidth - 100, time = 500 })

        if(enemy2) then
            timer.performWithDelay(1000, createEnemy2Laser, 5)
        end

    else
        enemy3 = display.newImageRect(mainGroup, "png/enemy3.png", 75, 100)
        enemy3.x = display.contentWidth + 300
        enemy3.y = yy
        enemy3.myName = "enemy"
        physics.addBody(enemy3, "dynamic", {radius = 50})
        transition.to(enemy3, {x = display.contentWidth - 100, time = math.random(100, 1000) })

        if(enemy3) then
            timer.performWithDelay(1000, createEnemy3Laser, 5)
        end

    end

end



local function createFastEnemy()
    local whichFastEnemy = math.random(2)
    local placeFastEnemy = math.random(3)

    if(placeFastEnemy == 1) then
        yy = display.contentHeight / 3

    elseif(placeFastEnemy == 2) then
        yy = display.contentCenterY

    else
        yy = display.contentHeight - display.contentHeight / 3

    end

    if(whichFastEnemy  == 1) then
        enemy1 = display.newImageRect(mainGroup, "png/enemy1.png", 75, 100)
        enemy1.x = display.contentWidth + 300
        enemy1.y = yy
        physics.addBody(enemy1, "dynamic", {radius = 50})
        transition.to(enemy1, {x = -400, time = math.random(1000, 3000) })
        enemy1.myName = "fastEnemy"

    else
        enemy4 = display.newImageRect(mainGroup, "png/enemy4.png", 75, 100)
        enemy4.x = display.contentWidth + 300
        enemy4.y = yy
        physics.addBody(enemy4, "dynamic", {radius = 50})
        transition.to(enemy4, {x = -400, time = math.random(1000, 3000) })
        enemy4.myName = "fastEnemy"

    end

end



local function dragShip(event)

    local ship = event.target
    local phase = event.phase

    if ("began" == phase and event.x < display.contentCenterX) then
        display.currentStage:setFocus(ship)
        ship.touchOffsetY = event.y - ship.y

    elseif ("moved" == phase) then
        ship.y = event.y - ship.touchOffsetY

    elseif ("ended" == phase or "cancelled" == phase) then
        display.currentStage:setFocus(nil)
    end

    return true

end



local function gameLoop()

    createWall()
    for i = #wallTable, 1, -1 do
        local thisWall = wallTable[i]
        if(thisWall.x < -300) then
            display.remove(thisWall)
            table.remove(wallTable, i)
        end
    end

end



local function restoreShip()

    ship.isBodyActive = false
    ship.x = 70
    ship.y = display.contentCenterY
    display.remove(minusOne)

    transition.to(ship, {alpha = 1, time = 4000,
        onComplete = function()
            ship.isBodyActive = true
            died = false
        end
    })

end



local function endGame()

    composer.setVariable("finalScore", score)
    composer.gotoScene( "menu", { time=800, effect="crossFade" } )

end



local function onCollision(event)

    if(event.phase == "began") then

        local obj1 = event.object1
        local obj2 = event.object2

        if((obj1.myName == "shipLaser" and obj2.myName == "enemy") or
            (obj1.myName == "enemy" and obj2.myName == "shipLaser") or
            (obj1.myName == "fastEnemy" and obj2.myName == "shipLaser") or
            (obj1.myName == "shipLaser" and obj2.myName == "fastEnemy")) then
            score = score + 10
            scoreText.text = score
            if(obj1.myName == "fastEnemy" or obj1.myName == "enemy") then
                local effect = display.newImageRect("png/effect.png", 25, 25)
                effect.x = obj1.x
                effect.y = obj1.y
                transition.to(effect, {width = 50, height = 50, time = 500,
                    onComplete = function() display.remove(effect) end
                })
            elseif (obj2.myName == "fastEnemy" or obj2.myName == "enemy") then
                local effect = display.newImageRect("png/effect.png", 25, 25)
                effect.x = obj2.x
                effect.y = obj2.y
                transition.to(effect, {width = 50, height = 50, time = 500,
                    onComplete = function() display.remove(effect) end
                })
            end
            display.remove(obj1)
            display.remove(obj2)

        end

        if ((obj1.myName == "ship" and obj2.myName == "wall" ) or
            (obj1.myName == "wall" and obj2.myName == "ship" )or
            (obj1.myName == "ship" and obj2.myName == "fastEnemy") or
            (obj1.myName == "fastEnemy" and obj2.myName == "ship"))
        then
            if(died == false) then
                died = true
                audio.play( lose )
                lives = lives - 1
                livesText.text = "Lives: " .. lives

                if(lives == 0) then
                    display.remove( ship )
                    display.remove(fire)
                    timer.performWithDelay( 2000, endGame )
                else
                    ship.alpha = 0
                    timer.performWithDelay(1000, restoreShip)
                end
            end
        end

    end
end



function scene:create( event )

    local sceneGroup = self.view

    physics.pause()

    backGroup = display.newGroup()
    sceneGroup:insert(backGroup)

    mainGroup = display.newGroup()
    sceneGroup:insert(mainGroup)

    uiGroup = display.newGroup()
    sceneGroup:insert(uiGroup)

    local hx = -200
    local hy = 0
    for i = 1, 10 do
        for i = 1, 10 do
            local myBack = display.newImageRect(backGroup, "blue.png", 256, 256)
            myBack.x = hx
            myBack.y = hy
            hx = hx + 256
        end
        hy = hy + 256
        hx = -200
    end

    ship = display.newImageRect( mainGroup, "png/ship.png", 85, 100 )
    ship.x = 70
    ship.y = display.contentCenterY
    physics.addBody( ship, { radius = 60, isSensor = true } )
    ship.myName = "ship"

    fire = widget.newButton{
        shape = 'circle',
        radius = 70,
        x = display.contentWidth - 40,
        y = display.contentHeight - display.contentHeight  / 5,
        strokeWidth = 5,
        strokeColor = { default = { 1, 1, 1, 0.5 }, over = { 1, 1, 1, 0.3 } },
        fillColor = { default = { 1, 1, 1, 0.3 }, over = { 1, 1, 1, 0.1 } },

        onPress = function(event)
            audio.play( shipFireSound )

            local newLaser = display.newImageRect(mainGroup, "png/shipLaser.png", 35, 7)
            physics.addBody(newLaser, "dynamic", {isSensor = true})
            newLaser.isBullet = true
            newLaser.myName = "shipLaser"

            newLaser.x = ship.x
            newLaser.y = ship.y
            newLaser:toBack()

            transition.to(newLaser, {x = display.contentWidth + 300, time = 500,
                onComplete = function() display.remove(newLaser) end
            })
        end
    }


    livesText = display.newText( uiGroup, "Lives: " .. lives, 200, 80, "1", 45 )
    scoreText = display.newText( uiGroup, score, display.contentWidth - 10, 80, "1", 45 )

    ship:addEventListener( "touch", dragShip )

    lose = audio.loadSound("audio/lose.ogg")
    shipFireSound = audio.loadSound("audio/laser1.ogg")
    enemyLaser = audio.loadSound("audio/laser2.ogg")
    musicTrack = audio.loadStream( "audio/music.mp3")
end



function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then

    elseif ( phase == "did" ) then
        physics.start()
        Runtime:addEventListener( "collision", onCollision )
        gameLoopTimer = timer.performWithDelay( 1000, gameLoop, 0)
        enemyStrelLoopTimer = timer.performWithDelay(math.random(1000, 2000), createStrelEnemy, 0)
        enemyFastLoopTimer = timer.performWithDelay(math.random(2000, 3000), createFastEnemy, 0)
        audio.play( musicTrack, { channel = 2, loops = -1 } )

    end
end



function scene:hide( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        timer.cancel( gameLoopTimer )
        timer.cancel(enemyStrelLoopTimer)
        timer.cancel(enemyFastLoopTimer)
    elseif ( phase == "did" ) then
        Runtime:removeEventListener( "collision", onCollision )

        physics.pause()
        audio.stop( 2 )
        composer.removeScene( "game" )
    end
end



function scene:destroy( event )

    local sceneGroup = self.view
    audio.dispose( shipFireSound )
    audio.dispose( lose )
    audio.dispose( enemyLaser )
    audio.dispose( musicTrack )
end

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene
