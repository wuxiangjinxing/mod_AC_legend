local gt = this.getroottable();
if (!("Companions" in gt.Const))
{
	gt.Const.Companions <- {};
}

gt.Const.Companions.AttainableQuirks <- [
	"scripts/skills/perks/perk_anticipation",
	"scripts/skills/perks/perk_battering_ram",
	"scripts/skills/perks/perk_berserk",
	"scripts/skills/perks/perk_colossus",	
	"scripts/skills/perks/perk_dodge",
	"scripts/skills/perks/perk_fearsome",
	"scripts/skills/perks/perk_ironside",
	"scripts/skills/perks/perk_last_stand",
	"scripts/skills/perks/perk_legend_alert",
	"scripts/skills/perks/perk_legend_balance",
	"scripts/skills/perks/perk_legend_battleheart",
	"scripts/skills/perks/perk_legend_composure",
	"scripts/skills/perks/perk_legend_freedom_of_movement",
	"scripts/skills/perks/perk_legend_lithe",
	"scripts/skills/perks/perk_legend_terrifying_visage",	
	"scripts/skills/perks/perk_nimble",
	"scripts/skills/perks/perk_nine_lives",
	"scripts/skills/perks/perk_pathfinder",
	"scripts/skills/perks/perk_relentless",
	"scripts/skills/perks/perk_stalwart",
	"scripts/skills/perks/perk_underdog"
];

gt.Const.Companions.AttainableQuirksBeasts <- [ //Undead cannot get those quirks
	"scripts/skills/perks/perk_battle_flow",
	"scripts/skills/perks/perk_feint",
	"scripts/skills/perks/perk_fortified_mind",
	"scripts/skills/perks/perk_hold_out",
	"scripts/skills/perks/perk_legend_assured_conquest",
	"scripts/skills/perks/perk_legend_back_to_basics",
	"scripts/skills/perks/perk_legend_bloodbath",
	"scripts/skills/perks/perk_legend_matching_set",
	"scripts/skills/perks/perk_legend_mind_over_body",
	"scripts/skills/perks/perk_legend_poison_immunity",
	"scripts/skills/perks/perk_legend_second_wind",
	"scripts/skills/perks/perk_legend_taste_the_pain",
	"scripts/skills/perks/perk_legend_true_believer",
	"scripts/skills/perks/perk_rebound",
	"scripts/skills/perks/perk_steadfast",
	"scripts/skills/perks/perk_steel_brow"
];

gt.Const.Companions.AttainableQuirksPhysical <- [ //Alp cannot get those perks
	"scripts/skills/perks/perk_backstabber",
	"scripts/skills/perks/perk_bruiser",
	"scripts/skills/perks/perk_coup_de_grace",
	"scripts/skills/perks/perk_crippling_strikes",
	"scripts/skills/perks/perk_devastating_strikes",
	"scripts/skills/perks/perk_double_strike",
	"scripts/skills/perks/perk_duelist",
	"scripts/skills/perks/perk_fast_adaption",
	"scripts/skills/perks/perk_head_hunter",
	"scripts/skills/perks/perk_killing_frenzy",
	"scripts/skills/perks/perk_legend_clarity",
	"scripts/skills/perks/perk_legend_hair_splitter",
	"scripts/skills/perks/perk_legend_lacerate",
	"scripts/skills/perks/perk_legend_muscularity",
	"scripts/skills/perks/perk_legend_onslaught",
	"scripts/skills/perks/perk_legend_slaughter",
	"scripts/skills/perks/perk_mar_in_the_zone",
	"scripts/skills/perks/perk_overwhelm",
	"scripts/skills/perks/perk_push_the_advantage",
	"scripts/skills/perks/perk_slaughterer",
	"scripts/skills/perks/perk_sundering_strikes",
	"scripts/skills/perks/perk_vengeance"
];

gt.Const.Companions.AttainableQuirksPTR <- [
	"scripts/skills/perks/perk_ptr_bloodbath",
	"scripts/skills/perks/perk_ptr_bully",
	"scripts/skills/perks/perk_ptr_dynamic_duo",
	"scripts/skills/perks/perk_ptr_formidable_approach",
	"scripts/skills/perks/perk_ptr_fruits_of_labor",
	"scripts/skills/perks/perk_ptr_light_weapon",
	"scripts/skills/perks/perk_ptr_menacing",
	"scripts/skills/perks/perk_ptr_pattern_recognition",
	"scripts/skills/perks/perk_ptr_strength_in_numbers",
	"scripts/skills/perks/perk_ptr_survival_instinct",
	"scripts/skills/perks/perk_ptr_tempo",
	"scripts/skills/perks/perk_ptr_tunnel_vision",
	"scripts/skills/perks/perk_ptr_vigilant",
	"scripts/skills/perks/perk_ptr_wear_them_down",
];

gt.Const.Companions.AttainableQuirksBeastsPTR <- [
	"scripts/skills/perks/perk_ptr_bloodlust",
	"scripts/skills/perks/perk_ptr_exude_confidence",
	"scripts/skills/perks/perk_ptr_fluid_weapon",
	"scripts/skills/perks/perk_ptr_sanguinary",
	"scripts/skills/perks/perk_ptr_the_rush_of_battle",
	"scripts/skills/perks/perk_ptr_wears_it_well"
];

gt.Const.Companions.AttainableQuirksPhysicalPTR <- [
	"scripts/skills/perks/perk_ptr_bear_down",
	"scripts/skills/perks/perk_ptr_between_the_ribs",
	"scripts/skills/perks/perk_ptr_bone_breaker",
	"scripts/skills/perks/perk_ptr_concussive_strikes",
	"scripts/skills/perks/perk_ptr_cull",
	"scripts/skills/perks/perk_ptr_deep_impact",
	"scripts/skills/perks/perk_ptr_dent_armor",
	"scripts/skills/perks/perk_ptr_dismantle",
	"scripts/skills/perks/perk_ptr_dismemberment",
	"scripts/skills/perks/perk_ptr_exploit_opening",
	"scripts/skills/perks/perk_ptr_fresh_and_furious",
	"scripts/skills/perks/perk_ptr_from_all_sides",
	"scripts/skills/perks/perk_ptr_head_smasher",
	"scripts/skills/perks/perk_ptr_intimidate",
	"scripts/skills/perks/perk_ptr_king_of_all_weapons",
	"scripts/skills/perks/perk_ptr_know_their_weakness",
	"scripts/skills/perks/perk_ptr_mauler",
	"scripts/skills/perks/perk_ptr_push_it",
	"scripts/skills/perks/perk_ptr_small_target",
	"scripts/skills/perks/perk_ptr_soft_metal",
	"scripts/skills/perks/perk_ptr_unstoppable"
];