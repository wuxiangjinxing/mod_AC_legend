this.beast_tamer_intro_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.beast_tamer_intro";
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_95.png[/img]The villagers of %home% spoke of demons in the woods. Of beasts and eyes that gleamed like coals in the brush. Of livestock torn apart, entrails picked clean. But you and yours knew better. You were Tamers. You raised beasts not to terrorise, but to serve. Every fang you broke, every claw you trained, was a blade turned against worse things still.\n\nThe truth didn\'t matter. Fear never listens.\n\nThey came at dusk with torches in hand, pitchforks sharpened, smoke curling through the trees before the shouting ever reached your ears. Had it not been for %bro1%, the village houndmaster who knew about the lives you saved, you\'d have burned with the rest.\n\nThey came running, breathless and wide-eyed. You had minutes. Maybe less.\n\nA few of you fled, yourself, %bro2%, and %bro3%. No time to gather your full packs, only what you could leash, lift, or call. The rest… stayed.\n\nNow you walk the roads as outlaws with collars in your packs and beasts at your side. The world fears what it doesn\'t understand. But you remember. You\'ll always remember.",
			Image = "",
			Banner = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "You\'ll remember who the real monsters are.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = "ui/banners/" + this.World.Assets.getBanner() + "s.png";
			}

		});
	}

	function onUpdateScore()
	{
		return;
	}

	function onPrepare()
	{
		this.m.Title = "The " + this.World.Assets.getName();
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"home",
			this.World.Flags.get("HomeVillage")
		]);

		local brothers = this.World.getPlayerRoster().getAll();
		_vars.push([
			"bro1",
			brothers[0].getName()
		]);
		_vars.push([
			"bro2",
			brothers[1].getName()
		]);
		_vars.push([
			"bro3",
			brothers[2].getName()
		]);
	}

	function onClear()
	{
	}

});