function Initialize()
	sJSONParser = SELF:GetOption('JSONParser')
	sFileToRead = SELF:GetOption('FileToRead')
	
	--load the external JSON library
	JSON = assert(loadfile(sJSONParser))()
    JSON.strictTypes = true
end

function Update()
	--Create oldSongInfo if it doesn't exist
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
	local FileContents = File:read("*all")
	File:close()
	
	--Convert JSON to lua table and set meters
		nowPlaying_info = JSON:decode(FileContents)
	SKIN:Bang('!SetVariable', 'Playing', tostring(nowPlaying_info.playing))
	if nowPlaying_info ~= nill then
		if nowPlaying_info.playing then
			if oldSongInfo == nil or oldSongInfo.title ~= nowPlaying_info.song.title then
				if SKIN:GetMeter(SKIN:GetVariable("MeterTitleName")) ~= nil then
					SKIN:GetMeter(SKIN:GetVariable("MeterTitleName")):SetText(nowPlaying_info.song.title)
				end
				
				if SKIN:GetMeter(SKIN:GetVariable("MeterArtistName")) ~= nil then
					SKIN:GetMeter(SKIN:GetVariable("MeterArtistName")):SetText(nowPlaying_info.song.artist)
				end
			end
			SKIN:Bang('!SetVariable', 'Length', nowPlaying_info.time.current / nowPlaying_info.time.total)
			oldSongInfo = nowPlaying_info.song
		end
	end
end