local hasInitalizedBefore = GOldPrint ~= nil

GOldPrint = GOldPrint or print
function print(...)
    GOldPrint("[sm.regui]", ...)
end