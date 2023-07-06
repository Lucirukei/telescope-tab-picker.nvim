local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local sorters = require("telescope.sorters")
local conf = require("telescope.config").values
local previewers = require("telescope.previewers")
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

local L = {}

function L.select_entry(prompt_bufnr)
	local selected = action_state.get_selected_entry()
	vim.cmd("tabnext " .. selected.value.id)
end

function L.step_up(prompt_bufnr)
	actions.move_selection_previous(prompt_bufnr)
end

function L.step_down(prompt_bufnr)
	actions.move_selection_next(prompt_bufnr)
end

local default_config = {
	create_command = true,
	command_name = "TabPicker",
	display_amount = true,
	sorter = sorters.get_fuzzy_file,
	mappings = {
		["<cr>"] = L.select_entry,
		["<c-k>"] = L.step_up,
		["<c-j>"] = L.step_down,
	}
}

local function get_open_tabs()
	local open_tab_ids = vim.api.nvim_list_tabpages()
	local open_tabs = {}
	for _, open_tab_id in pairs(open_tab_ids) do
		local tab_window_ids = vim.api.nvim_tabpage_list_wins(open_tab_id)
		local tab_buffer_paths = {}
		local tab_buffer_ids = {}
		for _, tab_window_id in pairs(tab_window_ids) do
			local buffer_id = vim.api.nvim_win_get_buf(tab_window_id)
			local buffer_path = vim.api.nvim_buf_get_name(buffer_id)
			table.insert(tab_buffer_ids, buffer_id)
			table.insert(tab_buffer_paths, buffer_path)
		end
		table.insert(open_tabs, {
			id = open_tab_id,
			buffer_ids = tab_buffer_ids,
			buffer_paths = tab_buffer_paths,
			path = tab_buffer_paths[1],
			window_amount = #tab_window_ids
		})
	end
	return open_tabs
end

local function entry_maker(entry)
	local relative_buf_paths = {}
	for _, buffer_path in pairs(entry.buffer_paths) do
		local relative_buf_path = vim.fn.fnamemodify(buffer_path, ":.")
		table.insert(relative_buf_paths, relative_buf_path)
	end
	local display_text = entry.id .. ". "
	if default_config.display_amount then
		display_text = display_text .. " [" .. entry.window_amount .. "] "
	end
	display_text = display_text .. table.concat(relative_buf_paths, " | ")
	return {
		value = entry,
		display = display_text,
		ordinal = display_text
	}
end

local function attach_mapping(map, key, fun)
	map({ "n", "i" }, key, fun)
end

local function attach_mappings(_, map)
	for key, fun in pairs(default_config.mappings) do
		attach_mapping(map, key, fun)
	end
	return true
end

local function dyn_title(self, entry)
	local relative_buf_path = vim.fn.fnamemodify(entry.value.path, ":.")
	return "Previewing " .. relative_buf_path
end

local function define_preview(self, entry, status)
	local preview_buf_nr = self.state.bufnr
	conf.buffer_previewer_maker(entry.value.path, preview_buf_nr, {
		use_ft_detect = true,
	})
end

function L.open_tab_picker()
	local open_tabs = get_open_tabs()
	pickers.new(open_tabs, {
		prompt_title = "Select a Tab",
		finder = finders.new_table {
			results = open_tabs,
			entry_maker = entry_maker
		},
		sorter = sorters.get_fuzzy_file(conf),
		attach_mappings = attach_mappings,
		previewer = previewers.new_buffer_previewer({
			title = "Buffer Preview",
			dynamic_preview_title = true,
			dyn_title = dyn_title,
			define_preview = define_preview
		})
	}):find()
end

L.open = L.open_tab_picker

function L.setup(user_config)
	default_config = vim.tbl_deep_extend("force", default_config, user_config)
	if default_config.create_command then
		vim.api.nvim_create_user_command(default_config.command_name, L.open_tab_picker, {})
	end
end

return L
