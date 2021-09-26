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
		this.m.IsUsingHitchance = true;

		this.m.ActionPointCost = 6;
		this.m.FatigueCost = 30;
		this.m.MinRange = 1;
		this.m.MaxRange = 1;

		this.m.Name = "Tame Beast";
		this.m.Description = "Attempt to tame an adjacent beast. The success rate increases if the target is more wounded. Failing the attempt can make further attempts on the same beast impossible. Succeeding the attempt equips the beast in the brother\'s accessory slot, but it cannot be unleashed in the same battle.";
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
			},
			{
				id = 4,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Cannot tame the last enemy on the battlefield"
			}			
		];
		return ret;
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		local tamechanceHP = 30;
		foreach(beastmaster in this.Const.Companions.BeastMasters)
		{
			if (this.getContainer().hasSkill(beastmaster[0]))
			{
				tamechanceHP += (beastmaster[1] * 1000);
			}
		}		
		if (_skill == this)
		{
			_properties.MeleeSkill += ((1.0 - _targetEntity.getHitpointsPct()) * tamechanceHP);
			_properties.MeleeSkill -= 50;
		}
	}
	
	function getHitchance( _targetEntity )
	{
		if (this.Tactical.Entities.getHostilesNum() <= 1)
		{
			return 0;
		}
		else
		{
			return this.skill.getHitchance( _targetEntity );
		}
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
		if (target.getFlags().has("taming_protection"))
		{
			return false;
		}
		if (this.isKindOf(target, "lindwurm_tail"))
		{
			return false;
		}

		local actor = this.getContainer().getActor();
		
		if (this.isKindOf(target, "legend_demon_hound") && !actor.getSkills().hasSkill("perk.legend_raise_undead"))
		{
			return false;
		}
		if (actor.isAlliedWith(target))
		{
			return false;
		}

		local tamable = this.Const.Companions.TameList.find(target.getName());

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
		local chance = this.getHitchance(target);

		if (this.Math.rand(1, 100) <= chance)
		{
			this.Tactical.EventLog.logEx(this.Const.UI.getColorizedEntityName(actor) + " successfully tamed " + this.Const.UI.getColorizedEntityName(target));
			local loot = this.new("scripts/items/accessory/wardog_item");
			loot.setType(this.Const.Companions.Library[this.Const.Companions.TameList.find(target.getName())].Type);

			local ET = _targetTile.getEntity().m.Type;
			local ETC = this.Const.EntityType;

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
			if (target.m.IsMiniboss)
			{
				loot.m.Quirks.push("scripts/skills/racial/champion_racial");
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

			if (this.isKindOf(target, "lindwurm") && target.m.Tail != null && !target.m.Tail.isNull() && target.m.Tail.isAlive())
			{
				target.m.Tail.m.IsDying = true;
				target.m.Tail.m.IsAlive = false;
				target.m.Tail.removeFromMap();
				target.m.Tail = null;
			}

			actor.addXP(target.getXPValue());
			target.m.IsDying = true;
			target.m.IsAlive = false;
			target.removeFromMap();
		}
		else
		{
			this.Tactical.EventLog.logEx(this.Const.UI.getColorizedEntityName(actor) + " failed to tame " + this.Const.UI.getColorizedEntityName(target));
			target.onMissed(this.getContainer().getActor(), this);
			if (this.Math.rand(1, 100) <= 100 - chance)
			{
				this.spawnIcon("status_effect_111", _targetTile);
				target.getFlags().add("taming_protection");
				target.m.Skills.add(this.new("scripts/companions/player/companions_taming_protection"));
			}
		}

		return true;
	}
});
