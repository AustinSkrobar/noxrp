local RECIPE = {}RECIPE.Name = "brass"RECIPE.Display = "Brass"RECIPE.RequiredEntity = "item_crafting_engineering"RECIPE.Category = CRAFTING_ENGINEERINGRECIPE.IsDefault = trueRECIPE.Skill = SKILL_ENGINEERINGRECIPE.Difficulty = 100RECIPE.Requirements = {	{"metal_copper", 1},	{"metal_zinc", 1}}RECIPE.FinishedItems = {	{"metal_brass", 1}}if CLIENT then	RECIPE.SortBy = RECIPEES_SORTBY_METALREFINEendRegisterRecipe(RECIPE)