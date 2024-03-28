::modAccessoryCompanions.HooksMod.hook("scripts/items/misc/wardog_heavy_armor_upgrade_item", function( q ) 
{
	// wardogs and warhounds retain their name, variant, level, XP, attributes and quirks after an armor upgrade
	q.onUse = @(__original) function(_actor, _item = null)
	{
		local dog = _item == null ? _actor.getItems().getItemAtSlot(this.Const.ItemSlot.Accessory) : _item;
		if (dog == null || !("setType" in dog))
		{
			return false;
		}

		local new_dog;
		switch (dog.getType()) 
		{
		    case this.Const.Companions.TypeList.Wardog:
		    case this.Const.Companions.TypeList.WardogArmor:
		        new_dog = this.new("scripts/items/accessory/heavily_armored_wardog_item");
				new_dog.setType(this.Const.Companions.TypeList.WardogArmorHeavy);
		        break;

		    case this.Const.Companions.TypeList.Warhound:
		    case this.Const.Companions.TypeList.WarhoundArmor:
		       	new_dog = this.new("scripts/items/accessory/heavily_armored_warhound_item");
				new_dog.setType(this.Const.Companions.TypeList.WarhoundArmorHeavy);
		        break;

		    case this.Const.Companions.TypeList.Warwolf:
		    case this.Const.Companions.TypeList.WarwolfArmor:
		       	new_dog = this.new("scripts/items/accessory/heavily_armored_wolf_item");
				new_dog.setType(this.Const.Companions.TypeList.WarwolfArmorHeavy);
		        break;
		
		    default:
		    	return false;
		}

		new_dog.setName(dog.getName());
		new_dog.setVariant(dog.getVariant());
		new_dog.setLevel(dog.getLevel());
		new_dog.setXP(dog.getXP());
		new_dog.setWounds(dog.getWounds());
		new_dog.setAttributes(dog.getAttributes());
		new_dog.setQuirks(dog.getQuirks());
		new_dog.setEntity(dog.getEntity());
		new_dog.updateCompanion();
		_actor.getItems().unequip(dog);
		_actor.getItems().equip(new_dog);
		this.Sound.play("sounds/combat/armor_leather_impact_03.wav", this.Const.Sound.Volume.Inventory);
		return true;
	}
});