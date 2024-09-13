---@diagnostic disable: need-check-nil
local Song = Class:extend()

Song.DEFAULT_SONGNAME = "Unknown"
Song.DEFAULT_ARTIST = "Unknown"
Song.DEFAULT_TIMEFORMAT = 1
Song.DEFAULT_DIVISIONS = nil
Song.DEFAULT_LOOPS = false
Song.DEFAULT_STAGE = "mainStage"
Song.DEFAULT_SCROLLSPEED = 1

function Song:new(id)
    self.id = id

    self.difficulties = {}

    self._data = self:_fetchData(id)

    self._metadata = self._data == nil and {} or {[Constants.DEFAULT_VARIATION] = self._data}

    if self._data ~= nil and self._data.playData ~= nil then
        for _, variation in self._data.playData.variation do
            local variMeta = self:fetchVariationMetadata(id, variation)
            if variMeta then
                self._metadata[variation] = variMeta
            else
                print("No metadata found for variation " .. variation .. " of song " .. id)
            end
        end
    end

    if #self._metadata == 0 then
        print("No metadata found for song " .. id)
    end

    self:populateDifficulties()
end

function Song:populateDifficulties()
    if self._metadata == nil or #self._metadata == 0 then
        return
    end

    for _, metadata in pairs(self._metadata) do
        if metadata == nil or metadata.playData == nil then
            return
        end

        if #metadata.playData.difficulties == 0 then
            error("Song " .. self.id .. " has no difficulties listed in metadata!")
        end

        for _, diffId in ipairs(metadata.playData.difficulties) do
            ---@diagnostic disable-next-line: undefined-global
            local difficulty = SongDifficulty(self, diffId, metadata.variation)

            difficulty.songName = metadata.songName
            difficulty.songArtist = metadata.artist
            difficulty.charter = metadata.charter or Constants.DEFAULT_CHARTER
            difficulty.timeFormat = metadata.timeFormat
            difficulty.divisions = metadata.divisions
            difficulty.timeChanges = metadata.timeChanges
            difficulty.looped = metadata.looped
            difficulty.generatedBy = metadata.generatedBy
            difficulty.offsets = metadata.offsets or SongOffsets()

            difficulty.difficultyRating = metadata.playData.ratings[diffId] or 0
            difficulty.album = metadata.playData.album

            difficulty.stage = metadata.playData.stage
            difficulty.noteStyle = metadata.playData.noteStyle

            difficulty.characters = metadata.playData.characters

            local variationSuffix = metadata.variation ~= Constants.DEFAULT_VARIATION and "-" .. metadata.variation or ""
            self.difficulties[diffId .. variationSuffix] = difficulty
        end
    end
end
  
function Song:getDifficulty(diffId, variation, variations)
    diffId = diffId or self:listDifficulties(variation, variations)[1]
    variation = variation or Constants.DEFAULT_VARIATION
    variations = variations or {variation}

    for _, currentVariation in ipairs(variations) do
        local variationSuffix = currentVariation ~= Constants.DEFAULT_VARIATION and "-" .. currentVariation or ""

        if self.difficulties[diffId .. variationSuffix] then
            return self.difficulties[diffId .. variationSuffix]
        end
    end

    return nil
end
  
function Song:listDifficulties(variation, variations)
    variations = variations or {variation}

    local diffFiltered = {}

    for diffId, difficulty in pairs(self.difficulties) do
        if difficulty == nil then
            diffFiltered[diffId] = nil
        end

        if #variations > 0 and not table.contains(variations, difficulty.variation) then
            diffFiltered[diffId] = nil
        end

        diffFiltered[diffId] = difficulty.difficulty
    end

    diffFiltered = table.filter(diffFiltered, function(diffId)
        for _, targetVariation in ipairs(variations) do
            if self:isDifficultyVisible(diffId, targetVariation) then return true end
        end

        return false
    end)

    table.sort(diffFiltered, function(a, b)
        return a < b
    end)

    return diffFiltered
end

function Song:isDifficultyVisible(diffId, variation)
    local variation = self._metadata[variation]
    if variation == nil then
        return false
    end

    return variation.playData.difficulties[diffId] ~= nil
end

function Song:_fetchData(id)
    local version = SongRegistry:fetchEntryMetadataVersion(id)
    if version == nil then
        return nil
    end
    return SongRegistry:parseEntryMetadataWithMigration(id, Constants.DEFAULT_VARIATION, version)
end

local SongDifficulty = Class:extend()

function SongDifficulty:new(song, difficulty, variation)
    self.song = song
    self.difficulty = difficulty
    self.variation = variation

    self.songName = Song.DEFAULT_SONGNAME
    self.songArtist = Song.DEFAULT_ARTIST
    self.charter = Constants.DEFAULT_CHARTER
    self.timeFormat = Song.DEFAULT_TIMEFORMAT
    self.divisions = Song.DEFAULT_DIVISIONS
    self.timeChanges = {}
    self.looped = Song.DEFAULT_LOOPS
    self.generatedBy = nil
    self.offsets = SongOffsets()

    self.difficultyRating = 0
    self.album = nil

    self.stage = Song.DEFAULT_STAGE
    self.noteStyle = nil

    self.characters = {}
    self.notes = {}
end

function SongDifficulty:clearChart()
    self.notes = {}
end

function SongDifficulty:getStartingBPM()
    if #self.timeChanges == 0 then
        return 0
    end

    return self.timeChanges[1].bpm
end

function SongDifficulty:getInstPath(inst)
    inst = inst or ""
    if self.characters ~= nil then
        if inst ~= "" and table.contains(self.characters.altInstrumentals, inst) then
            local instId = "-" .. inst
            return Paths.inst(self.song.id, instId)
        else
            local instId = self.characters.instrumental ~= "" and "-" .. self.characters.instrumental or ""
            return Paths.inst(self.song.id, instId)
        end
    else
        return Paths.inst(self.song.id)
    end
end

function SongDifficulty:cacheInst(inst)
    inst = inst or ""
    Game.sound.cache(self:getInstPath(inst))
end

function SongDifficulty:playInst(volume, inst, looped)
    volume = volume or 1.0
    inst = inst or ""
    looped = looped or false

    local suffix = inst ~= "" and "-" .. inst or ""
    Game.sound.music = FunkinSound.load(Paths.inst(self.song.id, suffix), volume, looped, function() end, false)

    Game.sound.list:remove(Game.sound.music)
end

function SongDifficulty:cacheVocals()
    for _, voice in ipairs(self:buildVoiceList()) do
        Game.sound.cache(voice)
    end
end

function SongDifficulty:buildVoiceList()
    local suffix = self.variation ~= nil and self.variation ~= "" and self.variation ~= Constants.DEFAULT_VARIATION and "-" .. self.variation or ""

    local playerId = self.characters.player
    local voicePlayer = Paths.voices(self.song.id, "-" .. playerId .. suffix)
    while voicePlayer ~= nil and not love.filesystem.getInfo(voicePlayer) do
        playerId = table.slice(playerId:split("-"), 1, -1):join("-")
        voicePlayer = playerId == "" and nil or Paths.voices(self.song.id, "-" .. playerId .. suffix)
    end

    if voicePlayer == nil then
        playerId = self.characters.player
        voicePlayer = Paths.voices(self.song.id, "-" .. playerId)
        while voicePlayer ~= nil and not love.filesystem.getInfo(voicePlayer) do
            playerId = table.slice(playerId:split("-"), 1, -1):join("-")
            voicePlayer = playerId == "" and nil or Paths.voices(self.song.id, "-" .. playerId .. suffix)
        end
    end

    local opponentId = self.characters.opponent
    local voiceOpponent = Paths.voices(self.song.id, "-" .. opponentId .. suffix)
    while voiceOpponent ~= nil and not love.filesystem.getInfo(voiceOpponent) do
        opponentId = table.slice(opponentId:split("-"), 1, -1):join("-")
        voiceOpponent = opponentId == "" and nil or Paths.voices(self.song.id, "-" .. opponentId .. suffix)
    end

    if voiceOpponent == nil then
        opponentId = self.characters.opponent
        voiceOpponent = Paths.voices(self.song.id, "-" .. opponentId)
        while voiceOpponent ~= nil and not love.filesystem.getInfo(voiceOpponent) do
            opponentId = table.slice(opponentId:split("-"), 1, -1):join("-")
            voiceOpponent = opponentId == "" and nil or Paths.voices(self.song.id, "-" .. opponentId .. suffix)
        end
    end

    local result = {}
    if voicePlayer ~= nil then table.insert(result, voicePlayer) end
    if voiceOpponent ~= nil then table.insert(result, voiceOpponent) end
    if voicePlayer == nil and voiceOpponent == nil then
        if love.filesystem.getInfo(Paths.voices(self.song.id)) then
            table.insert(result, Paths.voices(self.song.id, suffix))
        end
    end

    return result
end

--[[
public function buildVocals():VoicesGroup
  {
    var result:VoicesGroup = new VoicesGroup();

    var voiceList:Array<String> = buildVoiceList();

    if (voiceList.length == 0)
    {
      trace('Could not find any voices for song ${this.song.id}');
      return result;
    }

    // Add player vocals.
    if (voiceList[0] != null) result.addPlayerVoice(FunkinSound.load(voiceList[0]));
    // Add opponent vocals.
    if (voiceList[1] != null) result.addOpponentVoice(FunkinSound.load(voiceList[1]));

    // Add additional vocals.
    if (voiceList.length > 2)
    {
      for (i in 2...voiceList.length)
      {
        result.add(FunkinSound.load(Assets.getSound(voiceList[i])));
      }
    }

    result.playerVoicesOffset = offsets.getVocalOffset(characters.player);
    result.opponentVoicesOffset = offsets.getVocalOffset(characters.opponent);

    return result;
  }]]

function SongDifficulty:buildVocals()
    local result = VoicesGroup()

    local voiceList = self:buildVoiceList()

    if #voiceList == 0 then
        print("Could not find any voices for song " .. self.song.id)
        return result
    end

    if voiceList[1] ~= nil then
        result:addPlayerVoice(FunkinSound.load(voiceList[1]))
    end

    if voiceList[2] ~= nil then
        result:addOpponentVoice(FunkinSound.load(voiceList[2]))
    end

    if #voiceList > 2 then
        for i = 3, #voiceList do
            result:add(FunkinSound.load(voiceList[i]))
        end
    end

    result.playerVoicesOffset = self.offsets:getVocalOffset(self.characters.player)
    result.opponentVoicesOffset = self.offsets:getVocalOffset(self.characters.opponent)

    return result
end

return Song, SongDifficulty