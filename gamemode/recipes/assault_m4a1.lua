local RECIPE = {}RECIPE.Name = "assault_m4a1"RECIPE.Display = "'M4A1' Assault Rifle"RECIPE.RequiredEntity = "item_crafting_gunsmithing"RECIPE.Category = CRAFTING_GUNSMITHINGRECIPE.IsDefault = trueRECIPE.Skill = SKILL_GUNSMITHINGRECIPE.Difficulty = 700RECIPE.Requirements = {	{"mediumgunbarrel", 1},	{"mediumgunframe", 1},	{"metal_iron", 15}}RECIPE.FinishedItems = {	{"rifle_m4a1", 1}}if CLIENT then	RECIPE.SortBy = RECIPEES_SORTBY_ASSAULTRSendRegisterRecipe(RECIPE)