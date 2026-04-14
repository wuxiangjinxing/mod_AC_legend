// Pull all the settlements I want to put Beast Tamer into
local settlements = [
	"scripts/entity/world/settlements/city_state",
	"scripts/entity/world/settlements/large_coast_fort",
	"scripts/entity/world/settlements/large_farm_fort",
	"scripts/entity/world/settlements/large_farming_village",
	"scripts/entity/world/settlements/large_fishing_village",
	"scripts/entity/world/settlements/large_forest_fort",
	"scripts/entity/world/settlements/large_lumber_village",
	"scripts/entity/world/settlements/large_mountains_fort",
	"scripts/entity/world/settlements/large_snow_fort",
	"scripts/entity/world/settlements/large_snow_village",
	"scripts/entity/world/settlements/large_steppe_fort",
	"scripts/entity/world/settlements/large_steppe_village",
	"scripts/entity/world/settlements/large_swamp_village",
	"scripts/entity/world/settlements/large_tundra_fort",
	"scripts/entity/world/settlements/large_tundra_village",
	"scripts/entity/world/settlements/medium_coast_fort",
	"scripts/entity/world/settlements/medium_farm_fort",
	"scripts/entity/world/settlements/medium_farming_village",
	"scripts/entity/world/settlements/medium_fishing_village",
	"scripts/entity/world/settlements/medium_forest_fort",
	"scripts/entity/world/settlements/medium_lumber_village",
	"scripts/entity/world/settlements/medium_mining_village",
	"scripts/entity/world/settlements/medium_mountains_fort",
	"scripts/entity/world/settlements/medium_snow_fort",
	"scripts/entity/world/settlements/medium_snow_village",
	"scripts/entity/world/settlements/medium_steppe_fort",
	"scripts/entity/world/settlements/medium_steppe_village",
	"scripts/entity/world/settlements/medium_swamp_fort",
	"scripts/entity/world/settlements/medium_swamp_village",
	"scripts/entity/world/settlements/medium_tundra_fort",
	"scripts/entity/world/settlements/medium_tundra_village"
	// Never gonna give you up, never gonna let you down, never gonna run around and desert you
	// Never gonna make you cry, never gonna say goodbye, never gonna tell a lie and hurt you
];

// Push the new Beast Tamer to the draft list
foreach (directory in settlements)
{
	::modAccessoryCompanions.HooksMod.hook(directory, function(q)
	{
		q.create = @(__original) function()
		{
			__original();
			this.m.DraftList.extend([
				"beast_tamer_background"
			]);
		}
	})
}