// load all hooks related to config
foreach (file in ::IO.enumerateFiles("ac_hooks/config"))
{
	::include(file);
}

// load all hooks related to vanilla and legends
foreach (file in ::IO.enumerateFiles("ac_hooks/hooks"))
{
	::include(file);
}