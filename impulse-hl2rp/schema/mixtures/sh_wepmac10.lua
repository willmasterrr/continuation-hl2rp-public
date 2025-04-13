local MIX = {}

MIX.Class = "wepmac10"

MIX.Level = 2
MIX.Bench = "weapon"

MIX.Output = "wep_mac10"
MIX.Input = {
	["util_pipe"] = {take = 1},
	["util_glue"] = {take = 2},
	["util_gear"] = {take = 1},
	["util_metalplate"] = {take = 8}
}

impulse.RegisterMixture(MIX)
