local TokenConfig = require("nsconn.tokenconfig")
local Connection = require("nsconn.connection")
local Config = require("nsconn.config")
local Helpers = require("nsconn.helpers")

local M = {}

--- Get the active profile name.
-- @return The active profile string
M.getActiveProfile = TokenConfig.getActiveProfile

--- Show a dialog to select a profile to delete.
M.showDeleteProfilePicker = TokenConfig.showDeleteProfilePicker

--- Show a dialog to select the active picker.
M.showSelectProfilePicker = TokenConfig.showSelectProfilePicker()

--- Set the active profile.
-- @param profile
M.setActiveProfile = TokenConfig.setActiveProfile

--- Get the list of profiles.
-- @return The active profile
-- @return A list of profiles
M.getProfileList = TokenConfig.getProfileList

--- Remove a profile
--@param profile The profile to remove
M.removeProfile = TokenConfig.removeProfile

--- Prompt the user to create a new profile.
M.addProfile = TokenConfig.addProfile

--- Remove all tokens
-- Prompts user before executing
M.resetTokens = TokenConfig.resetTokens

--- Create a custom value for the active profile
-- The app parameter allows key value pairs to be namespaced to a paticular application
-- @param app - The application name the value is for
-- @param key - The value key
-- @param value - the Value
M.setCustomValue = TokenConfig.setCustomValue

--- Get the custom value.
-- @return The custom value.  Nil if the custom value does not exist
M.getCustomValue = TokenConfig.getCustomValue

--- Remove the custom value
-- @param app
-- @param key
M.removeCustomValue = TokenConfig.removeCustomValue

--- Make a request to Netsuite.
-- @param url
-- @param method
-- @param opts
-- @param opts.body - The body table to send.  Ignored if method is GET or DELETE
-- @param opts.headers - Table of additional headers to send
M.makeNetsuiteRequest = Connection.netsuiteRequest

--- Enum which contains http methods.
M.Method = Connection.Method

--- Get a restlet url.
-- The script and deployment ids may be either the numerical internal id or the string script id
-- @param scriptId - The script id of the restlet
-- @param deploymentId - The deployment id of the restlet
-- @param params - Optional table of additional get parameters
-- @return The endpoint URL
M.getRestletURL = Helpers.getRestletURL

--- Get the url for suitetalk.
-- The path parameter should contain the part of the url after https://000000.suitetalk.api.netsuite.com
-- EX:
-- if the full url would be https://000000.suitetalk.api.netsuite.com/services/rest/query/v1/suiteql
-- The path should be '/services/rest/query/v1/suiteql'
-- @param path
-- @param params -  Optional table of additional get parameters
-- @return The endpoint URL
M.getSuiteTalkURL = Helpers.callSuiteTalk

--- Call a restlet
-- The script and deployment ids may be either the numerical internal id or the string script id
-- @param scriptId - The script id of the restlet
-- @param deploymentId - The deployment id of the restlet
-- @param opts
-- @param opts.method - Required. The method to use.  Should be in the Method enum
-- @param opts.body - The body table to send.  Ignored if method is GET or DELETE
-- @param opts.headers - Table of additional headers to send
-- @param opts.params - Optional table of additional get parameters
-- @return A boolean indicating if the call was successful
-- @return The response in a table
M.callRestlet = Helpers.callRestlet

--- Call a suitetalk function.
-- The path parameter should contain the part of the url after https://000000.suitetalk.api.netsuite.com
-- EX:
-- if the full url would be https://000000.suitetalk.api.netsuite.com/services/rest/query/v1/suiteql
-- The path should be '/services/rest/query/v1/suiteql'
-- @param path
-- @param opts
-- @param opts.method - Required. The method to use.  Should be in the Method enum
-- @param opts.body - The body table to send.  Ignored if method is GET or DELETE
-- @param opts.headers - Table of additional headers to send
-- @param opts.params - Optional table of additional get parameters
-- @return A boolean indicating if the call was successful
-- @return The response in a table
M.callSuiteTalk = Helpers.callSuiteTalk

M.setup = Config.setup

return M
