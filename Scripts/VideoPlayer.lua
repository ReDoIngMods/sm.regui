---@class sm.regui.video
sm.regui.video = {}

function sm.regui.video.createPlayer(path, widget)
    AssertArgument(path, 1, {"string"})
    AssertArgument(path, 2, {"table"}, {"ReGuiWidget"})
    
    ---@class ReGui.VideoPlayer : sm.regui.video
    local self = {
        __type = "ReGuiUserdata",

        path = path,
        playbackData = sm.json.open(path .. "/data.json"), ---@type integer[]
        frameCounter = 1,
        widget = widget, ---@type ReGui.Widget

        playing = false,
        looping = false
    }

    for key, value in pairs(sm.regui.video) do
        if type(value) == "function" then
            self[key] = value
        end
    end

    for i = 1, 5, 1 do
        local img = self.playbackData[i]
        if not img then break end
        
        self.widget:setImage(self.path .. "/" .. img .. ".webp")
    end

    return self
end

---@param self ReGui.VideoPlayer
function sm.regui.video:runFrame()
    SelfAssert(self)

    if not self.playing then return end
    local currentFrame = 1 + math.floor(self.frameCounter / 2)

    for i = 1, 5, 1 do
        local img = self.playbackData[currentFrame + i]
        if img then
            self.widget:setImage(self.path .. "/" .. img .. ".webp")
        end
    end

    local img = self.playbackData[currentFrame]
    if not img then
        if self.looping then
            self.frameCounter = 1
            self:runFrame()
        else
            self.playing = false
        end

        return
    end

    self.widget:setImage(self.path .. "/" .. img .. ".webp")
    
    self.frameCounter = self.frameCounter + 1
end

function sm.regui.video:play()
    SelfAssert(self)

    self.playing = true
end

function sm.regui.video:stop()
    SelfAssert(self)

    self.playing = false
    self.frameCounter = 1
end

function sm.regui.video:pause()
    SelfAssert(self)

    self.playing = false
end

function sm.regui.video:isLooping()
    SelfAssert(self)
    
    return self.looping
end

function sm.regui.video:setLooping(looping)
    SelfAssert(self)
    AssertArgument(looping, 1, {"boolean"})

    self.looping = looping
end

function sm.regui.video:isPlaying()
    SelfAssert(self)

    return self.playing
end

function sm.regui.video:getFrameCounter()
    SelfAssert(self)

    return self.frameCounter
end

function sm.regui.video:setFrameCounter(frameCounter)
    SelfAssert(self)
    AssertArgument(frameCounter, 1, {"integer"})

    self.frameCounter = sm.util.clamp(frameCounter, 1, #self.playbackData)
end