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
        looping = false,

        -- SM-CustomAudioExtension only
        audioName = "NONE",
        audioEffect = nil, ---@type Effect?
        audioParameters = {}
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
            self:stop()
            self:play()
        else
            self:stop()
        end

        return
    end

    if currentFrame % 40 == 0 and sm.exists(self.audioEffect) then
        -- Sync audio
        self.audioEffect:setParameter("CAE_Position", currentFrame * 40) -- TODO: Check if we need to offset it a bit
    end

    self.widget:setImage(self.path .. "/" .. img .. ".webp")
    
    self.frameCounter = self.frameCounter + 1
end

---@param self ReGui.VideoPlayer
function sm.regui.video:play()
    SelfAssert(self)
    assert(not self.playing, "Already playing!")
    
    if sm.exists(self.audioEffect) then
        self.audioEffect:destroy()
    end

    if self.audioName ~= "NONE" then
        self.audioEffect = sm.effect.createEffect(self.audioName)
        for key, value in pairs(self.audioParameters) do
            self.audioEffect:setParameter("CAE_" .. key, value)
        end

        local currentFrame = 1 + math.floor(self.frameCounter / 2)
        self.audioEffect:setParameter("CAE_Position", currentFrame * 40) -- TODO: Check if we need to offset it a bit

        self.audioEffect:start()
    end

    self.playing = true
end

---@param self ReGui.VideoPlayer
function sm.regui.video:stop()
    SelfAssert(self)
    if not self.playing then return end

    if sm.exists(self.audioEffect) then
        self.audioEffect:destroy()
    end

    self.playing = false
    self.frameCounter = 1
end

---@param self ReGui.VideoPlayer
function sm.regui.video:pause()
    SelfAssert(self)

    if sm.exists(self.audioEffect) then
        self.audioEffect:destroy()
    end

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

function sm.regui.video:getAudioName()
    SelfAssert(self)
    ValueAssert(sm.cae_injected == true, 1, "Audio support is not enabled! (SM-CustomAudioExtension not injected)")

    return self.audioName
end

function sm.regui.video:setAudioName(audioName)
    SelfAssert(self)
    AssertArgument(audioName, 1, {"string"})
    ValueAssert(sm.cae_injected == true, 1, "Audio support is not enabled! (SM-CustomAudioExtension not injected)")

    self.audioName = audioName
end

function sm.regui.video:setAudioParameter(index, value)
    SelfAssert(self)
    AssertArgument(index, 1, {"string"})
    AssertArgument(value, 2, {"number"})
    ValueAssert(sm.cae_injected == true, 1, "Audio support is not enabled! (SM-CustomAudioExtension not injected)")

    self.audioParameters[index] = value

    if sm.exists(self.audioEffect) then
        self.audioEffect:setParameter("CAE_" .. index, value)
    end
end

function sm.regui.video:getAudioParameter(index)
    SelfAssert(self)
    AssertArgument(index, 1, {"string"})
    ValueAssert(sm.cae_injected == true, 1, "Audio support is not enabled! (SM-CustomAudioExtension not injected)")

    return self.audioParameters[index]
end


function sm.regui.video:getAllAudioParameters()
    SelfAssert(self)
    ValueAssert(sm.cae_injected == true, 1, "Audio support is not enabled! (SM-CustomAudioExtension not injected)")

    return CloneTable(self.audioParameters)
end