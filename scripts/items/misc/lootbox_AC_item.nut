this.lootbox_AC_item <- this.inherit("scripts/items/item", {
	m = {},
	function create()
	{
		this.item.create();
		this.m.ID = "misc.lootbox_AC_item";
		this.m.Name = "Locked Pet Chest";
		this.m.Description = "Locked chest with some wild sounds into. Key to unlock it is forbidden, so breaking chest is only way to release creature captured there.";
		this.m.SlotType = this.Const.ItemSlot.None;
		this.m.ItemType = this.Const.Items.ItemType.Usable;
		this.m.IsUsable = true;
		local dc = this.World.getTime().Days;
		local rdc = this.Math.rand(1, dc);
		local mx = 200 + rdc * 200;
		this.m.Value = this.Math.min(20000, this.Math.rand(200, mx));
		if (this.m.Value < 5000)
			this.m.Icon = "misc/lootbox_AC_1.png";
		else if (this.m.Value < 10000)
			this.m.Icon = "misc/lootbox_AC_2.png";
		else
			this.m.Icon = "misc/lootbox_AC_3.png";
	}
	
	function playInventorySound( _eventType )
	{
		this.Sound.play("sounds/combat/armor_leather_impact_03.wav", this.Const.Sound.Volume.Inventory);
	}

	function getBuyPrice()
	{
		if (this.m.IsSold)
		{
			return this.getSellPrice();
		}

		return this.item.getBuyPrice();
	}

	function getSellPrice()
	{
		if (this.m.IsBought)
		{
			return this.getBuyPrice();
		}

		return this.item.getSellPrice();
	}
	
	function getSellPriceMult()
	{
		return this.World.State.getCurrentTown().getBeastPartsPriceMult();
	}
	
	function onUse( _actor, _item = null )
	{	
		this.World.Assets.getStash().makeEmptySlots(1);		
		
		local value = this.m.Value;
		local chkv = 0;	
		
		local tierRoll = this.Math.rand(1, 10000);		
		local typeRoll = 0;			

		local sum = 0;
		local type = 0;
		local Type = 0;
		
		chkv = 9727 - 0.3145 * value;
		
		//this.logInfo("tierRoll = " + tierRoll + " chkv_t1 = " + chkv);
		
		if (tierRoll < chkv)							//doggos
		{	
			for (local i = 0; i < 9; i++)
			{
				type = i;
				if (i == 7)
					type = 22;
				if (i == 8)
					type = 23;
				sum = sum + this.Math.round(1 / this.Const.Companions.Library[type].PartyStrength * 10000);
			}	

			typeRoll = this.Math.rand(1, sum);
			
			//this.logInfo("typeRoll = " + typeRoll + " sum = " + sum);
			
			sum = 0;
			
			for (local i = 0; i < 9; i++)
			{
				type = i;
				if (i == 7)
					type = 22;
				if (i == 8)
					type = 23;
				
				sum = sum + this.Math.round(1 / this.Const.Companions.Library[type].PartyStrength * 10000);
				
				if (typeRoll <= sum)
				{
					Type = type;
					break;
				}
			}	
		}
		else 
		{
			chkv = chkv + 0.1445 * value + 446;
			
			//this.logInfo("tierRoll = " + tierRoll + " chkv_t2 = " + chkv);
			
			if (tierRoll < chkv)						// 7,9,11,13  - direwolf + spider + nacho
			{	
				for (local i = 0; i < 4; i++)
				{
					type = i * 2 + 7;
					if (i == 3)
						sum = sum + this.Math.round(1 / (this.Const.Companions.Library[type].PartyStrength + 16) * 10000);	
					else					
						sum = sum + this.Math.round(1 / this.Const.Companions.Library[type].PartyStrength * 10000);
				}	
	
				typeRoll = this.Math.rand(1, sum);
				
				//this.logInfo("typeRoll = " + typeRoll + " sum = " + sum);
				
				sum = 0;
				
				
				for (local i = 0; i < 4; i++)
				{
					type = i * 2 + 7;
					if (i == 3)
						sum = sum + this.Math.round(1 / (this.Const.Companions.Library[type].PartyStrength + 16) * 10000);	
					else					
						sum = sum + this.Math.round(1 / this.Const.Companions.Library[type].PartyStrength * 10000);
					
					if (typeRoll <= sum)
					{
						Type = type;
						break;
					}
				}
			}
			else
			{
				chkv = chkv + 0.12 * value + 127;
				
				//this.logInfo("tierRoll = " + tierRoll + " chkv_t3 = " + chkv);
				
				if (tierRoll < chkv)					// 8,10,12,14, 24  - frenzy + alp + snake + d hound
				{
					for (local i = 0; i < 5; i++)
					{
						type = i * 2 + 8;
						if (i == 4)
							type = 24;
						
						sum = sum + this.Math.round(1 / this.Const.Companions.Library[type].PartyStrength * 10000);
					}	
		
					typeRoll = this.Math.rand(1, sum);
					
					//this.logInfo("typeRoll = " + typeRoll + " sum = " + sum);
					
					sum = 0;
					
					for (local i = 0; i < 5; i++)
					{
						type = i * 2 + 8;	
						if (i == 4)
							type = 24;	
						
						sum = sum + this.Math.round(1 / this.Const.Companions.Library[type].PartyStrength * 10000);
						
						if (typeRoll <= sum)
						{
							Type = type;
							break;
						}
					}
				}
				else
				{
					chkv = chkv + 0.04 * value - 200;			// big ones + tome
					
					//this.logInfo("tierRoll = " + tierRoll + " chkv_t4 = " + chkv);
					
					if (tierRoll < chkv)
					{
						for (local i = 0; i < 7; i++)
						{
							type = i + 15;
							
							sum = sum + this.Math.round(1 / this.Const.Companions.Library[type].PartyStrength * 10000);
						}	
			
						typeRoll = this.Math.rand(1, sum);
						
						//this.logInfo("typeRoll = " + typeRoll + " sum = " + sum);
						
						sum = 0;
						
						for (local i = 0; i < 7; i++)
						{
							type = i + 15;	
							
							sum = sum + this.Math.round(1 / this.Const.Companions.Library[type].PartyStrength * 10000);
							
							if (typeRoll <= sum)
							{
								Type = type;
								break;
							}
						}
					}
					else
					{											// legendary
						for (local i = 0; i < 7; i++)
						{
							type = i + 26;
							
							if (i == 3)
								sum = sum + this.Math.round(1 / (this.Const.Companions.Library[type].PartyStrength + 45) * 10000);	
							else					
								sum = sum + this.Math.round(1 / this.Const.Companions.Library[type].PartyStrength * 10000);
						}	
			
						typeRoll = this.Math.rand(1, sum);
						
						//this.logInfo("typeRoll = " + typeRoll + " sum = " + sum);
						
						sum = 0;
						
						for (local i = 0; i < 7; i++)
						{
							type = i + 26;	
							
							if (i == 3)
								sum = sum + this.Math.round(1 / (this.Const.Companions.Library[type].PartyStrength + 45) * 10000);	
							else					
								sum = sum + this.Math.round(1 / this.Const.Companions.Library[type].PartyStrength * 10000);
							
							if (typeRoll <= sum)
							{
								Type = type;
								break;
							}
						}
					}
				}
			}
		}
		
		
		local loot = this.new("scripts/items/accessory/wardog_item");
		loot.setType(Type);
		loot.giverandXP();
		loot.updateCompanion();
						
		this.World.Assets.getStash().add(loot);
		
		local sl = this.Const.Companions.Library[Type].UnleashSounds;
		local rs = this.Math.rand(0, sl.len() - 1);
		this.Sound.play(sl[rs], this.Const.Sound.Volume.Inventory);			
				
		return true;
	}
	
	function onSerialize( _out )
	{
		this.item.onSerialize(_out);
		_out.writeF32(this.m.Value);
	}
	
	
	function onDeserialize( _in )
	{
		this.item.onDeserialize(_in);
		this.m.Value = _in.readF32();
		//_in.readF32();
	}

});

