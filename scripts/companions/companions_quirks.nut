local gt = this.getroottable();
if (!("Companions" in gt.Const))
{
	gt.Const.Companions <- {};
}
gt.Const.Companions.AttainableQuirks <- [
	// PERKS
	"scripts/skills/perks/perk_fast_adaption",
	"scripts/skills/perks/perk_crippling_strikes",
	"scripts/skills/perks/perk_colossus",
	"scripts/skills/perks/perk_nine_lives",
//	"scripts/skills/perks/perk_bags_and_belts",
	"scripts/skills/perks/perk_pathfinder",
	"scripts/skills/perks/perk_adrenalin",
//	"scripts/skills/perks/perk_recover",
//	"scripts/skills/perks/perk_student",
	"scripts/skills/perks/perk_coup_de_grace",
//	"scripts/skills/perks/perk_bullseye",
	"scripts/skills/perks/perk_dodge",
//	"scripts/skills/perks/perk_fortified_mind",
	"scripts/skills/perks/perk_hold_out",
	"scripts/skills/perks/perk_steel_brow",
//	"scripts/skills/perks/perk_quick_hands",
//	"scripts/skills/perks/perk_gifted",
	"scripts/skills/perks/perk_backstabber",
	"scripts/skills/perks/perk_anticipation",
//	"scripts/skills/perks/perk_shield_expert",
//	"scripts/skills/perks/perk_brawny",
	"scripts/skills/perks/perk_relentless",
//	"scripts/skills/perks/perk_rotation",
//	"scripts/skills/perks/perk_rally_the_troops",
//	"scripts/skills/perks/perk_taunt",
//	"scripts/skills/perks/perk_mastery_mace",
//	"scripts/skills/perks/perk_mastery_flail",
//	"scripts/skills/perks/perk_mastery_hammer",
//	"scripts/skills/perks/perk_mastery_axe",
//	"scripts/skills/perks/perk_mastery_cleaver",
//	"scripts/skills/perks/perk_mastery_sword",
//	"scripts/skills/perks/perk_mastery_dagger",
//	"scripts/skills/perks/perk_mastery_polearm",
//	"scripts/skills/perks/perk_mastery_spear",
//	"scripts/skills/perks/perk_mastery_crossbow",
//	"scripts/skills/perks/perk_mastery_bow",
//	"scripts/skills/perks/perk_mastery_throwing",
//	"scripts/skills/perks/perk_reach_advantage",
	"scripts/skills/perks/perk_overwhelm",
	"scripts/skills/perks/perk_lone_wolf",
	"scripts/skills/perks/perk_underdog",
//	"scripts/skills/perks/perk_footwork",
	"scripts/skills/perks/perk_berserk",
	"scripts/skills/perks/perk_head_hunter",
	"scripts/skills/perks/perk_nimble",
//	"scripts/skills/perks/perk_battle_forged",
	"scripts/skills/perks/perk_fearsome",
//	"scripts/skills/perks/perk_duelist",
	"scripts/skills/perks/perk_killing_frenzy",
//	"scripts/skills/perks/perk_indomitable", - Never seen it used
//	"scripts/skills/perks/perk_battle_flow",
	"scripts/skills/perks/perk_devastating_strikes",
	"scripts/skills/perks/perk_battering_ram",
//	"scripts/skills/perks/perk_steadfast",
	"scripts/skills/perks/perk_stalwart",
	"scripts/skills/perks/perk_sundering_strikes",

// PERKS - Legends
    "scripts/skills/perks/perk_legend_escape_artist",
    "scripts/skills/perks/perk_legend_terrifying_visage",  
    "scripts/skills/perks/perk_slaughterer",  
    "scripts/skills/perks/perk_legend_poison_immunity",  // -> Make sure to change properties of creatures to give it as bonus perk instead of unaffected
    "scripts/skills/perks/perk_legend_onslaught",  
    "scripts/skills/perks/perk_legend_assured_conquest",  
    "scripts/skills/perks/perk_legend_alert",
    "scripts/skills/perks/perk_double_strike",  
    "scripts/skills/perks/perk_legend_second_wind",  
    "scripts/skills/perks/perk_return_favor",  
    "scripts/skills/perks/perk_feint"
	// TRAITS

//	"scripts/skills/traits/huge_trait",   Effectively a nerf, and hurts the high tier stuff less than dogs and such
	"scripts/skills/traits/lucky_trait",
	"scripts/skills/traits/delz_darkvision_trait",






	// ACTIVES, EFFECTS, QUIRKS
	"scripts/companions/quirks/companions_berserker_rage", // Berserker
	"scripts/companions/quirks/companions_poisonous",
	"scripts/companions/quirks/companions_healthy",
	"scripts/companions/quirks/companions_soften_blows",
	"scripts/companions/quirks/companions_regenerative",

	"scripts/companions/quirks/companions_delz_ferocity",
	"scripts/companions/quirks/companions_delz_tenacity"
    



];
gt.Const.Companions.AttainableQuirksDLCUnhold <- [ // Beasts and Exploration
];
gt.Const.Companions.AttainableQuirksDLCWildmen <- [ // Warriors of the North
];
gt.Const.Companions.AttainableQuirksDLCDesert <- [ // Blazing Deserts
	"scripts/skills/actives/throw_dirt_skill"
];
gt.Const.Companions.AttainableQuirksBeasts <- [ // Beast-specific Quirks
];
gt.Const.Companions.SerializeQuirks <- [
	// PERKS
	"perk.fast_adaption",
	"perk.crippling_strikes",
	"perk.colossus",
	"perk.nine_lives",
	"perk.bags_and_belts",
	"perk.pathfinder",
	"perk.adrenaline",
	"perk.recover",
	"perk.student",
	"perk.coup_de_grace",
	"perk.bullseye",
	"perk.dodge",
	"perk.fortified_mind",
	"perk.hold_out",
	"perk.steel_brow",
	"perk.quick_hands",
	"perk.gifted",
	"perk.backstabber",
	"perk.anticipation",
	"perk.shield_expert",
	"perk.brawny",
	"perk.relentless",
	"perk.rotation",
	"perk.rally_the_troops",
	"perk.taunt",
	"perk.mastery.mace",
	"perk.mastery.flail",
	"perk.mastery.hammer",
	"perk.mastery.axe",
	"perk.mastery.cleaver",
	"perk.mastery.sword",
	"perk.mastery.dagger",
	"perk.mastery.polearm",
	"perk.mastery.spear",
	"perk.mastery.crossbow",
	"perk.mastery.bow",
	"perk.mastery.throwing",
	"perk.reach_advantage",
	"perk.overwhelm",
	"perk.lone_wolf",
	"perk.underdog",
	"perk.footwork",
	"perk.berserk",
	"perk.head_hunter",
	"perk.nimble",
	"perk.battle_forged",
	"perk.fearsome",
	"perk.duelist",
	"perk.killing_frenzy",
	"perk.indomitable",
	"perk.battle_flow",
	"perk.devastating_strikes",
	"perk.battering_ram",
	"perk.steadfast",
	"perk.stalwart",
	"perk.sundering_strikes",


	// BEAST-SPECIFICS
	"quirk.good_boy",

	// TRAITS
	"trait.huge",
	"trait.lucky",


	// ACTIVES, EFFECTS, QUIRKS
	"actives.throw_dirt",
	"quirk.berserker_rage",
	"quirk.poison_coat",
	"quirk.healthy",
	"quirk.soften_blows",
	"quirk.regenerative",


 // Legends
    "perk.legend_escape_artist",
    "perk.legend_terrifying_visage",
    "perk.slaughterer",
    "perk.legend_poison_immunity",
    "perk.legend_onslaught",
    "perk.legend_assured_conquest",
    "perk.legend_alert",
    "perk.double_strike",
    "perk.legend_second_wind",
    "perk.return_favor",



    "trait.delz_darkvision",
    

    "quirk.delz_ferocity",
    "quirk.delz_tenacity",
    "perk.feint"

];
gt.Const.Companions.DeserializeQuirks <- [
	// PERKS
	"scripts/skills/perks/perk_fast_adaption",
	"scripts/skills/perks/perk_crippling_strikes",
	"scripts/skills/perks/perk_colossus",
	"scripts/skills/perks/perk_nine_lives",
	"scripts/skills/perks/perk_bags_and_belts",
	"scripts/skills/perks/perk_pathfinder",
	"scripts/skills/perks/perk_adrenalin",
	"scripts/skills/perks/perk_recover",
	"scripts/skills/perks/perk_student",
	"scripts/skills/perks/perk_coup_de_grace",
	"scripts/skills/perks/perk_bullseye",
	"scripts/skills/perks/perk_dodge",
	"scripts/skills/perks/perk_fortified_mind",
	"scripts/skills/perks/perk_hold_out",
	"scripts/skills/perks/perk_steel_brow",
	"scripts/skills/perks/perk_quick_hands",
	"scripts/skills/perks/perk_gifted",
	"scripts/skills/perks/perk_backstabber",
	"scripts/skills/perks/perk_anticipation",
	"scripts/skills/perks/perk_shield_expert",
	"scripts/skills/perks/perk_brawny",
	"scripts/skills/perks/perk_relentless",
	"scripts/skills/perks/perk_rotation",
	"scripts/skills/perks/perk_rally_the_troops",
	"scripts/skills/perks/perk_taunt",
	"scripts/skills/perks/perk_mastery_mace",
	"scripts/skills/perks/perk_mastery_flail",
	"scripts/skills/perks/perk_mastery_hammer",
	"scripts/skills/perks/perk_mastery_axe",
	"scripts/skills/perks/perk_mastery_cleaver",
	"scripts/skills/perks/perk_mastery_sword",
	"scripts/skills/perks/perk_mastery_dagger",
	"scripts/skills/perks/perk_mastery_polearm",
	"scripts/skills/perks/perk_mastery_spear",
	"scripts/skills/perks/perk_mastery_crossbow",
	"scripts/skills/perks/perk_mastery_bow",
	"scripts/skills/perks/perk_mastery_throwing",
	"scripts/skills/perks/perk_reach_advantage",
	"scripts/skills/perks/perk_overwhelm",
	"scripts/skills/perks/perk_lone_wolf",
	"scripts/skills/perks/perk_underdog",
	"scripts/skills/perks/perk_footwork",
	"scripts/skills/perks/perk_berserk",
	"scripts/skills/perks/perk_head_hunter",
	"scripts/skills/perks/perk_nimble",
	"scripts/skills/perks/perk_battle_forged",
	"scripts/skills/perks/perk_fearsome",
	"scripts/skills/perks/perk_duelist",
	"scripts/skills/perks/perk_killing_frenzy",
	"scripts/skills/perks/perk_indomitable",
	"scripts/skills/perks/perk_battle_flow",
	"scripts/skills/perks/perk_devastating_strikes",
	"scripts/skills/perks/perk_battering_ram",
	"scripts/skills/perks/perk_steadfast",
	"scripts/skills/perks/perk_stalwart",
	"scripts/skills/perks/perk_sundering_strikes",

	// BEAST-SPECIFICS
	"scripts/companions/quirks/companions_good_boy",

	// TRAITS
	"scripts/skills/traits/huge_trait",
	"scripts/skills/traits/lucky_trait",

	// ACTIVES, EFFECTS, QUIRKS
	"scripts/skills/actives/throw_dirt_skill",
	"scripts/companions/quirks/companions_berserker_rage",
	"scripts/companions/quirks/companions_poisonous",
	"scripts/companions/quirks/companions_healthy",
	"scripts/companions/quirks/companions_soften_blows",
	"scripts/companions/quirks/companions_regenerative",

 // Legends

    "scripts/skills/perks/perk_legend_escape_artist",
    "scripts/skills/perks/perk_legend_terrifying_visage",  
    "scripts/skills/perks/perk_slaughterer",  
    "scripts/skills/perks/perk_legend_poison_immunity", 
    "scripts/skills/perks/perk_legend_onslaught",  
    "scripts/skills/perks/perk_legend_assured_conquest",  
    "scripts/skills/perks/perk_legend_alert",
    "scripts/skills/perks/perk_double_strike",  
    "scripts/skills/perks/perk_legend_second_wind",  
    "scripts/skills/perks/perk_return_favor",  
	"scripts/skills/traits/delz_darkvision_trait",
	"scripts/companions/quirks/companions_delz_ferocity",
	"scripts/companions/quirks/companions_delz_tenacity",
	"scripts/skills/perks/perk_feint"


];
