local diarys = {}

function getDiarys()
	local sql = mysql_query(cmysql, "SELECT * FROM `diarys`")
	if sql then
		local diarysData = mysql_fetch_assoc(sql)
		while (diarysData) do
			if not diarys[tonumber(diarysData["diary"])] then diarys[tonumber(diarysData["diary"])] = {} end
			if not diarys[tonumber(diarysData["diary"])][tonumber(diarysData["page"])] then diarys[tonumber(diarysData["diary"])][tonumber(diarysData["page"])] = {} end
			diarys[tonumber(diarysData["diary"])][tonumber(diarysData["page"])].name = diarysData["name"]
			diarys[tonumber(diarysData["diary"])][tonumber(diarysData["page"])].text = diarysData["text"]
			diarysData = mysql_fetch_assoc(sql)
		end
		mysql_free_result(sql)
	else
		outputDebugString("Mysql Error (" .. mysql_errno(cmysql) .. "):" .. mysql_error(cmysql), 1)
	end
	
	triggerEvent("onServerGetDiarys", resRoot)
end
addEventHandler("onResourceStart", resRoot, getDiarys)