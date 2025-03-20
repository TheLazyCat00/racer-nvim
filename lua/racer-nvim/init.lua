local defaults = require("racer-nvim.defaults")
local M = {}

local keys = {}

local macro = ""
local recording = ""
local pending = false

local function swap_recording()
	if recording == "" then
		return
	end
	macro = recording
	recording = ""
end

local function process_key(key, typed_key)
	local banned_modes = {
		["i"] = true,
		["c"] = true,
	}
	local mode = vim.fn.mode(1)

	if typed_key == vim.api.nvim_replace_termcodes("<ESC>", true, false, true) then
		swap_recording()
		return
	end

	if banned_modes[mode] then
		return
	end

	local is_trigger = keys[typed_key:sub(1, 1)]

	if is_trigger or pending then
		if typed_key:len() == 1 then
			recording = recording .. typed_key

			pending = true
			if recording:len() >= 2 then
				pending = false
				swap_recording()
			end
		else
			recording = typed_key
			pending = false
			swap_recording()
		end
	end
end

local function replace_first_char(str, replacement)
	return replacement .. string.sub(str, 2)
end

local function get_first_char(str)
	return str:sub(1, 1)
end

function M.setup(opts)
	local triggers = opts.triggers or defaults.triggers
	for _, trigger in ipairs(triggers) do
		local prev = trigger[1]
		local next = trigger[2]

		keys[prev] = {
			prev = prev,
			next = next,
		}

		keys[next] = {
			prev = prev,
			next = next,
		}
	end
	vim.on_key(process_key)
end

function M.next()
	local first_char = get_first_char(macro)
	local new_char = keys[first_char].next
	local new_macro = replace_first_char(macro, new_char)
	vim.api.nvim_input("<ESC>" .. new_macro)
end


function M.prev()
	local first_char = get_first_char(macro)
	local new_char = keys[first_char].prev
	local new_macro = replace_first_char(macro, new_char)
	vim.api.nvim_input("<ESC>" .. new_macro)
end

return M
