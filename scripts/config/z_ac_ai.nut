local id = ::Const.AI.Behavior.ID.COUNT;

::Const.AI.Behavior.ID.UnleashCompanion <- id;
::Const.AI.Behavior.Name.push("AC.UnleashCompanion");
id++;

::Const.AI.Behavior.ID.COUNT = id;

::Const.AI.Behavior.Order.UnleashCompanion <- this.Const.AI.Behavior.Order.Adrenaline;
::Const.AI.Behavior.Score.UnleashCompanion <- 700;