this.armored_wolf_item <- this.inherit("scripts/items/accessory/wolf_item", {
	m = {},
	function create()
	{
		this.wolf_item.create();
		this.m.ID = "accessory.armored_wolf";
		this.m.Description = "A strong and wild wolf, tamed to be a loyal companion in battle. Can be unleashed in battle for scouting, tracking or running down routing enemies. This one wears a leather coat for protection against cutting wounds.";
		this.m.SlotType = this.Const.ItemSlot.Accessory;
		this.m.IsDroppedAsLoot = true;
		this.m.ShowOnCharacter = false;
		this.m.ArmorScript = "scripts/items/armor/special/warwolf_armor";
		this.m.Value = 800;
	}

	function setEntity( _e )
	{
		this.m.Entity = _e;

		if (this.m.Variant > 2)
		{
			this.m.Variant = this.Math.rand(1, 2);
		}

		local variant = this.m.Variant == 1 ? 2 : 1;

		if (this.m.Entity != null)
		{
			this.m.Icon = "tools/dog_01_leash_70x70.png";
		}
		else
		{
			this.m.Icon = "tools/wolf_0" + variant + "_armor_01_70x70.png";
		}
	}

});

