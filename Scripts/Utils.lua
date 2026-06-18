sm.regui.utils = sm.regui.utils or {}

function sm.regui.utils.createTranslatorJSONFile(fileName)
    local executingModUuid = tostring(GetCurrentlyExecutingModUUID())

    return function(translationKey, ...)
        local currentLanguage = sm.gui.getCurrentLanguage()
        local filePath = string.format("$CONTENT_%s/Gui/Languages/%s/%s.json", executingModUuid, currentLanguage, fileName)
        local success, translatorData = pcall(sm.json.open, filePath)
        if not success or type(translatorData) ~= "table" then
            filePath = string.format("$CONTENT_%s/Gui/Languages/English/%s.json", executingModUuid, fileName)
            success, translatorData = pcall(sm.json.open, filePath)
            if not success or type(translatorData) ~= "table" then
                return translationKey
            end
        end

        local translation = translatorData[translationKey]
        if type(translation) ~= "string" then
            return translationKey
        end

        return string.format(translation, ...)
    end
end