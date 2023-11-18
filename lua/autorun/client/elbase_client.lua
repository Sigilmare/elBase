function elBase:ScreenScale(val)
    if val then
        return ScrW() / 1920
    else
        return ScrH() / 1080
    end
end

function elBase:CreateFonts()
    local ssh = elBase:ScreenScale()
    local ssw = elBase:ScreenScale(true)

    surface.CreateFont("elFontNameLabel", {font = "Consolas", size = 22 * ssh, antialias = true})
    surface.CreateFont("elFontDescLabel", {font = "Consolas", size = 20 * ssh, antialias = true})

    -- Use width scaling because it's for the "View profile?" text in credits
    surface.CreateFont("elFontProfilePrompt", {font = "Arial", size = 16 * ssw, antialias = true})

    surface.CreateFont("elFontLarge", {font = "Consolas", size = 60 * ssh, antialias = true})
    surface.CreateFont("elFontMenuTitle", {font = "Consolas", size = 96 * ssh, antialias = true})
end

elBase:CreateFonts()
chat.AddText(Color(255, 165, 0), "[elBase] Fonts refreshed/updated")

local function ButtonPaint(self, w, h)
	if self.Hovered then
        surface.SetDrawColor(255, 255, 255, 20)
        surface.DrawRect(0, 0, w, h)
	end

	surface.SetDrawColor(0, 0, 0, 180)
    surface.DrawRect(0, 0, w, h)
    
    surface.SetDrawColor(255, 255, 255, 20)
    surface.DrawOutlinedRect(0, 0, w, h)
end

local OldDerma_DrawBackgroundBlur = Derma_DrawBackgroundBlur
local matBlurScreen = Material("pp/blurscreen")
function Derma_DrawBackgroundBlur(panel, starttime, duration)
	local Fraction = 1
    local Time = duration or 1

	if starttime then
		Fraction = math.Clamp((SysTime() - starttime) / Time, 0, 1)
	end

	local x, y = panel:LocalToScreen(0, 0)
	local wasEnabled = DisableClipping(true)

	if not MENU_DLL then
		surface.SetMaterial(matBlurScreen)
		surface.SetDrawColor(255, 255, 255, 255)

		for i=0.33, 1, 0.33 do
			matBlurScreen:SetFloat("$blur", Fraction * 5 * i)
			matBlurScreen:Recompute()
			if render then render.UpdateScreenEffectTexture() end
			surface.DrawTexturedRect( x * -1, y * -1, ScrW(), ScrH())
		end
	end

	surface.SetDrawColor(10, 10, 10, 200 * Fraction)
	surface.DrawRect(x * -1, y * -1, ScrW(), ScrH())

	DisableClipping(wasEnabled)
end

function elBase:ButtonClick()
    surface.PlaySound("garrysmod/ui_click.wav")
end

function elBase:MainMenu()
    local swid = elBase:ScreenScale(true)
    local shei = elBase:ScreenScale()

    local frame = vgui.Create("DFrame")
    frame:SetSize(ScrW(), ScrH())
    frame:SetDraggable(false)
    frame:ShowCloseButton(false)
    frame:SetTitle("")
    frame:SetAlpha(0)
    frame:AlphaTo(255, 0.15)
    frame:MakePopup()
    frame.Created = SysTime()
    frame.Paint = function(self, w, h)
        Derma_DrawBackgroundBlur(self, self.Created, 0.15)
        surface.SetDrawColor(0, 0, 0, 180)
        surface.DrawRect(0, 0, w, h)
    end

    local base = vgui.Create("DPanel", frame)
    base:SetSize(600 * swid, ScrH())
    base:Center()
    base.Paint = nil

    local title = vgui.Create("DLabel", base)
    title:SetFont("elFontMenuTitle")
    title:SetText("elBase v"..elBase.Version)
    title:SetTextColor(color_white)
    title:SizeToContents()
    title:SetContentAlignment(8)
    title:DockMargin(0, 64 * shei, 0, 64 * shei)
    title:Dock(TOP)

    local function Button(name, callback)
        callback = callback or function() end

        local close = vgui.Create("DButton", base)
        close:SetFont("elFontLarge")
        close:SetText(name or "Unnamed")
        close:SetTextColor(color_white)
        close:SetSize(600 * swid, 70 * shei)
        close:Dock(TOP)
        close:DockMargin(0, 0, 0, 16 * shei)
        close.OnMousePressed = function(self, key)
            if key != MOUSE_LEFT then return end
    
            elBase:ButtonClick()
            callback()
        end
        close.Paint = function(self, w, h)
            ButtonPaint(self, w, h)
        end
        close.OnCursorEntered = function()
            surface.PlaySound("garrysmod/ui_return.wav")
        end
    end

    Button("Credits", function()
        base:AlphaTo(0, 0.15)

        local baseMain = vgui.Create("DPanel", frame)
        baseMain:SetSize(800 * swid, 800 * shei)
        baseMain:SetAlpha(0)
        baseMain:AlphaTo(255, 0.15, 0.15)
        baseMain:AlignTop(64 * shei)
        baseMain:CenterHorizontal()
        baseMain.Paint = function(self, w, h)
            surface.SetDrawColor(255, 255, 255, 20)
            surface.DrawOutlinedRect(0, 0, w, h)
        end

        local baseMainS = vgui.Create("DScrollPanel", baseMain)
        baseMainS:Dock(FILL)
        baseMainS:DockMargin(9 * swid, 9 * shei, 9 * swid, 9 * shei)
        baseMainS.Debounce = false
        baseMainS.PerformLayout = function(self)
            if self:GetVBar().Enabled and not self.Debounce then
                self:GetCanvas():DockPadding(0, 0, 9 * swid, 0)
                self.Debounce = true
            end

            self:PerformLayoutInternal()
        end

        local baseMainSVBar = baseMainS:GetVBar()
        baseMainSVBar:SetHideButtons(true)
        baseMainSVBar.Paint = function(self, w, h)
            surface.SetDrawColor(0, 0, 0, 180)
            surface.DrawRect(0, 0, w, h)
    
            surface.SetDrawColor(255, 255, 255, 20)
            surface.DrawOutlinedRect(0, 0, w, h)
        end
        baseMainSVBar.btnGrip.Paint = function(self, w, h)
            surface.SetDrawColor(0, 0, 0, 180)
            surface.DrawRect(0, 0, w, h)
    
            surface.SetDrawColor(255, 255, 255, 20)
            surface.DrawOutlinedRect(0, 0, w, h)
        end

        local baseBottom = vgui.Create("DPanel", frame)
        baseBottom:SetSize(800 * swid, 70 * shei)
        baseBottom:SetAlpha(0)
        baseBottom:AlphaTo(255, 0.15, 0.15)
        baseBottom:AlignBottom(70 * shei)
        baseBottom:CenterHorizontal()
        baseBottom.Paint = nil

        local back = vgui.Create("DButton", baseBottom)
        back:SetFont("elFontLarge")
        back:SetText("Back")
        back:SetTextColor(color_white)
        back:SetSize(350 * swid, 70 * shei)
        back:Dock(LEFT)
        back.OnMousePressed = function(self, key)
            if key != MOUSE_LEFT then return end
    
            elBase:ButtonClick()

            baseMain:AlphaTo(0, 0.15, 0, function()
                baseMain:Remove()
            end)
            baseBottom:AlphaTo(0, 0.15, 0, function()
                baseBottom:Remove()
            end)

            base:AlphaTo(255, 0.15, 0.15)
        end
        back.Paint = function(self, w, h)
            ButtonPaint(self, w, h)
        end
        back.OnCursorEntered = function()
            surface.PlaySound("garrysmod/ui_return.wav")
        end

        local close = vgui.Create("DButton", baseBottom)
        close:SetFont("elFontLarge")
        close:SetText("Close")
        close:SetTextColor(color_white)
        close:SetSize(350 * swid, 70 * shei)
        close:Dock(RIGHT)
        close.OnMousePressed = function(self, key)
            if key != MOUSE_LEFT then return end
    
            elBase:ButtonClick()
            
            frame:AlphaTo(0, 0.15, 0, function()
                frame:Close()
            end)
        end
        close.Paint = function(self, w, h)
            ButtonPaint(self, w, h)
        end
        close.OnCursorEntered = function()
            surface.PlaySound("garrysmod/ui_return.wav")
        end

        for index, tab in ipairs(elBase.Credits) do
            local area = vgui.Create("DPanel", baseMainS)
            area:SetSize(800 * swid, 100 * shei)
            area:Dock(TOP)
            area:DockMargin(0, 0, 0, 8 * shei)
            area.Paint = function(self, w, h)
                surface.SetDrawColor(0, 0, 0, 180)
                surface.DrawRect(0, 0, w, h)

                surface.SetDrawColor(255, 255, 255, 20)
                surface.DrawOutlinedRect(0, 0, w, h)
            end

            local areaPFP = vgui.Create("DPanel", area)
            areaPFP:SetSize(84 * swid, 84 * shei)
            areaPFP:Dock(LEFT)
            areaPFP:DockMargin(8 * shei, 8 * shei, 0, 8 * shei)
            areaPFP.Paint = function(self, w, h)
                surface.SetDrawColor(255, 255, 255, 20)
                surface.DrawOutlinedRect(0, 0, w, h)
            end

            local avatar = vgui.Create("AvatarImage", areaPFP)
            avatar:Dock(FILL)
            avatar:DockMargin(1, 1, 1, 1)
            avatar:InvalidateParent()
            avatar:SetSteamID(tab[1], avatar:GetSize())

            local profileURL = vgui.Create("DButton", avatar)
            profileURL:SetText("")
            profileURL:Dock(FILL)
            profileURL.OnMousePressed = function(self, key)
                if key != MOUSE_LEFT then return end
        
                elBase:ButtonClick()
                gui.OpenURL("https://steamcommunity.com/profiles/"..tab[1])
            end
            profileURL.Paint = function(self, w, h)
                if self.Hovered then
                    surface.SetDrawColor(255, 255, 255, 20)
                    surface.DrawRect(0, 0, w, h)
                    draw.SimpleTextOutlined("View profile?", "elFontProfilePrompt", w/2, h/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black)
                    return
                end
            end
            profileURL.OnCursorEntered = function()
                surface.PlaySound("garrysmod/ui_return.wav")
            end

            local name = vgui.Create("DPanel", area)
            name:SetTall(28 * shei)
            name:Dock(TOP)
            name:DockMargin(8 * swid, 8 * shei, 8 * swid, 0)
            name:InvalidateParent()
            name.Paint = function(self, w, h)
                surface.SetDrawColor(0, 0, 0, 180)
                surface.DrawRect(0, 0, w, h)

                surface.SetDrawColor(255, 255, 255, 20)
                surface.DrawOutlinedRect(0, 0, w, h)
            end

            local nameLabel = vgui.Create("DLabel", name)
            nameLabel:SetText("Requesting player info...")
            steamworks.RequestPlayerInfo(tab[1], function(nick)
                nameLabel:SetText(nick)
            end)
            nameLabel:SetFont("elFontNameLabel")
            nameLabel:Dock(FILL)
            nameLabel:DockMargin(8 * swid, 0, 8 * swid, 0)
            nameLabel:SetContentAlignment(4)

            local desc = vgui.Create("DPanel", area)
            desc:Dock(FILL)
            desc:DockMargin(8 * swid, 8 * shei, 8 * swid, 8 * shei)
            desc:InvalidateParent()
            desc.Paint = function(self, w, h)
                surface.SetDrawColor(0, 0, 0, 180)
                surface.DrawRect(0, 0, w, h)

                surface.SetDrawColor(255, 255, 255, 20)
                surface.DrawOutlinedRect(0, 0, w, h)
            end

            local descLabel = vgui.Create("DLabel", desc)
            descLabel:SetText(tab[2])
            descLabel:SetFont("elFontDescLabel")
            descLabel:Dock(FILL)
            descLabel:DockMargin(8 * swid, 4 * shei, 8 * swid, 4 * shei)
            descLabel:SetContentAlignment(7)
            descLabel:SetWrap(true)
        end
    end)

    Button("Close", function()
        frame:AlphaTo(0, 0.15, 0, function()
            frame:Close()
        end)
    end)
end