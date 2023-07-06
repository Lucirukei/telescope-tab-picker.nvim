# telescope-tab-picker.nvim

A simple [Telescope](https://github.com/nvim-telescope/telescope.nvim) extension for searching for tabs based on what buffers, and how many windows, are open in them.

## Installation

Using [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{
  "lucirukei/telescope-tab-picker.nvim",
}
```

## Setup

### As an extension

To configure the plugin, you can add to the telescope setup:

```lua

local telescope = require("telescope")
local sorters = require("telescope.sorters")
local telescope_tab_picker = require("telescope-tab-picker")

telescope.setup({
		-- Telescope config,
		extensions = {
        -- The default config values.
		["telescope-tab-picker"] = {		   
						-- How the file names will show in the picker
			filename_modifier = ":t",
						-- How the filenames will be separated in the picker
			filename_separator = ", ",
						-- How the file name will show up in the picker title
			title_fn_modifier = ":.",
            -- Create an Ex command, separate from Telescope
			create_command = true,				
            -- The name of the Ex command to create
			command_name = "TabPicker",         
            -- Show how many buffers are open in the tabs
			display_amount = true,              
            -- The Telescope sorter to use
			sorter = sorters.get_fuzzy_file,    
            -- Mappings for navigating the picker
			mappings = {                        
				["<cr>"] = telescope_tab_picker.select_entry,
				["<c-k>"] = telescope_tab_picker.step_up,
				["<c-j>"] = telescope_tab_picker.step_down,
			}
		}
	}
	})

```

### Standard way

This plugin can also be installed on its own, but Telescope would still need to be installed aswell.
The only difference is you can't open the picker via Telescope.
\
Using Lazy:

```lua

{
	"lucirukei/telescope-tab-picker",
	dependencies = { "nvim-telescope/telescope.nvim" },
	config = function() 
		local sorters = require("telescope.sorters")
		local telescope_tab_picker = require("telescope-tab-picker")
        -- The default config values.
		require("telescope-tab-picker").setup({   
						-- How the file names will show in the picker
			filename_modifier = ":t",
						-- How the filenames will be separated in the picker
			filename_separator = ", ",
						-- How the file name will show up in the picker title
			title_fn_modifier = ":.",
            -- Create an Ex command, separate from Telescope
			create_command = true,                
            -- The name of the Ex command to create
			command_name = "TabPicker",           
            -- Show how many buffers are open in the tabs
			display_amount = true,                
            -- The Telescope sorter to use
			sorter = sorters.get_fuzzy_file,      
            -- Mappings for navigating the picker
			mappings = {                          
				["<cr>"] = telescope_tab_picker.select_entry,
				["<c-k>"] = telescope_tab_picker.step_up,
				["<c-j>"] = telescope_tab_picker.step_down,
			}
		})
	end
}

```

To enable the extension, after telescope setup:

```lua
require("telescope").load_extension("telescope-tab-picker")
```

## Usage

This can be run as an Ex command.\
Via Telescope:

```viml
:Telescope telescope-tab-picker
:Telescope telescope-tab-picker open
```
If `create_command = true`
```viml
:TabPicker
```

Or called in lua\
Via Telescope:

```viml
:lua require("telescope").extensions["telescope-tab-picker"].open()
```
Or directly:
```viml
:lua require("telescope-tab-picker").open()
```

