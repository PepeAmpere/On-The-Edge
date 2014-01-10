------------------------------------------------------------------------------
-- OTE ITEMS combinator
-- just calculate all posible combinations of pre-game setups
------------------------------------------------------------------------------

-- final structures --
itemCodeToName			= {}				-- item code to name hash table
itemNameToCode			= {}				-- reversed
headItems				= {}
headItemsCounter		= 0
weaponItems				= {}
weaponItemsCounter		= 0
chestItems				= {}
chestItemsCounter		= 0
reactorSettings			= {}
reactorSettingsCounter	= 5

chestDoubles			= {}
chestDoublesItems		= {}
chestDoublesCounter		= 0

itemCombo				= {}
itemComboCounter		= 0

-- items code structure
-- "headItemCode_weaponItemCode_reactorSetting_ChestItem1Code_ChestItem2Code" string

for k,v in pairs(oteItem) do
	local thisItem = oteItem[k]
	itemCodeToName[thisItem.code] 	= k
	itemNameToCode[k] 				= thisItem.code
	
	if (thisItem.position == "head") then
		headItemsCounter			= headItemsCounter + 1
		headItems[headItemsCounter] = k
	end
	
	if (thisItem.position == "weapon") then
		weaponItemsCounter				= weaponItemsCounter + 1
		weaponItems[weaponItemsCounter] = k
	end
	
	if (thisItem.position == "chest") then
		chestItemsCounter				= chestItemsCounter + 1
		chestItems[chestItemsCounter] 	= k
	end
end	

for k=1,reactorSettingsCounter do
	reactorSettings[k] = k .. (reactorSettingsCounter - k + 1)
end

	
-- chest Doubles
-- TODO: currently X x X version, later will be special with own conditons, otherwise i would put it in main generator
for i=1,chestItemsCounter do
	for j=1,chestItemsCounter do
		chestDoublesCounter 					= chestDoublesCounter + 1
		chestDoubles[chestDoublesCounter]		= itemNameToCode[chestItems[i]] .. "_" .. itemNameToCode[chestItems[j]]
		chestDoublesItems[chestDoublesCounter] 	= {
			first 	= chestItems[i],
			second 	= chestItems[j],
		}
	end
end

for i=1,headItemsCounter do
	for j=1,weaponItemsCounter do
		for k=1,reactorSettingsCounter do
			for l=1,chestDoublesCounter do
				itemComboCounter 			= itemComboCounter + 1
				-- Spring.Echo(itemComboCounter, headItems[i], weaponItems[j], reactorSettings[k], chestDoublesItems[l].first, chestDoublesItems[l].second)
				itemCombo[itemComboCounter] = {
					comboString = itemNameToCode[headItems[i]] .. "_" .. itemNameToCode[weaponItems[j]] .. "_" .. reactorSettings[k] .. "_" .. chestDoubles[l],
					itemList	= {
						head	= headItems[i],
						weapon	= weaponItems[j],
						reactor	= reactorSettings[k],
						chest1	= chestDoublesItems[l].first,
						chest2	= chestDoublesItems[l].second,
					}
				}
			end
		end
	end
end
