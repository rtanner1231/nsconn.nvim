# nsconn.nvim

Neovim plugin to making connections to rest calls to Netsuite.

This plugin is designed to be used by other plugins to make Netsuite connections while centrally maintaining connection information.

# Main Features

- Manage profiles to connect to multiple Netsuite instances
- Provide functions to make restlet and suitetalk rest service calls into Netsuite

# Requirements

- [nui.nvim](https://github.com/MunifTanjim/nui.nvim)
- [plenary.nvim](https://github.com/nvim-lua/plenary.nvim)
- Node.js

# Installation

Install with your preferred package manager. Optionally call a setup function to override default options.

## [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
return {
    'rtanner1231/nsconn.nvim',
    dependencies = {
                "nvim-lua/plenary.nvim",
                "MunifTanjim/nui.nvim"
    },
    opts={
        -- override default options
    }
}
```

# Configuration Options

## Defaults

```lua
{
	encryptKey = "NVIMQueryKey",
	timeout = 50000,
}
```

## Options

- **encryptKey ** (_default: "NVIMQueryKey"_) - The environmental variable which will hold the encryption key for the Oauth tokens storage.
- **timeout** (_default: 50000_) - The timeout in milliseconds to wait for a response from a Netsuite API call.

# Commands

This plugin provides the below commands

- `:NSConn AddProfile` - Create a new profile for a Netsuite account. Running this command will prompt you for a profile name and then an account id and Oauth 1.0 tokens for the account. Using an existing profile name will overwrite that profile. Multiple profiles may be created.
- `:NSConn SelectProfile` - Open a floating window to select the profile which will be used when running Netsuite service calls. Press the number beside a profile or put the cursor over the profiles line and press enter to select. Escape to cancel.
- `:NSConn DeleteProfile` - Open a floating window to delete a profile. The active profile may not be deleted. Press the number beside a profile or put the cursor over the profiles line and press enter to select. Escape to cancel.
- `:NSConn ResetTokens` - Remove all saved profiles. This cannot be undone.

# Setup

Running Netsuite Rest calls requires Oauth tokens to be setup and saved. These tokens will be encrypted and stored in a file called sqc in the vim standard data folder.

1. Set an encryption key (optional). Create an environmental variable called NVIMQueryKey (or what you set encryptKey to in the config). For example add `export NVIMQueryKey=ABCDEF12345` to your .bashrc file to set ABCDEF12345 as the encryption key. If an environmental variable is not set, a hardcoded encryption key will be used.
2. Generate oauth tokens in your Netsuite environments. These tokens will need to be created with a role that has access to any functions or record types that will need to be accessed in service calls.
3. Run `:NSConn AddProfile` in Neovim. Follow the prompts to create a profile for a Netsuite account and assign OAuth tokens to it.

# Available functions

The plugin provides the below functions. They may be called with `require("nsconn").functionName()`

```lua
--- Get the active profile name.
-- @return The active profile string
getActiveProfile()

--- Show a dialog to select a profile to delete.
showDeleteProfilePicker()

--- Show a dialog to select the active picker.
showSelectProfilePicker()

--- Set the active profile.
-- @param profile
setActiveProfile(profile)

--- Get the list of profiles.
-- @return The active profile
-- @return A list of profiles
getProfileList()

--- Create a custom value for the active profile
-- The app parameter allows key value pairs to be namespaced to a paticular application
-- @param app - The application name the value is for
-- @param key - The value key
-- @param value - the Value
setCustomValue(app,key,value)

--- Get the custom value.
-- @param app
-- @param key
-- @return The custom value.  Nil if the custom value does not exist
getCustomValue(app,key)

--- Remove the custom value
-- @param app
-- @param key
removeCustomValue(app,key)

--- Remove a profile
--@param profile The profile to remove
removeProfile(profile)

--- Prompt the user to create a new profile.
addProfile()

--- Remove all tokens
-- Prompts user before executing
resetTokens()

--- Make a request to Netsuite.
-- @param url
-- @param method
-- @param opts
-- @param opts.body - The body table to send.  Ignored if method is GET or DELETE
-- @param opts.headers - Table of additional headers to send.  Optional
makeNetsuiteRequest(url,method,{
    body=body,
    headers=headers
})

--- Enum which contains http methods.
-- EX: Method.POST
-- Has values:
-- POST
-- GET
-- PUT
-- DELETE
Method

--- Get a restlet url.
-- The script and deployment ids may be either the numerical internal id or the string script id
-- @param scriptId - The script id of the restlet
-- @param deploymentId - The deployment id of the restlet
-- @param params - Optional table of additional get parameters
-- @return The endpoint URL
getRestletURL(scriptId,deploymentId,params)

--- Get the url for suitetalk.
-- The path parameter should contain the part of the url after https://000000.suitetalk.api.netsuite.com
-- EX:
-- if the full url would be https://000000.suitetalk.api.netsuite.com/services/rest/query/v1/suiteql
-- The path should be '/services/rest/query/v1/suiteql'
-- @param path
-- @param params -  Optional table of additional get parameters
-- @return The endpoint URL
getSuiteTalkURL(path,params)

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
callRestlet(scriptId,deploymentId,{
    method=method,
    body=body,
    headers=headers,
    params=params
})

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
callSuiteTalk(path,{
    method=method,
    body=body,
    headers=headers,
    params=params
})

```

# A note on security

Oauth tokens are encrypted and stored in the neovim Data Directory (see `:h standard-path` in Neovim) in a file called **sqc**. The encryption key used is retrived from the environmental variable _NVIMQueryKey_. The name of this environmental variable can be changed in the configuration.
