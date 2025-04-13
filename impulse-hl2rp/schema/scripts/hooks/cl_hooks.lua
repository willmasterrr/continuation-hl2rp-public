-- put clientside hooks here, format the same as sv_hooks.lua
local lp = LocalPlayer()

function SCHEMA:PlayerGetKnownName(target)
	if (target:GetSyncVar(SYNC_COS_FACE, 0) == 4 and lp != target) then -- if wearning facewrap
		return "Masked person"
	end
end

function SCHEMA:RagdollMenuAddOptions(panel, body)

	if (lp:Team() == TEAM_CP and lp:GetTeamClass() == CLASS_JURY) and (body:IsRagdoll()) then
		panel:AddAction("impulse/icons/detective-256.png", "Investigate Body", function()
			panel:Remove()
			-- 15 original
			impulse.MakeWorkbar(15, "Inspecting body...", function()

				if not IsValid(body) then return end

				if (impulse.Anim.GetModelClass(body:GetModel()) == "metrocop") then

					if (not IsValid(body) or not lp:IsCP() or not lp:Alive()) then return end


					impulse.MakeWorkbar(15, "Reviewing bodycam footage...", function()
						if (not IsValid(body)) then return end

						net.Start("impulseCheckBody")
						net.WriteEntity(body)
						net.SendToServer()

					end)
				else
					if not IsValid(body) then
						return
					end

					if body:GetModel() == "models/gibs/fast_zombie_legs.mdl" then
						Derma_Message("A skeleton remains, with most of it's flesh ripped off...\nWhat happened here?", "impulse", "Close")
						return
					end

					net.Start("impulseCheckBody")
					net.WriteEntity(body)
					net.SendToServer()
				end
			end)
		end)
	end
end

hook.Add("PickUpThatCanWin", "impulseAchPUTC", function()
	net.Start("impulseAchPUTCWin")
	net.SendToServer()
end)

net.Receive("PlayGestureAnimation", function()
	local ply = net.ReadEntity()
	local value2 = net.ReadString()
	ply:AddVCDSequenceToGestureSlot(GESTURE_SLOT_CUSTOM, ply:LookupSequence(value2), 0, true)
end)

local range = impulse.Config.VortessenceRange ^ 2
local col = Color(138, 43, 226)
LocalPlayer().Scan = LocalPlayer().Scan or false
local plys = {}
function SCHEMA:PreDrawHalos()
	if not Scan and LocalPlayer().VortWallhack then
		local pos = LocalPlayer():GetPos()
		plys = {}

		for v,k in pairs(player.GetAll()) do
			if not k:GetNoDraw() and k.GetPos(k):DistToSqr(pos) < range then
				table.insert(plys, k)
			end
		end
		LocalPlayer().Scan = true
		halo.Add(plys, col, 5, 5, 1, nil, true)
	end
end