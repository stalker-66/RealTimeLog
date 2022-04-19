# RealTimeLog
## Overview
The "RealTimeLog" plugin allows you to remotely debug an application built on the Solar2d engine in Google Spreadsheets.
## Project Settings
To use this plugin, add an entry into the plugins table of ***build.settings***.
```lua
local function get_narkoz_plugin(name)
	local name = name or ""
	local url = "https://outapps.info/codework/get_plug_solar2d.php"
	local plugin = {publisherId = 'com.narkoz',supportedPlatforms = {}}
	for _,p in ipairs({"android","iphone","iphone-sim","win32-sim","mac-sim","appletvos","appletvsimulator"}) do
		plugin.supportedPlatforms[p] = {url = url.."?name="..name.."&platform="..p}
	end

	return plugin
end

settings = 
{
	android =
	{
		usesPermissions =
		{
			"android.permission.INTERNET",
			"android.permission.WRITE_EXTERNAL_STORAGE",
		},
	},

	plugins = {
		["plugin.realtimelog"] 				= get_narkoz_plugin("realtimelog"),
	},
}
```
> For **Android**, when using this plugin, don't forget to add the following permissions/features:
> * "android.permission.INTERNET"
> * "android.permission.WRITE_EXTERNAL_STORAGE"
## Require
```lua
local realtimelog = require "plugin.realtimelog"
```
## Functions
> Initializes the **realtimelog** plugin. This call is required and must be executed before making other **realtimelog** calls.
> ```lua
> realtimelog.init(params)
> ```
> The ***params*** table includes parameters for **realtimelog** initialization. <br/>
> * **deploymentID** (required) <br/>
> `String`. Your Deployment ID. See more - [How to get Deployment ID](https://github.com/stalker-66/RealTimeLog/blob/87fbaddbe90e5688e710bcd2040e7bfd80627f17/Docs/How%20to%20get%20Deployment%20ID.md). <br/>
> * **userID** (optional) <br/>
> `String`.
## Additionally
## Example
See more - [Solar2dExample](https://github.com/stalker-66/RealTimeLog/tree/main/Solar2dExample)
## Support
stalker66.production@gmail.com
