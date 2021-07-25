this.delz_darkvision_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {},
	function create()
	{
		this.character_trait.create();
		this.m.ID = "trait.delz_darkvision";
		this.m.Name = "Darkvision";
		this.m.Icon = "ui/perks/nightvision_circle.png";
		this.m.Description = "This character can see fine in the dark.";
		this.m.IsHidden = false;
		this.m.Titles = [
			"the Bat",
			"the Nocturnal"
		];
		this.m.Excluded = [
			"trait.short_sighted",
			"trait.night_blind",
			"trait.legend_diurnal"
		];
	}

	function getTooltip()
	{
		return [
			{
				id = 1,
				type = "title",
				text = this.getName()
			},
			{
				id = 2,
				type = "description",
				text = this.getDescription()
			},
			{
				id = 10,
				type = "text",
				icon = "ui/perks/nightvision_circle.png",
				text = "Unaffected By Night"
			}
		];
	}

	function onUpdate( _properties )
	{
		_properties.IsAffectedByNight = false;

	}

});

