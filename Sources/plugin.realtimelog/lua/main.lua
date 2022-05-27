-- Sample app for the RealTimeLog plugin for Solar2D
-- Documentation: https://github.com/stalker-66/RealTimeLog/

local realtimelog = require "plugin.realtimelog"

realtimelog.init({
	deploymentID = "AKfycbzANJkZPtiWyHem-iBZ7N5-JAVmahEt5IHE_-le_0PfTFHM6enCHVt-IYE4sCrzs0yqwQ",
	clearOldSession = true,
	offlineLog = false,
	debug = true,
})

-- title --
local title = display.newText{
	text = "Real Time Log Plugin",
	fontSize = display.contentHeight*.05
}
title.x = display.contentWidth*.5
title.y = display.contentHeight*.18

local auth = display.newText{
	text = "by narkoz",
	fontSize = display.contentHeight*.025
}
auth.x = title.x+title.width*.5-auth.width*.5
auth.y = title.y+title.height*.5+auth.height*.5
auth:setFillColor(1,0,0)

-- buttons --
local widget = require  "widget"
local size = display.contentWidth*.6


local clear = widget.newButton(
	{
		shape = "roundedRect",
		width = size,
		height = size*.2,
		cornerRadius = size*.05,
		label = "Clear Log",
		fontSize = size*.08,
		fillColor = { default={1,0,0,1}, over={1,0.1,0.7,0.4} },
		labelColor = { default={ 1, 1, 1 }, over={ 0, 0, 0, 0.5 } },
		onRelease  = function()
			realtimelog.clear()
		end
	}
)
clear.x = display.contentWidth*.5
clear.y = display.contentHeight*.5-clear.height*.5

local send_info = widget.newButton(
	{
		shape = "roundedRect",
		width = size,
		height = size*.2,
		cornerRadius = size*.05,
		label = "Send \"Info\" Message",
		fontSize = size*.08,
		fillColor = { default={1,0,0,1}, over={1,0.1,0.7,0.4} },
		labelColor = { default={ 1, 1, 1 }, over={ 0, 0, 0, 0.5 } },
		onRelease  = function()
			print( "@type=Info@My message about Info" )
		end
	}
)
send_info.x = display.contentWidth*.5
send_info.y = clear.y+clear.height*.5+send_info.height

local send_warning = widget.newButton(
	{
		shape = "roundedRect",
		width = size,
		height = size*.2,
		cornerRadius = size*.05,
		label = "Send \"Warning\" Message",
		fontSize = size*.08,
		fillColor = { default={1,0,0,1}, over={1,0.1,0.7,0.4} },
		labelColor = { default={ 1, 1, 1 }, over={ 0, 0, 0, 0.5 } },
		onRelease  = function()
			print( "@type=Warning@My message about Warning" )
		end
	}
)
send_warning.x = display.contentWidth*.5
send_warning.y = send_info.y+send_info.height*.5+send_warning.height

local send_error = widget.newButton(
	{
		shape = "roundedRect",
		width = size,
		height = size*.2,
		cornerRadius = size*.05,
		label = "Send \"Error\" Message",
		fontSize = size*.08,
		fillColor = { default={1,0,0,1}, over={1,0.1,0.7,0.4} },
		labelColor = { default={ 1, 1, 1 }, over={ 0, 0, 0, 0.5 } },
		onRelease  = function()
			print( "@type=Error@My message about Error" )
		end
	}
)
send_error.x = display.contentWidth*.5
send_error.y = send_warning.y+send_warning.height*.5+send_error.height

local send_table = widget.newButton(
	{
		shape = "roundedRect",
		width = size,
		height = size*.2,
		cornerRadius = size*.05,
		label = "Send table in message",
		fontSize = size*.08,
		fillColor = { default={1,0,0,1}, over={1,0.1,0.7,0.4} },
		labelColor = { default={ 1, 1, 1 }, over={ 0, 0, 0, 0.5 } },
		onRelease  = function()
			local list = {
				name = "John Doe",
				items = {
					{ id = "orange", count = 2, quality = "legend" },
					{ id = "banana", count = 8, quality = "legend" },
					{ id = "coconut", count = 14, quality = "legend" },
				}
			}

			print( "@type=Warning@",list )
		end
	}
)
send_table.x = display.contentWidth*.5
send_table.y = send_error.y+send_error.height*.5+send_table.height