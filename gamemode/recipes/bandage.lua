local RECIPE = {}RECIPE.Name = "bandage"RECIPE.Display = "Bandage"RECIPE.RequiredEntity = "item_crafting_engineering"RECIPE.Category = CRAFTING_ENGINEERINGRECIPE.IsDefault = trueRECIPE.Skill = SKILL_ENGINEERINGRECIPE.Difficulty = 75RECIPE.Requirements = {	{"cloth", 2}}RECIPE.FinishedItems = {	{"bandage", 1}}if CLIENT then	RECIPE.SortBy = RECIPEES_SORTBY_MEDICALendRegisterRecipe(RECIPE)