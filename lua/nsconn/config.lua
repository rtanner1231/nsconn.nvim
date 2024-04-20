local M = {}

local defaults = {
	encryptKey = "NVIMQueryKey",
	timeout = 50000,
}

M.options = defaults

M.setup = function(opts)
	M.options = vim.tbl_deep_extend("force", defaults, opts)
end

return M
