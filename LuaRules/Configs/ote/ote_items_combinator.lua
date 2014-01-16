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
bodyItems				= {}
bodyItemsCounter		= 0
reactorSettings			= {}
reactorSettingsCounter	= 5

bodyDoubles				= {}
bodyDoublesItems		= {}
bodyDoublesCounter		= 0

itemCombo				= {}
itemComboCounter		= 0

-- items code structure
-- "headItemCode_weaponItemCode_reactorSetting_BodyItem1Code_BodyItem2Code" string

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
	
	if (thisItem.position == "body") then
		bodyItemsCounter				= bodyItemsCounter + 1
		bodyItems[bodyItemsCounter] 	= k
	end
end	

for l=1,reactorSettingsCounter do
	reactorSettings[l] = l -- .. (reactorSettingsCounter - k + 1)
end
	
-- body Doubles (! NOT USED NOW)
function AllDoubles()
	for i=1,bodyItemsCounter do
		for j=1,bodyItemsCounter do
			bodyDoublesCounter 						= bodyDoublesCounter + 1
			bodyDoubles[bodyDoublesCounter]			= itemNameToCode[bodyItems[i]] .. "_" .. itemNameToCode[bodyItems[j]]
			bodyDoublesItems[bodyDoublesCounter] 	= {
				first 	= bodyItems[i],
				second 	= bodyItems[j],
			}
		end
	end
end

-- all items (! NOT USED NOW)
function AllItems()
	for i=1,headItemsCounter do
		for j=1,weaponItemsCounter do
			for k=1,bodyDoublesCounter do
				for l=1,reactorSettingsCounter do
					itemComboCounter 			= itemComboCounter + 1
					-- Spring.Echo(itemComboCounter, headItems[i], weaponItems[j], reactorSettings[k], bodyDoublesItems[l].first, bodyDoublesItems[l].second)
					itemCombo[itemComboCounter] = {
						comboString = itemNameToCode[headItems[i]] .. "_" .. itemNameToCode[weaponItems[j]] .. "_" .. bodyDoubles[k] .. "_" .. reactorSettings[l],
						itemList	= {
							head	= headItems[i],
							weapon	= weaponItems[j],
							body1	= bodyDoublesItems[k].first,
							body2	= bodyDoublesItems[k].second,
							reactor	= reactorSettings[l],
						},
					}
				end
			end
		end
	end
end