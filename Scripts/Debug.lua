function sm.regui:DEBUG_showAllWidgets()
    print("--- DEBUG | WIDGET TREE ----")

    ---@param children ReGui.Widget[]
    local function iterator(level, children)
        for i, value in pairs(children) do
            local children = value:getChildren()
            print(("\t"):rep(level) .. value:getName() .. ", PanelSkin = \"" .. value:getSkin() .. "\"")
            iterator(level + 1, children)
        end
    end

    iterator(0, self:getRootChildren())
end