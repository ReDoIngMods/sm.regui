GOldPrint = GOldPrint or print
function print(...)
    GOldPrint("[sm.regui]", ...)
end

function warn(...)
    sm.log.warning("[sm.regui]", ...)
end