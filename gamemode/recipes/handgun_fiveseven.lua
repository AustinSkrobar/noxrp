local RECIPE = {}RECIPE.Name = "handgun_fiveseven"RECIPE.Display = "Five-Seven Handgun"RECIPE.RequiredEntity = "item_crafting_gunsmithing"RECIPE.Category = CRAFTING_GUNSMITHINGRECIPE.Skill = SKILL_GUNSMITHINGRECIPE.Difficulty = 225RECIPE.Requirements = {{"smallgunbarrel", 1},{"smallgunframe", 1},{"metal_iron", 10}}RECIPE.FinishedItems = {{"handgun_fiveseven", 1}}if CLIENT then	RECIPE.SortBy = RECIPEES_SORTBY_HANDGUNSendRegisterRecipe(RECIPE)