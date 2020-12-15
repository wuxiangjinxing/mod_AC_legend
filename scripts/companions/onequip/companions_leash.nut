this.companions_leash <- this.inherit("scripts/skills/skill", {
	m = {
		Item = null
	},
	function create()
	{
		this.m.ID = "actives.leash_companion";
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.NonTargeted + 5;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = false;
		this.m.IsTargetingActor = true;
		this.m.IsUsingHitchance = false;
		this.m.ActionPointCost = 3;
		this.m.FatigueCost = 15;
		this.m.MinRange = 1;
		this.m.MaxRange = 6;
	}

	function getItem()
	{
		return this.m.Item;
	}

	function setItem( _i )
	{
		if (typeof _i == "instance")
		{
			this.m.Item = _i;
		}
		else
		{
			this.m.Item = this.WeakTableRef(_i);
		}
	}

	function applyCompanionModification()
	{
		if (this.m.Item == null || this.m.Item.isNull())
		{
			return;
		}

		this.m.Name = "Leash " + this.m.Item.m.Name;
		this.m.Description = "Call " + this.m.Item.m.Name + " back and re-leash them, removing them from the battlefield. " + this.m.Item.m.Name + " cannot be charmed, stunned, rooted or fleeing, and must be within this character\'s vision range.";
		this.m.Icon = this.Const.Companions.Library[this.m.Item.m.Type].Leash.Icon(this.m.Item.m.Variant);
		this.m.IconDisabled = this.Const.Companions.Library[this.m.Item.m.Type].Leash.IconDisabled(this.m.Item.m.Variant);
		this.m.Overlay = this.Const.Companions.Library[this.m.Item.m.Type].Leash.Overlay;
		this.m.SoundOnUse = this.Const.Companions.Library[this.m.Item.m.Type].InventorySounds;
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
				icon = "ui/icons/vision.png",
				text = "Has a max range of [color=" + this.Const.UI.Color.PositiveValue + "]" + this.m.MaxRange + "[/color] tiles"
			}
		];
		return ret;
	}

	function isUsable()
	{
		if (!this.m.Item.isUnleashed() || !this.skill.isUsable())
		{
			return false;
		}

		return true;
	}

	function onUpdate( _properties )
	{
		this.applyCompanionModification();
		this.m.IsHidden = !this.m.Item.isUnleashed();
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		local companion = this.m.Item.m.Entity;
		local target = _targetTile.getEntity();
		local actor = this.getContainer().getActor();
		local distance = _targetTile.getDistanceTo(actor.getTile());
		local range = this.Math.min(this.m.MaxRange, actor.getCurrentProperties().getVision());

		if (distance > range)
		{
			return false;
		}

		if (target != companion)
		{
			return false;
		}

		if (!target.isAlliedWith(actor))
		{
			return false;
		}

		if (target.getCurrentProperties().IsStunned)
		{
			return false;
		}

		if (target.getCurrentProperties().IsRooted)
		{
			return false;
		}

		if (target.getMoraleState() == this.Const.MoraleState.Fleeing)
		{
			return false;
		}

		return this.skill.onVerifyTarget(_originTile, _targetTile);
	}

	function onUse( _user, _targetTile )
	{
		local entity = _targetTile.getEntity();

		if (this.isKindOf(entity, "companions_noodle") && entity.m.Tail != null && !entity.m.Tail.isNull() && entity.m.Tail.isAlive())
		{
			entity.m.Tail.m.IsTurnDone = true;
			entity.m.Tail.removeFromMap();
		}

		entity.m.IsTurnDone = true;
		entity.removeFromMap();
		this.m.Item.setEntity(null);
		this.m.IsHidden = !this.m.Item.isUnleashed();
		return true;
	}

});

