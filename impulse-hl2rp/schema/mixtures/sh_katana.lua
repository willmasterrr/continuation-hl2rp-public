local MIX = {}

MIX.Class = "wep_katana"

MIX.Level = 6
MIX.Bench = "general"

MIX.Output = "wep_katana"
MIX.Input = {
	["util_refinedmetalplate"] = {take = 4},
	["util_glue"] = {take = 3},
	["util_plastic"] = {take = 2},
	["util_pipe"] = {take = 2},
}

impulse.RegisterMixture(MIX)
