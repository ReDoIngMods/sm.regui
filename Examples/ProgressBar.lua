function MyClass:client_onCreate()
    self.gui = sm.regui.newBlank()

    local backPanel = self.gui:createWidget("BackPanel", "Widget", "BackgroundPopup")
    backPanel:setSizeRealUnits({ 0.4, 0.15 })
    
    local title = backPanel:createWidget("Title", "TextBox", "TextBox")
    title:setSizeRealUnits({ 1, 0.65 })
    title:setProperties({
        TextAlign = "Center",
        FontName = "SM_HeaderLarge_Wide"
    })
    title:setText("ProgressBar Example")
    
    local progressBarWidget = backPanel:createWidget("ProgressBar", "Widget", "WhiteSkin")
    progressBarWidget:setSizeRealUnits({ 0.9, 0.3 })
    progressBarWidget:setPositionRealUnits({ 0.05, 0.5 })
    
    self.progressBar = sm.regui.progressbar.createProgressBar(progressBarWidget)
    self.progressBar:setMaxValue(100)
    self.progressBar:setValue(0)

    self.incrementer = 1
end

function MyClass:client_onInteract(_, state)
    if not state then return end
    
    self.gui:open()
end

function MyClass:client_onUpdate(deltaTime)
    if not self.gui then return end

    local value = self.progressBar:getValue()
    local maxValue = self.progressBar:getMaxValue()

    if value >= maxValue then
        self.incrementer = -math.abs(self.incrementer)
    elseif value <= 0 then
        self.incrementer = math.abs(self.incrementer)
    end

    local newValue = value + (self.incrementer * deltaTime * 60)
    self.progressBar:setValue(newValue)
end
