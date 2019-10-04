local menuTrack
local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local json = require("json") --Data base for high scores
local scoresTable = {}
local filePath = system.pathForFile("scores.json", system.DocumentsDirectory)


local function loadScores()

    local file = io.open(filePath, "r")
    if file then
        local contents = file:read("*a")
        io.close(file)
        scoresTable = json.decode(contents)
    end

    if (scoresTable == nil or #scoresTable == 0) then
        scoresTable = {0, 0, 0, 0, 0}
    end

end


local function saveScores()

    for i = #scoresTable, 11, -1 do
        table.remove(scoresTable, i)
    end

    local file = io.open(filePath, "w")

    if file then
        file:write(json.encode(scoresTable))
        io.close(file)
    end

end


local function gotoMenu()
    composer.gotoScene( "menu", { time=800, effect="crossFade" } )
end


-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------


-- create()
function scene:create( event )

    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen
    loadScores()

    table.insert( scoresTable, composer.getVariable( "finalScore" ) )
    composer.setVariable( "finalScore", 0 )

    -- Sort the table entries from highest to lowest
    local function compare( a, b )
        return a > b
    end
    table.sort( scoresTable, compare )
    saveScores()

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

    local highScoresHeader = display.newText( sceneGroup, "High Scores", display.contentCenterX, 100, "1", 60 )
    for i = 1, 5 do
        if ( scoresTable[i] ) then
            local yPos = 150 + ( i * 56 )
            local rankNum = display.newText( sceneGroup, i .. ")", 30, yPos, "2", 50 )
            rankNum:setFillColor( 0.8 )
            rankNum.anchorX = 1

            local thisScore = display.newText( sceneGroup, scoresTable[i], 50, yPos, "2", 50 )
            thisScore.anchorX = 0
        end
    end
    local menuButton = display.newText( sceneGroup, "Menu", display.contentCenterX, 710, "1", 60 )
    menuButton:setFillColor( 0.75, 0.78, 1 )
    menuButton:addEventListener( "tap", gotoMenu )
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
        audio.play( menuTrack, { channel = 3, loops=-1 } )
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
        composer.removeScene( "highscores" )
        audio.stop( 3 )
    end
end


-- destroy()
function scene:destroy( event )

    local sceneGroup = self.view
    -- Code here runs prior to the removal of scene's view
    audio.dispose( menuTrack )
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
