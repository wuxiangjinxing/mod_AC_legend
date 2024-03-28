::modAccessoryCompanions.HooksMod.hook("scripts/skills/actives/legend_skin_ghoul_swallow_whole_skill", function( q ) 
{
	q.onVerifyTarget = @(__original) function(_originTile, _targetTile)
	{
		if (!this.skill.onVerifyTarget(_originTile, _targetTile))
		{
			return false;
		}
		
		local entities = this.Tactical.Entities.getInstancesOfFaction(this.Const.Faction.Player);

		if (entities.len() == 1)
		{
			return false;
		}
		
		local hostilesNum = this.Tactical.Entities.getHostilesNum();
		
		if (hostilesNum == 1)
		{
			return false;
		}

		local target = _targetTile.getEntity();

		if (target == null)
		{
			return false;
		}

		//if (target.getFlags().has("IsSummoned"))
		//{
		//	return false;
		//}
		
		//if ((target.getFaction() != this.Const.Faction.Player) && (this.getContainer().getActor().getFaction() != this.Const.Faction.PlayerAnimals))
		//{
		//	return false;
		//}
		
		local ET = _targetTile.getEntity().getType();
		local ETC = this.Const.EntityType;

		if (ET == ETC.Kraken || ET == ETC.KrakenTentacle)
		{
			return false;
		}
		if (ET == ETC.SkeletonLich || ET == ETC.SkeletonLichMirrorImage || ET == ETC.SkeletonPhylactery || ET == ETC.FlyingSkull)
		{
			return false;
		}
		if (ET == ETC.BarbarianMadman || ET == ETC.TricksterGod)
		{
			return false;
		}
		if (ET == ETC.ZombieBoss)
		{
			return false;
		}
		if (ET == ETC.SkeletonBoss || ET == ETC.SkeletonHeavy || ET == ETC.SkeletonLight || ET == ETC.SkeletonMedium || ET == ETC.SkeletonPriest)
		{
			return false;
		}
		if (ET == ETC.OrcWarlord)
		{
			return false;
		}
		if (ET == ETC.BarbarianChosen)
		{
			return false;
		}
		if (ET == ETC.Lindwurm)
		{
			return false;
		}
		if (ET == ETC.Mortar)
		{
			return false;
		}
		if (ET == ETC.GreenskinCatapult)
		{
			return false;
		}
		if (ET == ETC.Schrat)
		{
			return false;
		}
		if (ET == ETC.LegendOrcBehemoth)
		{
			return false;
		}
		if (ET == ETC.LegendStollwurm)
		{
			return false;
		}
		if (ET == ETC.LegendRockUnhold)
		{
			return false;
		}
		if (ET == ETC.LegendGreenwoodSchrat)
		{
			return false;
		}
		if (ET == ETC.LegendVampireLord || ET == ETC.Vampire)
		{
			return false;
		}
		if (ET == ETC.BanditWarlord)
		{
			return false;
		}
		if (ET == ETC.LegendMummyQueen || ET == ETC.LegendMummyPriest || ET == ETC.LegendMummyMedium || ET == ETC.LegendMummyLight || ET == ETC.LegendMummyHeavy)
		{
			return false;
		}
		if (ET == ETC.LegendOrcElite)
		{
			return false;
		}
		if (ET == ETC.LegendWhiteDirewolf)
		{
			return false;
		}
		if (ET == ETC.LegendSkinGhoul || ET == ETC.Ghoul)
		{
			return false;
		}
		if (ET == ETC.LegendRedbackSpider)
		{
			return false;
		}
		if (ET == ETC.LegendBanshee || ET == ETC.Ghost || ET == ETC.LegendDemonHound)
		{
			return false;
		}
		if (ET == ETC.SandGolem)
		{
			return false;
		}
		
		if(target.m.IsMiniboss)
		{
			return false;
		}

		return this.skill.onVerifyTarget(_originTile, _targetTile) && !_targetTile.getEntity().getCurrentProperties().IsImmuneToKnockBackAndGrab;
	}
	
	q.onUse = @(__original) function(_user, _targetTile)
	{
		local target = _targetTile.getEntity();

		if (!_user.isHiddenToPlayer() && (_targetTile.IsVisibleForPlayer || this.knockToTile.IsVisibleForPlayer))
		{
			this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_user) + " devours " + this.Const.UI.getColorizedEntityName(target));
		}

		local skills = target.getSkills();
		skills.removeByID("effects.shieldwall");
		skills.removeByID("effects.spearwall");
		skills.removeByID("effects.riposte");
		skills.removeByID("effects.legend_vala_chant_disharmony_effect");
		skills.removeByID("effects.legend_vala_chant_fury_effect");
		skills.removeByID("effects.legend_vala_chant_senses_effect");
		skills.removeByID("effects.legend_vala_currently_chanting");
		skills.removeByID("effects.legend_vala_in_trance");

		if (target.getMoraleState() != this.Const.MoraleState.Ignore)
		{
			target.setMoraleState(this.Const.MoraleState.Breaking);
		}

		this.Tactical.getTemporaryRoster().add(target);
		this.Tactical.TurnSequenceBar.removeEntity(target);
		this.m.SwallowedEntity = target;
		this.m.SwallowedEntity.getFlags().set("Devoured", true);
		this.m.SwallowedEntity.setHitpoints(this.Math.max(5, this.m.SwallowedEntity.getHitpoints() - this.Math.rand(10, 20)));
		target.removeFromMap();
		_user.getSprite("body").setBrush("bust_ghoulskin_body_04");
		_user.getSprite("injury").setBrush("bust_ghoul_04_injured");
		_user.getSprite("head").setBrush("bust_ghoulskin_04_head_0" + _user.m.Head);
		_user.m.Sound[this.Const.Sound.ActorEvent.Death] = _user.m.Sound[this.Const.Sound.ActorEvent.Other2];
		local effect = this.new("scripts/skills/effects/swallowed_whole_effect");
		effect.setName(target.getName());
		_user.getSkills().add(effect);

		if (this.m.SoundOnHit.len() != 0)
		{
			this.Sound.play(this.m.SoundOnHit[this.Math.rand(0, this.m.SoundOnHit.len() - 1)], this.Const.Sound.Volume.Skill, _user.getPos());
		}

		return true;
	}
});