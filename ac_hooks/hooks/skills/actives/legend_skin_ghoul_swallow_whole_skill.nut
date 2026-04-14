::modAccessoryCompanions.HooksMod.hook("scripts/skills/actives/legend_skin_ghoul_swallow_whole_skill", function( q ) {

	q.m.SwallowedKill <- [];

	q.onVerifyTarget = @(__original) function(_originTile, _targetTile)
	{
		if (!this.skill.onVerifyTarget(_originTile, _targetTile))
			return false;

		local entities = this.Tactical.Entities.getInstancesOfFaction(this.Const.Faction.Player);

		if (entities.len() == 1)
			return false;

		local hostilesNum = this.Tactical.Entities.getHostilesNum();

		if (hostilesNum == 1)
			return false;

		local target = _targetTile.getEntity();

		if (target == null)
			return false;

		// The removed vanilla functions, doesn't apply any more

		//if (target.getFlags().has("IsSummoned"))
		//{
		//	return false;
		//}

		//if ((target.getFaction() != this.Const.Faction.Player) && (this.gIsontainer().getActor().getFaction() != this.Const.Faction.PlayerAnimals))
		//{
		//	return false;
		//}

		// Adding checks to stop bad interactions with specific entities and cheesing others
		local Who = _targetTile.getEntity().getType();
		local Is = this.Const.EntityType;

		// Legendary location entities
		if (Who == Is.Kraken || Who == Is.KrakenTentacle)
			return false;
		if (Who == Is.SkeletonLich || Who == Is.SkeletonLichMirrorImage || Who == Is.SkeletonPhylactery || Who == Is.FlyingSkull)
			return false;
		if (Who == Is.BarbarianMadman || Who == Is.TricksterGod)
			return false;

		// Greenskin and high tier enemies
		if (Who == Is.OrcWarlord || Who == Is.LegendOrcBehemoth || Who == Is.LegendOrcElite)
			return false;
		if (Who == Is.LegendRobberBaron || Who == Is.BarbarianChosen)
			return false;

		// Siege weapons
		if (Who == Is.Mortar || Who == Is.GreenskinCatapult)
			return false;

		// Beasts and their Legendary counterparts
		if (Who == Is.SandGolem || Who == Is.Schrat || Who == Is.LegendGreenwoodSchrat)
			return false;
		if (Who == Is.Lindwurm || Who == Is.LegendStollwurm)
			return false;
		if (Who == Is.LegendRedbackSpider || Who == Is.LegendWhiteDirewolf || Who == Is.LegendRockUnhold || Who == Is.LegendSkinGhoul)
			return false;

		// Undead entities
		if (Who == Is.LegendVampireLord || Who == Is.Vampire)
			return false;
		if (Who == Is.LegendMummyQueen || Who == Is.LegendMummyPriest || Who == Is.LegendMummyHeavy)
			return false;
		if (Who == Is.LegendBanshee || Who == Is.Ghost || Who == Is.LegendDemonHound)
			return false;
		if (Who == Is.ZombieBoss)
			return false;
		if (Who == Is.SkeletonBoss || Who == Is.SkeletonHeavy || Who == Is.SkeletonPriest)
			return false;

		// Champion entities
		if(target.m.IsMiniboss)
			return false;

		return this.skill.onVerifyTarget(_originTile, _targetTile) && !_targetTile.getEntity().getCurrentProperties().IsImmuneToKnockBackAndGrab;
	}

	q.onUse = @(__original) function(_user, _targetTile)
	{
		local target = _targetTile.getEntity();

		if (!_user.isHiddenToPlayer() && (_targetTile.IsVisibleForPlayer || this.knockToTile.IsVisibleForPlayer))
			this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_user) + " devours " + this.Const.UI.getColorizedEntityName(target));

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
			target.setMoraleState(this.Const.MoraleState.Breaking);

		this.Tactical.getTemporaryRoster().add(target);
		this.Tactical.TurnSequenceBar.removeEntity(target);
		this.m.SwallowedKill.push([target, _user]);
		this.m.SwallowedEntity = target;
		this.m.SwallowedEntity.getFlags().set("Devoured", true);
		this.m.SwallowedEntity.setHitpoints(this.Math.max(5, this.m.SwallowedEntity.getHitpoints() - this.Math.rand(10, 20)));
		target.removeFromMap();
		_user.getSprite("body").setBrush("bust_ghoul_body_04");
		_user.getSprite("injury").setBrush("bust_ghoul_04_injured");
		_user.getSprite("head").setBrush("bust_ghoul_04_head_0" + _user.m.Head);
		_user.m.Sound[this.Const.Sound.ActorEvent.Death] = _user.m.Sound[this.Const.Sound.ActorEvent.Other2];
		local effect = this.new("scripts/skills/effects/swallowed_whole_effect");
		effect.setName(target.getName());
		_user.getSkills().add(effect);

		if (this.m.SoundOnHit.len() != 0)
			this.Sound.play(this.m.SoundOnHit[this.Math.rand(0, this.m.SoundOnHit.len() - 1)], this.Const.Sound.Volume.Skill, _user.getPos());

		return true;
	}

	q.onCombatFinished = @(__original) function()
	{
		while(this.m.SwallowedKill.len() != 0)
		{
			local pair = this.m.SwallowedKill.pop();
			pair[0].kill(pair[1], this, this.Const.FatalityType.Kraken, true);
		}
		__original();
	}

});