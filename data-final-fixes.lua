-- Runs last so that planets and resources added by other mods are seen.
if mods["space-age"] then
    require("prototypes.planet-extraction")
    require("prototypes.planet-direct-processing")
    require("prototypes.planet-research-triggers")
end
