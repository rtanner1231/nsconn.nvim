local File = require("nsconn.util.fileutil")

local M = {}

M.getScriptPath = function(currentFilePath, localFilePath, localPathToScript)
	local dirPath = File.getDirFromPath(currentFilePath)

	local pluginPath = string.gsub(dirPath, localFilePath, "")

	return File.pathcombine(pluginPath, localPathToScript)
end

return M
