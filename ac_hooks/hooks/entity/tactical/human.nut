::modAccessoryCompanions.HooksMod.hook("scripts/entity/tactical/human", function( q ) 
{	
	if ("assignRandomEquipment" in q)
	{
		q.assignRandomEquipment = @(__original) function()
		{
			if (("State" in this.Tactical) && this.Tactical.State != null && this.Tactical.State.getStrategicProperties() != null && !this.Tactical.State.getStrategicProperties().IsArenaMode)
			{
				if (::modAccessoryCompanions.isEnableEnemyAC && ::modAccessoryCompanions.scaledCondition && this.getFaction() > this.Const.Faction.PlayerAnimals && ::modAccessoryCompanions.PlayerCompanionsStrength > 0 && !this.isAlliedWithPlayer())
				{
					local tierRoll = this.Math.rand(1, 100);			
					local rollType = 0;
					
					if (tierRoll > this.Math.min(80, 33.0 * (1.0 + ::modAccessoryCompanions.PlayerCompanionsStrength * 0.002)))
					{
						rollType = this.Math.rand(0,8);  				//doggos
						if (rollType == 7)
							rollType = 22;
						if (rollType == 8)
							rollType = 23;
					}
					else if (tierRoll > this.Math.min(60, 16.0 * (1.0 + ::modAccessoryCompanions.PlayerCompanionsStrength * 0.004)))
						rollType = this.Math.rand(0,3) * 2 + 7; 		// 7,9,11,13  - direwolf + spider + nacho
					else if (tierRoll > this.Math.min(40, 6.0 * (1.0 + ::modAccessoryCompanions.PlayerCompanionsStrength * 0.003)))
						rollType = this.Math.rand(0,3) * 2 + 8;			// 8,10,12,14  - frenzy + alp + snake
					else if (tierRoll > this.Math.min(10, 1.0 * (1.0 + ::modAccessoryCompanions.PlayerCompanionsStrength * 0.006)))
					{
						rollType = this.Math.rand(15,20);
						while (rollType == 19)							// big ones
						{
							rollType = 21;
						}
					}
					else 
						rollType = this.Math.rand(26,32);				// legendary
	
					local loot = this.new("scripts/items/accessory/wardog_item");
					loot.setType(rollType);
					loot.giverandXP();
					loot.updateCompanion();
				
					local lootStr = 0;
					if (loot.getType() == this.Const.Companions.TypeList.Nacho && loot.m.Level >= 9)
					{
						lootStr = (this.Const.Companions.Library[loot.getType()].PartyStrength + 22.0) * this.pow(loot.m.Level, 0.17);
					}
					else if (loot.getType() == this.Const.Companions.TypeList.Nacho && loot.m.Level >= 5)
					{
						lootStr = (this.Const.Companions.Library[loot.getType()].PartyStrength + 10.0) * this.pow(loot.m.Level, 0.17);
					}
					else if (loot.getType() == this.Const.Companions.TypeList.SkinGhoul && loot.m.Level >= 9)
					{
						lootStr = (this.Const.Companions.Library[loot.getType()].PartyStrength + 60.0) * this.pow(loot.m.Level, 0.17);
					}
					else if (loot.getType() == this.Const.Companions.TypeList.SkinGhoul && loot.m.Level >= 5)
					{
						lootStr = (this.Const.Companions.Library[loot.getType()].PartyStrength + 25.0) * this.pow(loot.m.Level, 0.17);
					}
					else
					{
						lootStr = this.Const.Companions.Library[loot.getType()].PartyStrength * this.pow(loot.m.Level, 0.17);
					}
					
					if (loot.m.Quirks.find("scripts/skills/racial/champion_racial") != null)
						lootStr *= 2;
				
					if(::modAccessoryCompanions.PlayerCompanionsStrength - lootStr > 0)
					{
						::modAccessoryCompanions.PlayerCompanionsStrength = ::modAccessoryCompanions.PlayerCompanionsStrength - lootStr;
						this.m.Items.equip(loot);
					}
				}
			}
			__original();
			
		}
	}
	else
	{
		q.assignRandomEquipment = @(__original) function()
		{
			if (("State" in this.Tactical) && this.Tactical.State && this.Tactical.State.getStrategicProperties() != null && !this.Tactical.State.getStrategicProperties().IsArenaMode)
			{
				if (::modAccessoryCompanions.isEnableEnemyAC && ::modAccessoryCompanions.scaledCondition && this.getFaction() > this.Const.Faction.PlayerAnimals && ::modAccessoryCompanions.PlayerCompanionsStrength > 0 && !this.isAlliedWithPlayer())
				{
					local tierRoll = this.Math.rand(1, 100);			
					local rollType = 0;
					
					if (tierRoll > this.Math.min(80, 33.0 * (1.0 + ::modAccessoryCompanions.PlayerCompanionsStrength * 0.002)))
					{
						rollType = this.Math.rand(0,8);  				//doggos
						if (rollType == 7)
							rollType = 22;
						if (rollType == 8)
							rollType = 23;
					}
					else if (tierRoll > this.Math.min(60, 16.0 * (1.0 + ::modAccessoryCompanions.PlayerCompanionsStrength * 0.004)))
						rollType = this.Math.rand(0,3) * 2 + 7; 		// 7,9,11,13  - direwolf + spider + nacho
					else if (tierRoll > this.Math.min(40, 6.0 * (1.0 + ::modAccessoryCompanions.PlayerCompanionsStrength * 0.003)))
						rollType = this.Math.rand(0,3) * 2 + 8;			// 8,10,12,14  - frenzy + alp + snake
					else if (tierRoll > this.Math.min(10, 1.0 * (1.0 + ::modAccessoryCompanions.PlayerCompanionsStrength * 0.006)))
					{
						rollType = this.Math.rand(15,20);
						while (rollType == 19)							// big ones
						{
							rollType = 21;
						}
					}
					else 
						rollType = this.Math.rand(26,32);				// legendary
	
					local loot = this.new("scripts/items/accessory/wardog_item");
					loot.setType(rollType);
					loot.giverandXP();
					loot.updateCompanion();
				
					local lootStr = 0;
					if (loot.getType() == this.Const.Companions.TypeList.Nacho && loot.m.Level >= 9)
					{
						lootStr = (this.Const.Companions.Library[loot.getType()].PartyStrength + 22.0) * this.pow(loot.m.Level, 0.17);
					}
					else if (loot.getType() == this.Const.Companions.TypeList.Nacho && loot.m.Level >= 5)
					{
						lootStr = (this.Const.Companions.Library[loot.getType()].PartyStrength + 10.0) * this.pow(loot.m.Level, 0.17);
					}
					else if (loot.getType() == this.Const.Companions.TypeList.SkinGhoul && loot.m.Level >= 9)
					{
						lootStr = (this.Const.Companions.Library[loot.getType()].PartyStrength + 60.0) * this.pow(loot.m.Level, 0.17);
					}
					else if (loot.getType() == this.Const.Companions.TypeList.SkinGhoul && loot.m.Level >= 5)
					{
						lootStr = (this.Const.Companions.Library[loot.getType()].PartyStrength + 25.0) * this.pow(loot.m.Level, 0.17);
					}
					else
					{
						lootStr = this.Const.Companions.Library[loot.getType()].PartyStrength * this.pow(loot.m.Level, 0.17);
					}
					
					if (loot.m.Quirks.find("scripts/skills/racial/champion_racial") != null)
						lootStr *= 2;
				
					if (::modAccessoryCompanions.PlayerCompanionsStrength - lootStr > 0)
					{
						::modAccessoryCompanions.PlayerCompanionsStrength = ::modAccessoryCompanions.PlayerCompanionsStrength - lootStr;
					this.m.Items.equip(loot);
					}
				}
			}
			this.actor.assignRandomEquipment();
		}
	}
});	