--[[
Author : @Lazeyy_RBX
Version : 0.2.1
Date : 23/05/2026

@IMPORTANT Version format :
	1st number -> Changes based on 2nd digit,
	2nd number -> Incremented based on bug fixes/updates,
	3rd number -> Incremented based on script changes (increments by one per function and per major type),
		
Description : A lightweight typed checked module loader implementation.

--> DOCUMENTATION  <--
Docs up to date for version 0.2.1

1
--\\ Getting Started //--
This section of the documentation will focus
on getting you ready to use the module loader at a basic level.

1.1
Server setup :
	First create a Script in ServerScriptService
	For better clarity i recommend naming this script "Server"

Client setup :
	LocalScript in StarterPlayer -> StarterPlayerScripts
	For better clarity i recommend naming this script "Client"

1.2
Initialization snippet for Server and Client : 

	``local ReplicatedStorage = game:GetService("ReplicatedStorage")
	  local ModuleLoader = require(ReplicatedStorage.Shared.Utilities.ModuleLoader)

	  ModuleLoader.new(script):loadAllModules()``

2
--\\ Datatypes //--
This section of the documentation will focus on
the datatypes of the module loader.

2.1
Utility functions :

	@method requireModules
	[
		Loops through and requires all ModuleScripts contained in self.modules, returns nil if none.
	]
	
	@method initModule
	[
		Locates and initializes a single import (more in 2.3).
	]
	
	@method loadAllModules
	[
		Loops through and intializes all imports contained in self.imports.
	]

2.2 
Fields :

	@Table LOADER_CONFIG 
	[
		@String _InitFunction
		@String _StartFunction
		@String _FetchTag
		@String _ForceLoadTag
	
		@Boolean VerboseLoading
	]

	@Script|Folder container
	[
		A script or folder that contains all of the modules for the loader to get.
	]
	
	@String contextPrefix
	[
		A string used to print server and client logs using a prefix ([S]/[C])
	]
	
	@Table imports
	[
		A table containing all of the required module imports (more in 2.3)
	]
	
	@Table modules
	[
		A table containing all of the modules caught by the loader.
	]
	
	[Deprecated] @Table loadedModules
	[
		A table containing all of the already loaded modules.
	]
	
	@String _InitFunction
	[
		Extends @Attribute InitFunction
		@Default : "Init"
		
		Defines the function the loader will use to initialize the module (more on InitFunctions in 2.4).
	]
	
	@String _StartFunction
	[
		Extends @Attribute StartFunction
		@Default : "Start"
		
		Defines the function the loader will use to start the module (more on StartFunctions in 2.4).
	]
	
	@String _FetchTag
	[
		Extends @Attribute FetchTag
		@Default : "LOAD_MODULE"
		
		Defines the tag the loader will use to catch modules tagged with said tag.
	]
	
	@Boolean VerboseLoading
	[
		Extends @Attribute VerboseLoading
		@Default : true
		
		Enables/Disables logs for the loader.
	]
	
2.3
Imports :
	
	An import is the table returned by a module when it is required by the loader.
	Each import is essentially composed of two functions by default being the "Init" and "Start" functions.
	
	All imports are printed to the output when @Boolean VerboseLoading is enabled, 
	it is a table containing all functions you indexed with the module table.

2.4
InitFunctions and StartFunctions :
	
	The InitFunction is a function that is called when the module is required by the loader,
	it is the first function that should be called only by the loader.
	
	The StartFunction is a function that is called when the module is initialized by the loader,
	it is a function that needs to be called whenever the Init function is finished.

3
Setters and Getters :

	Setters are used to overwrite data in the loader's fields at runtime.
	
	Getters are use to read data in loader's fields at runtime.
	
3.1
Setters

	@method setInitFunction 
	[
		sets the current init function to the one provided.
	]
	
	@method setStartFunction 
	[
		sets the current start function to the one provided.
	]
	
	@method setFetchTag 
	[
		sets the current @String fetch tag to the one provided.
	]

3.2 Getters

	@method getModules
	[
		loops through and returns a table of all modules contained in the loaders container.
	]
	
	@method getContext
	[
		returns the current context prefix using RunService.
	]
	
	@method getFunction
	[
		returns the function associated with the name provided.
	]
	
	@method getInitFunction
	[
		returns the current init function.
	]
	
	@method getStartFunction
	[
		returns the current start function.
	]
	
	@method getFetchTag
	[
		returns the current fetch tag.
	]
	
	@method getTaggedModules
	[
		returns a table of all modules tagged with the current fetch tag using CollectionService.
	]

]]

local RunService = game:GetService("RunService")
local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

type ModuleLoader = {
	__index: ModuleLoader,

	--//Constructor
	new: (container: Script|Folder) -> ModuleLoader,

	--//Utils
	requireModules: () -> any,
	initModule: (Import: {}) -> ModuleLoader,
	loadAllModules: () -> ModuleLoader,

	--//Setters
	setInitFunction: (func: () -> any) -> ModuleLoader,
	setStartFunction: (func: () -> any) -> ModuleLoader,
	setFetchTag: (tagName: string) -> ModuleLoader,

	--//Getters
	getModules: () -> {ModuleScript},
	getContext: () -> (),
	getFunction: (func: () -> any) -> boolean,
	getInitFunction: () -> string,
	getStartFunction: () -> string,
	getFetchTag: () -> string,
	getTaggedModules: () -> ModuleLoader,
}


local ModuleLoader = {}
ModuleLoader.__index = ModuleLoader
ModuleLoader.LOADER_CONFIG = {
	_InitFunction = script:GetAttribute("InitFunction"),
	_StartFunction = script:GetAttribute("StartFunction"),

	_FetchTag = script:GetAttribute("FetchTag"),
	VerboseLoading = script:GetAttribute("VerboseLoading"),
	_ForceLoadTag = script:GetAttribute("ForceLoadTag"),
}

function ModuleLoader.new(container: Script|Folder)
	return setmetatable(
		{
			_InitFunction = ModuleLoader.LOADER_CONFIG._InitFunction,
			_StartFunction = ModuleLoader.LOADER_CONFIG._StartFunction,
			_FetchTag = ModuleLoader.LOADER_CONFIG._FetchTag,

			container = container,
			contextPrefix = nil,
			imports = {},
			modules = {},
			loadedModules = {},
		}, 
		ModuleLoader
	)
end

function ModuleLoader:getModules()
	for _, module in self.container:GetChildren() do
		if not module:IsA("ModuleScript") then continue end

		table.insert(self.modules, module)
	end
end

function ModuleLoader:requireModules()
	if not self.modules then return end

	for _, module : ModuleScript in self.modules do

		local success, result = pcall(function()
			return require(module)
		end)		

		if not success then
			warn("[".. self.contextPrefix .."]: ", result)
			return
		else
			table.insert(self.imports, result)
		end
	end
end

function ModuleLoader:getContext()
	if self.contextPrefix ~= nil then return end

	return RunService:IsServer() and "S" or "C"
end

function ModuleLoader:getFunction(funcName: string)
	if self.imports == nil then return end

	for _, import in self.imports do
		for i, _func in import do
			if _func ~= funcName then continue end

			return _func ~= nil
		end
	end
end

function ModuleLoader:setInitFunction(funcName: string)
	self._InitFunction = funcName or ModuleLoader.LOADER_CONFIG._InitFunction
	return self	
end

function ModuleLoader:setStartFunction(funcName: string)
	self._StartFunction = funcName or ModuleLoader.LOADER_CONFIG._StartFunction
	return self	
end

function ModuleLoader:setFetchTag(tagName: string)
	self._FetchTag = tagName or ModuleLoader.LOADER_CONFIG._FetchTag
	return self	
end

function ModuleLoader:getInitFunction()
	return self._InitFunction	
end

function ModuleLoader:getStartFunction()
	return self._StartFunction 
end

function ModuleLoader:getFetchTag()
	return self._FetchTag
end

function ModuleLoader:getTaggedModules()
	for _, module in CollectionService:GetTagged(self._FetchTag) do
		if not module:IsA("ModuleScript") then continue end

		if module:IsDescendantOf(ReplicatedStorage) then
			if not RunService:IsClient() and not module:GetAttribute(ModuleLoader.LOADER_CONFIG._ForceLoadTag) then continue end
		elseif module:IsDescendantOf(ServerScriptService) then
			if not RunService:IsServer() and not module:GetAttribute(ModuleLoader.LOADER_CONFIG._ForceLoadTag) then continue end
		end

		table.insert(self.modules, module)
	end

	return self
end

function ModuleLoader:initModule(Import: {})
	if not Import then return end

	local success, result = pcall(function()
		return Import[self:getInitFunction()]()
	end)

	if not success then
		warn("[".. self.contextPrefix .."]: ", result)
	else
		if ModuleLoader.LOADER_CONFIG.VerboseLoading == false then return end

		warn("[".. self.contextPrefix .."]: ", result)
	end

	return self
end

function ModuleLoader:loadAllModules()
	self.contextPrefix = self:getContext()
	self:getTaggedModules()
	self:getModules()
	self:requireModules()

	for _, import in self.imports do
		self:initModule(import)
		table.insert(self.loadedModules, import)

		if ModuleLoader.LOADER_CONFIG.VerboseLoading == false then continue end

		warn("[".. self.contextPrefix .."]: Loaded  import : ", import)
	end

	return self
end

return ModuleLoader