# racer-nvim 🏎

A Neovim plugin for cycling through key sequences with custom triggers.

## Description

racer-nvim allows you to record key sequences and cycle through variations of these sequences by changing the first character. This is particularly useful for navigating between similar commands or for custom macro functionality.

## Installation

### Using [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
	"TheLazyCat00/racer-nvim",

	-- if you want to keep the defaults, do opts = {}
	-- if opts is nil, lazy.nvim does not load the plugin
	opts = {
		triggers = {

			-- first element: key used to go backwards
			-- last element: key used to go forwards
			{"[", "]"},
			{"F", "f"}
		},

		-- allow other plugins to take over for certain keys
		-- this is useful for plugins like flash.nvim or leap.nvim
		-- keys specified here have to be also specified in the triggers section
		-- this example is for flash.nvim
		external = {
			["f"] = require("flash.plugins.char").next,
			["F"] = require("flash.plugins.char").prev,
		}
	}

	-- racer-nvim does not automatically configure the keymaps
	-- this is a design choice because this makes it more customizable
	keys = {
		{";", "<cmd>lua require('racer-nvim').prev()<CR>", mode = {"n", "x"}, desc = "Repeat previous"},
		{",", "<cmd>lua require('racer-nvim').next()<CR>", mode = {"n", "x"}, desc = "Repeat next"},
	}
}
```

Defaults:
```lua
```lua
{
	triggers = {
		{"[", "]"}
	},
	external = {}
}
```

## Usage

1. Type a sequence starting with a trigger character (default: `[` or `]`)
2. Use the keymaps from your config to repeat the motion forwards or backwards


## How It Works

1. When you type a sequence starting with a trigger character, racer-nvim records it
2. When you call `next()` or `prev()`, it replaces the first character with its corresponding pair (the one in the right direction)
and executes the new sequence
3. If an external function is defined for a trigger, it will be called instead



Contributions are welcome! Feel free to open issues or submit pull requests.
