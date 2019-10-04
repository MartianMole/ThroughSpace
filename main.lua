--Trough Space
--Creator: Zakharov Daniil
--Date: 1 August, 2018

local composer = require("composer")

display.setStatusBar(display.HiddenStatusBar)

math.randomseed(os.time())

audio.reserveChannels( 1 )
audio.setVolume( 0.3, { channel = 1 } )

audio.reserveChannels( 2 )
audio.setVolume( 0.3, { channel = 2 } )

audio.reserveChannels( 3 )
audio.setVolume( 0.3, { channel = 3 } )

composer.gotoScene("menu")
