local menuTrack
local composer = require( "composer" )

local physics = require "physics"
physics.start()
physics.setGravity(0, 0)

local scene = composer.newScene()

local function gotoGame()
    composer.gotoScene( "game", {time == 800, effect == "crossFade"} )
end

local function gotoHighScores()
    composer.gotoScene( "highscores", {time == 800, effect == "crossFade"} )
end

function scene:create( event )

    local sceneGroup = self.view

    hx = -200
    hy = 0
    for i = 1, 10 do
        for i = 1, 10 do
            local myBack = display.newImageRect(sceneGroup, "blue.png", 256, 256)
            myBack.x = hx
            myBack.y = hy
            hx = hx + 256
        end
        hy = hy + 256
        hx = -200
    end

    local wall1 = display.newImageRect(sceneGroup, "png/wall1.png", 256, 256)
    wall1.x = 50
    wall1.y = 0

    local wall11 = display.newImageRect(sceneGroup, "png/wall1.png", 128, 128)
    wall11.x = wall1.x + 200
    wall11.y = 0

    local wall2 = display.newImageRect(sceneGroup, "png/wall2.png", 256, 256)
    wall2.x = display.contentWidth - 100
    wall2.y = 800

    local wall3 = display.newImageRect(sceneGroup, "png/wall3.png", 256, 256)
    wall3.x = display.contentCenterX
    wall3.y = display.contentCenterY + 40

    local title = display.newText( sceneGroup, "Through Space", display.contentCenterX, 700, "1", 100 )
    title.x = display.contentCenterX
    title.y = 200
    title:setFillColor(110 / 255, 155 / 255, 1)

    local playButton = display.newText( sceneGroup, "Play", display.contentCenterX, 630, "2", 70 )
    playButton:setFillColor( 0.82, 0.86, 1 )

    local highScoresButton = display.newText( sceneGroup, "High Scores", display.contentCenterX, 700, "2", 44 )
    highScoresButton:setFillColor( 171 / 255, 197 / 255, 1)

    playButton:addEventListener("tap", gotoGame)
    highScoresButton:addEventListener("tap", gotoHighScores)
    menuTrack = audio.loadStream("audio/menu.mp3")
end


-- show()
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
    -- Code here runs when the scene is still off screen (but is about to come on screen)

    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
        audio.play( menuTrack, { channel = 1, loops = -1 } )
    end
end


-- hide()
function scene:hide( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
    -- Code here runs when the scene is on screen (but is about to go off screen)

    elseif ( phase == "did" ) then
        -- Code here runs immediately after the scene goes entirely off screen
        audio.stop( 1 )
    end
end


-- destroy()
function scene:destroy( event )

    local sceneGroup = self.view
    -- Code here runs prior to the removal of scene's view
    display.remove(wall3)
	audio.dispose(menuTrack)
end


-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------

return scene
