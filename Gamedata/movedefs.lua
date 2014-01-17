local moveDefs =
{
	{
		name = "Default2x2",
		footprintX = 3,
		footprintZ = 3,
		maxWaterDepth = 10,
		maxSlope = 20,
		crushStrength = 25,
	},
	{
		name = "HeroNormal",
		footprintX = 4,
		footprintZ = 4,
		maxWaterDepth = 10,
		maxSlope = 20,
		crushStrength = 200,
	},	
	{
		name = "HeroFat",
		footprintX = 5,
		footprintZ = 5,
		maxWaterDepth = 10,
		maxSlope = 20,
		crushStrength = 1200,
	},
	{
		name = "HeroSlim",
		footprintX = 3,
		footprintZ = 3,
		maxWaterDepth = 10,
		maxSlope = 30,
		crushStrength = 50,
	},
}

return moveDefs
