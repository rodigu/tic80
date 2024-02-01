local has_args = (#arg~=0)

--- Reads file with given name
---@param filename string
---@return string[]
function ReadFile(filename)
  local file = io.open(filename, 'r')
  local lines = {}
  for line in file:lines() do
    table.insert(lines, line)
  end
  file:close()
  return lines
end

function ReadConfig(config_filename)
  local config_lines = ReadFile(config_filename)
  
  local target = string.sub(config_lines[1], #'target:' + 1)
  local input = string.sub(config_lines[2], #'in:' + 1)

  return target, input
end

function SplitString(str, split)
  if split == nil then split = '%s' end
  local t={}
  for s in string.gmatch(str, "([^"..split.."]+)") do table.insert(t, s) end
  return t
end

function TableSlice(t, first, last, step)
  local sliced = {}
  for i=first or 1, last or #t, step or 1 do
    table.insert(sliced, t[i])
  end
  return sliced
end

function ConcatTable(t1, t2)
  for _,v in ipairs(t2) do
    table.insert(t1, v)
  end
  return t1
end

function InsertHeader(new, original)
  local header_end = 7
  local header_lines = TableSlice(original, 1, header_end)
  ConcatTable(new, header_lines)
end

function InsertInputs(new, input_names)
  for _,input_name in ipairs(input_names) do
    local input_data = ReadFile(input_name..'.lua')
    ConcatTable(new, input_data)
  end
end

function InsertCartData(new, original_data)
  local cart_data_id = '-- <TILES>'
  local cart_data_loc = 0

  for i,l in ipairs(original_data) do
    if l:find(cart_data_id)~= nil then
      cart_data_loc = i
      break
    end
  end

  ConcatTable(new, TableSlice(original_data, cart_data_loc))
end

function WriteFile(config_filename)
  local target, input = ReadConfig(config_filename)
  local input_names = SplitString(input, ',')

  local original_data = ReadFile(target..'.lua')

  local new_data = {}

  -- Injection
  InsertHeader(new_data, original_data)
  InsertInputs(new_data, input_names)
  InsertCartData(new_data, original_data)

  local file = io.open(target..'.lua', 'w+')

  file:write(table.concat(new_data, '\n'))

  file:close()
end

local config_filename = 'config'
if has_args then
  config_filename = arg[1]
  print('Using config file: '..config_filename)
end

WriteFile(config_filename)