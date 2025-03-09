data:extend(
    {
        {
            type = "noise-expression",
            name = "StrandedBlock_ele",
            intended_property = "elevation",
            expression = "noise",
            local_expressions = {
                noise = "(terrace(base_noise - 0.76, 1, 1, 1) - starting_area_circle) + (small_island*10)",
                base_noise =
                "basis_noise{x = x, y = y, seed0 = map_seed, seed1 = 0, input_scale = 1/50, output_scale = 1}",
                starting_area_circle = "if(x^2 + y^2 < starting_area^2, 1, 0)",
                small_island = "if(x^2 + y^2 < 2^2, 1, 0)",
                starting_area = 250,
            }
        }
    }
)
