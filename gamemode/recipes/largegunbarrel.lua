local RECIPE = {}RECIPE.Name = "largegunbarrel"RECIPE.Display = "Large Gun Barrel"RECIPE.RequiredEntity = "item_crafting_gunsmithing"RECIPE.Category = CRAFTING_GUNSMITHINGRECIPE.Skill = SKILL_GUNSMITHINGRECIPE.Difficulty = 450RECIPE.Requirements = {	{"metal_iron", 35}}RECIPE.FinishedItems = {	{"largegunbarrel", 1}}if CLIENT then	RECIPE.SortBy = RECIPEES_SORTBY_WEAPONCOMPONENTSendRegisterRecipe(RECIPE)