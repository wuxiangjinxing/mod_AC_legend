::modAccessoryCompanions.HooksMod.hook("scripts/entity/tactical/enemies/legend_skin_ghoul", function( q ) {

	q.onAfterDeath = @() function(_tile)
	{
		if (this.m.Size < 3)
		{
			return;
		}

		local skill = ::Legends.Actives.get(this, ::Legends.Active.LegendSkinGhoulSwallowWhole);
		if (skill == null)
		{
			return;
		}

		local e = skill.getSwallowedEntity();

		if (e == null)
		{
			return;
		}

		e.setIsAlive(true);
		this.Tactical.addEntityToMap(e, _tile.Coords.X, _tile.Coords.Y);
		e.getFlags().set("Devoured", false);

		if (!e.isPlayerControlled())
			this.Tactical.getTemporaryRoster().remove(e);

		this.Tactical.TurnSequenceBar.addEntity(e);

		if (e.hasSprite("dirt"))
		{
			local slime = e.getSprite("dirt");
			slime.setBrush("bust_slime");
			slime.setHorizontalFlipping(!e.isAlliedWithPlayer());
			slime.Visible = true;
		}

		return e;
	}

});