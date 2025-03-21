local defaults = require("racer-nvim.defaults")
local M = {}

local keys = {}
local external = {}

local macro = ""
local recording = ""

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

	if banned_modes[mode] then
		return
	end

	vim.schedule(function ()
		local is_trigger = keys[typed_key:sub(1, 1)]

		if is_trigger then
			recording = typed_key
			swap_recording()
		end
	end)
end

local function replace_first_char(str, replacement)
	return replacement .. string.sub(str, 2)
end

local function get_first_char(str)
	return str:sub(1, 1)
end

function M.setup(opts)
	external = opts.external or defaults.external
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
	if macro == "" then
		return
	end

	local first_char = get_first_char(macro)
	local new_char = keys[first_char].next

	if external[new_char] then
		external[new_char]()
		return
	end

	local new_macro = replace_first_char(macro, new_char)
	vim.api.nvim_input(new_macro)
end


function M.prev()
	if macro == "" then
		return
	end

	local first_char = get_first_char(macro)
	local new_char = keys[first_char].prev

	if external[new_char] then
		external[new_char]()
		return
	end

	local new_macro = replace_first_char(macro, new_char)
	vim.api.nvim_input(new_macro)
end

return M
