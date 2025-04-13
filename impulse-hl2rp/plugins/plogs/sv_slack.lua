-- This file contains private info, do NOT publicise.

local types = {
	["chat"] = "https://hooks.slack.com/services/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",--"https://hooks.slack.com/services/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",
	["death"] = "https://hooks.slack.com/services/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" --"https://hooks.slack.com/services/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"
}

function plogsSlackLog(type, message)
	local isPreview = GetConVar("impulse_ispreview"):GetBool()

	if isPreview then
		return	
	end

	local post = {
		text = message
	}

	local struct = {
		failed = function(error) MsgC(Color(255,0,0), "Impulse Slack log error: "..error) end,
		method = "post",
		url = types[type],
		body = util.TableToJSON(post),
		type = "application/json"
	}

	HTTP(struct)
end

local pastebin = "bsUBB5VlSR5ecNh_RQCIv4u9mYmG6RrI"

function plogsPastebinUpload(msg)
	local post = {
		["api_dev_key"] = "bsUBB5VlSR5ecNh_RQCIv4u9mYmG6RrI",
		["api_paste_code"] = msg,
		["api_option"] = "paste",
		["api_user_key"] = "",
		["api_paste_format"] = "json"
	}
	local struct = {
		failed = function(error) MsgC(Color(255,0,0), "Impulse Pastebin log error: "..error) end,
		success = function(a,b,c) 
			plogsSlackLog("death","Snapshot Download: " .. b)
		end,
		method = "post",
		url = "https://pastebin.com/api/api_post.php",--?".."api_dev_key=bsUBB5VlSR5ecNh_RQCIv4u9mYmG6RrI",
		parameters = post,
		body = util.TableToJSON(post,true),
		type = "application/json"
	}

	local resp = HTTP(struct)
	MsgC(Color(0,255,0,255),tostring(resp))

end