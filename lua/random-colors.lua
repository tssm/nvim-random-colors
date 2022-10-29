local _2afile_2a = "fnl/random-colors.fnl"
local core = require("random-colors.aniseed.core")
local f = vim.fn
local state_path = f.stdpath("state")
local used_schemes_file = (state_path .. "/used_schemes")
if (0 == f.filereadable(used_schemes_file)) then
  os.execute(("mkdir -p " .. state_path .. " && touch " .. used_schemes_file))
else
end
local all_schemes
do
  local strings = f.globpath(vim.o.packpath, "pack/**/colors/*.vim")
  local paths = f.split(strings, "\n")
  local function _2_(path)
    return f.fnamemodify(path, ":t:r")
  end
  all_schemes = core.map(_2_, paths)
end
local function used_schemes()
  return f.split(core.slurp(used_schemes_file))
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