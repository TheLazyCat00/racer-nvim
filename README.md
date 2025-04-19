# racer-nvim 🏎

racer-nvim allows you to repeat the last jump forward or backward. It's similar to demicolon, but unlike [demicolon](https://github.com/mawkler/demicolon.nvim), this plugin works with any other plugin because the functionality isn't hardcoded per jump. That means if you later add more functionality to the keys you've configured with this plugin, you won't have to worry about it not working.

https://github.com/user-attachments/assets/a41debdc-459c-42f8-b141-5b84e0395e57

## Installation with [lazy.nvim](https://github.com/folke/lazy.nvim)

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
