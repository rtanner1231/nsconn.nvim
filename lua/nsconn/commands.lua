local NSConn = require("nsconn")

local M = {}

M.command_list = {
	{ value = "AddProfile", callback = NSConn.addProfile },
	{ value = "SelectProfile", callback = NSConn.showSelectProfilePicker },
	{ value = "DeleteProfile", callback = NSConn.showDeleteProfilePicker },
	{ value = "ResetTokens", callback = NSConn.resetTokens },
}

M.runCommand = function(command)
	for _, v in pairs(M.command_list) do
		if v.value == command then
			v.callback()
			return
		end
	end
end

return M
