local curllib = require("plenary.curl")
local File = require("nsconn.util.fileutil")
local TokenConfig = require("nsconn.tokenconfig")
local Config = require("nsconn.config").options

local P = function(tbl)
	return print(vim.inspect(tbl))
end

local M = {}

M.Method = {
	POST = "post",
	GET = "get",
	PUT = "put",
	DELETE = "delete",
}

local getScriptPath = function(currentFilePath, localFilePath, localPathToScript)
	local dirPath = File.getDirFromPath(currentFilePath)

	local pluginPath = string.gsub(dirPath, localFilePath, "")

	return File.pathcombine(pluginPath, localPathToScript)
end

--opts:
--token
--tokenSecret
--consumerKey
--consumerSecret
--url
--method
--account
--node testcli.js -t 12345 -k 23456 -c 34567 -s 45678 -r 361134_SB1 -u http://www.google.com -m POST -p '{"test": 1}'
local getAuthHeader = function(opts)
	local body = vim.json.encode(opts.body)

	local args = {
		"-t",
		opts.token,
		"-k",
		opts.tokenSecret,
		"-c",
		opts.consumerKey,
		"-s",
		opts.consumerSecret,
		"-r",
		opts.account,
		"-u",
		"'" .. opts.url .. "'",
		"-m",
		opts.method,
		"-p",
		"'" .. body .. "'",
	}

	local argStr = ""

	for _, v in pairs(args) do
		argStr = argStr .. " " .. v
	end

	local fullPath = debug.getinfo(1).source:sub(2)

	-- local dirPath=File.getDirFromPath(fullPath)
	--
	--
	-- local scriptPath=File.pathcombine(pluginPath,'scripts/oauth/oauthheader.js')

	local scriptPath = getScriptPath(fullPath, "/lua/nsconn", "scripts/oauth/oauthheader.js")

	local command = "node " .. scriptPath .. argStr

	--print(command)

	local result = vim.fn.system(command)

	local resultTable = vim.json.decode(result)

	return resultTable

	--local result=io.popen('node -v')

	-- local lines = {}
	--   for line in result:lines() do
	--     lines[#lines + 1] = vim.json.decode(line)
	--   end
	--
	--
	--
	-- return lines[1]

	-- local headerJob=job:new({
	--     --command="node ./oauth/oauthheader.js",
	--     command="node -v",
	--     --args=args
	-- })
	--
	-- local result=headerJob:sync()

	--local headerTable=vim.json.decode(result)

	--return headerTable;
end

----------------------------------------------------------------------------------

--opts:
--token
--tokenSecret
--consumerKey
--consumerSecret
--url
--method
--account
--body: table
--timeout
local make_request = function(opts, cust_headers, method)
	local headers = getAuthHeader(opts)

	headers = vim.tbl_deep_extend("force", headers, cust_headers)

	local funcMap = {
		[M.Method.GET] = curllib.get,
		[M.Method.PUT] = curllib.put,
		[M.Method.POST] = curllib.post,
		[M.Method.DELETE] = curllib.delete,
	}
	local hasBodyMap = {
		[M.Method.GET] = false,
		[M.Method.PUT] = true,
		[M.Method.POST] = true,
		[M.Method.DELETE] = false,
	}

	local requestFunc = funcMap[method]

	if requestFunc == nil then
		local message = "invalid method: " .. method
		return false, message
	end

	local hasBody = hasBodyMap[method]

	local params = {
		headers = headers,
		timeout = opts.timeout,
	}

	if hasBody then
		local body = vim.json.encode(opts.body)
		params.body = body
	end

	-- local res=curllib.post(opts.url,{
	--     headers=headers,
	--     body=body
	-- })

	local success, res = pcall(function()
		return requestFunc(opts.url, params)
	end)

	return success, res
end

M.netsuiteRequest = function(url, method, opts)
	local tokens = TokenConfig.getTokens()
	if tokens == nil then
		return false, "error retrieving tokens"
	end
	local headers = {}
	if opts.headers ~= nil then
		headers = opts.headers
	end

	local timeout = Config.timeout

	local account = tokens.account
	local token = tokens.token
	local tokenSecret = tokens.tokenSecret
	local consumerKey = tokens.consumerKey
	local consumerSecret = tokens.consumerSecret

	return make_request({
		tokenSecret = tokenSecret,
		token = token,
		consumerKey = consumerKey,
		consumerSecret = consumerSecret,
		url = url,
		method = "POST",
		account = account,
		body = opts.body,
		timeout = timeout,
	}, headers, method)
end

return M

-- local function test()
--     connect('http://www.google.com',{})
-- end
--
-- test()
