-- Replace MyClass with whatever class your interactable is set to.

function MyClass:client_onCreate()
    self.gui = sm.regui.newBlank()
    self.gui:setOnCloseCallback("cl_onGuiClose")

    self.backPanel = self.gui:createWidget("BackPanel", "Widget", "BackgroundPopup")
    self.backPanel:setPosition({ 0, 0 })
    self.backPanel:setSize({ 1280 + 200, 720 + 200 })

    self.image = self.backPanel:createWidget("Image", "ImageBox", "ImageBox")
    self.image:setPosition({ 100, 100 })
    self.image:setSize({ 1280, 720 })
    self.player = sm.regui.video.createPlayer("Path/To/Video", self.image)
end

function MyClass:client_onInteract(_, state)
    if not state then return end
    
    self.gui:open()
    self.player:play()
end

function MyClass:client_onFixedUpdate()
    self.player:runFrame()
end

function MyClass:cl_onGuiClose()
    self.player:stop()
end