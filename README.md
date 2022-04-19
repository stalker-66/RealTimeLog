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
		["plugin.realtimelog"] 	= get_narkoz_plugin("realtimelog"),
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
> `String`. User ID for logging. Default is `Device ID` - ***system.getInfo( "deviceID" )*** [Solar2D API](https://docs.coronalabs.com/api/library/system/getInfo.html). <br/>
> * **timeUpdate** (optional) <br/>
> `Number`. The delay in updating the log by the plugin in milliseconds. Default is `250` ms. <br/>
> * **clearOldSession** (optional) <br/>
> `Boolean`. Clearing the log on a new session. Default is `false`. <br/>
> * **offlineLog** (optional) <br/>
> `Boolean`. Saving the log to a file. If the app was closed before all logs were sent, a next launch of the app will resume sending old logs. Default is `false`. <br/>
> * **debug** (optional) <br/>
> `Boolean`. Includes additional debugging information for the plugin. Default is `false`. <br/>

> Calling this function clears the log.
> ```lua
> realtimelog.clear()
> ```

> Plugin stop. After calling this function, initialization is required to work with the plugin.
> ```lua
> realtimelog.stop()
> ```
## Usage
## Extras
> The ***print*** function now supports output lua tables. <br/>
> `Example:` <br/>
> ```lua
> local items = {
> 	{ id = "orange", count = 2, quality = "legend" },
> 	{ id = "banana", count = 8, quality = "legend" },
> 	{ id = "coconut", count = 14, quality = "legend" },
> }
> print( items )
> ```
> `Output:` <br/>
> ```json
>   [{
>     "id":"orange",
>     "count":2,
>     "quality":"legend"
>   },{
>     "id":"banana",
>     "count":8,
>     "quality":"legend"
>   },{
>     "id":"coconut",
>     "count":14,
>     "quality":"legend"
>   }]
> ```

> You can generate a **unique id** from your ***mask***. Plugin initialization is optional.
> ```lua
> local uniqueId = realtimelog.getUnic(mask)
> ```
> * **mask** (optional) <br/>
> `String`. The mask by which a unique identifier will be generated. Default is `"xxxx-xxxx-xxxx"`. <br/>
> 
> `Example:` <br/>
> ```lua
> local uniqueId = realtimelog.getUnic("xx-xx-xxxxxx-xx-xx")
> print( uniqueId )
> ```
> `Output:` <br/>
> ```lua
>   "b8-40-1522f7-10-06"
> ```
## Example
See more - [Solar2dExample](https://github.com/stalker-66/RealTimeLog/tree/main/Solar2dExample)
## Support
stalker66.production@gmail.com
