local diarys = {}

addEvent("onServerGetDiarys", true)
addEventHandler("onServerGetDiarys", root, function(theTable)
	diarys = theTable
	outputChatBox("Empfang diarys.. :)")
	outputChatBox("- - - - - - - - - - - - - - - - - - -")
	for _, diary in ipairs(diarys) do
		for i, page in ipairs(diary) do
			outputConsole("Page [" .. i .. "] name: " .. page.name)
			outputConsole(page.text)
		end
	end
end)