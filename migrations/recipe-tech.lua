for index, force in pairs(game.forces) do
  local technologies = force.technologies
  local recipes = force.recipes
  
  recipes["uranium-extraction"].enabled = technologies["uranium-processing"].researched
  recipes["uranium-extraction"].reload()

  recipes["pumpjack"].enabled = false
  recipes["pumpjack"].reload()  

  recipes["burner-mining-drill"].enabled = false
  recipes["burner-mining-drill"].reload()

  recipes["electric-mining-drill"].enabled = false
  recipes["electric-mining-drill"].reload()
  
  recipes["oil-extraction"].enabled = technologies["oil-processing"].researched
  recipes["oil-extraction"].reload()

  force.print("Recipies and technologies have been updated for the latest version of StrandedBlock.");
end