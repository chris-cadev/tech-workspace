require 'mp'
require 'mp.msg'

WINDOWS = 2
UNIX = 3

local function platform_type()
    local utils = require 'mp.utils'
    local workdir = utils.to_string(mp.get_property_native("working-directory"))
    if string.find(workdir, "\\") then
        return WINDOWS
    else
        return UNIX
    end
end

local function command_exists(cmd)
    local pipe = io.popen("type " .. cmd .. " > /dev/null 2> /dev/null; printf \"$?\"", "r")
    exists = pipe:read() == "0"
    pipe:close()
    return exists
end

local function get_clipboard_cmd()
    if command_exists("xclip") then
        return "xclip -silent -in -selection clipboard"
    elseif command_exists("wl-copy") then
        return "wl-copy"
    elseif command_exists("pbcopy") then
        return "pbcopy"
    else
        mp.msg.error("No supported clipboard command found")
        return false
    end
end

local function divmod(a, b)
    return a / b, a % b
end

local function set_clipboard(text)
    if platform == WINDOWS then
        mp.commandv("run", "powershell", "set-clipboard", text)
        return true
    elseif (platform == UNIX and clipboard_cmd) then
        local pipe = io.popen(clipboard_cmd, "w")
        pipe:write(text)
        pipe:close()
        return true
    else
        mp.msg.error("Set_clipboard error")
        return false
    end
end

local function copy_url()
    local url = mp.get_property("path")
    local clipboard = string.format("%s", url)
    if set_clipboard(clipboard) then
        mp.osd_message(string.format("Clipboard: %s", clipboard))
    end
end

platform = platform_type()
if platform == UNIX then
    clipboard_cmd = get_clipboard_cmd()
end

mp.add_key_binding("Ctrl+c", "copy_url", copy_url)
