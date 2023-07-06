local telescope_tab_picker = require("telescope-tab-picker")
local open_tab_picker = telescope_tab_picker.open_tab_picker
local setup = telescope_tab_picker.setup

return require("telescope").register_extension({
	setup = setup,
	exports = {
		["telescope-tab-picker"] = open_tab_picker,
		open = open_tab_picker,
	}
})
