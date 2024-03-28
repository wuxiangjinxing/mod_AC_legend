this.legend_demon_shadows_skill <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.legend_demon_shadows";
		this.m.Name = "Realm of Burning Nightmares";
		this.m.Description = "";
		this.m.Icon = "skills/active_160.png";
		this.m.IconDisabled = "skills/active_160_sw.png";
		this.m.Overlay = "active_160";
		this.m.SoundOnUse = [
			"sounds/enemies/dlc2/alp_sleep_01.wav",
			"sounds/enemies/dlc2/alp_sleep_02.wav",
			"sounds/enemies/dlc2/alp_sleep_03.wav",
			"sounds/enemies/dlc2/alp_sleep_04.wav",
			"sounds/enemies/dlc2/alp_sleep_05.wav",
			"sounds/enemies/dlc2/alp_sleep_06.wav",
			"sounds/enemies/dlc2/alp_sleep_07.wav",
			"sounds/enemies/dlc2/alp_sleep_08.wav",
			"sounds/enemies/dlc2/alp_sleep_09.wav",
			"sounds/enemies/dlc2/alp_sleep_10.wav",
			"sounds/enemies/dlc2/alp_sleep_11.wav",
			"sounds/enemies/dlc2/alp_sleep_12.wav"
		];
		this.m.IsUsingActorPitch = true;
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.UtilityTargeted;
		this.m.Delay = 0;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsTargetingActor = false;
		this.m.IsStacking = false;
		this.m.IsAttack = false;
		this.m.IsRanged = false;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsShowingProjectile = false;
		this.m.IsUsingHitchance = false;
		this.m.IsDoingForwardMove = false;
		this.m.IsVisibleTileNeeded = false;
		this.m.ActionPointCost = 3;
		this.m.FatigueCost = 10;
		this.m.MinRange = 3;
		this.m.MaxRange = 10;
		this.m.MaxLevelDifference = 4;
	}

	function onUse( _user, _targetTile )
	{
		local targets = [];
		targets.push(_targetTile);

		for( local i = 0; i != 6; i = i )
		{
			if (!_targetTile.hasNextTile(i))
			{
			}
			else
			{
				local tile = _targetTile.getNextTile(i);
				targets.push(tile);
			}

			i = ++i;
		}
		
		function onApplyDemonShadowsAC( _tile, _entity )
		{
			if (_entity.isNonCombatant())
			{
				return;
			}
			
			if (_entity.getSkills().hasSkill("racial.alp") || ::MSU.isKindOf(_entity, "alp_shadow"))
			{
				return;
			}
			
			this.Tactical.spawnIconEffect("fire_circle", _tile, this.Const.Tactical.Settings.SkillIconOffsetX, this.Const.Tactical.Settings.SkillIconOffsetY, this.Const.Tactical.Settings.SkillIconScale, this.Const.Tactical.Settings.SkillIconFadeInDuration, this.Const.Tactical.Settings.SkillIconStayDuration, this.Const.Tactical.Settings.SkillIconFadeOutDuration, this.Const.Tactical.Settings.SkillIconMovement);
			local sounds = [
				"sounds/combat/fire_01.wav",
				"sounds/combat/fire_02.wav",
				"sounds/combat/fire_03.wav",
				"sounds/combat/fire_04.wav",
				"sounds/combat/fire_05.wav",
				"sounds/combat/fire_06.wav"
			];
			this.Sound.play(sounds[this.Math.rand(0, sounds.len() - 1)], this.Const.Sound.Volume.Actor, _entity.getPos());
			local hitInfo = clone this.Const.Tactical.HitInfo;
			hitInfo.DamageRegular = this.Math.rand(10, 20);
			hitInfo.DamageDirect = 1.0;
			hitInfo.BodyPart = this.Const.BodyPart.Body;
			hitInfo.BodyDamageMult = 1.0;
			hitInfo.FatalityChanceMult = 0.0;
			_tile.getEntity().onDamageReceived(_entity, null, hitInfo);
		}

		local p = {
			Type = "shadows",
			Tooltip = "The boundary to the realm of dreams is erased here, allowing living nightmares to manifest",
			IsPositive = false,
			IsAppliedAtRoundStart = false,
			IsAppliedAtTurnEnd = true,
			IsAppliedOnMovement = true,
			IsAppliedOnEnter = false,
			Timeout = this.Time.getRound() + 4,
			Callback = onApplyDemonShadowsAC,
			function Applicable( _a )
			{
				return true;
			}
		};
		
		foreach( tile in targets )
		{
			if (tile.Properties.Effect != null && tile.Properties.Effect.Type == "shadows")
			{
				tile.Properties.Effect.Timeout = this.Time.getRound() + 2;
			}
			else
			{
				tile.Properties.Effect = clone p;
				local particles = [];

				/*
				for( local i = 0; i < this.Const.Tactical.FireParticles.len(); i = i )
				{
					particles.push(this.Tactical.spawnParticleEffect(true, this.Const.Tactical.FireParticles[i].Brushes, tile, this.Const.Tactical.FireParticles[i].Delay, this.Const.Tactical.FireParticles[i].Quantity, this.Const.Tactical.FireParticles[i].LifeTimeQuantity, this.Const.Tactical.FireParticles[i].SpawnRate, this.Const.Tactical.FireParticles[i].Stages));
					i = ++i;
				}
				*/
				
				for( local i = 0; i < this.Const.Tactical.ShadowFlamesParticles.len(); i = i )
				{
					particles.push(this.Tactical.spawnParticleEffect(true, this.Const.Tactical.ShadowFlamesParticles[i].Brushes, tile, this.Const.Tactical.ShadowFlamesParticles[i].Delay, this.Const.Tactical.ShadowFlamesParticles[i].Quantity, this.Const.Tactical.ShadowFlamesParticles[i].LifeTimeQuantity, this.Const.Tactical.ShadowFlamesParticles[i].SpawnRate, this.Const.Tactical.ShadowFlamesParticles[i].Stages));
					i = ++i;
				}

				this.Tactical.Entities.addTileEffect(tile, tile.Properties.Effect, particles);
			}
		}
		
		local max_shadows = 4;
			
		//this.logInfo("tile =" + r + " isEmpty =" + tile.IsEmpty + " max_shadows =" + max_shadows);
		
		local tiles = [];
		foreach (t in targets)
		{
			if (t.IsEmpty)
				tiles.push(t);
		}
		
		while (tiles.len() > 0)
		{
			local r = this.Math.rand(0, tiles.len() - 1);
			local tile = tiles[r];
			local shadow = this.Tactical.spawnEntity("scripts/entity/tactical/enemies/alp_shadow", tile.Coords.X, tile.Coords.Y);
			shadow.setFaction(_user.getFaction());
			max_shadows = max_shadows - 1;
			
			if (max_shadows < 1)
				break;
			
			tiles.remove(r);
		}

		return true;
	}

});

::Const.Tactical.ShadowFlamesParticles <- [
	{
		Delay = 0,
		Quantity = 230,
		LifeTimeQuantity = 0,
		SpawnRate = 156,
		Brushes = [
			"effect_fire_01",
			"effect_fire_02",
			"effect_fire_03"
		],
		Stages = [
			{
				LifeTimeMin = 0.1,
				LifeTimeMax = 0.1,
				ColorMin = this.createColor("cfe7fe00"),
				ColorMax = this.createColor("cfe4fe00"),
				ScaleMin = 0.5,
				ScaleMax = 0.75,
				RotationMin = 0,
				RotationMax = 359,
				VelocityMin = 60,
				VelocityMax = 100,
				DirectionMin = this.createVec(-0.4, 0.6),
				DirectionMax = this.createVec(0.4, 0.6),
				SpawnOffsetMin = this.createVec(-50, -45),
				SpawnOffsetMax = this.createVec(50, 5),
				ForceMin = this.createVec(0, 50),
				ForceMax = this.createVec(0, 80)
			},
			{
				LifeTimeMin = 0.2,
				LifeTimeMax = 0.5,
				ColorMin = this.createColor("3dbbffff"),
				ColorMax = this.createColor("9fdcfeff"),
				ScaleMin = 0.5,
				ScaleMax = 0.75,
				RotationMin = 0,
				RotationMax = 359,
				VelocityMin = 60,
				VelocityMax = 100,
				DirectionMin = this.createVec(-0.4, 0.6),
				DirectionMax = this.createVec(0.4, 0.6),
				ForceMin = this.createVec(0, 50),
				ForceMax = this.createVec(0, 80)
			},
			{
				LifeTimeMin = 0.2,
				LifeTimeMax = 0.5,
				ColorMin = this.createColor("51e3fcf0"),
				ColorMax = this.createColor("51a4fcf0"),
				ScaleMin = 0.75,
				ScaleMax = 1.0,
				RotationMin = 0,
				RotationMax = 359,
				VelocityMin = 60,
				VelocityMax = 100,
				ForceMin = this.createVec(0, 50),
				ForceMax = this.createVec(0, 80)
			},
			{
				LifeTimeMin = 0.1,
				LifeTimeMax = 0.2,
				ColorMin = this.createColor("00a0d800"),
				ColorMax = this.createColor("00a0d800"),
				ScaleMin = 0.75,
				ScaleMax = 1.0,
				RotationMin = 0,
				RotationMax = 359,
				VelocityMin = 60,
				VelocityMax = 100,
				ForceMin = this.createVec(0, 50),
				ForceMax = this.createVec(0, 80)
			}
		]
	},
	{
		Delay = 100,
		Quantity = 40,
		LifeTimeQuantity = 0,
		SpawnRate = 21,
		Brushes = [
			"ash_01"
		],
		Stages = [
			{
				LifeTimeMin = 0.1,
				LifeTimeMax = 0.2,
				ColorMin = this.createColor("ffffff00"),
				ColorMax = this.createColor("ffffff00"),
				ScaleMin = 0.5,
				ScaleMax = 0.5,
				RotationMin = 0,
				RotationMax = 359,
				VelocityMin = 60,
				VelocityMax = 100,
				DirectionMin = this.createVec(-0.4, 0.6),
				DirectionMax = this.createVec(0.4, 0.6),
				SpawnOffsetMin = this.createVec(-35, -45),
				SpawnOffsetMax = this.createVec(35, 0)
			},
			{
				LifeTimeMin = 2.0,
				LifeTimeMax = 3.0,
				ColorMin = this.createColor("ffffffff"),
				ColorMax = this.createColor("ffffffff"),
				ScaleMin = 0.5,
				ScaleMax = 0.75,
				VelocityMin = 60,
				VelocityMax = 100,
				ForceMin = this.createVec(0, 0),
				ForceMax = this.createVec(0, 10)
			},
			{
				LifeTimeMin = 0.2,
				LifeTimeMax = 0.3,
				ColorMin = this.createColor("ffffff00"),
				ColorMax = this.createColor("ffffff00"),
				ScaleMin = 0.75,
				ScaleMax = 1.0,
				VelocityMin = 0,
				VelocityMax = 0,
				ForceMin = this.createVec(0, -80),
				ForceMax = this.createVec(0, -80)
			}
		]
	}
];

