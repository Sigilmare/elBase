hook.Add("PlayerSay", "elBase:Server", function(ply, text)
    if string.lower(text) == "!elbase" or string.lower(text) == "/elbase" then
        ply:SendLua("elBase:MainMenu()")
        return ""
    end

    if text == "test" then ply:SendLua("test()") end
end)