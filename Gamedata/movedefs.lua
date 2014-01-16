local moveDefs =
{
	{
		name = "Default2x2",
		footprintX = 2,
		maxWaterDepth = 10,
		maxSlope = 20,
		crushStrength = 25,
	},
	{
		name = "HeroNormal",
		footprintX = 5,
		maxWaterDepth = 10,
		maxSlope = 20,
		crushStrength = 200,
	},	
	{
		name = "HeroFat",
		footprintX = 6,
		maxWaterDepth = 10,
		maxSlope = 20,
		crushStrength = 1200,
	},
	{
		name = "HeroSlim",
		footprintX = 4,
		maxWaterDepth = 10,
		maxSlope = 30,
		crushStrength = 50,
	},
}

return moveDefs
