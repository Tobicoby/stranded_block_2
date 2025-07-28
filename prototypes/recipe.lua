data:extend({
    {
        type = "recipe",
        name = "stone-extraction",
        energy_required = 4,
        enabled = true,
        ingredients = {
            {type = "fluid", name = "water", amount = 50}
        },
        results = {
            {type = "item", name = "stone", amount = 5}
        },
        icon = "__base__/graphics/icons/stone.png",
        icon_size = 64,
        category = "chemistry",
        subgroup = "fluid-recipes",
    },
    {
        type = "recipe",
        name = "brick-smelting",
        energy_required = 3.2,
        enabled = false,
        ingredients = {
            {type = "fluid", name = "water", amount = 100}
        },
        results = {
            {type = "item", name = "stone-brick", amount = 2}
        },
        icon = "__stranded_block_2__/graphics/icons/brick-smelt.png",
        icon_size = 64,
        category = "chemistry",
        subgroup = "fluid-recipes",
        allow_productivity = true
    },
    {
        type = "recipe",
        name = "wood-extraction",
        energy_required = 5,
        enabled = true,
        ingredients = {
            {type = "fluid", name = "water", amount = 50}
        },
        results = {
            {type = "item", name = "wood", amount = 5}
        },
        icon = "__base__/graphics/icons/wood.png",
        icon_size = 64,
        category = "chemistry",
        subgroup = "fluid-recipes"
    },
    {
        type = "recipe",
        name = "coal-extraction",
        energy_required = 4,
        enabled = true,
        ingredients = {
            {type = "fluid", name = "water", amount = 50},
        },
        results = {
            {type = "item", name = "coal", amount = 5}
        },
        icon = "__base__/graphics/icons/coal.png",
        icon_size = 64,
        category = "chemistry",
        subgroup = "fluid-recipes",
    },
    {
        type = "recipe",
        name = "iron-extraction",
        energy_required = 5,
        enabled = true,
        ingredients = {
            {type = "fluid", name = "water", amount = 75},
        },
        results = {
            {type = "item", name = "iron-ore", amount = 5}
        },
        icon = "__base__/graphics/icons/iron-ore.png",
        icon_size = 64,
        category = "chemistry",
        subgroup = "fluid-recipes",
    },
    {
        type = "recipe",
        name = "iron-smelting",
        energy_required = 3.2,
        enabled = false,
        ingredients = {
            {type = "fluid", name = "water", amount = 100}
        },
        results = {
            {type = "item", name = "iron-plate", amount = 2}
        },
        icon = "__stranded_block_2__/graphics/icons/iron-smelt.png",
        icon_size = 64,
        category = "chemistry",
        subgroup = "fluid-recipes",
        allow_productivity = true
    },
    {
        type = "recipe",
        name = "copper-extraction",
        energy_required = 5,
        enabled = true,
        ingredients = {
            {type = "fluid", name = "water", amount = 75},
        },
        results = {
            {type = "item", name = "copper-ore", amount = 5}
        },
        icon = "__base__/graphics/icons/copper-ore.png",
        icon_size = 64,
        category = "chemistry",
        subgroup = "fluid-recipes",
    },
    {
        type = "recipe",
        name = "copper-smelting",
        energy_required = 3.2,
        enabled = false,
        ingredients = {
            {type = "fluid", name = "water", amount = 100}
        },
        results = {
            {type = "item", name = "copper-plate", amount = 2}
        },
        icon = "__stranded_block_2__/graphics/icons/copper-smelt.png",
        icon_size = 64,
        category = "chemistry",
        subgroup = "fluid-recipes",
        allow_productivity = true
    },
    {
        type = "recipe",
        name = "oil-extraction",
        energy_required = 5,
        enabled = false,
        ingredients = {
            {type = "fluid", name = "steam", amount = 15},
            {type = "item", name = "coal", amount = 12}
        },
        results = {
            {type = "fluid", name = "crude-oil", amount = 200}
        },
        icon = "__base__/graphics/icons/fluid/basic-oil-processing.png",
        icon_size = 64,
        category = "chemistry",
        subgroup = "fluid-recipes",
        order = "a[oil-processing]-a[basic-oil-processing]",
        allow_productivity = true        
    },
    {
        type = "recipe",
        name = "uranium-extraction",
        energy_required = 10,
        enabled = false,
        ingredients = {
            {type = "item", name = "stone", amount = 10},
            {type = "fluid", name = "sulfuric-acid", amount = 20}
        },
        results = {
            {type = "item", name = "uranium-ore", amount = 5}
        },
        icon = "__base__/graphics/icons/uranium-ore.png",
        icon_size = 64,
        category = "chemistry",
        subgroup = "fluid-recipes",
        allow_productivity = true
    },
})

data:extend({
    {
        type = "technology",
        name = "mining-productivity-1",
        icons = util.technology_icon_constant_productivity("__base__/graphics/technology/mining-productivity.png"),
        effects = {
            {
                type = "mining-drill-productivity-bonus",
                modifier = 0.1
            },
            {
                type = "change-recipe-productivity",
                recipe = "stone-extraction",
                change = 0.1
            },
            {
                type = "change-recipe-productivity",
                recipe = "coal-extraction",
                change = 0.1
            },
            {
                type = "change-recipe-productivity",
                recipe = "iron-extraction",
                change = 0.1
            },
            {
                type = "change-recipe-productivity",
                recipe = "copper-extraction",
                change = 0.1
            },
            {
                type = "change-recipe-productivity",
                recipe = "oil-extraction",
                change = 0.1
            },
            {
                type = "change-recipe-productivity",
                recipe = "uranium-extraction",
                change = 0.1
            }
        },
        prerequisites = {"advanced-circuit"},
        unit =
        {
        count = 250,
        ingredients =
        {
            {"automation-science-pack", 1},
            {"logistic-science-pack", 1}
        },
        time = 60
        },
        upgrade = true
    },
    {
        type = "technology",
        name = "mining-productivity-2",
        icons = util.technology_icon_constant_productivity("__base__/graphics/technology/mining-productivity.png"),
        effects =
        {
          {
            type = "mining-drill-productivity-bonus",
            modifier = 0.1
          },
          {
              type = "change-recipe-productivity",
              recipe = "stone-extraction",
              change = 0.1
          },
          {
              type = "change-recipe-productivity",
              recipe = "coal-extraction",
              change = 0.1
          },
          {
              type = "change-recipe-productivity",
              recipe = "iron-extraction",
              change = 0.1
          },
          {
              type = "change-recipe-productivity",
              recipe = "copper-extraction",
              change = 0.1
          },
          {
              type = "change-recipe-productivity",
              recipe = "oil-extraction",
              change = 0.1
          },
          {
              type = "change-recipe-productivity",
              recipe = "uranium-extraction",
              change = 0.1
          }
        },
        prerequisites = {"mining-productivity-1", "chemical-science-pack"},
        unit =
        {
          count = 500,
          ingredients =
          {
            {"automation-science-pack", 1},
            {"logistic-science-pack", 1},
            {"chemical-science-pack", 1}
          },
          time = 60
        },
        upgrade = true
    },
    {
        type = "technology",
        name = "mining-productivity-3",
        icons = util.technology_icon_constant_productivity("__base__/graphics/technology/mining-productivity.png"),
        effects =
        {
          {
            type = "mining-drill-productivity-bonus",
            modifier = 0.1
          },
          {
              type = "change-recipe-productivity",
              recipe = "stone-extraction",
              change = 0.1
          },
          {
              type = "change-recipe-productivity",
              recipe = "coal-extraction",
              change = 0.1
          },
          {
              type = "change-recipe-productivity",
              recipe = "iron-extraction",
              change = 0.1
          },
          {
              type = "change-recipe-productivity",
              recipe = "copper-extraction",
              change = 0.1
          },
          {
              type = "change-recipe-productivity",
              recipe = "oil-extraction",
              change = 0.1
          },
          {
              type = "change-recipe-productivity",
              recipe = "uranium-extraction",
              change = 0.1
          }
        },
        prerequisites = {"mining-productivity-2", "production-science-pack", "utility-science-pack"},
        unit =
        {
          count = 1000,
          ingredients =
          {
            {"automation-science-pack", 1},
            {"logistic-science-pack", 1},
            {"chemical-science-pack", 1},
            {"production-science-pack", 1},
            {"utility-science-pack", 1}
          },
          time = 60
        },
        upgrade = true
    },
    {
        type = "technology",
        name = "mining-productivity-4",
        icons = util.technology_icon_constant_productivity("__base__/graphics/technology/mining-productivity.png"),
        effects =
        {
          {
            type = "mining-drill-productivity-bonus",
            modifier = 0.1
          },
          {
              type = "change-recipe-productivity",
              recipe = "stone-extraction",
              change = 0.1
          },
          {
              type = "change-recipe-productivity",
              recipe = "coal-extraction",
              change = 0.1
          },
          {
              type = "change-recipe-productivity",
              recipe = "iron-extraction",
              change = 0.1
          },
          {
              type = "change-recipe-productivity",
              recipe = "copper-extraction",
              change = 0.1
          },
          {
              type = "change-recipe-productivity",
              recipe = "oil-extraction",
              change = 0.1
          },
          {
              type = "change-recipe-productivity",
              recipe = "uranium-extraction",
              change = 0.1
          }
        },
        prerequisites = {"mining-productivity-3", "space-science-pack"},
        unit =
        {
          count_formula = "2500*(L - 3)",
          ingredients =
          {
            {"automation-science-pack", 1},
            {"logistic-science-pack", 1},
            {"chemical-science-pack", 1},
            {"production-science-pack", 1},
            {"utility-science-pack", 1},
            {"space-science-pack", 1}
          },
          time = 60
        },
        max_level = "infinite",
        upgrade = true
    },
})

data:extend({
{
type = "technology",
name = "advanced-water-smelting",
icon = "__base__/graphics/technology/mining-productivity.png",
icon_size = 256,
effects =
{
  {
    type = "unlock-recipe",
    recipe = "iron-smelting"
  },
  {
    type = "unlock-recipe",
    recipe = "copper-smelting"
  },
  {
    type = "unlock-recipe",
    recipe = "brick-smelting"
  }
},
prerequisites = {"utility-science-pack","chemical-science-pack"},
unit =
{
  count = 600,
  ingredients =
  {
    {"automation-science-pack", 1},
    {"logistic-science-pack", 1},
    {"chemical-science-pack", 1},
    {"production-science-pack", 1},
    {"utility-science-pack", 1}
  },
  time = 90
},
upgrade = true,
order = "i-q-a"
}
})

data:extend({
    {
        type = "technology",
        name = "water-smelting-productivity-1",
        icon = "__base__/graphics/technology/mining-productivity.png",
        icon_size = 256,
        effects = {
            {
                type = "change-recipe-productivity",
                recipe = "iron-smelting",
                change = 0.1
            },
            {
                type = "change-recipe-productivity",
                recipe = "copper-smelting",
                change = 0.1
            },
            {
                type = "change-recipe-productivity",
                recipe = "brick-smelting",
                change = 0.1
            }
        },
        prerequisites = {"advanced-water-smelting"},
        unit =
        {
        count = 250,
        ingredients =
        {
            {"automation-science-pack", 1},
            {"logistic-science-pack", 1}
        },
        time = 60
        },
        upgrade = true
    },
    {
        type = "technology",
        name = "water-smelting-productivity-2",
        icon = "__base__/graphics/technology/mining-productivity.png",
        icon_size = 256,
        effects = {
            {
                type = "change-recipe-productivity",
                recipe = "iron-smelting",
                change = 0.1
            },
            {
                type = "change-recipe-productivity",
                recipe = "copper-smelting",
                change = 0.1
            },
            {
                type = "change-recipe-productivity",
                recipe = "brick-smelting",
                change = 0.1
            }
        },
        prerequisites = {"water-smelting-productivity-1"},
        unit = {
            count = 1000,
            ingredients = {
                {"automation-science-pack", 1},
                {"logistic-science-pack", 1},
                {"chemical-science-pack", 1},
                {"production-science-pack", 1},
                {"utility-science-pack", 1}
            },
            time = 60
        },
        upgrade = true,
    },
    {
        type = "technology",
        name = "water-smelting-productivity-3",
        icon = "__base__/graphics/technology/mining-productivity.png",
        icon_size = 256,
        effects = {
            {
                type = "change-recipe-productivity",
                recipe = "iron-smelting",
                change = 0.1
            },
            {
                type = "change-recipe-productivity",
                recipe = "copper-smelting",
                change = 0.1
            },
            {
                type = "change-recipe-productivity",
                recipe = "brick-smelting",
                change = 0.1
            }
        },
        prerequisites = {"water-smelting-productivity-2"},
        unit = {
            count = 1500,
            ingredients = {
                {"automation-science-pack", 1},
                {"logistic-science-pack", 1},
                {"chemical-science-pack", 1},
                {"production-science-pack", 1},
                {"utility-science-pack", 1}
            },
            time = 60
        },
        upgrade = true,
    },
    {
        type = "technology",
        name = "water-smelting-productivity-4",
        icon = "__base__/graphics/technology/mining-productivity.png",
        icon_size = 256,
        effects = {
            {
                type = "change-recipe-productivity",
                recipe = "iron-smelting",
                change = 0.1
            },
            {
                type = "change-recipe-productivity",
                recipe = "copper-smelting",
                change = 0.1
            },
            {
                type = "change-recipe-productivity",
                recipe = "brick-smelting",
                change = 0.1
            }
        },
        prerequisites = {"water-smelting-productivity-3"},
        unit = {
            count_formula = "2500*(L - 3)",
            ingredients = {
                {"automation-science-pack", 1},
                {"logistic-science-pack", 1},
                {"chemical-science-pack", 1},
                {"production-science-pack", 1},
                {"utility-science-pack", 1},
                {"space-science-pack", 1}
            },
            time = 60
        },
        max_level = "infinite",
        upgrade = true,
    }
})