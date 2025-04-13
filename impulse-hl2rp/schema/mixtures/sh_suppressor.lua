local MIX = {}

MIX.Class = "att_suppressor"

MIX.Level = 4
MIX.Bench = "general"

MIX.Output = "att_suppressor"
MIX.Input = {
	["util_plastic"] = {take = 2},
	["util_glue"] = {take = 1},
}

impulse.RegisterMixture(MIX)
