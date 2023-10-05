local ChartingState = MusicBeatState:extend()

-- Simplicity
ChartingState.members = {}
function ChartingState:add(member)
    table.insert(self.members, member)
end

function ChartingState:remove(member)
    for i, member in ipairs(self.members) do
        if member == member then
            table.remove(self.members, i)
            return
        end
    end
end

function ChartingState:insert(position, member)
    table.insert(self.members, position, member)
end

function ChartingState:clear()
    self.members = {}
end
--

function ChartingState:enter()
    self.members = {}
    self.noteTypeList = {
        "",
        "Alt Animation",
        "Hey!",
        "Hurt Note",
        "GF Sing",
        "No Animation"
    }
    self.noteTypeIntMap = {}
    self.noteTypeMap = {}
    self.ignoreWarnings = false
    self.undos = {}
    self.redos = {}
    self.eventStuff = {
        {'', "Nothing. Yep, that's right."},
		{'Dadbattle Spotlight', "Used in Dad Battle,\nValue 1: 0/1 = ON/OFF,\n2 = Target Dad\n3 = Target BF"},
		{'Hey!', "Plays the \"Hey!\" animation from Bopeebo,\nValue 1: BF = Only Boyfriend, GF = Only Girlfriend,\nSomething else = Both.\nValue 2: Custom animation duration,\nleave it blank for 0.6s"},
		{'Set GF Speed', "Sets GF head bopping speed,\nValue 1: 1 = Normal speed,\n2 = 1/2 speed, 4 = 1/4 speed etc.\nUsed on Fresh during the beatbox parts.\n\nWarning: Value must be integer!"},
		{'Philly Glow', "Exclusive to Week 3\nValue 1: 0/1/2 = OFF/ON/Reset Gradient\n \nNo, i won't add it to other weeks."},
		{'Kill Henchmen', "For Mom's songs, don't use this please, i love them :("},
		{'Add Camera Zoom', "Used on MILF on that one \"hard\" part\nValue 1: Camera zoom add (Default: 0.015)\nValue 2: UI zoom add (Default: 0.03)\nLeave the values blank if you want to use Default."},
		{'BG Freaks Expression', "Should be used only in \"school\" Stage!"},
		{'Trigger BG Ghouls', "Should be used only in \"schoolEvil\" Stage!"},
		{'Play Animation', "Plays an animation on a Character,\nonce the animation is completed,\nthe animation changes to Idle\n\nValue 1: Animation to play.\nValue 2: Character (Dad, BF, GF)"},
		{'Camera Follow Pos', "Value 1: X\nValue 2: Y\n\nThe camera won't change the follow point\nafter using this, for getting it back\nto normal, leave both values blank."},
		{'Alt Idle Animation', "Sets a specified suffix after the idle animation name.\nYou can use this to trigger 'idle-alt' if you set\nValue 2 to -alt\n\nValue 1: Character to set (Dad, BF or GF)\nValue 2: New suffix (Leave it blank to disable)"},
		{'Screen Shake', "Value 1: Camera shake\nValue 2: HUD shake\n\nEvery value works as the following example: \"1, 0.05\".\nThe first number (1) is the duration.\nThe second number (0.05) is the intensity."},
		{'Change Character', "Value 1: Character to change (Dad, BF, GF)\nValue 2: New character's name"},
		{'Change Scroll Speed', "Value 1: Scroll Speed Multiplier (1 is default)\nValue 2: Time it takes to change fully in seconds."},
		{'Set Property', "Value 1: Variable name\nValue 2: New value"},
		{'Play Sound', "Value 1: Sound file name\nValue 2: Volume (Default: 1), ranges from 0 to 1"}
    }

    self._file = nil
    
    self.UI_box = nil

    self.goToPlayState = false

    self.curSec = 0
    self.lastSection = 0
    self.lastSong = ""

    self.bpmTxt = nil
    self.camPos = nil
    self.strumLine = nil
    self.curSong = "Test"
    self.amountSteps = 0
    self.bullshitUI = nil
    self.highlight = nil

    self.GRID_SIZE = 40
    self.CAM_OFFSET = 360
    
    self.dummyArrow = nil

    self.curRenderedSustains = nil
    self.curRenderedNotes = nil
    self.curRenderedNoteType = nil

    self.nextRenderedSustains = nil
    self.nextRenderedNotes = nil

    self.gridBG = nil
    self.nextGridBG = nil

    self.daquantspot = 0
    self.curEventSelected = 1
    self.curUndoIndex = 1
    self.curRedoIndex = 1
    self._song = nil

    self.curSelectedNote = nil
    
    self.tempBpm = 0
    self.playbackSpeed = 1

    self.vocals = nil

    self.leftIcon = nil
    self.rightIcon = nil

    self.value1InputText = nil
    self.value2InputText = nil
    self.currentSongName = nil

    self.zoomTxt = nil

    self.zoomList = {
        0.25,
        0.5,
        1,
        2,
        3,
        4,
        6,
        8,
        12,
        16,
        24
    }
    self.curZoom = 3

    self.blockPressWhileTypingOn = {}
    self.blockPressWhileTypingOnStepper = {}
    self.blockPressWhileScrolling = {}

    self.waveformSprite = nil
    self.gridLayer = nil
    
    self.quantization = 16
    self.curQuant = 3

    self.quantizations = {
        4,
        8,
        12,
        16,
        20,
        24,
        32,
        48,
        64,
        96,
        192,
    }

    self.text = ""
    self.vortex = false
    self.mouseQuant = false
    
    if PlayState.SONG then
        self._song = PlayState.SONG
    else
        Difficulty:resetList()
        self._song = {
            song = "Test",
            notes = {},
            events = {},
            bpm = 150,
            needsVoices = true,
            arrowSkin = "",
            splashSkin = "noteSplashes",
            player1 = "bf",
            player2 = "dad",
            gfVersion = "gf",
            speed = 1,
            stage = "stage"
        }
        --self:addSection()
        PlayState.SONG = self._song
    end

    local bg = Sprite():load("menu/menuDesat")
    bg.color = hexToColor(0xFF222222)
    self:add(bg)

    self.gridLayer = Group()
    self:add(self.gridLayer)

    local eventIcon = Sprite(-self.GRID_SIZE -5, -90):load("eventArrow")
    self.leftIcon = HealthIcon("bf")
    self.rightIcon = HealthIcon("dad")

    eventIcon:setGraphicSize(30, 30)
    self.leftIcon:setGraphicSize(0, 45)
    self.rightIcon:setGraphicSize(0, 45)

    self:add(eventIcon)
    self:add(self.leftIcon)
    self:add(self.rightIcon)

    self.leftIcon.x, self.leftIcon.y = self.GRID_SIZE+10, -100
    self.rightIcon.x, self.rightIcon.y = self.GRID_SIZE*5.2, -100

    self.curRenderedSustains = Group()
    self.curRenderedNotes = Group()
    self.curRenderedNoteType = Group()

    self.nextRenderedSustains = Group()
    self.nextRenderedNotes = Group()

    if self.curSec >= #self._song.notes then self.curSec = #self._song.notes - 1 end

    self.tempBpm = self._song.bpm

    --self:addSection()

    self.currentSongname = Paths.formatToSongPath(self._song.song)
    --self:loadSong()
    self:reloadGridLayer()
    Conductor.changeBPM(self._song.bpm)
    Conductor.mapBPMChanges(self._song)

    self.bpmTxt = Text(1000, 50, 0, "", Paths.font("assets/fonts/vcr.ttf", 16))
    self:add(self.bpmTxt)

    self.strumLine = Sprite(280, 20):makeGraphic(math.floor(self.GRID_SIZE*9), 4)
    self:add(self.strumLine)

    self.strumLineNotes = Group()
    for i = 1, 8 do
        local note = StrumNote(280+self.GRID_SIZE * (i), self.strumLine.y, (i-1)%4, 0)
        note:setGraphicSize(self.GRID_SIZE, self.GRID_SIZE)
        note:updateHitbox()
        note:playAnim("static", true)
        self.strumLineNotes:add(note)
    end
    self:add(self.strumLineNotes)

    self.camPos = {x=0, y=0, zoom=1}
    self.camPos.x, self.camPos.y = self.strumLine.x + self.CAM_OFFSET, self.strumLine.y

    self.dummyArrow = Sprite():makeGraphic(self.GRID_SIZE, self.GRID_SIZE)
    self:add(self.dummyArrow)

    local tabs = {
        {name = "Charting", label = 'Chart'},
        {name = "Events", label = 'Events'},
        {name = "Note", label = 'Note'},
        {name = "Section", label = 'Section'},
        {name = "Song", label = "Song"},
        {name = "Editor", label = "Editor"},
    }

    self.UI_box = UITabMenu(tabs)

    self.UI_box:resize(300, 400)
    self.UI_box.x = 640 + self.GRID_SIZE/2
    self.UI_box.y = 25
    self:add(self.UI_box)

    self.text = "W/S or Mouse Wheel - Change Conductor's strum time" ..
                "\nA/D - Go to the previous/next section" ..
                "\nUp/Down - Change Conductor's Strum Time with Snapping" ..
                "\nLeft Bracket / Right Bracket - Change Song Playback Rate (SHIFT to go Faster)" ..
                "\nALT + Left Bracket / Right Bracket - Reset Song Playback Rate" ..
                "\nHold Shift to move 4x faster" ..
                "\nHold Control and click on an arrow to select it" ..
                "\nZ/X - Zoom in/out" ..
                "\n" ..
                "\nEsc - Test your chart inside Chart Editor" ..
                "\nEnter - Play your chart" ..
                "\nQ/E - Decrease/Increase Note Sustain Length" ..
                "\nSpace - Stop/Resume song"
    
    local tipTextArray = self.text:split("\n")

    for i = 1, #tipTextArray do
        local tipText = Text(self.UI_box.x, self.UI_box.y+self.UI_box.height+20, 0, tipTextArray[i], Paths.font("assets/fonts/vcr.ttf", 14))
        tipText.y = tipText.y + (i-1) * 12
        tipText.alignment = "left"
        tipText.borderSize = 0
        self:add(tipText)
    end
    
    self:add(self.curRenderedSustains)
    self:add(self.curRenderedNotes)
    self:add(self.curRenderedNoteType)
    self:add(self.nextRenderedSustains)
    self:add(self.nextRenderedNotes)

    if self.lastSong ~= self.currentSongname then
        --self:changeSection()
    end

    self.zoomTxt = Text(10, 10, 0, "Zoom: 1 / 1", Paths.font("assets/fonts/vcr.ttf", 16))
    self:add(self.zoomTxt)

    --self:updateGrid()
end

function ChartingState:reloadGridLayer()
    self.gridLayer:clear()
    self.gridBG = Sprite(280, 20)
    self.gridBG:gridOverlay(self.GRID_SIZE, self.GRID_SIZE, self.GRID_SIZE*9, math.floor(self.GRID_SIZE * self:getSectionBeats() * 4 * self.zoomList[self.curZoom]))

    self.gridLayer:add(self.gridBG)

    local gridBlackLine = Sprite(self.gridBG.x + self.gridBG.width - (self.GRID_SIZE * 4), 20):makeGraphic(2, self.gridBG.height, 0x000000)
    self.gridLayer:add(gridBlackLine)
    gridBlackLine = Sprite(self.gridBG.x + self.GRID_SIZE, 20):makeGraphic(2, self.gridBG.height, 0x000000)
    self.gridLayer:add(gridBlackLine)
end

function ChartingState:getSectionBeats(section)
    local section = section or self.curSec
    local val

    if self._song.notes[section] then
        val = self._song.notes[section].beats.sectionBeats
    end
    return val or 4
end

function ChartingState:update(dt)
    for i, member in ipairs(self.members) do
        if member.update then member:update(dt) end
    end
end

function ChartingState:draw()
    for i, member in ipairs(self.members) do
        member:draw()
    end
end

return ChartingState