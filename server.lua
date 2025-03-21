local banned_chars = {'"', "'", "<", ">", "=", "script", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "!", "@", "#", "$", "%", "^", "&", "*", "(", ")", "-", "_", "+", "=", "{", "}", "[", "]", "|", "\\", ":", ";", "'", "\"", ",", ".", "/", "?", "~", "`"}
local kick_when_found = true
local check_on_connect = true
local check_during_playing = true

local function checkName(name)
  for _, char in ipairs(banned_chars) do
    if string.find(name, char) then
      return true
    end
  end
  return false
end

AddEventHandler('playerConnecting', function(playername, setKickReason)
  if check_on_connect then
    if checkName(playername) then
      if kick_when_found then
        TriggerClientEvent('chatMessage', -1, ':fsn_server:', {255,0,0}, GetPlayerIdentifiers(source)[1]..' was removed from the server due to disallowed characters in their Steam name.')
        DropPlayer(source, '[SERVER] You have been removed from the session due to your Steam name.')
        setKickReason('[SERVER] You have been removed from the session due to your Steam name.')
      else
        TriggerClientEvent('chatMessage', -1, ':fsn_server:', {255,0,0}, GetPlayerIdentifiers(source)[1]..' has disallowed characters in their Steam name but was not removed due to server configuration.')
      end
    end
  end
end)

Citizen.CreateThread(function()
  while check_during_playing do
    Citizen.Wait(1000)  -- Wait for 1 second to reduce CPU usage
    for _, player in ipairs(GetPlayers()) do
      local playerName = GetPlayerName(player)
      if checkName(playerName) then
        if kick_when_found then
          TriggerClientEvent('chatMessage', -1, ':fsn_server:', {255,0,0}, GetPlayerIdentifiers(player)[1]..' was removed from the server due to disallowed characters in their Steam name.')
          DropPlayer(player, '[SERVER] You have been removed from the session due to your Steam name.')
        else
          TriggerClientEvent('chatMessage', -1, ':fsn_server:', {255,0,0}, GetPlayerIdentifiers(player)[1]..' has disallowed characters in their Steam name but was not removed due to server configuration.')
        end
      end
    end
  end
end)
