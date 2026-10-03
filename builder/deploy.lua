-- Execute modules, get list of all Lua files that were required, copy them

--[[
  Author: Martin Eden
  Last mod.: 2026-10-30
]]

--[[
  How to use

  * Include root modules in <ModulesList>

  * Do one of

    * Copy this file to root Lua source directory

    * Call this file from Lua source directory:

        $ lua ../builder/deploy.lua

  Make sure that main Lua file executes without errors when
  loaded as module. If needed, make changes to it to behave so.
]]

--[[
  In my older style all required modules were unconditionally loaded.
  So just requiring root module was enough to load all required modules.

  In my recent style required modules may be conditionally loaded.
  So we often need to run module several times with different input
  to get coverage of used modules.
]]

--
local Modules =
  {
    {
      'files_tree',
      { 'export', '../input/', '../output/files.is' },
    },
    {
      'files_tree',
      { 'import', '../output/files.is', '../output/restored_input/' },
    },
  }
--
package.path = package.path .. ';../../../?.lua'
--
local FilesList
do
  local ModulesPaths = { }
  do
    local ModulePaths
    local observe_modules = require('workshop.system.observe_modules')

    for _, ModuleRec in ipairs(Modules) do
      for i, cmdline_arg in ipairs(ModuleRec[2]) do
        _G.arg[i] = cmdline_arg
      end
      ModulesPaths[#ModulesPaths + 1] = observe_modules({ ModuleRec[1] })
    end
  end

  local add_to = request('!.concepts.list.add_item')
  FilesList = { }
  for _, ModulePaths in ipairs(ModulesPaths) do
    for _, ModuleLoc in ipairs(ModulePaths) do
      add_to(FilesList, ModuleLoc[2])
    end
  end

  local map_values = request('!.table.map_values')
  local get_keys = request('!.table.get_keys')

  FilesList = get_keys(map_values(FilesList))
end

require('workshop.base')
local deploy = request('!.mechs.deploy')

deploy(FilesList)
--

--[[
  202?
  2026 # # # # # #
  2026-10-03
]]
