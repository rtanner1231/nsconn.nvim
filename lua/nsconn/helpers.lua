local TokenConfig = require("nsconn.tokenconfig")
local Connection = require("nsconn.connection")
local File = require("nsconn.util.fileutil")

local M = {}

--- Convert a Netuite account number to a value to use in an endpoint URL.
-- ex: 123456_SB1 to 123456_sb1
-- @param nsAccount
-- @return The converted value
local accountToURL = function(nsAccount)
	nsAccount = string.gsub(nsAccount, "_", "-")
	nsAccount = string.lower(nsAccount)
	return nsAccount
end

--- Add parameters to a url
-- @param url The base URL
-- @param parameters Table of parameters to add
local addParametersToUrl = function(url, parameters)
	if parameters == nil then
		return url
	end

	local separator = url:find("?") and "&" or "?"

	for key, value in pairs(parameters) do
		url = url .. separator .. key .. "=" .. value
		separator = "&"
	end

	return url
end

local mergeParameters = function(baseParameters, customParameters)
	if customParameters == nil then
		return baseParameters
	end

	return vim.tbl_deep_extend("force", baseParameters, customParameters)
end

local getURLAccount = function()
	local tokens = TokenConfig.getTokens()

	if tokens == nil then
		print("Tokens not found")
		return nil
	end

	local urlAccount = accountToURL(tokens.account)

	return urlAccount
end

M.getRestletURL = function(scriptId, deploymentId, params)
	local urlAccount = getURLAccount()

	if urlAccount == nil then
		return
	end

	local baseUrl = "https://" .. urlAccount .. ".restlets.api.netsuite.com/app/site/hosting/restlet.nl"

	local baseParameters = {
		script = scriptId,
		deploy = deploymentId,
	}

	local urlParams = mergeParameters(baseParameters, params)

	return addParametersToUrl(baseUrl, urlParams)
end

M.getSuiteTalkURL = function(path, params)
	local urlAccount = getURLAccount()

	if urlAccount == nil then
		return
	end

	local baseUrl = "https://" .. urlAccount .. ".suitetalk.api.netsuite.com"

	local fullUrl = File.pathcombine(baseUrl, path)

	return addParametersToUrl(fullUrl, params)
end

M.callRestlet = function(scriptId, deploymentId, opts)
	local restletUrl = M.getRestletURL(scriptId, deploymentId, opts.params)

	return Connection.netsuiteRequest(restletUrl, opts.method, { body = opts.body, headers = opts.headers })
end

M.callSuiteTalk = function(path, opts)
	local suiteTalkUrl = M.getSuiteTalkURL(path, opts.params)

	return Connection.netsuiteRequest(suiteTalkUrl, opts.method, { body = opts.body, headers = opts.headers })
end

return M
