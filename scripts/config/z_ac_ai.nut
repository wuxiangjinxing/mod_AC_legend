local gt = this.getroottable();

local id = gt.Const.AI.Behavior.ID.COUNT;

gt.Const.AI.Behavior.ID.UnleashCompanion <- id;
gt.Const.AI.Behavior.Name.push("AC.UnleashCompanion");
id++;

gt.Const.AI.Behavior.ID.COUNT = id;

gt.Const.AI.Behavior.Order.UnleashCompanion <- this.Const.AI.Behavior.Order.Adrenaline;
gt.Const.AI.Behavior.Score.UnleashCompanion <- 700;