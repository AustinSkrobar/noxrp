local RECIPE = {}RECIPE.Name = "smallgunbarrel"RECIPE.Display = "Small Gun Barrel"RECIPE.RequiredEntity = "item_crafting_gunsmithing"RECIPE.Category = CRAFTING_GUNSMITHINGRECIPE.IsDefault = trueRECIPE.Skill = SKILL_GUNSMITHINGRECIPE.Difficulty = 150RECIPE.Requirements = {	{"metal_iron", 5}}RECIPE.FinishedItems = {	{"smallgunbarrel", 1}}if CLIENT then	RECIPE.SortBy = RECIPEES_SORTBY_WEAPONCOMPONENTSendRegisterRecipe(RECIPE)