-- Codec between several files and one file

--[[
  Author: Martin Eden
  Last mod.: 2026-10-02
]]

--[[ Develop
package.path = package.path .. ';../../../?.lua'
--]]
require('workshop.base')

-- Encode files list to stream
local files_to_stream
do
  local file_to_str = request('!.convert.file_to_str')
  local encode_itness = request('!.concepts.codec_itness.compile')

  files_to_stream =
    function(FileNames, Output)
      for _, file_name in ipairs(FileNames) do
        encode_itness({ file_name, file_to_str(file_name) }, Output)
      end
    end
end

-- Create files from stream
local files_from_stream
do
  local decode_itness = request('!.concepts.codec_itness.parse')
  local rebase_to = request('!.concepts.path_name.rebase_to')
  local file_from_str = request('!.convert.file_from_str')

  files_from_stream =
    function(Input, output_dir)
      while true do
        local FileRec = decode_itness(Input)
        if not is_table(FileRec) then break end

        local name = FileRec[1]
        local data = FileRec[2]

        name = rebase_to(output_dir, name)
        file_from_str(name, data)
      end
    end
end

local print_help
do
  local help_text = [[
Codec between several files and one file

Usage: <action> <input_name> <output_name>

  <action> -- what to do. One of:

    export -- combine files
      from <input_name> directory to <output_name> file

    import -- decombine files
      from <input_name> file to <output_name> directory

-- Martin, 2026-10
]]
  print_help =
    function()
      io.stdout:write(help_text)
    end
end

local action = arg[1]
local input_name = arg[2]
local output_name = arg[3]

if not (action and input_name and output_name) then
  print_help()
  return
end

if (action == 'export') then
  local input_dir = input_name
  local output_file_name = output_name
  local FilesList
  do
    local get_files_list =
      request('!.file_system.directory.get_total_files_list')
    FilesList = get_files_list(input_dir)
  end
  local Output
  do
    local OutputFile = request('!.concepts.StreamIo.Output.File')
    Output = OutputFile.create(output_file_name)
  end
  Output:Open()
  files_to_stream(FilesList, Output)
  Output:Close()
elseif (action == 'import') then
  local input_file_name = input_name
  local output_dir = output_name
  local Input
  do
    local InputFile = request('!.concepts.StreamIo.Input.File')
    Input = InputFile.create(input_file_name)
  end
  Input:Open()
  files_from_stream(Input, output_dir)
  Input:Close()
end

--[[
  2026-09-23
  2026-10-02
]]
