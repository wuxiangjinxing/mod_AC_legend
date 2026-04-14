local mod_AC_foundation = function(o)
{
	if ("setEntity" in o)
	{
		o.m.Skill <- null;
		o.m.Entity <- null;
		o.m.Script <- null;
		o.m.ArmorScript <- null;
		o.m.UnleashSounds <- null;
		o.m.InventorySounds <- null;
		o.m.Type <- null;
		o.m.Level <- 1;
		o.m.XP <- 0;
		o.m.Wounds <- 0;
		o.m.Quirks <- [];
		o.m.Attributes <- {
			Hitpoints = 0,
			Stamina = 0,
			Bravery = 0,
			Initiative = 0,
			MeleeSkill = 0,
			RangedSkill = 0,
			MeleeDefense = 0,
			RangedDefense = 0
		};

		o.create <- function()
		{
			this.accessory.create();
			this.m.SlotType = this.Const.ItemSlot.Accessory;
			this.m.IsDroppedAsLoot = true;
			this.m.IsAllowedInBag = false;
			this.m.ShowOnCharacter = false;
			this.m.IsChangeableInBattle = false;

			if (this.isKindOf(this, "legend_wardog_item"))
			{
				this.m.ID = "accessory.legend_wardog";
				this.setType(this.Const.Companions.TypeList.Wardog);
			}
			if (this.isKindOf(this, "legend_armored_wardog_item"))
			{
				this.m.ID = "accessory.legend_armored_wardog";
				this.setType(this.Const.Companions.TypeList.WardogArmor);
			}
			if (this.isKindOf(this, "legend_heavily_armored_wardog_item"))
			{
				this.m.ID = "accessory.legend_heavily_armored_wardog";
				this.setType(this.Const.Companions.TypeList.WardogArmorHeavy);
			}
			if (this.isKindOf(this, "legend_warhound_item"))
			{
				this.m.ID = "accessory.legend_warhound";
				this.setType(this.Const.Companions.TypeList.Warhound);
			}
			if (this.isKindOf(this, "legend_armored_warhound_item"))
			{
				this.m.ID = "accessory.legend_armored_warhound";
				this.setType(this.Const.Companions.TypeList.WarhoundArmor);
			}
			if (this.isKindOf(this, "legend_heavily_armored_warhound_item"))
			{
				this.m.ID = "accessory.legend_heavily_armored_warhound";
				this.setType(this.Const.Companions.TypeList.WarhoundArmorHeavy);
			}
			if (this.isKindOf(this, "legend_wolf_item"))
			{
				this.m.ID = "accessory.legend_warwolf";
				this.setType(this.Const.Companions.TypeList.Warwolf);
			}
			if (this.isKindOf(this, "legend_warbear_item"))
			{
				this.m.ID = "accessory.legend_warbear";
				this.setType(this.Const.Companions.TypeList.Warbear);
			}
			if (this.isKindOf(this, "legend_white_wolf_item"))
			{
				this.m.ID = "accessory.legend_white_warwolf";
				this.setType(this.Const.Companions.TypeList.Whitewolf);
			}
		}

		o.getType <- function()
		{
			return this.m.Type;
		}

		o.setType <- function(_t)
		{
			this.m.Type = _t;
			this.m.Name = this.Const.Companions.Library[this.m.Type].Name();
			this.m.Variant = this.Const.Companions.Library[this.m.Type].Variant();
			this.m.Attributes.Hitpoints = this.Const.Companions.Library[this.m.Type].BasicAttributes.Hitpoints;
			this.m.Attributes.Stamina = this.Const.Companions.Library[this.m.Type].BasicAttributes.Stamina;
			this.m.Attributes.Bravery = this.Const.Companions.Library[this.m.Type].BasicAttributes.Bravery;
			this.m.Attributes.Initiative = this.Const.Companions.Library[this.m.Type].BasicAttributes.Initiative;
			this.m.Attributes.MeleeSkill = this.Const.Companions.Library[this.m.Type].BasicAttributes.MeleeSkill;
			this.m.Attributes.RangedSkill = this.Const.Companions.Library[this.m.Type].BasicAttributes.RangedSkill;
			this.m.Attributes.MeleeDefense = this.Const.Companions.Library[this.m.Type].BasicAttributes.MeleeDefense;
			this.m.Attributes.RangedDefense = this.Const.Companions.Library[this.m.Type].BasicAttributes.RangedDefense;
			this.m.Quirks = [];
			
			switch (this.m.Type)
			{
				// Dogs and Hounds
				case this.Const.Companions.TypeList.Wardog:
				case this.Const.Companions.TypeList.WardogArmor:
				case this.Const.Companions.TypeList.WardogArmorHeavy:
				case this.Const.Companions.TypeList.Warhound:
				case this.Const.Companions.TypeList.WarhoundArmor:
				case this.Const.Companions.TypeList.WarhoundArmorHeavy:
				case this.Const.Companions.TypeList.Warwolf:
				case this.Const.Companions.TypeList.WarwolfArmor:
				case this.Const.Companions.TypeList.WarwolfArmorHeavy:
					this.m.Quirks = [
						"scripts/skills/perks/perk_pathfinder",
						"scripts/skills/perks/perk_steel_brow"
					];
					if ("Assets" in this.World && this.World.Assets != null && this.World.Assets.getCombatDifficulty() == this.Const.Difficulty.Legendary) {
						this.m.Quirks.extend([
							"scripts/skills/perks/perk_legend_battleheart",
							"scripts/skills/perks/perk_legend_last_stand",
							"scripts/skills/traits/fearless_trait"
						]);
					}
					break;
				// Direwolves
				case this.Const.Companions.TypeList.Direwolf:
					this.m.Quirks = [
						"scripts/skills/perks/perk_pathfinder",
						"scripts/skills/perks/perk_berserk",
						"scripts/skills/perks/perk_coup_de_grace"
					];
					if ("Assets" in this.World && this.World.Assets != null && this.World.Assets.getCombatDifficulty() == this.Const.Difficulty.Legendary) {
						this.m.Quirks.extend([
							"scripts/skills/perks/perk_backstabber",
							"scripts/skills/racial/legend_werewolf_racial",
							"scripts/skills/traits/fearless_trait"
						]);
					}
					if (::Is_MC_Exist) {
						this.m.Quirks.extend([
							"scripts/skills/perks/perk_nggh_wolf_bite",
							"scripts/skills/perks/perk_nggh_wolf_thick_hide",
							"scripts/skills/perks/perk_nggh_wolf_enrage"
						]);
					}
					break;
				case this.Const.Companions.TypeList.DirewolfFrenzied:
					this.m.Quirks = [
						"scripts/skills/perks/perk_pathfinder",
						"scripts/skills/perks/perk_berserk",
						"scripts/skills/perks/perk_coup_de_grace",
						"scripts/skills/perks/perk_overwhelm",
						"scripts/skills/perks/perk_relentless"
					];
					if ("Assets" in this.World && this.World.Assets != null && this.World.Assets.getCombatDifficulty() == this.Const.Difficulty.Legendary) {
						this.m.Quirks.extend([
							"scripts/skills/perks/perk_backstabber",
							"scripts/skills/racial/legend_werewolf_racial",
							"scripts/skills/traits/fearless_trait",
							"scripts/skills/perks/perk_killing_frenzy",
							"scripts/skills/perks/perk_nimble"
						]);
					}
					if (::Is_MC_Exist) {
						this.m.Quirks.extend([
							"scripts/skills/perks/perk_nggh_wolf_bite",
							"scripts/skills/perks/perk_nggh_wolf_thick_hide",
							"scripts/skills/perks/perk_nggh_wolf_enrage"
						]);
					}
					break;
				case this.Const.Companions.TypeList.WhiteDirewolf:
					this.m.Quirks = [
						"scripts/skills/perks/perk_rotation",
						"scripts/skills/perks/perk_footwork",
						"scripts/skills/perks/perk_recover",
						"scripts/skills/perks/perk_coup_de_grace",
						"scripts/skills/perks/perk_berserk",
						"scripts/skills/perks/perk_pathfinder",
						"scripts/skills/perks/perk_overwhelm",
						"scripts/skills/perks/perk_nimble",
						"scripts/skills/perks/perk_inspiring_presence",
						"scripts/skills/perks/perk_fast_adaption",
						"scripts/skills/perks/perk_backstabber",
						"scripts/skills/perks/perk_fearsome",
						"scripts/skills/perks/perk_legend_battleheart",
						"scripts/skills/perks/perk_legend_true_believer",
						"scripts/skills/perks/perk_legend_terrifying_visage",
						"scripts/skills/racial/legend_werewolf_racial"
					];
					if ("Assets" in this.World && this.World.Assets != null && this.World.Assets.getCombatDifficulty() == this.Const.Difficulty.Legendary) {
						this.m.Quirks.extend([
							"scripts/skills/perks/perk_battle_forged",
							"scripts/skills/perks/perk_battle_flow",
							"scripts/skills/perks/perk_legend_last_stand",
							"scripts/skills/perks/perk_legend_second_wind",
							"scripts/skills/perks/perk_crippling_strikes",
							"scripts/skills/perks/perk_killing_frenzy",
							"scripts/skills/traits/fearless_trait"
						]);
					}
					if (::Is_MC_Exist) {
						this.m.Quirks.extend([
							"scripts/skills/perks/perk_nggh_wolf_bite",
							"scripts/skills/perks/perk_nggh_wolf_thick_hide",
							"scripts/skills/perks/perk_nggh_wolf_enrage"
						]);
					}
					break;
				// Hyenas
				case this.Const.Companions.TypeList.Hyena:
					this.m.Quirks = [
						"scripts/skills/perks/perk_pathfinder",
						"scripts/skills/perks/perk_berserk",
						"scripts/skills/perks/perk_coup_de_grace"
					];
					if ("Assets" in this.World && this.World.Assets != null && this.World.Assets.getCombatDifficulty() == this.Const.Difficulty.Legendary) {
						this.m.Quirks.extend([
							"scripts/skills/perks/perk_killing_frenzy",
							"scripts/skills/traits/iron_jaw_trait",
							"scripts/skills/traits/fearless_trait"
						]);
					}
					if (::Is_MC_Exist) {
						this.m.Quirks.extend([
							"scripts/skills/perks/perk_nggh_hyena_bite",
							"scripts/skills/perks/perk_nggh_wolf_thick_hide",
							"scripts/skills/perks/perk_nggh_wolf_enrage"
						]);
					}
					break;
				case this.Const.Companions.TypeList.HyenaFrenzied:
					this.m.Quirks = [
						"scripts/skills/perks/perk_pathfinder",
						"scripts/skills/perks/perk_berserk",
						"scripts/skills/perks/perk_coup_de_grace",
						"scripts/skills/perks/perk_overwhelm",
						"scripts/skills/perks/perk_relentless"
					];
					if ("Assets" in this.World && this.World.Assets != null && this.World.Assets.getCombatDifficulty() == this.Const.Difficulty.Legendary) {
						this.m.Quirks.extend([
							"scripts/skills/perks/perk_killing_frenzy",
							"scripts/skills/traits/iron_jaw_trait",
							"scripts/skills/traits/fearless_trait"
						]);
					}
					if (::Is_MC_Exist) {
						this.m.Quirks.extend([
							"scripts/skills/perks/perk_nggh_hyena_bite",
							"scripts/skills/perks/perk_nggh_wolf_thick_hide",
							"scripts/skills/perks/perk_nggh_wolf_enrage"
						]);
					}
					break;
				// Spiders
				case this.Const.Companions.TypeList.Spider:
					this.m.Quirks = [
						"scripts/skills/perks/perk_footwork",
						"scripts/skills/perks/perk_pathfinder",
						"scripts/skills/perks/perk_backstabber",
						"scripts/skills/perks/perk_fast_adaption",
						"scripts/skills/perks/perk_legend_poison_immunity",
						"scripts/skills/racial/spider_racial"
					];
					if ("Assets" in this.World && this.World.Assets != null && this.World.Assets.getCombatDifficulty() == this.Const.Difficulty.Legendary) {
						this.m.Quirks.extend([
							"scripts/skills/perks/perk_legend_levitation",
							"scripts/skills/effects/dodge_effect",
							"scripts/skills/traits/fearless_trait"
						]);
					}
					if (::Is_MC_Exist) {
						this.m.Quirks.extend([
							"scripts/skills/perks/perk_nggh_spider_tough_carapace",
							"scripts/skills/perks/perk_nggh_spider_venom",
							"scripts/skills/perks/perk_nggh_spider_bite"
						]);
					}
					break;
				case this.Const.Companions.TypeList.SpiderEggs:
					this.m.Quirks = [
						"scripts/skills/perks/perk_footwork",
						"scripts/skills/perks/perk_pathfinder",
						"scripts/skills/perks/perk_backstabber",
						"scripts/skills/perks/perk_fast_adaption",
						"scripts/skills/perks/perk_legend_poison_immunity",
						"scripts/skills/racial/spider_racial"
					];
					if ("Assets" in this.World && this.World.Assets != null && this.World.Assets.getCombatDifficulty() == this.Const.Difficulty.Legendary) {
						this.m.Quirks.extend([
							"scripts/skills/perks/perk_legend_levitation",
							"scripts/skills/effects/dodge_effect",
							"scripts/skills/traits/fearless_trait"
						]);
					}
					if (::Is_MC_Exist) {
						this.m.Quirks.extend([
							"scripts/skills/perks/perk_nggh_spider_tough_carapace",
							"scripts/skills/perks/perk_nggh_spider_venom",
							"scripts/skills/perks/perk_nggh_spider_bite"
						]);
					}
					break;
				case this.Const.Companions.TypeList.RedbackSpider:
					this.m.Quirks = [
						"scripts/skills/perks/perk_footwork",
						"scripts/skills/perks/perk_rotation",
						"scripts/skills/perks/perk_recover",
						"scripts/skills/perks/perk_pathfinder",
						"scripts/skills/perks/perk_backstabber",
						"scripts/skills/perks/perk_nimble",
						"scripts/skills/perks/perk_fast_adaption",
						"scripts/skills/perks/perk_killing_frenzy",
						"scripts/skills/perks/perk_underdog",
						"scripts/skills/perks/perk_overwhelm",
						"scripts/skills/perks/perk_legend_poison_immunity",
						"scripts/skills/racial/legend_redback_spider_racial"
					];
					if ("Assets" in this.World && this.World.Assets != null && this.World.Assets.getCombatDifficulty() == this.Const.Difficulty.Legendary) {
						this.m.Quirks.extend([
							"scripts/skills/perks/perk_legend_levitation",
							"scripts/skills/perks/perk_battle_forged",
							"scripts/skills/perks/perk_crippling_strikes",
							"scripts/skills/perks/perk_inspiring_presence",
							"scripts/skills/traits/fearless_trait"
						]);
					}
					if (::Is_MC_Exist) {
						this.m.Quirks.extend([
							"scripts/skills/perks/perk_nggh_spider_tough_carapace",
							"scripts/skills/perks/perk_nggh_spider_venom",
							"scripts/skills/perks/perk_nggh_spider_bite"
						]);
					}
					break;
				// Snakes
				case this.Const.Companions.TypeList.Snake:
					this.m.Quirks = [
						"scripts/skills/racial/serpent_racial",
						"scripts/skills/perks/perk_pathfinder",
						"scripts/skills/perks/perk_backstabber",
						"scripts/skills/perks/perk_relentless"
					];
					if ("Assets" in this.World && this.World.Assets != null && this.World.Assets.getCombatDifficulty() == this.Const.Difficulty.Legendary) {
						this.m.Quirks.extend([
							"scripts/skills/perks/perk_dodge",
							"scripts/skills/perks/perk_anticipation",
							"scripts/skills/perks/perk_legend_alert",
							"scripts/skills/traits/fearless_trait",
							"scripts/skills/traits/weasel_trait"
						]);
					}
					if (::Is_MC_Exist) {
						this.m.Quirks.extend([
							"scripts/skills/perks/perk_nggh_serpent_bite",
							"scripts/skills/perks/perk_nggh_serpent_drag",
							"scripts/skills/perks/perk_nggh_serpent_giant"
						]);
					}
					break;
				case this.Const.Companions.TypeList.Noodle:
					this.m.Quirks = [
						"scripts/skills/perks/perk_pathfinder",
						"scripts/skills/perks/perk_hold_out",
						"scripts/skills/racial/lindwurm_racial",
						"scripts/skills/perks/perk_reach_advantage",
						"scripts/skills/perks/perk_fearsome",
						"scripts/skills/perks/perk_underdog",
						"scripts/skills/perks/perk_stalwart",
						"scripts/skills/perks/perk_legend_composure"
					];
					if ("Assets" in this.World && this.World.Assets != null && this.World.Assets.getCombatDifficulty() == this.Const.Difficulty.Legendary) {
						this.m.Quirks.extend([
							"scripts/skills/perks/perk_pathfinder",
							"scripts/skills/perks/perk_legend_composure",
							"scripts/skills/perks/perk_killing_frenzy",
							"scripts/skills/traits/fearless_trait"
						]);
					}
					if (::Is_MC_Exist) {
						this.m.Quirks.extend([
							"scripts/skills/perks/perk_nggh_lindwurm_body",
							"scripts/skills/perks/perk_nggh_lindwurm_acid"
						]);
					}
					break;
				case this.Const.Companions.TypeList.Stollwurm:
					this.m.Quirks = [
						"scripts/skills/perks/perk_pathfinder",
						"scripts/skills/perks/perk_hold_out",
						"scripts/skills/racial/lindwurm_racial",
						"scripts/skills/perks/perk_reach_advantage",
						"scripts/skills/perks/perk_fearsome",
						"scripts/skills/perks/perk_underdog",
						"scripts/skills/perks/perk_legend_muscularity",
						"scripts/skills/perks/perk_battle_flow",
						"scripts/skills/perks/perk_stalwart",
						"scripts/skills/perks/perk_legend_composure"
					];
					if ("Assets" in this.World && this.World.Assets != null && this.World.Assets.getCombatDifficulty() == this.Const.Difficulty.Legendary) {
						this.m.Quirks.extend([
							"scripts/skills/perks/perk_pathfinder",
							"scripts/skills/perks/perk_legend_composure",
							"scripts/skills/perks/perk_killing_frenzy",
							"scripts/skills/traits/fearless_trait"
						]);
					}
					if (::Is_MC_Exist) {
						this.m.Quirks.extend([
							"scripts/skills/perks/perk_nggh_lindwurm_body",
							"scripts/skills/perks/perk_nggh_lindwurm_acid"
						]);
					}
					break;
				// Nachos
				case this.Const.Companions.TypeList.Nacho:
					this.m.Quirks = [
						"scripts/skills/effects/gruesome_feast_effect",
						"scripts/skills/perks/perk_pathfinder"
					];
					if ("Assets" in this.World && this.World.Assets != null && this.World.Assets.getCombatDifficulty() == this.Const.Difficulty.Legendary) {
						this.m.Quirks.extend([
							"scripts/skills/perks/perk_legend_muscularity",
							"scripts/skills/perks/perk_killing_frenzy",
							"scripts/skills/traits/fearless_trait"
						]);
					}
					if (::Is_MC_Exist) {
						this.m.Quirks.extend([
							"scripts/skills/perks/perk_nggh_nacho",
							"scripts/skills/perks/perk_nggh_nacho_frenzy"
						]);
					}
					break;
				case this.Const.Companions.TypeList.SkinGhoul:
					this.m.Quirks = [
						"scripts/skills/effects/gruesome_feast_effect",
						"scripts/skills/perks/perk_pathfinder",
						"scripts/skills/perks/perk_footwork",
						"scripts/skills/perks/perk_nimble",
						"scripts/skills/perks/perk_killing_frenzy",
						"scripts/skills/traits/fearless_trait"
					];
					if ("Assets" in this.World && this.World.Assets != null && this.World.Assets.getCombatDifficulty() == this.Const.Difficulty.Legendary) {
						this.m.Quirks.extend([
							"scripts/skills/perks/perk_battle_flow",
							"scripts/skills/perks/perk_legend_muscularity",
							"scripts/skills/perks/perk_anticipation",
							"scripts/skills/perks/perk_fast_adaption"
						]);
					}
					if (::Is_MC_Exist) {
						this.m.Quirks.extend([
							"scripts/skills/perks/perk_nggh_nacho",
							"scripts/skills/perks/perk_nggh_nacho_frenzy"
						]);
					}
					break;
				// Alps
				case this.Const.Companions.TypeList.Alp:
					this.m.Quirks = [
						"scripts/skills/racial/alp_racial",
						"scripts/skills/perks/perk_underdog",
						"scripts/skills/perks/perk_stalwart",
						"scripts/skills/perks/perk_legend_poison_immunity"
					];
					if ("Assets" in this.World && this.World.Assets != null && this.World.Assets.getCombatDifficulty() == this.Const.Difficulty.Legendary) {
						this.m.Quirks.extend([
							"scripts/skills/perks/perk_legend_levitation",
							"scripts/skills/perks/perk_legend_push_the_advantage",
							"scripts/skills/perks/perk_legend_return_favor",
							"scripts/skills/perks/perk_anticipation",
							"scripts/skills/perks/perk_dodge",
							"scripts/skills/perks/perk_overwhelm",
							"scripts/skills/perks/perk_fortified_mind",
							"scripts/skills/traits/fearless_trait"
						]);
					}
					if (::Is_MC_Exist) {
						this.m.Quirks.extend([
							"scripts/skills/perks/perk_nggh_alp_nightmare_mastery",
							"scripts/skills/perks/perk_nggh_alp_sleep_mastery"
						]);
					}
					break;
				case this.Const.Companions.TypeList.DemonAlp:
					this.m.Quirks = [
						"scripts/skills/racial/alp_racial",
						"scripts/skills/perks/perk_underdog",
						"scripts/skills/perks/perk_stalwart",
						"scripts/skills/perks/perk_anticipation"
					];
					if ("Assets" in this.World && this.World.Assets != null && this.World.Assets.getCombatDifficulty() == this.Const.Difficulty.Legendary) {
						this.m.Quirks.extend([
							"scripts/skills/perks/perk_nimble",
							"scripts/skills/traits/fearless_trait"
						]);
					}
					if (::Is_MC_Exist) {
						this.m.Quirks.extend([
							"scripts/skills/perks/perk_nggh_alp_nightmare_mastery",
							"scripts/skills/perks/perk_nggh_alp_sleep_mastery"
						]);
					}
					break;
				// Unholds
				case this.Const.Companions.TypeList.Unhold:
					this.m.Quirks = [
						"scripts/skills/perks/perk_crippling_strikes",
						"scripts/skills/perks/perk_pathfinder",
						"scripts/skills/perks/perk_steel_brow",
						"scripts/skills/perks/perk_battering_ram",
						"scripts/skills/perks/perk_stalwart",
						"scripts/skills/perks/perk_hold_out",
						"scripts/skills/racial/unhold_racial"
					];
					if ("Assets" in this.World && this.World.Assets != null && this.World.Assets.getCombatDifficulty() == this.Const.Difficulty.Legendary) {
						this.m.Quirks.extend([
							"scripts/skills/perks/perk_legend_battleheart",
							"scripts/skills/perks/perk_legend_last_stand",
							"scripts/skills/traits/fearless_trait"
						]);
					}
					break;
				case this.Const.Companions.TypeList.UnholdArmor:
					this.m.Quirks = [
						"scripts/skills/perks/perk_crippling_strikes",
						"scripts/skills/perks/perk_pathfinder",
						"scripts/skills/perks/perk_steel_brow",
						"scripts/skills/perks/perk_battering_ram",
						"scripts/skills/perks/perk_stalwart",
						"scripts/skills/perks/perk_hold_out",
						"scripts/skills/racial/unhold_racial"
					];
					if ("Assets" in this.World && this.World.Assets != null && this.World.Assets.getCombatDifficulty() == this.Const.Difficulty.Legendary) {
						this.m.Quirks.extend([
							"scripts/skills/perks/perk_legend_battleheart",
							"scripts/skills/perks/perk_legend_last_stand",
							"scripts/skills/traits/fearless_trait"
						]);
					}
					break;
				case this.Const.Companions.TypeList.RockUnhold:
					this.m.Quirks = [
						"scripts/skills/perks/perk_crippling_strikes",
						"scripts/skills/perks/perk_pathfinder",
						"scripts/skills/perks/perk_steel_brow",
						"scripts/skills/perks/perk_battering_ram",
						"scripts/skills/perks/perk_stalwart",
						"scripts/skills/perks/perk_hold_out",
						"scripts/skills/racial/unhold_racial",
						"scripts/skills/racial/legend_rock_unhold_racial"
					];
					if ("Assets" in this.World && this.World.Assets != null && this.World.Assets.getCombatDifficulty() == this.Const.Difficulty.Legendary) {
						this.m.Quirks.extend([
							"scripts/skills/perks/perk_legend_battleheart",
							"scripts/skills/perks/perk_legend_last_stand",
							"scripts/skills/perks/perk_legend_smackdown",
							"scripts/skills/perks/perk_bloody_harvest",
							"scripts/skills/traits/fearless_trait"
						]);
					}
					break;
				// Schrats
				case this.Const.Companions.TypeList.Schrat:
					this.m.Quirks = [
						"scripts/skills/racial/schrat_racial",
						"scripts/skills/perks/perk_pathfinder",
						"scripts/skills/perks/perk_crippling_strikes",
						"scripts/skills/perks/perk_steel_brow",
						"scripts/skills/perks/perk_hold_out",
						"scripts/skills/perks/perk_stalwart",
						"scripts/skills/perks/perk_legend_composure",
						"scripts/skills/perks/perk_legend_poison_immunity"
					];
					if ("Assets" in this.World && this.World.Assets != null && this.World.Assets.getCombatDifficulty() == this.Const.Difficulty.Legendary) {
						this.m.Quirks.extend([
							"scripts/skills/perks/perk_crippling_strikes",
							"scripts/skills/perks/perk_coup_de_grace",
							"scripts/skills/perks/perk_shield_expert",
							"scripts/skills/perks/perk_shield_bash",
							"scripts/skills/perks/perk_legend_lacerate",
							"scripts/skills/perks/perk_legend_specialist_shield_skill",
							"scripts/skills/perks/perk_legend_specialist_shield_push",
							"scripts/skills/traits/fearless_trait"
						]);
					}
					if (::Is_MC_Exist) {
						this.m.Quirks.extend([
							"scripts/skills/perks/perk_nggh_schrat_grow_shield",
							"scripts/skills/perks/perk_nggh_schrat_uproot_aoe"
						]);
					}
					break;
				case this.Const.Companions.TypeList.GreenwoodSchrat:
					this.m.Quirks = [
						"scripts/skills/racial/legend_greenwood_schrat_racial",
						"scripts/skills/perks/perk_pathfinder",
						"scripts/skills/perks/perk_crippling_strikes",
						"scripts/skills/perks/perk_steel_brow",
						"scripts/skills/perks/perk_hold_out",
						"scripts/skills/perks/perk_stalwart",
						"scripts/skills/perks/perk_legend_composure",
						"scripts/skills/perks/perk_legend_poison_immunity"
					];
					if ("Assets" in this.World && this.World.Assets != null && this.World.Assets.getCombatDifficulty() == this.Const.Difficulty.Legendary) {
						this.m.Quirks.extend([
							"scripts/skills/perks/perk_crippling_strikes",
							"scripts/skills/perks/perk_coup_de_grace",
							"scripts/skills/perks/perk_shield_expert",
							"scripts/skills/perks/perk_shield_bash",
							"scripts/skills/perks/perk_legend_lacerate",
							"scripts/skills/perks/perk_legend_specialist_shield_skill",
							"scripts/skills/perks/perk_legend_specialist_shield_push",
							"scripts/skills/traits/fearless_trait"
						]);
					}
					if (::Is_MC_Exist) {
						this.m.Quirks.extend([
							"scripts/skills/perks/perk_nggh_schrat_grow_shield",
							"scripts/skills/perks/perk_nggh_schrat_uproot_aoe"
						]);
					}
					break;
				// Legends misc beasts
				case this.Const.Companions.TypeList.Warbear:
					this.m.Quirks = [
						"scripts/skills/perks/perk_pathfinder",
						"scripts/skills/perks/perk_hold_out",
						"scripts/skills/perks/perk_berserk"
					];
					if ("Assets" in this.World && this.World.Assets != null && this.World.Assets.getCombatDifficulty() == this.Const.Difficulty.Legendary) {
						this.m.Quirks.extend([
							"scripts/skills/perks/perk_legend_battleheart",
							"scripts/skills/perks/perk_legend_last_stand",
							"scripts/skills/traits/fearless_trait"
						]);
					}
					break;
				case this.Const.Companions.TypeList.Whitewolf:
					this.m.Quirks = [
						"scripts/skills/perks/perk_pathfinder",
						"scripts/skills/perks/perk_steel_brow",
						"scripts/skills/perks/perk_footwork",
						"scripts/skills/perks/perk_recover",
						"scripts/skills/perks/perk_coup_de_grace",
						"scripts/skills/perks/perk_berserk",
						"scripts/skills/perks/perk_nimble",
						"scripts/skills/perks/perk_overwhelm"
					];
					if ("Assets" in this.World && this.World.Assets != null && this.World.Assets.getCombatDifficulty() == this.Const.Difficulty.Legendary) {
						this.m.Quirks.extend([
							"scripts/skills/perks/perk_legend_battleheart",
							"scripts/skills/perks/perk_legend_last_stand",
							"scripts/skills/traits/fearless_trait"
						]);
					}
					break;
				// Hollenhund
				case this.Const.Companions.TypeList.DemonHound:
					this.m.Quirks = [
						"scripts/skills/racial/skeleton_racial",
						"scripts/skills/perks/perk_pathfinder",
						"scripts/skills/perks/perk_anticipation",
						"scripts/skills/perks/perk_fearsome",
						"scripts/skills/perks/perk_legend_poison_immunity"
					];
					if ("Assets" in this.World && this.World.Assets != null && this.World.Assets.getCombatDifficulty() == this.Const.Difficulty.Legendary) {
						this.m.Quirks.extend([
							"scripts/skills/perks/perk_nimble"
						]);
					}
					break;
				// Basilisks
				case this.Const.Companions.TypeList.BasiliskDrone:
					this.m.Quirks = [
						"scripts/skills/perks/perk_legend_second_wind",
						"scripts/skills/perks/perk_overwhelm",
						"scripts/skills/perks/perk_legend_escape_artist",
						"scripts/skills/perks/perk_crippling_strikes",
						"scripts/skills/perks/perk_pathfinder",
						"scripts/skills/perks/perk_berserk",
						"scripts/skills/perks/perk_steel_brow",
						"scripts/skills/perks/perk_head_hunter"
					];
					if ("Assets" in this.World && this.World.Assets != null && this.World.Assets.getCombatDifficulty() == this.Const.Difficulty.Legendary) {
						this.m.Quirks.extend([
							"scripts/skills/perks/perk_sundering_strikes",
							"scripts/skills/perks/perk_legend_onslaught"
						]);
					}
					break;
				case this.Const.Companions.TypeList.BasiliskSentry:
					this.m.Quirks = [
						"scripts/skills/perks/perk_legend_escape_artist",
						"scripts/skills/perks/perk_pathfinder",
						"scripts/skills/perks/perk_steel_brow",
						"scripts/skills/perks/perk_reach_advantage",
						"scripts/skills/perks/perk_legend_strength_in_numbers",
						"scripts/skills/perks/perk_footwork",
						"scripts/skills/perks/perk_coup_de_grace"
					];
					if ("Assets" in this.World && this.World.Assets != null && this.World.Assets.getCombatDifficulty() == this.Const.Difficulty.Legendary) {
						this.m.Quirks.extend([
							"scripts/skills/perks/perk_legend_smackdown",
							"scripts/skills/perks/perk_legend_feint",
							"scripts/skills/perks/perk_legend_onslaught",
							"scripts/skills/perks/perk_legend_push_the_advantage"
						]);
					}
					break;
				default:
					this.m.Quirks = ["scripts/skills/perks/perk_pathfinder", "scripts/skills/perks/perk_steel_brow"];
					break;
			}

			this.updateCompanion();
		}

		o.updateVariant <- function()
		{
		}

		o.updateCompanion <- function()
		{
			this.m.ID = this.Const.Companions.Library[this.m.Type].ID;
			this.m.Description = this.Const.Companions.Library[this.m.Type].Description;
			this.m.Value = this.Math.floor(this.Const.Companions.Library[this.m.Type].Value + ((this.m.Level - 1.00) * (this.Const.Companions.Library[this.m.Type].Value / 65.00)));
			this.m.Script = this.Const.Companions.Library[this.m.Type].Script;
			this.m.ArmorScript = this.Const.Companions.Library[this.m.Type].ArmorScript;
			this.m.UnleashSounds = this.Const.Companions.Library[this.m.Type].UnleashSounds;
			this.m.InventorySounds = this.Const.Companions.Library[this.m.Type].InventorySounds;
			this.setEntity(this.m.Entity);
							
			if ((this.m.Type == this.Const.Companions.TypeList.SkinGhoul) && this.m.Quirks.find("scripts/skills/racial/champion_racial") != null)
				this.m.Name = "Luftwaffle The Goodest";
		}

		o.getEntity <- function()
		{
			return this.m.Entity;
		}

		o.setEntity <- function(_e)
		{
			this.m.Entity = _e;

			if (this.m.Entity == null)
				this.m.Icon = this.Const.Companions.Library[this.m.Type].IconLeashed(this.m.Variant);
			else
				this.m.Icon = this.Const.Companions.Library[this.m.Type].IconUnleashed;
		}

		o.getName <- function()
		{
			if (this.m.Entity == null)
				return this.m.Name;
			else
			{
				return this.Const.Companions.Library[this.m.Type].NameUnleashed + " (" + this.m.Name + ")";
				return this.m.Name + "\'s Collar";
			}
		}

		o.setName <- function(_n)
		{
			this.m.Name = _n;
		}

		o.getDescription <- function()
		{
			if (this.m.Entity == null)
				return this.m.Description;
			else
				return this.Const.Companions.Library[this.m.Type].DescriptionUnleashed;
		}

		o.getScript <- function()
		{
			return this.m.Script;
		}

		o.getArmorScript <- function()
		{
			return this.m.ArmorScript;
		}

		o.playInventorySound <- function(_eventType)
		{
			this.Sound.play(this.m.InventorySounds[this.Math.rand(0, this.m.InventorySounds.len() - 1)], this.Const.Sound.Volume.Inventory);
		}

		o.isUnleashed <- function()
		{
			return this.m.Entity != null;
		}

		o.getTooltip <- function()
		{
			local xpMax = this.m.XP;
			if (this.m.Level < this.Const.LevelXP.len())
				xpMax = this.Const.LevelXP[this.m.Level] - this.Const.LevelXP[this.m.Level - 1];

			local xpText = "MAX LEVEL";
			if (this.m.Level < this.Const.LevelXP.len())
				xpText = this.m.XP + " / " + this.Const.LevelXP[this.m.Level];

			local woundsCalc = (100 - this.m.Wounds);
			if (this.m.Entity != null)
				woundsCalc = this.Math.floor(this.m.Entity.getHitpointsPct() * 100.0);

			local nameText = this.getName();
			local levelText = "Level " + this.m.Level;
			if (this.m.Type != this.Const.Companions.TypeList.TomeReanimation)
			{
				nameText += " ([color=" + (woundsCalc >= 50 ? this.Const.UI.Color.PositiveValue : this.Const.UI.Color.NegativeValue) + "]" + woundsCalc + "%[/color])";
			}

			local result = [
				{
					id = 1,
					type = "title",
					text = nameText
				},
				{
					id = 2,
					type = "description",
					text = this.getDescription()
				},
				{
					id = 3,
					type = "text",
					text = this.getValueString()
				},
				{
					id = 4,
					type = "text",
					text = "Worn in Accessory Slot"
				},
				{
					id = 5,
					type = "text",
					text = "Usable in Combat"
				},
				{
					id = 6,
					type = "text",
					text = levelText
				},
				{
					id = 7,
					type = "progressbar",
					icon = "ui/icons/xp_received.png",
					value = this.m.XP - this.Const.LevelXP[this.m.Level - 1],
					valueMax = xpMax,
					text = xpText,
					style = "armor-body-slim"
				}
			];

			local aHit = this.m.Attributes.Hitpoints;
			local aFat = this.m.Attributes.Stamina;
			local aRes = this.m.Attributes.Bravery;
			local aIni = this.m.Attributes.Initiative;
			local aMS = this.m.Attributes.MeleeSkill;
			local aRS = this.m.Attributes.RangedSkill;
			local aMD = this.m.Attributes.MeleeDefense;
			local aRD = this.m.Attributes.RangedDefense;

			local bufferHealth;
			local bufferStamina;
			local bufferBravery;
			local bufferInitiative;

			if (aHit < 10 || aFat < 10 || aRes < 10 || aIni < 10)
			{
				bufferHealth = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
				bufferStamina = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
				bufferBravery = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
				bufferInitiative = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
			}
			else
			{
				bufferHealth = "&nbsp;&nbsp;&nbsp;";
				bufferStamina = "&nbsp;&nbsp;&nbsp;";
				bufferBravery = "&nbsp;&nbsp;&nbsp;";
				bufferInitiative = "&nbsp;&nbsp;&nbsp;";

				if (aHit < 100 && aFat < 100 && aRes < 100 && aIni < 100)
				{
					bufferHealth += "&nbsp;&nbsp;";
					bufferStamina += "&nbsp;&nbsp;";
					bufferBravery += "&nbsp;&nbsp;";
					bufferInitiative += "&nbsp;&nbsp;";
				}
			}

			if (aHit < 10)
			{
				bufferHealth += "&nbsp;&nbsp;";
				bufferStamina += "&nbsp;&nbsp;";
				bufferBravery += "&nbsp;&nbsp;";
				bufferInitiative += "&nbsp;&nbsp;";
			}
			else if (aHit >= 10)
			{
				bufferStamina += "&nbsp;&nbsp;";
				bufferBravery += "&nbsp;&nbsp;";
				bufferInitiative += "&nbsp;&nbsp;";

				if (aHit >= 100)
				{
					bufferStamina += "&nbsp;&nbsp;";
					bufferBravery += "&nbsp;&nbsp;";
					bufferInitiative += "&nbsp;&nbsp;";

					if (aHit >= 1000)
					{
						bufferStamina += "&nbsp;&nbsp;";
						bufferBravery += "&nbsp;&nbsp;";
						bufferInitiative += "&nbsp;&nbsp;";
					}
				}
			}
			if (aFat < 10)
			{
				bufferHealth += "&nbsp;&nbsp;";
				bufferStamina += "&nbsp;&nbsp;";
				bufferBravery += "&nbsp;&nbsp;";
				bufferInitiative += "&nbsp;&nbsp;";
			}
			else if (aFat >= 10)
			{
				bufferHealth += "&nbsp;&nbsp;";
				bufferBravery += "&nbsp;&nbsp;";
				bufferInitiative += "&nbsp;&nbsp;";

				if (aFat >= 100)
				{
					bufferHealth += "&nbsp;&nbsp;";
					bufferBravery += "&nbsp;&nbsp;";
					bufferInitiative += "&nbsp;&nbsp;";
				}
			}
			if (aRes < 10)
			{
				bufferHealth += "&nbsp;&nbsp;";
				bufferStamina += "&nbsp;&nbsp;";
				bufferBravery += "&nbsp;&nbsp;";
				bufferInitiative += "&nbsp;&nbsp;";
			}
			else if (aRes >= 10)
			{
				bufferHealth += "&nbsp;&nbsp;";
				bufferStamina += "&nbsp;&nbsp;";
				bufferInitiative += "&nbsp;&nbsp;";

				if (aRes >= 100)
				{
					bufferHealth += "&nbsp;&nbsp;";
					bufferStamina += "&nbsp;&nbsp;";
					bufferInitiative += "&nbsp;&nbsp;";
				}
			}
			if (aIni < 10)
			{
				bufferHealth += "&nbsp;&nbsp;";
				bufferStamina += "&nbsp;&nbsp;";
				bufferBravery += "&nbsp;&nbsp;";
				bufferInitiative += "&nbsp;&nbsp;";
			}
			else if (aIni >= 10)
			{
				bufferHealth += "&nbsp;&nbsp;";
				bufferStamina += "&nbsp;&nbsp;";
				bufferBravery += "&nbsp;&nbsp;";

				if (aIni >= 100)
				{
					bufferHealth += "&nbsp;&nbsp;";
					bufferStamina += "&nbsp;&nbsp;";
					bufferBravery += "&nbsp;&nbsp;";
				}
			}

			local attribs = [
				{
					id = 8,
					type = "text",
					text = this.m.Type == this.Const.Companions.TypeList.TomeReanimation ? "The power of this incantation:" : "This individual\'s base attributes:"
				},
				{
					id = 9,
					type = "text",
					text = "[img]gfx/ui/icons/health_ac.png[/img] " + aHit + bufferHealth + "[img]gfx/ui/icons/melee_skill_ac.png[/img] " + aMS + ""
				},
				{
					id = 10,
					type = "text",
					text = "[img]gfx/ui/icons/fatigue_ac.png[/img] " + aFat + bufferStamina + "[img]gfx/ui/icons/ranged_skill_ac.png[/img] " + aRS + ""
				},
				{
					id = 11,
					type = "text",
					text = "[img]gfx/ui/icons/bravery_ac.png[/img] " + aRes + bufferBravery + "[img]gfx/ui/icons/melee_defense_ac.png[/img] " + aMD + ""
				},
				{
					id = 12,
					type = "text",
					text = "[img]gfx/ui/icons/initiative_ac.png[/img] " + aIni + bufferInitiative + "[img]gfx/ui/icons/ranged_defense_ac.png[/img] " + aRD + ""
				}
			];
			result.extend(attribs);

			local quirkString = "";
			local knownQuirks = [];
			if (this.m.Quirks.len() != 0)
			{
				foreach(i, quirk in this.m.Quirks)
				{
					local getQuirk = this.new(quirk);
					knownQuirks.push(getQuirk.m.Name);
				}
		
				knownQuirks.sort();
				foreach(i, quirk in knownQuirks)
				{
					quirkString += quirk;

					if (i < this.m.Quirks.len() - 1)
						quirkString += ", ";
				}
			}

			if (this.m.Quirks.len() != 0)
			{
				result.push({
					id = 13,
					type = "text",
					text = this.m.Type == this.Const.Companions.TypeList.TomeReanimation ? "And its additional effects:" : "And the quirks it possesses:"
				});

				result.push({
					id = 14,
					type = "text",
					icon = "ui/icons/perks.png",
					text = quirkString
				});
			}

			if (this.getIconLarge() != null)
			{
				result.push({
					id = 15,
					type = "image",
					image = this.getIconLarge(),
					isLarge = true
				});
			}
			else
			{
				result.push({
					id = 15,
					type = "image",
					image = this.getIcon()
				});
			}

			return result;
		}

		o.onEquip <- function()
		{
			this.accessory.onEquip();
			local unleash = this.new(this.Const.Companions.Library[this.m.Type].Unleash.Script);
			unleash.setItem(this);
			unleash.applyCompanionModification();
			this.m.Skill = this.WeakTableRef(unleash);
			this.addSkill(unleash);
			local leash = this.new(this.Const.Companions.Library[this.m.Type].Leash.Script);
			if ("setItem" in leash)
			{
				leash.setItem(this);
				leash.applyCompanionModification();
			}
			this.addSkill(leash);
			if (this.m.Type != this.Const.Companions.TypeList.TomeReanimation && this.getContainer().getActor() != null && this.getContainer().getActor().getFaction() != this.Const.Faction.Player)
				this.m.IsDroppedAsLoot = false;
		}

		o.onCombatFinished <- function()
		{
			if (this.m.Entity != null)
				this.m.Wounds = this.Math.floor((1.0 - this.m.Entity.getHitpointsPct()) * 100.0);

			this.setEntity(null);
		}

		o.onActorDied <- function(_onTile)
		{
			if (this.m.Type != null && !this.isUnleashed() && _onTile != null && this.getScript() != null && this.Const.Companions.Library[this.m.Type].Unleash.onActorDied)
			{
				local entity = this.Tactical.spawnEntity(this.getScript(), _onTile.Coords.X, _onTile.Coords.Y);
				entity.setItem(this);
				entity.setName(this.getName());
				entity.setVariant(this.getVariant());
				entity.setFaction(this.getContainer().getActor().getFaction() == this.Const.Faction.Player ? this.Const.Faction.PlayerAnimals : this.getContainer().getActor().getFaction());
				entity.applyCompanionScaling();
				entity.m.IsSummoned = true;
				this.setEntity(entity);

				if (this.getArmorScript() != null)
				{
					local item = this.new(this.getArmorScript());
					entity.getItems().equip(item);
				}

				if (!this.World.getTime().IsDaytime)
					entity.getSkills().add(this.new("scripts/skills/special/night_effect"));

				local healthPercentage = (100.0 - this.m.Wounds) / 100.0;
				entity.setHitpoints(this.Math.max(1, this.Math.floor(healthPercentage * entity.m.Hitpoints)));
				entity.setDirty(true);
				this.Sound.play(this.m.UnleashSounds[this.Math.rand(0, this.m.UnleashSounds.len() - 1)], this.Const.Sound.Volume.Skill, _onTile.Pos);
				entity.onTurnEnd();
			}
		}

		o.isAmountShown <- function()
		{
			return true;
		}

		o.getAmountString <- function()
		{
			return "Level " + this.m.Level;
		}

		o.getXPToNextLevelPercentage <- function()
		{
			if (this.m.Level >= this.Const.LevelXP.len())
				return "MAX";

			local tnl = this.Math.floor(((this.m.XP - this.Const.LevelXP[this.m.Level - 1]) / (this.Const.LevelXP[this.m.Level] - this.Const.LevelXP[this.m.Level - 1])) * 100);

			if (tnl > 99)
				tnl = 99;

			return "" + tnl + "%";
		}

		o.addXP <- function(_xp)
		{
			if (this.m.Level >= this.Const.LevelXP.len())
				return;

			_xp = _xp * this.Const.Combat.GlobalXPMult;

			if (this.getContainer() != null && !this.getContainer().isNull() && this.getContainer().getActor() != null && !this.getContainer().getActor().isNull() && this.getContainer().getActor().m.Type == this.Const.EntityType.Player && this.m.Type != this.Const.Companions.TypeList.TomeReanimation)
			{
				local actor = this.getContainer().getActor();
				foreach(beastmaster in this.Const.Companions.BeastMasters)
				{
					if (actor.getSkills().hasSkill(beastmaster[0]))
						_xp = _xp * (1 + beastmaster[1] * (10 + actor.getLevel()));
				}
			}

			if (this.m.Level >= this.Const.XP.MaxLevelWithPerkpoints)
				_xp = _xp * this.Const.Combat.GlobalXPVeteranLevelMult;

			if (this.m.XP + _xp >= this.Const.LevelXP[this.Const.LevelXP.len() - 1])
			{
				this.m.XP = this.Const.LevelXP[this.Const.LevelXP.len() - 1];
				this.updateLevel();
				return;
			}

			this.m.XP += this.Math.floor(_xp);
			this.updateLevel();
		}
		
		o.wearArmor <- function()
		{
			if ( this.m.Type == this.Const.Companions.TypeList.TomeReanimation )
				return true;
			if (this.m.Type == this.Const.Companions.TypeList.Unhold || this.m.Type == this.Const.Companions.TypeList.UnholdArmor)
				return (this.m.Variant >= 4);
			return false;
		}
		
		o.hasHeavyArmor <- function()
		{
			if (this.m.Type == this.Const.Companions.TypeList.Noodle || 
				this.m.Type == this.Const.Companions.TypeList.Stollwurm || 
				this.m.Type == this.Const.Companions.TypeList.WhiteDirewolf || 
				this.m.Type == this.Const.Companions.TypeList.RedbackSpider || 
				this.m.Type == this.Const.Companions.TypeList.Whitewolf || 
				this.m.Type == this.Const.Companions.TypeList.TomeReanimation)
					return true;
			if (this.m.Type == this.Const.Companions.TypeList.Unhold || this.m.Type == this.Const.Companions.TypeList.UnholdArmor)
				return (this.m.Variant == 5);
			return false;
		}
		
		o.DamageType <- function()
		//0: None, 1: Cut, 2: Pierce, 3: Blunt, 4: Cut + Pierce
		{
			switch (this.m.Type) {
				// Specific checks can be grouped if they return the same value
				case this.Const.Companions.TypeList.RedbackSpider:
				case this.Const.Companions.TypeList.Spider:
				case this.Const.Companions.TypeList.HyenaFrenzied:
					return 4;

				case this.Const.Companions.TypeList.BasiliskDrone:
				case this.Const.Companions.TypeList.BasiliskSentry:
				case this.Const.Companions.TypeList.Unhold:
				case this.Const.Companions.TypeList.UnholdArmor:
				case this.Const.Companions.TypeList.RockUnhold:
				case this.Const.Companions.TypeList.Horse:
					return 3;

				case this.Const.Companions.TypeList.Snake:
				case this.Const.Companions.TypeList.Schrat:
				case this.Const.Companions.TypeList.GreenwoodSchrat:
					return 2;

				case this.Const.Companions.TypeList.Nacho:
				case this.Const.Companions.TypeList.Noodle:
				case this.Const.Companions.TypeList.Stollwurm:
				case this.Const.Companions.TypeList.SkinGhoul:
				case this.Const.Companions.TypeList.Warbear:
				case this.Const.Companions.TypeList.WarwolfArmorHeavy:
					return 1;

				default:
				// Handle range checks here because switch does not support them directly
					if (this.m.Type < this.Const.Companions.TypeList.Direwolf)
						return 1;
					else if (this.m.Type >= this.Const.Companions.TypeList.Direwolf && this.m.Type <= this.Const.Companions.TypeList.HyenaFrenzied)
						return 4;
					else if (this.m.Type >= this.Const.Companions.TypeList.Warbear && this.m.Type <= this.Const.Companions.TypeList.WarwolfArmorHeavy)
						return 1;
					// Fallback case if none of the conditions above match
					return 0;
			}
		}

		o.updateLevel <- function()
		{
			local applyAttributeBonus = function(attribute)
			{
				local attributeMin = this.Const.AttributesLevelUp[attribute].Min;
				local attributeMax = this.Const.AttributesLevelUp[attribute].Max;
				local attributeValue = this.m.Level <= this.Const.XP.MaxLevelWithPerkpoints ? this.Math.rand(attributeMin, attributeMax) : 1;
				switch (attribute)
				{
					case 0:
						this.m.Attributes.Hitpoints += attributeValue;
						break;
					case 1:
						this.m.Attributes.Bravery += attributeValue;
						break;
					case 2:
						this.m.Attributes.Stamina += attributeValue;
						break;
					case 3:
						this.m.Attributes.Initiative += attributeValue;
						break;
					case 4:
						this.m.Attributes.MeleeSkill += attributeValue;
						break;
					case 5:
						this.m.Attributes.MeleeSkill += attributeValue;
						break;
					case 6:
						this.m.Attributes.MeleeDefense += attributeValue;
						break;
					case 7:
						this.m.Attributes.RangedDefense += attributeValue;
						break;
				}
			}

			local availableQuirks = this.Const.Companions.AttainableQuirks;
			if (this.m.Type != this.Const.Companions.TypeList.TomeReanimation && this.m.Type != this.Const.Companions.TypeList.DemonHound)
				availableQuirks.extend(this.Const.Companions.AttainableQuirksBeasts);
			if (this.m.Type != this.Const.Companions.TypeList.Alp)
				availableQuirks.extend(this.Const.Companions.AttainableQuirksPhysical);
			if (this.m.Type == this.Const.Companions.TypeList.Unhold || this.m.Type == this.Const.Companions.TypeList.UnholdArmor || this.m.Type == this.Const.Companions.TypeList.Schrat || this.m.Type == this.Const.Companions.TypeList.Warbear)
			{
				availableQuirks.extend([
					"scripts/skills/perks/perk_bloody_harvest",
					"scripts/skills/perks/perk_legend_forceful_swing"
					]);
			}
			if (this.m.Type != this.Const.Companions.TypeList.Noodle)
				availableQuirks.push("scripts/skills/perks/perk_lone_wolf");
			if ( this.wearArmor() )
			{
				availableQuirks.extend([
					"scripts/skills/perks/perk_legend_lithe"
					]);
			}				
			if ( this.hasHeavyArmor() )
				availableQuirks.push("scripts/skills/perks/perk_battle_forged");
			if (this.m.Level >= this.Const.XP.MaxLevelWithPerkpoints)
			{
				availableQuirks.extend(this.Const.Companions.AttainableQuirksActive);
				if (this.m.Type != this.Const.Companions.TypeList.TomeReanimation && this.m.Type != this.Const.Companions.TypeList.DemonHound)
					availableQuirks.push("scripts/skills/actives/recover_skill");
				if (this.m.Type != this.Const.Companions.TypeList.Alp)
				{
					availableQuirks.extend([
						"scripts/skills/perks/perk_legend_debilitate",
						"scripts/skills/perks/perk_legend_prepare_bleed",
						"scripts/skills/perks/perk_legend_prepare_graze",
						"scripts/skills/perks/perk_legend_smackdown"
					]);
					if (this.m.Type != this.Const.Companions.TypeList.Unhold && this.m.Type != this.Const.Companions.TypeList.UnholdArmor )
					{
						availableQuirks.extend([
							"scripts/skills/perks/perk_legend_evasion",
							"scripts/skills/perks/perk_legend_leap"
						]);
					}
				}
			}
			if ((this.m.Level == 7) || (this.m.Level - 1) % 5 == 0)
				availableQuirks.push("scripts/skills/racial/champion_racial");
			if (::Is_PTR_Exist)
			{
				availableQuirks.extend(this.Const.Companions.AttainableQuirksPTR);
				if (this.m.Type != this.Const.Companions.TypeList.TomeReanimation && this.m.Type != this.Const.Companions.TypeList.DemonHound)
					availableQuirks.extend(this.Const.Companions.AttainableQuirksBeastsPTR);
				if (this.m.Type != this.Const.Companions.TypeList.Alp)
				{
					availableQuirks.extend(this.Const.Companions.AttainableQuirksPhysicalPTR);
					if (this.m.Type != this.Const.Companions.TypeList.TomeReanimation && this.m.Type != this.Const.Companions.TypeList.DemonHound)
						availableQuirks.push("scripts/skills/perks/perk_ptr_utilitarian");
				}
				if (this.m.Type == this.Const.Companions.TypeList.Unhold || this.m.Type == this.Const.Companions.TypeList.UnholdArmor || this.m.Type == this.Const.Companions.TypeList.Schrat || this.m.Type == this.Const.Companions.TypeList.Warbear )
				{
					availableQuirks.extend([
						"scripts/skills/perks/perk_ptr_bloody_harvest",
						"scripts/skills/perks/perk_ptr_sweeping_strikes"
						]);
				}
				local dT = this.DamageType();
				if (dT == 1 || dT == 4)
				{
					availableQuirks.push("scripts/skills/perks/perk_ptr_dismemberment");
					availableQuirks.push("scripts/skills/perks/perk_ptr_deep_cuts");
				}
				else if (dT == 2)
				{
					availableQuirks.push("scripts/skills/perks/perk_ptr_pointy_end");
					availableQuirks.push("scripts/skills/perks/perk_ptr_through_the_gaps");
				}
				else if (dT == 3)
				{
					availableQuirks.push("scripts/skills/perks/perk_ptr_rattle");
					availableQuirks.push("scripts/skills/perks/perk_ptr_dent_armor");
					availableQuirks.push("scripts/skills/perks/perk_ptr_dismantle");
					availableQuirks.push("scripts/skills/perks/perk_ptr_deep_impact");
					availableQuirks.push("scripts/skills/perks/perk_ptr_internal_hemorrhage");
				}

				if (this.m.Type == this.Const.Companions.TypeList.Noodle || this.m.Type == this.Const.Companions.TypeList.Stollwurm)
					availableQuirks.push("scripts/skills/perks/perk_ptr_leverage");
				if ( this.hasHeavyArmor() )
				{
					availableQuirks.extend([
						"scripts/skills/perks/perk_ptr_man_of_steel",
						"scripts/skills/perks/perk_ptr_personal_armor"
						]);
					if (this.m.Type != this.Const.Companions.TypeList.TomeReanimation)
						availableQuirks.push("scripts/skills/perks/perk_ptr_bulwark");
				}
			}

			while (this.m.Level < this.Const.LevelXP.len() && this.m.XP >= this.Const.LevelXP[this.m.Level])
			{
				++this.m.Level;
				this.updateCompanion();
				if (::mods_getRegisteredMod("mod_8skills") != null)
				{
					for ( local i = 0 ; i < 8 ; ++i )
						applyAttributeBonus(i);
				}
				else
				{
					local attributeArray = [0, 1, 2, 3, 4, 5, 6, 7]; // all attributes
					applyAttributeBonus(this.Const.Companions.Library[this.m.Type].PreferredAttribute);
					attributeArray.remove(this.Const.Companions.Library[this.m.Type].PreferredAttribute);

					local bonusesSpent = 1;
					while (bonusesSpent < 3)
					{
						local randomAttribute = this.Math.rand(0, attributeArray.len() - 1);
						applyAttributeBonus(attributeArray[randomAttribute]);
						attributeArray.remove(randomAttribute);
						++bonusesSpent;
					}
				}

				if (this.m.Level <= this.Const.XP.MaxLevelWithPerkpoints || (this.m.Level - 1) % 5 == 0)
				{
					if (availableQuirks.len() > 0)
					{
						while (true)
						{
							local rng = this.Math.rand(0, availableQuirks.len() - 1);
							local quirk = availableQuirks[rng];
							if (this.m.Quirks.find(quirk) == null)
							{
								this.m.Quirks.push(quirk);
								break;
							}
						}
					}
				}
			}
		}

		o.giverandXP <- function()
		{
			local day = this.World.getTime().Days;
			if (day > 100)
				day = 100;
			
			if (day >= 10)
			{
				this.m.XP = this.Math.min(9000, this.Math.rand(0, day * day));
				this.updateLevel();
			}
		}

		o.getLevel <- function()
		{
			return this.m.Level;
		}

		o.setLevel <- function(_l)
		{
			this.m.Level = _l;
		}

		o.getXP <- function()
		{
			return this.m.XP;
		}

		o.setXP <- function(_xp)
		{
			this.m.XP = _xp;
		}

		o.getQuirks <- function()
		{
			return this.m.Quirks;
		}

		o.setQuirks <- function(_q)
		{
			this.m.Quirks = _q;
		}

		o.getAttributes <- function()
		{
			local attr =
			{
				Hitpoints = this.m.Attributes.Hitpoints,
				Stamina = this.m.Attributes.Stamina,
				Bravery = this.m.Attributes.Bravery,
				Initiative = this.m.Attributes.Initiative,
				MeleeSkill = this.m.Attributes.MeleeSkill,
				RangedSkill = this.m.Attributes.RangedSkill,
				MeleeDefense = this.m.Attributes.MeleeDefense,
				RangedDefense = this.m.Attributes.RangedDefense
			};

			return attr;
		}

		o.setAttributes <- function(_a)
		{
			this.m.Attributes.Hitpoints = _a.Hitpoints;
			this.m.Attributes.Stamina = _a.Stamina;
			this.m.Attributes.Bravery = _a.Bravery;
			this.m.Attributes.Initiative = _a.Initiative;
			this.m.Attributes.MeleeSkill = _a.MeleeSkill;
			this.m.Attributes.RangedSkill = _a.RangedSkill;
			this.m.Attributes.MeleeDefense = _a.MeleeDefense;
			this.m.Attributes.RangedDefense = _a.RangedDefense;
		}

		o.getWounds <- function()
		{
			return this.m.Wounds;
		}

		o.setWounds <- function(_w)
		{
			this.m.Wounds = _w;
		}

		o.onSerialize <- function(_out)
		{
			this.accessory.onSerialize(_out);
			_out.writeString(this.m.Name);
			_out.writeU32(this.m.Type);
			_out.writeU32(this.m.Level);
			_out.writeI32(this.m.XP);
			_out.writeI32(this.m.Wounds);

			_out.writeI16(this.m.Attributes.Hitpoints);
			_out.writeI16(this.m.Attributes.Stamina);
			_out.writeI16(this.m.Attributes.Bravery);
			_out.writeI16(this.m.Attributes.Initiative);
			_out.writeI16(this.m.Attributes.MeleeSkill);
			_out.writeI16(this.m.Attributes.RangedSkill);
			_out.writeI16(this.m.Attributes.MeleeDefense);
			_out.writeI16(this.m.Attributes.RangedDefense);

			_out.writeU16(this.m.Quirks.len());

			foreach ( quirk in this.m.Quirks )
			{
				local getQuirk = this.new(quirk);
				_out.writeI32(getQuirk.ClassNameHash);
			}
		}

		o.onDeserialize <- function(_in)
		{
			this.accessory.onDeserialize(_in);
			this.m.Name = _in.readString();
			this.m.Type = _in.readU32();
			this.m.Level = _in.readU32();
			this.m.XP = _in.readI32();
			this.m.Wounds = _in.readI32();
			
			this.m.Attributes.Hitpoints = _in.readI16();
			this.m.Attributes.Stamina = _in.readI16();
			this.m.Attributes.Bravery = _in.readI16();
			this.m.Attributes.Initiative = _in.readI16();
			this.m.Attributes.MeleeSkill = _in.readI16();
			this.m.Attributes.RangedSkill = _in.readI16();
			this.m.Attributes.MeleeDefense = _in.readI16();
			this.m.Attributes.RangedDefense = _in.readI16();

			local num = _in.readU16();
			this.m.Quirks = [];

			for ( local i = 0 ; i < num ; ++i )
			{
				local script = this.IO.scriptFilenameByHash(_in.readI32());

				if (script != null)
				{
					this.m.Quirks.push(script);
				}
			}

			this.updateCompanion();
		}
	}
}

::mods_hookDescendants("items/accessory/accessory", mod_AC_foundation);