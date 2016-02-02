function Initialize()
	sJSONParser = SELF:GetOption('JSONParser')
	sFileToRead = SELF:GetOption('FileToRead')
	JSON = assert(loadfile(sJSONParser))() --load the routines
    JSON.strictTypes = true
end

function Update()

	if oldSongInfo == nill then
		local oldSongInfo
	end
	
	local File = io.open(sFileToRead)
	-- HANDLE ERROR OPENING FILE.
	if not File then
		print('ReadFile: unable to open file at ' .. sFileToRead)
		return
	end

	-- READ FILE CONTENTS AND CLOSE.
	local Contents = File:read("*all")
	File:close()
	
	song_info = JSON:decode(Contents)
	if song_info["isPlaying"] then
		if oldSongInfo == nil or oldSongInfo["song"] ~= song_info["song"] then
			SKIN:GetMeter(SKIN:GetVariable("MeterTitleName")):SetText(song_info["song"])
			SKIN:GetMeter(SKIN:GetVariable("MeterArtistName")):SetText(song_info["artist"])
			SKIN:GetMeter(SKIN:GetVariable("MeterAlbumName")):SetText(song_info["album"])
			SKIN:Bang('!SetVariable', 'CoverUrl', song_info["imageURL"])
			SKIN:Bang('!CommandMeasure', 'MeasureImageDownload', "Update")
		end
		oldSongInfo = song_info
	end
end
