if not _G.PD2QC then
    dofile(ModPath .. "lua/pd2qc.lua")
end

if PD2QC._settings.pausable then
    if not PD2QC._paused then
        PD2QC:SELECT("UP")
    end
else
    PD2QC:SELECT("UP")
end