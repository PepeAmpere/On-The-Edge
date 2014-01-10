-- ubergenerator :) 
VFS.Include("LuaRules/Configs/ote/ote_heroes.lua")
VFS.Include("LuaRules/Configs/ote/ote_rules.lua")
VFS.Include("LuaRules/Configs/ote/ote_items.lua")
VFS.Include("LuaRules/Configs/ote/ote_items_combinator.lua")

local allHeroesDefs 	= {}

local defName  			=  "dude"


-- jedna class
-- vsechny predmety
	-- vsechny kombinace class + predmety pro dany level
	-- pro kazdou kombinaci
		-- jedna class + predmety
		-- dostanu meno a vsechny vlastnosti, ktere se nemeni s levelem
		-- mam vsechny kombinace jmen (+ table = uroven + schopnosti + predchudce + naslednici)
		-- pak jedu, a davam vlasnosti, ktere se nemeni s levelem + pridam efekt predmetu
		-- protoze znam level, tak ty, ktere se meni pravidelne s levelem + efekt predmetu
		-- pak pridam tabulku se schopnostmi, predchudci a nasledniky + existuje/neexistuje


-- final table completing
-- for k,v in pairs(newSpiritDef) do
	-- spiritDef[k] = v 
-- end

return lowerkeys(allHeroesDefs)