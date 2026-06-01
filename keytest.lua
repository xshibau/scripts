local Key = "Gemini béo"
local Response = game:HttpGet("https://raw.githubusercontent.com/User/Repo/main/keys.txt")

if Response:find(Key) then
    loadstring(game:HttpGet("https://link-script-chinh.lua"))()
else
    return
end
