::modAccessoryCompanions.HooksMod.hook("scripts/states/tactical_state", function( q ) 
{
	q.onInit = @(__original) function()
	{
		::modAccessoryCompanions.scaledCondition = false;
		if(this.World.State.getPlayer() != null)
		{
			local companyStrength = this.World.State.getPlayer().getStrength();
			
			local company = this.World.getPlayerRoster().getAll();
			if (company.len() > this.World.Assets.getBrothersScaleMax() && ("onLevelCompare" in this))
			{
				company.sort(this.onLevelCompare);
			}
	
			local count = 0;
			local companionsStrength = 0;
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
			
			::modAccessoryCompanions.PlayerCompanionsStrength = companionsStrength;
			local pureCompanyStrength = companyStrength - ::modAccessoryCompanions.PlayerCompanionsStrength;
			::modAccessoryCompanions.PlayerCompanionsStrength =  (::modAccessoryCompanions.PlayerCompanionsStrength + pureCompanyStrength * this.Math.rand(0, 5) * 0.01) * ::modAccessoryCompanions.ACOnlyPartyStrengthMultiplier * 0.1;
			if ((25.0 + this.Math.min(companyStrength, 3000.0) * 0.0167) * ::modAccessoryCompanions.EnemyACchanceMult * 0.1  > this.Math.rand(1, 100))  //start from 25% at 0 PS and end at 75% at 3000 PS
			{
				::modAccessoryCompanions.scaledCondition = true;
			}
		}
		__original();
	}
});