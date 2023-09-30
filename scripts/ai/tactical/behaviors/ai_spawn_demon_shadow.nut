this.ai_spawn_demon_shadow <- this.inherit("scripts/ai/tactical/behavior", {
	m = {
		PossibleSkills = [
			"actives.legend_demon_shadows"
		],
		Selection = null,
		Skill = null
	},
	function create()
	{
		this.m.ID = this.Const.AI.Behavior.ID.SpawnShadow;
		this.m.Order = this.Const.AI.Behavior.Order.SpawnShadow;
		this.m.IsThreaded = false;
		this.behavior.create();
	}

	function onEvaluate( _entity )
	{
		// Function is a generator.
		this.m.Selection = null;
		this.m.Skill = null;

		local scoreMult = this.getProperties().BehaviorMult[this.m.ID];
		local time = this.Time.getExactTime();
		
		if (_entity.getActionPoints() < this.Const.Movement.AutoEndTurnBelowAP)
		{
			return this.Const.AI.Behavior.Score.Zero;
		}

		if (_entity.getMoraleState() == this.Const.MoraleState.Fleeing)
		{
			return this.Const.AI.Behavior.Score.Zero;
		}

		if (!this.getAgent().hasVisibleOpponent())
		{
			return this.Const.AI.Behavior.Score.Zero;
		}
		
		this.m.Skill = this.selectSkill(this.m.PossibleSkills);

		if (this.m.Skill == null)
		{
			return this.Const.AI.Behavior.Score.Zero;
		}
		
		local apRequiredForUse = this.m.Skill.getActionPointCost();
		
		if (_entity.getTile().hasZoneOfOccupationOtherThan(_entity.getAlliedFactions()) || _entity.getActionPoints() < apRequiredForUse)
		{
			return this.Const.AI.Behavior.Score.Zero;
		}
		
		local myTile = _entity.getTile();
		local tiles = [];
		
		this.Tactical.queryTilesInRange(myTile, 3, 10, false, [], this.onQueryTile, tiles);
		
		local ret = {
			Score = 0,
			Target = null
		};

		local targets = [];

		foreach( tile in tiles )
		{
			if (this.m.Skill != null && !this.m.Skill.isUsableOn(tile))
			{
				continue;
			}

			if (tile.IsOccupiedByActor)
			{
				if (tile.getEntity().isAlliedWith(_entity))
				{
					continue;
				}
				else
					targets.push(tile.getEntity());
			}
			else 
			{
				continue;
			}
		}

		foreach( target in targets )
		{
			local score = 0.0;
			local counter = 0;
			local alliesHit = 0;
			
			local targetTile = target.getTile();	

			if (targetTile.Type == this.Const.Tactical.TerrainType.ShallowWater || targetTile.Type == this.Const.Tactical.TerrainType.DeepWater)
			{
				continue;
			}	
				
			local s = this.queryTargetValue(_entity, target, null);
			
			s = s + this.Math.max(0, 11 - myTile.getDistanceTo(targetTile));
			
			counter = 0;
			for( local i = 0; i < 6; i = ++i )
			{
				if (targetTile.getNextTile(i).getEntity() != null)
				{
					if (targetTile.getNextTile(i).IsOccupiedByActor && targetTile.getNextTile(i).getEntity().isAlliedWith(_entity) && targetTile.getNextTile(i).getEntity().getType() != this.Const.EntityType.AlpShadow)
						alliesHit = alliesHit + 1;
					counter = counter + 1;
				}
			}
			
			if (counter > 2)
				s = s * (6 - counter) * 0.25;
			
			if (s == 0)
				continue;
			
			if (myTile.getDistanceTo(targetTile) <= target.getIdealRange())
			{
				s = s + this.Const.AI.Behavior.HorrorAttackingMeBonus;
			}

			if (target.getCurrentProperties().IsStunned || target.getCurrentProperties().IsRooted)
			{
				s = s * this.Const.AI.Behavior.ThrowBombStunnedMult;
			}

			if (target.getHitpoints() <= 20)
			{
				s = s * this.Const.AI.Behavior.ThrowBombInstakillMult;
			}
			
			if (target.getMoraleState() == this.Const.MoraleState.Fleeing)
			{
				s = s * 0.5;
			}

			score = score + s;
			
			if (score > ret.Score && alliesHit < 2)
			{
				ret.Score = score;
				ret.Target = targetTile;
			}
		
		}
		
		scoreMult = scoreMult * this.getFatigueScoreMult(this.m.Skill);
		
		if (ret == null)
		{
			return this.Const.AI.Behavior.Score.Zero;
		}
		else
		{
			this.m.Selection = ret;
			
			return this.Const.AI.Behavior.Score.SpawnShadow * this.m.Selection.Score * scoreMult;
		}
	}

	function onTurnStarted()
	{
	}

	function onExecute( _entity )
	{
		if (this.m.Skill != null)
		{
			if (this.Const.AI.VerboseMode)
			{
				this.logInfo("* " + _entity.getName() + ": Using " + this.m.Skill.getName() + "!");
			}

			this.m.Skill.use(this.m.Selection.Target);

			if (_entity.isAlive() && (!_entity.isHiddenToPlayer() || this.m.Selection.Target.IsVisibleForPlayer))
			{
				this.getAgent().declareAction();
				this.getAgent().declareEvaluationDelay();
			}
			
			this.getAgent().adjustCameraToTarget(this.m.Selection.Target);

			this.m.Selection = null;
			this.m.Skill = null;
		}
	
		
		//this.getAgent().declareEvaluationDelay(1000);
		return true;
	}
	
	function onQueryTile( _tile, _tag )
	{
		_tag.push(_tile);
	}

	function onSortByScore( _a, _b )
	{
		if (_a.Score > _b.Score)
		{
			return -1;
		}
		else if (_a.Score < _b.Score)
		{
			return 1;
		}

		return 0;
	}

});

