local RECIPE = {}RECIPE.Name = "handgun_usp"RECIPE.Display = "USP Handgun"RECIPE.RequiredEntity = "item_crafting_gunsmithing"RECIPE.Category = CRAFTING_GUNSMITHINGRECIPE.Skill = SKILL_GUNSMITHINGRECIPE.Difficulty = 200RECIPE.Requirements = {	{"smallgunbarrel", 1},	{"smallgunframe", 1},	{"metal_iron", 10}}RECIPE.FinishedItems = {	{"handgun_usp",1}}if CLIENT then	RECIPE.SortBy = RECIPEES_SORTBY_HANDGUNSendRegisterRecipe(RECIPE)