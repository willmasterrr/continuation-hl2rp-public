require("reqwest")

function ReqwestLog(embeddedmessages, webhook)
    reqwest({
        method = "POST",
        url = webhook or "", -- Put your discord webhook here
        timeout = 30,
        body = util.TableToJSON({ embeds = embeddedmessages }),

        headers = {
            ["User-Agent"] = "Your Server Name", 
            ["Content-Type"] = "application/json",  -- Explicitly set Content-Type to JSON
        },

        failed = function(error, errExt) 
            MsgC(Color(255,0,0), "impulse discord log error: "..error.. " - " ..errExt) 
        end,
        success = function(status, body, headers) 
            -- print(status) 
            -- print(headers) 
            -- print(body) 
        end
    })
end

local embedMessage = {
    {
        description = "Server Refresh!",
        color = 16711680, -- Red color (in decimal)
    }
}

ReqwestLog(embedMessage)
