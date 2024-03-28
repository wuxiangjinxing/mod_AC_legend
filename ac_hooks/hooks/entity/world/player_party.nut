::modAccessoryCompanions.HooksMod.hook("scripts/entity/world/player_party", function( q ) 
{
	q.updateStrength = @(__original) function(_addACStrength = true)
	{
		__original();
		
		if (_addACStrength)
		{
			local companionsStrength = 0.0;
			if(this.World.State.getPlayer() != null)
			{
				
				local company = this.World.getPlayerRoster().getAll();
				if (company.len() > this.World.Assets.getBrothersScaleMax())
				{
					company.sort(this.onLevelCompare);
				}
	
				local count = 0;
				foreach( i, bro in company )
				{
					if (i >= this.World.Assets.getBrothersScaleMax())
					{
						break;
					}
					
					local companion = bro.getItems().getItemAtSlot(this.Const.ItemSlot.Accessory);
					if (companion != null && "setType" in companion)
					{
						local mult = 1.0;
						if (companion.m.Quirks.find("scripts/skills/racial/champion_racial") != null)
							mult = 2.0;
						
						if (companion.getType() == this.Const.Companions.TypeList.Nacho && companion.m.Level >= 9)
						{
							companionsStrength += count + (this.Const.Companions.Library[companion.getType()].PartyStrength + 22.0) * this.pow(companion.m.Level, 0.17) * mult;
						}
						else if (companion.getType() == this.Const.Companions.TypeList.Nacho && companion.m.Level >= 5)
						{
							companionsStrength += count + (this.Const.Companions.Library[companion.getType()].PartyStrength + 10.0) * this.pow(companion.m.Level, 0.17) * mult;
						}
						else if (companion.getType() == this.Const.Companions.TypeList.SkinGhoul && companion.m.Level >= 9)
						{
							companionsStrength += count + (this.Const.Companions.Library[companion.getType()].PartyStrength + 60.0) * this.pow(companion.m.Level, 0.17) * mult;
						}
						else if (companion.getType() == this.Const.Companions.TypeList.SkinGhoul && companion.m.Level >= 5)
						{
							companionsStrength += count + (this.Const.Companions.Library[companion.getType()].PartyStrength + 25.0) * this.pow(companion.m.Level, 0.17) * mult;
						}
						else 
						{
							companionsStrength += count + this.Const.Companions.Library[companion.getType()].PartyStrength * this.pow(companion.m.Level, 0.17) * mult;
						}
						count++;
					}
					
					local companions;
					if (bro.getSkills().hasSkill("perk.legend_packleader"))
					{
						companions = bro.getItems().getAllItemsAtSlot(this.Const.ItemSlot.Bag);
					
						if (companions != null)
						{
							foreach (j, c in companions)
							{
								local companion = c;
								if (companion != null && "setType" in companion)
								{
									local mult = 0.75;
									if (companion.m.Quirks.find("scripts/skills/racial/champion_racial") != null)
										mult = 1.5;
									
									if (companion.getType() == this.Const.Companions.TypeList.Nacho && companion.m.Level >= 9)
									{
										companionsStrength += count + (this.Const.Companions.Library[companion.getType()].PartyStrength + 22.0) * this.pow(companion.m.Level, 0.17) * mult;
									}
									else if (companion.getType() == this.Const.Companions.TypeList.Nacho && companion.m.Level >= 5)
									{
										companionsStrength += count + (this.Const.Companions.Library[companion.getType()].PartyStrength + 10.0) * this.pow(companion.m.Level, 0.17) * mult;
									}
									else if (companion.getType() == this.Const.Companions.TypeList.SkinGhoul && companion.m.Level >= 9)
									{
										companionsStrength += count + (this.Const.Companions.Library[companion.getType()].PartyStrength + 60.0) * this.pow(companion.m.Level, 0.17) * mult;
									}
									else if (companion.getType() == this.Const.Companions.TypeList.SkinGhoul && companion.m.Level >= 5)
									{
										companionsStrength += count + (this.Const.Companions.Library[companion.getType()].PartyStrength + 25.0) * this.pow(companion.m.Level, 0.17) * mult;
									}
									else 
									{
										companionsStrength += count + this.Const.Companions.Library[companion.getType()].PartyStrength * this.pow(companion.m.Level, 0.17) * mult;
									}
									count++;
								}
							}
						}
					}
				}
				
				companionsStrength = companionsStrength * ::modAccessoryCompanions.ACPartyStrengthMultiplier * 0.1;
			}
			
			this.m.Strength += companionsStrength;
		}
	}
	
	q.getStrength = @(__original) function(_addACStrength = true)
	{
		this.updateStrength();
		return this.m.Strength;
	}			
});