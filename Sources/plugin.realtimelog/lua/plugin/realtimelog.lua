-- init
local publisherId = "com.narkoz"
local pluginName = "realtimelog"

local public = require "CoronaLibrary":new{ name=pluginName, publisherId=publisherId }

-- add modules/optimization
local mime = require "mime"
local mime_b64 = mime.b64
local mime_unb64 = mime.unb64
local json = require "json"
local json_prettify = json.prettify
local json_decode = json.decode
local json_encode = json.encode
local table_remove = table.remove
local string_find = string.find
local string_match = string.match
local string_gsub = string.gsub
local string_len = string.len
local string_sub = string.sub
local string_format = string.format
local math_random = math.random
local math_floor = math.floor
local os_time = os.time
local os_date = os.date
local _print = print

-- private
local private = {
	init = false,
	list = {},
	order = true,
	typeList = {
		["Info"] = 0,
		["Warning"] = 1,
		["Error"] = 2,
		["NewSession"] = 3,
	}
}

private.update = function()
	if not private.init then return false end

	if #private.list>0 and private.order then
		private.order = false

		local def_date = os_date("%x").." "..os_date("%X")
		local messageList = {}
		local index = 0
		for i=1,500 do
			local msg = private.list[i]
			if msg then
				local msgDate = def_date
				local msgType = "Info"
				local msgText = msg

				if string_find(msgText, "@type=") then
					msgType = string_match(msgText,"@type=(.-)@")
					msgText = string_gsub(msgText,"@type="..msgType.."@","")
				end

				
				if string_find(msgText, "@date=") then
					msgDate = string_match(msgText,"@date=(.-)@")
					msgText = string_gsub(msgText,"@date="..msgDate.."@","")
				end

				messageList[#messageList+1] = {
					msgDate = msgDate,
					msgType = private.typeList[msgType] and private.typeList[msgType] or 0,
					msgText = mime_b64(msgText)
				}

				index = index+1
			end
		end

		local bodyList = {
			userId = private.userId,
			platform = private.platform,
			messages = json_encode(messageList),
		}
		local body = private.tableToStr(bodyList)
		local request = network.request(private.url, "POST", function(e)
			if private.debug then
				_print( "RealTimeLog: Response - ", json_prettify(e) )
			end
			if e.isError or e.status~=200 then
				if private.debug then
					_print( "RealTimeLog: Log sending error. There is no internet connection or the server is unavailable.", json_prettify(e) )
				end
			else
				for i=index,1,-1 do
					if private.list[i] then
						table_remove(private.list,i)
					end
				end

				if private.offlineLog then
					private.save()
				end
			end
			private.order = true
		end, {
			headers = {
				["Content-Type"] = "application/x-www-form-urlencoded",
			},
			body = body,
		})
	end
end

private.save = function()
	if not private.init then return false end
	local delta = os_time()-private.oldSaveTime
	
	if delta>1 then
		private.oldSaveTime = os_time()
		
		local path = system.pathForFile( "realtimelog"..private.userId, system.DocumentsDirectory )
		local file, errorString = io.open( path, "w" )

		if not file then
		else
			file:write( json_encode( private.list ) )
			io.close( file )
		end
	end
end

private.load = function()
	if not private.init then return false end

	local path = system.pathForFile( "realtimelog"..private.userId, system.DocumentsDirectory )
	local file, errorString = io.open( path, "r" )

	if not file then
		private.list = {}
	else
		local contents = file:read( "*a" )
		private.list = json_decode( contents )
		io.close( file )
	end
end

private.parsePrint = function(...)
	local str = ""
	local args = {...}
	if #args>0 then
		for i=1,#args do
			local v = args[i]
			if type(v)=="table" then
				v = json_prettify(v)
			end
			if i==1 then
				str = tostring(v)
			else
				str = str..' '..tostring(v)
			end
		end
	end
	return str
end

private.tableToStr = function(params)
	local res,sp = "","&"
	for k,v in pairs(params) do
		if type(v) == "boolean" then
			v = v and "true" or "false"
		end
		res = res .. sp .. k .. "=" .. v
	end
	res = res:gsub("+", "%%2B")	
	return res
end

-- public
public.init = function(p)
	if private.init then return false end

	local p = p or {}
	if p.deploymentID==nil then
		if private.debug then
			_print( "RealTimeLog: Incorrect Deployment ID. The plugin stops working." )
		end
		return false
	end
	p.userID = p.userID or system.getInfo( "deviceID" )
	p.timeUpdate = p.timeUpdate or 250
	p.clearOldSession = p.clearOldSession
	p.offlineLog = p.offlineLog
	p.debug = p.debug

	private.time = timer.performWithDelay( p.timeUpdate, private.update, 0 )
	private.url = "https://script.google.com/macros/s/"..p.deploymentID.."/exec"
	private.userId = p.userID
	private.debug = p.debug
	private.offlineLog = p.offlineLog
	private.platform = system.getInfo("platform").." "..system.getInfo("platformVersion")
	private.oldSaveTime = os_time()
	private.init = true

	if p.clearOldSession then
		public.clear()
	else
		private.update()
	end

	-- global --
	_G.printEvents = _G.printEvents or {}
	_G.printEvents[#_G.printEvents+1] = function(str)
		if not private.init then return false end

		if string_len(str)>0 then
			local msgDate = "@date="..os_date("%x").." "..os_date("%X").."@"
			local content = msgDate..str

			-- split text message into chunks
			local length = string_len(content)
			local maxLength = 40000
			if length>maxLength then
				local pos = 1
				local parts = math_floor(length/maxLength)
				local msgType = string_find(content, "@type=") and "@type="..string_match(content,"@type=(.-)@").."@" or ""
				for i=1,parts do
					local idx = maxLength*i
					local msgPart = string_sub(content,pos,idx)
					private.list[#private.list+1] = i==1 and msgPart or msgDate..msgType..msgPart
					pos = idx+1
				end
				private.list[#private.list+1] = msgDate..msgType..string_sub(content,pos,length)
			else
				private.list[#private.list+1] = content
			end
		end

		if private.offlineLog then
			private.save()
		end

		if not private.debug then
			if string_find(str, "@type=") then
				local msgType = string_match(str,"@type=(%w+)@")
				return string_gsub(str,"@type="..msgType.."@","")
			end
		end
	end
	if _G.narkozPrint~=true then
		_G.narkozPrint = true
		print = function(...)
			local str = private.parsePrint(...)
			for i=1,#_G.printEvents do
				local res = _G.printEvents[i](str)
				str = res and res or str
			end
			_print(str)
		end
	end

	if private.debug then
		_print( "RealTimeLog: Initialization success." )
	end

	if private.offlineLog then
		private.load()
	end

	local unic = public.getUnic()
	print("@type=NewSession@RealTimeLog: New session: "..unic..".\nPlatform: "..private.platform..".\nUserId: "..private.userId..".")

	return true
end

public.clear = function()
	if not private.init then return false end

	private.order = false
	private.list = {}

	local bodyList = {
		isClear = true
	}
	local body = private.tableToStr(bodyList)
	local request = network.request(private.url, "POST", function(e)
		if private.debug then
			_print( "RealTimeLog: Response - ", json_prettify(e) )
		end
		if e.isError or e.status~=200 then
			if private.debug then
				_print( "RealTimeLog: Log cleanup error. There is no internet connection or the server is unavailable.", json_prettify(e) )
			end
		else
			if private.debug then
				_print( "RealTimeLog: Log cleared." )
			end
		end
		private.order = true
	end, {
		headers = {
			["Content-Type"] = "application/x-www-form-urlencoded",
		},
		body = body,
	})
end

public.stop = function()
	if not private.init then return false end

	if private.time then
		timer.cancel(private.time)
	end
	private.init = false
	private.order = true
	private.url = nil
	private.userId = nil
	private.debug = nil
	private.offlineLog = nil
	private.platform = nil
	private.oldSaveTime = nil
	private.list = {}
end

public.getUnic = function(mask)
	local mask = mask~=nil and mask or "xxxx-xxxx-xxxx"
	return string_gsub(mask, "[xy]", function(c)
		local v = (c == "x") and math_random(0, 0xf) or math_random(8, 0xb)
		return string_format("%x", v)
	end)
end

return public