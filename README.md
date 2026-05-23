ModuleLoader

A lightweight, typed‑checked module loader for Roblox.
Version 0.2.1 — Documentation fully up to date.
Overview

The ModuleLoader provides a structured, predictable way to initialize and start ModuleScripts on both server and client. It supports typed fields, configurable init/start functions, tagged module discovery, and runtime setters/getters.
Getting Started
1. Server Setup

Create a Script inside ServerScriptService.
Recommended name: Server.
2. Client Setup

Create a LocalScript inside:
StarterPlayer > StarterPlayerScripts
Recommended name: Client.
3. Initialization Snippet

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ModuleLoader = require(ReplicatedStorage.Shared.Utilities.ModuleLoader)

ModuleLoader.new(script):loadAllModules()

Datatypes
Utility Methods

    requireModules
    Loops through and requires all ModuleScripts in self.modules. Returns nil if none.

    initModule
    Locates and initializes a single import.

    loadAllModules
    Initializes all imports contained in self.imports.

Fields
LOADER_CONFIG

    _InitFunction (string)

    _StartFunction (string)

    _FetchTag (string)

    _ForceLoadTag (string)

    VerboseLoading (boolean)

Core Fields

    container
    Script or Folder containing all modules to load.

    contextPrefix
    Prefix used for contextual logging such as [S] or [C].

    imports
    Table of all required module imports.

    modules
    Table of all modules discovered by the loader.

    loadedModules (deprecated)
    Previously loaded modules.

Configurable Fields

    _InitFunction
    Default: "Init"
    Defines the initialization function name.

    _StartFunction
    Default: "Start"
    Defines the start function name.

    _FetchTag
    Default: "LOAD_MODULE"
    Tag used to detect modules via CollectionService.

    VerboseLoading
    Default: true
    Enables or disables loader logs.

Imports

An import is the table returned by a module when required.
By default, imports contain two functions:

    Init

    Start

When VerboseLoading is enabled, all imports are printed to output.
InitFunctions and StartFunctions

    InitFunction
    Called when the module is required.
    Should only be called by the loader.

    StartFunction
    Called after initialization.
    Runs once Init has completed.

Setters and Getters
Setters

    setInitFunction
    Overrides the current init function name.

    setStartFunction
    Overrides the current start function name.

    setFetchTag
    Overrides the fetch tag used to detect modules.

Getters

    getModules
    Returns all modules inside the loader’s container.

    getContext
    Returns the current context prefix.

    getFunction
    Returns a function by name.

    getInitFunction
    Returns the current init function name.

    getStartFunction
    Returns the current start function name.

    getFetchTag
    Returns the current fetch tag.

    getTaggedModules
    Returns all modules tagged with the current fetch tag.

Versioning Format

    First digit: changes based on second digit

    Second digit: incremented for bug fixes and updates

    Third digit: incremented per script change or major type addition
    A full API reference version

    A version with code examples for each method
    Just tell me which one you want next using generate quickstart or add examples.****
