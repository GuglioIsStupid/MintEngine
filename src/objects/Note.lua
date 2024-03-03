local Note = Sprite:extend()

Note.strumTime = 0
Note.mustPress = false
Note.noteData = 0
Note.canBeHit = false
Note.tooLate = false
Note.wasGoodHit = false
Note.ignoreNote = false
Note.hitByOpponent = false
Note.noteWasHit = false

Note.prevNote = nil
Note.nextNote = nil

Note.spawned = false

Note.tail = {}
Note.parent = nil
Note.blockHit = false

Note.sustainlength = 0
Note.isSustainNote = false
Note.noteType = nil

Note.eventName = ""
Note.eventLength = 0
Note.eventVal1 = ""
Note.eventVal2 = ""

Note.animSuffix = ""
Note.gfNote = false
Note.earlyHitMult = 1
Note.lateHitMult =  1
Note.lowPriority = false

Note.SUSTAIN_SIZE = 44
Note.swagWidth = 160 * 0.7
Note.colArray = {"purple", "blue", "green", "red"}

Note.defaultNoteSkin = "noteSkins/NOTE_assets"

Note.offsetX = 0
Note.offsetY = 0
Note.offsetAngle = 0
Note.multAlpha = 1
Note.multSpeed = 1

Note.copyX = true
Note.copyY = true
Note.copyAngle = true
Note.copyAlpha = true

Note.hitHealth = 0.023
Note.missHealth = 0.0475
Note.rating = "unknown"
Note.ratingMod = 0
Note.ratingDisabled = false

Note.noAnimation = false
Note.noMissAnimation = false 
Note.hitCausesMiss = false
Note.distance = 2000

Note.correctionOffset = 0

function Note:changeMultSpeed(value)
    self:resizeByRatio(value / self.multSpeed)
    self.multSpeed = value
    return value
end

function Note:resizeByRatio(ratio)
    if self.isSustainNote and self.curAnim ~= nil and not self.curAnim.name:endsWith("end") then
        self.scale.y = self.scale.y * ratio
        self:updateHitbox()
    end
end

function Note:new(strumTime, noteData, prevNote, sustainNote, inEditor, createdFrom)
    self.super.new(self)
    self.downScroll = ClientPrefs.data.downScroll

    if not createdFrom then createdFrom = PlayState end

    if not prevNote then
        prevNote = self
    end

    self.prevNote = prevNote
    self.isSustainNote = sustainNote
    self.inEditor = inEditor
    self.moves = false

    self.x = self.x + PlayState.STRUM_X + 25
    self.y = -2000

    self.strumTime = strumTime
    
    self.noteData = noteData

    if noteData > -1 then
        if not PlayState.isPixelStage then
            self:setFrames(Paths.getAtlas(PlayState.noteSkin or Note.defaultNoteSkin, (PlayState.noteSkin or Note.defaultNoteSkin) .. ".xml"))
            self.x = self.x + Note.swagWidth * noteData
            if not self.isSustainNote and noteData < #Note.colArray then
                local animToPlay = ""
                animToPlay = Note.colArray[noteData % #Note.colArray + 1]
                self:addByPrefix(animToPlay .. "Scroll", animToPlay .. " instance", 24, true)
                self:play(animToPlay .. "Scroll")
            end
            self:setGraphicSize(math.floor(self.width * 0.7))
        else
            local ox = self.x
            -- since pixel notes are wacky, we gotta get the animation from "tiles"
            if self.isSustainNote then
                local graphic = Paths.image("pixel/pixelUI/NOTE_assetsENDS")
                self:load(graphic, true, math.floor(graphic:getWidth() / 4), math.floor(graphic:getHeight() / 2)) -- 4 columns, 2 rows
                self.originalHeight = graphic:getHeight()/2

                local animToPlay = ""
                animToPlay = Note.colArray[noteData % #Note.colArray + 1]

                self:addByTiles(animToPlay .. "holdend", {self.noteData+5}, 24, true)
                self:addByTiles(animToPlay .. "hold", {self.noteData+1}, 24, true)
                self:play(animToPlay .. "holdend")
            else
                local graphic = Paths.image("pixel/pixelUI/NOTE_assets")
                self:load(graphic, true, math.floor(graphic:getWidth() / 4), math.floor(graphic:getHeight() / 5)) -- 4 columns, 5 rows
                
                local animToPlay = ""
                animToPlay = Note.colArray[noteData % #Note.colArray + 1]

                self:addByTiles(animToPlay .. "Scroll", {self.noteData+5}, 24, true)
                self:play(animToPlay .. "Scroll")
            end

            self:setGraphicSize(math.floor(self.width * PlayState.daPixelZoom))
            self:updateHitbox()
            self.antialiasing = false

            if self.isSustainNote then
                self.offset.x = self.offset.x + (self._lastNoteOffX or 0)
                self._lastNoteOffX = (self.width - 7) * (PlayState.daPixelZoom / 2)
                self.offsetX = self.offsetX - self._lastNoteOffX
            end
        end
    end

    if self.prevNote ~= nil then
        self.prevNote.nextNote = self
    end

    if self.isSustainNote and self.prevNote ~= nil then
        self.alpha = 0.6
        self.multAlpha = 0.6

        self.offsetX = self.offsetX + self.width / 2
        self.copyAngle = false

        if not PlayState.isPixelStage then
            self:addByPrefix(Note.colArray[self.noteData % #Note.colArray + 1] .. "holdend", Note.colArray[self.noteData % #Note.colArray + 1] .. " hold end instance 1", 24, true)
            self:addByPrefix(Note.colArray[self.noteData % #Note.colArray + 1] .. "hold", Note.colArray[self.noteData % #Note.colArray + 1] .. " hold piece instance 1", 24, true)
        end
        self:play(Note.colArray[self.noteData % #Note.colArray + 1] .. "holdend")

        self:updateHitbox()

        self.offsetX = self.offsetX - self.width / 2

        if PlayState.isPixelStage then
            self.offsetX = self.offsetX + 0
        end

        if self.prevNote.isSustainNote then
            if not PlayState.isPixelStage then
                
            end
            self.prevNote:play(Note.colArray[self.noteData % #Note.colArray + 1] .. "hold")
            if createdFrom ~= nil and createdFrom.songSpeed ~= nil then self.prevNote.scale.y = self.prevNote.scale.y * createdFrom.songSpeed end
            
            self.prevNote.scale.y = (prevNote.width / prevNote:getFrameWidth()) * ((Conductor.stepCrochet/100) * (1.05 / 0.7)) * PlayState.songSpeed

            if PlayState.isPixelStage then
                self.prevNote.scale.y = self.prevNote.scale.y * 5
                self.prevNote.scale.y = self.prevNote.scale.y * (6 / self.height)
            end
            self.prevNote:updateHitbox()
        end

        if PlayState.isPixelStage then
            self:updateHitbox()
        end
        self.earlyHitMult = 0
    elseif not self.isSustainNote then
        self:centerOffsets()
        self:centerOrigin()
    end

    self.x = self.x + self.offsetX

    return self
end

function Note:update(dt)
    self.super.update(self, dt)

    if self.mustPress then
        self.canBeHit = self.strumTime > Conductor.songPosition - Conductor.safeZoneOffset * self.lateHitMult and self.strumTime < Conductor.songPosition + Conductor.safeZoneOffset * self.earlyHitMult
        if self.strumTime < Conductor.songPosition - Conductor.safeZoneOffset and not self.wasGoodHit then
            self.tooLate = true
        end
    else
        self.canBeHit = false
        if self.strumTime < Conductor.songPosition + (Conductor.safeZoneOffset * self.earlyHitMult) then
            if ((self.isSustainNote and self.prevNote.wasGoodHit) or self.strumTime <= Conductor.songPosition) then
                self.wasGoodHit = true
            end
        end
    end

    if self.tooLate and not self.inEditor then
        self.alpha = 0.3
    end
end

function Note:draw()
    self.super.draw(self)
end

function Note:followStrumNote(myStrum, fakeCrochet, songSpeed)
    if not myStrum then return end
    local songSpeed = songSpeed or 1
    
    local strumX, strumY = myStrum.x, myStrum.y
    local strumAngle = myStrum.angle
    local strumAlpha = myStrum.alpha
    local strumDirection = myStrum.direction

    self.distance = (0.45 * (Conductor.songPosition - self.strumTime) * songSpeed * self.multSpeed)
    if not myStrum.downScroll then self.distance = -self.distance end

    local angleDir = strumDirection * math.pi / 180

    if copyAngle then
        self.angle = math.rad(strumAngle - 90 + strunAngle + offsetAngle)
    end

    if copyAlpha then
        self.alpha = strumAlpha * multAlpha
    end

    if copyX then
        self.x = strumX + self.offsetX + math.cos(angleDir) * self.distance
    else
        self.x = strumX + self.offsetX + ((PlayState.isPixelStage and self.isSustainNote) and 135 or 0)
    end

    if self.copyY then
        self.y = strumY + self.offsetY + self.correctionOffset + math.sin(angleDir) * self.distance
    end
end

function Note:clipToStrumNote(myStrum)
    if not myStrum then return end
    local center = myStrum.y + self.offsetY + Note.swagWidth/2
    local vert = center - self.y
    if self.isSustainNote and (self.mustPress or not self.ignoreNote) and ((not self.mustPress) or (self.wasGoodHit or (self.prevNote.wasGoodHit and not self.canBeHit))) then
        local swagRect = self.clipRect
        if not swagRect then
            swagRect = {x = 0, y = 0, width = self.frameWidth, height = self.frameHeight}
        end

        if myStrum.downScroll then
            if (self.y - self.offset.y + self.height >= center) then
                swagRect.width = self:getFrameWidth() * self.scale.x
                swagRect.height = vert / self.scale.y
                swagRect.y = self:getFrameHeight() - swagRect.height
            end
        elseif (self.y + self.offset.y <= center) then
            swagRect.y = vert
            swagRect.width = self:getFrameWidth() * self.scale.x
            swagRect.height = self:getFrameHeight() * self.scale.y - vert
        else
            -- default to full frame
            swagRect.y = 0
            swagRect.width = self:getFrameWidth() * self.scale.x
            swagRect.height = self:getFrameHeight() * self.scale.y
        end
        -- if height is 0, set it to frameHeight
        self.clipRect = swagRect
    end
end

return Note