local list = {
    ["script-962961096558"] = true,
    ["Key123"] = true,
    ["TaoLaBoss"] = true
}

if list[script_key] then
    loadstring(game:HttpGet("https://raw.githubusercontent.com/xshibau/scripts/refs/heads/main/36hub_script-1780253539920.lua"))()
else
    error("Key sai")
end
