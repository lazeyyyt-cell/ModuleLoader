# ModuleLoader

A lightweight, typed‑checked module loader for Roblox.
Version 0.2.1 — Documentation fully up to date.
Overview

# DOCUMENTATION
## Docs up to date for version 0.2.1

### 1/ Getting Started

This section of the documentation will focus
on getting you ready to use the module loader at a basic level.

### 1.1 Server setup :
	First create a Script in ServerScriptService
	For better clarity i recommend naming this script "Server"

Client setup :
	LocalScript in StarterPlayer -> StarterPlayerScripts
	For better clarity i recommend naming this script "Client"

### 1.2 Initialization snippet for Server and Client : 

```lua
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ModuleLoader = require(ReplicatedStorage.Shared.Utilities.ModuleLoader)

ModuleLoader.new(script):loadAllModules()
```
    
### 2/ Datatypes
This section of the documentation will focus on
the datatypes of the module loader.

### 2.1 Utility functions :

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

### 2.2 Fields :

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
	
### 2.3 Imports :

An import is the table returned by a module when it is required by the loader.
Each import is essentially composed of two functions by default being the "Init" and "Start" functions.
	
All imports are printed to the output when @Boolean VerboseLoading is enabled, 
it is a table containing all functions you indexed with the module table.

### 2.4 InitFunctions and StartFunctions :
	
	The InitFunction is a function that is called when the module is required by the loader,
	it is the first function that should be called only by the loader.
	
	The StartFunction is a function that is called when the module is initialized by the loader,
	it is a function that needs to be called whenever the Init function is finished.

### 3/ Setters and Getters :

	Setters are used to overwrite data in the loader's fields at runtime.
	
	Getters are use to read data in loader's fields at runtime.
	
### 3.1 Setters

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

### 3.2 Getters

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
