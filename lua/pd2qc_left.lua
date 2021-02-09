if not _G.PD2QC then
    dofile(ModPath .. "lua/pd2qc.lua")
end

if not PD2QC._paused then
    PD2QC:SELECT("LEFT")
end