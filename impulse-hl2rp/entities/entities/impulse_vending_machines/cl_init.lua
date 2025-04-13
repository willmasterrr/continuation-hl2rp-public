include('shared.lua')

	local draw_SimpleText = draw.SimpleText
	local glowMaterial = Material("sprites/glow04_noz")

	local color_green = Color(0, 255, 0, 255)
	local color_red = Color(255, 0, 0, 255)
	local color_orange = Color(255, 125, 0, 255)

	function ENT:Initialize()
		self.buttons = {}

		local position = self:GetPos()
		local f, r, u = self:GetForward(), self:GetRight(), self:GetUp()

		self.buttons[1] = position + f*18 + r*-24.7 + u*4
		self.buttons[2] = position + f*18 + r*-24.7 + u*2
		self.buttons[3] = position + f*18 + r*-24.7 + u*0
	end

	function ENT:Draw()
		self:DrawModel()

		local position = self:GetPos()
		local angles = self:GetAngles()
		angles:RotateAroundAxis(angles:Up(), 90)
		angles:RotateAroundAxis(angles:Forward(), 90)

		local f, r, u = self:GetForward(), self:GetRight(), self:GetUp()

		cam.Start3D2D(position + f*18 + r*-19.5 + u*5.75, angles, 0.06)
			draw_SimpleText("Regular", "Impulse-Elements18", 0, 12, color_white, 0, 0)
			draw_SimpleText("Sparkling", "Impulse-Elements18", -3, 48, color_white, 0, 0)
			draw_SimpleText("Special", "Impulse-Elements18", 0, 84, color_white, 0, 0)
		cam.End3D2D()

		render.SetMaterial(glowMaterial)

		if (self.buttons) then
			self.buttons[1] = position + f*18 + r*-24.7 + u*4
			self.buttons[2] = position + f*18 + r*-24.7 + u*2
			self.buttons[3] = position + f*18 + r*-24.7 + u*0

			local closest = self:getNearestButton()
			local stocks = util.JSONToTable(self:GetStocks());

			for k, v in pairs(self.buttons) do
				local color = color_green

				if (self:GetActive()) then
					if (stocks and stocks[k] and stocks[k] < 1) then
						color = color_red
						color.a = 200
					end

					if (closest != k) then
						color.a = color == color_red and 100 or 75
					else
						color.a = 230 + (math.sin(RealTime() * 7.5) * 25)
					end

					if (LocalPlayer():KeyDown(IN_USE) and closest == k) then
						color = table.Copy(color)
						color.r = math.min(color.r + 100, 255)
						color.g = math.min(color.g + 100, 255)
						color.b = math.min(color.b + 100, 255)
					end
				else
					color = color_orange
				end

				render.DrawSprite(v, 4, 4, color)
			end
		end
	end
