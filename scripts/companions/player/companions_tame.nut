this.companions_tame <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.companions_tame";
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.BeforeLast + 100;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = false;
		this.m.IsTargetingActor = true;
		this.m.IsUsingHitchance = false;

		this.m.ActionPointCost = ::modAccessoryCompanions.ACTameAP;
		this.m.FatigueCost = ::modAccessoryCompanions.ACTameFat;
		this.m.MinRange = 1;
		this.m.MaxRange = 1;

		this.m.Name = "Tame Beast";
		this.m.Description = "Attempt to tame an adjacent beast. The success rate increases if the target is more wounded and have various debuffs. Failing the attempt can make further attempts on the same beast impossible. Succeeding the attempt equips the beast in the brother\'s accessory slot, but it cannot be unleashed in the same battle.";
		this.m.Icon = "skills/tame_ac.png";
		this.m.IconDisabled = "skills/tame_sw_ac.png";
		this.m.SoundOnUse = ["sounds/dice_01.wav", "sounds/dice_02.wav", "sounds/dice_03.wav"];
	}

	function getTooltip()
	{
		local ret = [
			{
				id = 1,
				type = "title",
				text = this.getName()
			},
			{
				id = 2,
				type = "description",
				text = this.getDescription()
			},
			{
				id = 3,
				type = "text",
				text = this.getCostString()
			}
			/*,
			{
				id = 4,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Cannot tame the last enemy on the battlefield"
			}		*/	
		];
		return ret;
	}

		function isHidden()
	{
		local acc = this.getContainer().getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Accessory);

		if (acc == null)
		{
			return false;
		}

		return true;
	}
	
		function onUpdate(_properties)
	{
		this.m.IsHidden = this.isHidden();
	}
	
	function getHitchance( _targetEntity )
	{
		/*
		if (this.Tactical.Entities.getHostilesNum() <= 1)
		{
			return 0;
		}
		else
			*/
		
		local tameDefault = ::modAccessoryCompanions.TameChance;
		foreach(beastmaster in this.Const.Companions.BeastMasters)
		{
			if (this.getContainer().hasSkill(beastmaster[0]))
			{
				tameDefault += (beastmaster[1] * 100);
			}
		}
		local chance = (1.0 - _targetEntity.getHitpointsPct()) * tameDefault;
		
		
		local mod = 1.0;
		local i = 0;
		
		local tableDebuffLow = [
								"effects.goblin_poison",
								"effects.staggered",
								"effects.legend_baffled",
								"effects.distracted",
								"effects.legend_grazed_effect",
								"effects.legend_parried",
								"effects.overwhelmed",
								"effects.ptr_exploitable_opening",
								"effects.ptr_eyes_up",
								"effects.ptr_from_all_sides",
								"effects.ptr_rattled",
								"effects.ptr_worn_down",
								"effects.ptr_formidable_approach_debuff"
							   ];
		
		local tableDebuffMed = [
								"effects.net",
								"effects.web",
								"effects.rooted",
								"effects.legend_dazed",
								"effects.spider_poison",
								"effects.bleeding",
								"effects.debilitated",
								"effects.sweeping_strikes_debuff_effect",
								"effects.ptr_intimidated",
								"effects.ptr_arrow_to_the_knee_debuff"
							   ];
							   
		local tableDebuffHigh = [
								"effects.legend_redback_spider_poison",
								"effects.sleeping",
								"effects.horrified",
								"effects.stunned",
								"effects.withered",
								"effects.legend_grappled"
							   ];
							   
		foreach(skill in tableDebuffLow)
		{
			if (_targetEntity.getSkills().hasSkill(skill))
			{
				mod = mod * 1.2;
			}
		}
		
		foreach(skill in tableDebuffMed)
		{
			if (_targetEntity.getSkills().hasSkill(skill))
			{
				mod = mod * 1.515;
			}
		}
		
		foreach(skill in tableDebuffHigh)
		{
			if (_targetEntity.getSkills().hasSkill(skill))
			{
				mod = mod * 1.833;
			}
		}
		
		if (_targetEntity.getMoraleState() == this.Const.MoraleState.Fleeing)
		{
			mod = mod * 1.833;
		}
		
		if (_targetEntity.getMoraleState() == this.Const.MoraleState.Breaking)
		{
			mod = mod * 1.515;
		}
		
		if (_targetEntity.getMoraleState() == this.Const.MoraleState.Wavering)
		{
			mod = mod * 1.2;
		}
		
		if (_targetEntity.getSkills().hasSkill("racial.champion"))
		{
			mod = mod * 0.5;
		}
		
		local ETC = this.Const.EntityType;
		
		local temp = this.new("scripts/items/accessory/wardog_item");
		if (_targetEntity.getType() == ETC.UnholdFrost || _targetEntity.getType() == ETC.UnholdBog)
			temp.setType(this.Const.Companions.TypeList.Unhold);
		else if (_targetEntity.getType() == ETC.BarbarianUnholdFrost)
			temp.setType(this.Const.Companions.TypeList.UnholdArmor);
		else 
			temp.setType(this.Const.Companions.Library[this.Const.Companions.TameListByType.find(_targetEntity.getType())].Type);
		
		local creatureStrength = this.Const.Companions.Library[temp.getType()].PartyStrength;
		
		if (_targetEntity.getType() == this.Const.EntityType.Ghoul)		//increasing taming chance 
			if (_targetEntity.getSize() > 2)
				creatureStrength += 22;
			else if (_targetEntity.getSize() > 1)
				creatureStrength += 10;
					
		if (_targetEntity.getType() == this.Const.EntityType.LegendSkinGhoul)		//increasing taming chance
			if (_targetEntity.getSize() > 2)
				creatureStrength += 60;
			else if (_targetEntity.getSize() > 1)
				creatureStrength += 25;
		
		mod = mod * ( 1.612 - this.pow((this.pow(creatureStrength,-1) * 11 + 0.634),-1));
		
		chance = this.Math.round(chance * mod * 10) * 0.1;
		
		if (chance > 95)
		{
			chance = 95;
		}
		
		return chance;
		
	}

	function onVerifyTarget(_originTile, _targetTile)
	{
		if (_targetTile.IsEmpty)
		{
			return false;
		}

		local target = _targetTile.getEntity();

		if (target == null)
		{
			return false;
		}
		if (!target.isAlive())
		{
			return false;
		}
		if (!::modAccessoryCompanions.isEnableTamingEnemyAC && target.isSummoned())
		{
			return false;
		}
		if (target.getFlags().has("taming_protection"))
		{
			return false;
		}
		if (this.isKindOf(target, "lindwurm_tail"))
		{
			return false;
		}
		
		if (this.isKindOf(target, "legend_stollwurm_tail"))
		{
			return false;
		}

		local actor = this.getContainer().getActor();
		
		if (this.isKindOf(target, "legend_demon_hound") && !actor.getSkills().hasSkill("trait.legend_deathly_spectre"))
		{
			return false;
		}
		if (actor.isAlliedWith(target))
		{
			return false;
		}

		local tamable = this.Const.Companions.TameListByType.find(target.getType());
		
		local ETC = this.Const.EntityType;
		if (target.getType() == ETC.UnholdFrost || target.getType() == ETC.UnholdBog || target.getType() == ETC.BarbarianUnholdFrost)
		{
			tamable = 1;
		}

		if (tamable == null)
		{
			return false;
		}

		return this.skill.onVerifyTarget(_originTile, _targetTile);
	}

	function onUse(_user, _targetTile)
	{
		local actor = this.getContainer().getActor();
		local target = _targetTile.getEntity();
		local chance = this.getHitchance(target) * 10;

		local rolled = this.Math.rand(1, 1000);
		if (rolled <= chance)
		{
			this.Tactical.EventLog.logEx(this.Const.UI.getColorizedEntityName(actor) + " successfully tamed " + this.Const.UI.getColorizedEntityName(target) + " (Chance: " + this.Math.floor(chance) + ", Rolled: " + rolled + ")");
			local ETC = this.Const.EntityType;
			local loot = this.new("scripts/items/accessory/wardog_item");
			if (target.getType() == ETC.UnholdFrost || target.getType() == ETC.UnholdBog)
				loot.setType(this.Const.Companions.TypeList.Unhold);
			else if (target.getType() == ETC.BarbarianUnholdFrost)
				loot.setType(this.Const.Companions.TypeList.UnholdArmor);
			else
				loot.setType(this.Const.Companions.Library[this.Const.Companions.TameListByType.find(target.getType())].Type);

			local ET = _targetTile.getEntity().m.Type;

			if (ET == ETC.Unhold)
			{
				loot.setVariant(2);
			}
			else if (ET == ETC.UnholdFrost)
			{
				loot.setVariant(1);
			}
			else if (ET == ETC.UnholdBog)
			{
				loot.setVariant(3);
			}
			else if (ET == ETC.BarbarianUnhold)
			{
				loot.setVariant(4);
			}
			else if (ET == ETC.BarbarianUnholdFrost)
			{
				loot.setVariant(5);
			}

			loot.m.Wounds = this.Math.floor((1.0 - target.getHitpointsPct()) * 100.0);
			loot.m.Attributes.Hitpoints = target.m.BaseProperties.Hitpoints;
			loot.m.Attributes.Stamina = target.m.BaseProperties.Stamina;
			loot.m.Attributes.Bravery = target.m.BaseProperties.Bravery;
			loot.m.Attributes.Initiative = target.m.BaseProperties.Initiative;
			loot.m.Attributes.MeleeSkill = target.m.BaseProperties.MeleeSkill;
			loot.m.Attributes.RangedSkill = target.m.BaseProperties.RangedSkill;
			loot.m.Attributes.MeleeDefense = target.m.BaseProperties.MeleeDefense;
			loot.m.Attributes.RangedDefense = target.m.BaseProperties.RangedDefense;
			
			local target_perks = target.getSkills().query(this.Const.SkillType.Perk);
			if(!target.isSummoned())
			{
				foreach(perk in target_perks)
				{
					local quirk = "";
					foreach( i, v in this.getroottable().Const.Perks.PerkDefObjects )
					{
						if (perk.getID() == v.ID)
						{
							quirk = v.Script;
							break;
						}
					}
					if (quirk != "" && loot.m.Quirks.find(quirk) == null)
					{
						loot.m.Quirks.push(quirk);
					}			
				}
			}
			if (target.m.IsMiniboss)
			{
				loot.setName(target.getName());
				loot.m.Quirks.push("scripts/skills/racial/champion_racial");
			}
			//loot.giverandXP();
			if (ET != ETC.Ghoul && ET != ETC.LegendSkinGhoul)
				loot.giverandXP();
			else
			{
				local size = target.getSize();
				
				local day = this.World.getTime().Days;
				if (day > 100)
				{
					day = 100;
				}
				
				if (size == 2)
					loot.m.XP = this.Math.min(this.Const.LevelXP[7], this.Math.max(this.Math.rand(0, day * day), this.Const.LevelXP[4]));
				else if (size == 3)
					loot.m.XP = this.Math.max(this.Math.rand(0, day * day), this.Const.LevelXP[8]);
				else if (size == 1)
					loot.m.XP = this.Math.min(this.Math.rand(0, day * day), this.Const.LevelXP[3]);		
				loot.updateLevel();
			}
			
			
			loot.updateCompanion();
			
			if (actor.getItems().getItemAtSlot(this.Const.ItemSlot.Accessory) == null)
			{				
				actor.getItems().equip(loot);
	
				local unleash = actor.getSkills().getSkillByID("actives.unleash_companion");
				if (unleash != null)
				{
					unleash.m.IsUsed = true;
					unleash.m.IsHidden = unleash.isUsed();
				}
			}
			else if (this.Tactical.State.getStrategicProperties() != null && this.Tactical.State.getStrategicProperties().IsArenaMode)
			{
				this.World.Assets.getStash().add(loot);
			}
			else
			{
				loot.drop(_targetTile);
			}

			if (target.m.WorldTroop != null && ("Party" in target.m.WorldTroop) && target.m.WorldTroop.Party != null && !target.m.WorldTroop.Party.isNull())
			{
				target.m.WorldTroop.Party.removeTroop(target.m.WorldTroop);
			}

			if ((this.isKindOf(target, "lindwurm") || this.isKindOf(target, "legend_stollwurm")) && target.m.Tail != null && !target.m.Tail.isNull() && target.m.Tail.isAlive())
			{
				target.m.Tail.m.IsDying = true;
				target.m.Tail.m.IsAlive = false;
				target.m.Tail.removeFromMap();
				target.m.Tail = null;
			}

			actor.addXP(target.getXPValue());
			target.m.IsDying = true;
			target.m.IsAlive = false;
			if (::Tactical.Entities.getHostilesNum() <= 1)
				::Tactical.Entities.setLastCombatResult(::Const.Tactical.CombatResult.EnemyRetreated);
			target.removeFromMap();
		}
		else
		{
			this.Tactical.EventLog.logEx(this.Const.UI.getColorizedEntityName(actor) + " failed to tame " + this.Const.UI.getColorizedEntityName(target) + " (Chance: " + this.Math.floor(chance) + ", Rolled: " + rolled + ")");
			target.onMissed(this.getContainer().getActor(), this);
			if (this.Math.rand(1, 1000) <= 1000 - chance)
			{
				this.spawnIcon("status_effect_111", _targetTile);
				target.getFlags().add("taming_protection");
				target.m.Skills.add(this.new("scripts/companions/player/companions_taming_protection"));
			}
		}

		return true;
	}
});
