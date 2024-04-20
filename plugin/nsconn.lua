local Commands = require("nsconn.commands")

local startsWith = function(st, query)
	return st:sub(1, #query) == query
end

vim.api.nvim_create_user_command("NSConn", function(opts)
	if #opts.fargs == 0 then
		return
	end

	Commands.runCommand(opts.args)
end, {
	nargs = "?",
	complete = function(a, _, _)
		local cList = {}
		for _, v in pairs(Commands.command_list) do
			if a == nil or a == "" or startsWith(v.value, a) then
				table.insert(cList, v.value)
			end
		end
		return cList
	end,
})
