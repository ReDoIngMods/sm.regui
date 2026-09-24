print("sm.regui Hello, World!")

---@class LoaderToolClass : ToolClass
LoaderToolClass = class()

-- SERVER --

function LoaderToolClass:server_onCreate()
    print("LoaderToolClass:server_onCreate")
end

function LoaderToolClass:server_onRefresh()
    print("LoaderToolClass:server_onRefresh")
    
    self:server_onCreate()
end

-- CLIENT --

function LoaderToolClass:client_onCreate()
    print("LoaderToolClass:client_onCreate")
end

function LoaderToolClass:client_onRefresh()
    print("LoaderToolClass:client_onRefresh")

    self:client_onCreate()
end