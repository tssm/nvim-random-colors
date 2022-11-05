local _2afile_2a = "fnl/random-colors.fnl"
local _local_1_ = require("random-colors.aniseed.core")
local concat = _local_1_["concat"]
local map = _local_1_["map"]
local slurp = _local_1_["slurp"]
local _local_2_ = vim.fn
local filereadable = _local_2_["filereadable"]
local fnamemodify = _local_2_["fnamemodify"]
local globpath = _local_2_["globpath"]
local split = _local_2_["split"]
local stdpath = _local_2_["stdpath"]
local state_path = stdpath("state")
local used_schemes_file = (state_path .. "/used_schemes")
if (0 == filereadable(used_schemes_file)) then
  os.execute(("mkdir -p " .. state_path .. " && touch " .. used_schemes_file))
else
end
local all_schemes
do
  local path_template = "pack/*/%s/*/colors/*.%s"
  local packpath = vim.o.packpath
  local paths = concat(globpath(packpath, string.format(path_template, "opt", "lua"), false, true), globpath(packpath, string.format(path_template, "opt", "vim"), false, true), globpath(packpath, string.format(path_template, "start", "lua"), false, true), globpath(packpath, string.format(path_template, "start", "vim"), false, true))
  local function _4_(path)
    return fnamemodify(path, ":t:r")
  end
  all_schemes = map(_4_, paths)
end
local function used_schemes()
  return split(slurp(used_schemes_file))
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
  vim.api.nvim_exec(("colorscheme " .. scheme), false)
  return os.execute(("echo " .. scheme .. " >> " .. used_schemes_file))
end
return set_scheme