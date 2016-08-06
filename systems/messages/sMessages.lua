local messages = {}

function initialiseMessages()
	messages = {}
	local sql = mysql_query(cmysql, "SELECT * FROM `system_messages`")
	if sql then
		local mD = mysql_fetch_assoc(sql)
		while mD do
			local ID = #messages+1
			messages[ID] = {}
			messages[ID].text = mD["text"]
			
			mD = mysql_fetch_assoc(sql)
		end
		mysql_free_result(sql)
	else
		outputChatBox("Error while get gifts from Database!", root, 255, 0, 0)
		outputDebugString("Mysql Error (" .. mysql_errno(cmysql) .. "):" .. mysql_error(cmysql), 1)
		stopResource(getThisResource())
	end
end
addEventHandler("onResourceStart", resroot, initialiseMessages)

function showRandomMessage()
	local mID = math.random(1, #messages)
	outputChatBox("|Info| #4FE875" .. messages[mID].text, root, 255, 255, 255, true)
end
setTimer(showRandomMessage, 600000, -1)


addCommandHandler("sysMessage", function(pl)
	if g_Admins[pl] then
		initialiseMessages()
		outputChatBox("Message settings refreshed", pl)
	end
end)