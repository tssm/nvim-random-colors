local _2afile_2a = "fnl/random-colors.fnl"
local api = vim.api
local call = api.nvim_call_function
local core = require("random-colors.aniseed.core")
local cache_path = call("stdpath", {"cache"})
local used_schemes_file = (cache_path .. "/used_schemes")
if (0 == call("filereadable", {used_schemes_file})) then
  os.execute(("mkdir -p " .. cache_path .. " && touch " .. used_schemes_file))
else
end
local all_schemes
do
  local strings = call("globpath", {api.nvim_get_option("packpath"), "pack/**/colors/*.vim"})
  local paths = call("split", {strings, "\n"})
  local function _2_(path)
    return call("fnamemodify", {path, ":t:r"})
  end
  all_schemes = core.map(_2_, paths)
end
local function used_schemes()
  return call("split", {core.slurp(used_schemes_file)})
end
local function _5c_5c(a, b)
  local remove = {}
  local result = {}
  for _, v in ipairs(b) do
    remove[v] = true
  end
  for _, v in ipairs(a) do
    if not remove[v] then
      table.insert(result, v)
    else
    end
  end
  return result
end
local function random_number(limit)
  return ((os.time() % limit) + 1)
end
local function available_schemes()
  local difference = _5c_5c(all_schemes, used_schemes())
  if (0 == #difference) then
    return all_schemes
  else
    return difference
  end
end
local function set_scheme()
  local total_schemes = #available_schemes()
  local schemes = available_schemes()
  local scheme = schemes[random_number(total_schemes)]
  if (total_schemes == #all_schemes) then
    os.execute(("echo '' > " .. used_schemes_file))
  else
  end
  api.nvim_command(("colorscheme " .. scheme))
  return os.execute(("echo " .. scheme .. " >> " .. used_schemes_file))
end
return set_scheme