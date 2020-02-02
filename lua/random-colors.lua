local n = vim.api
local cache_path = n.nvim_call_function('stdpath', { 'cache' })
local used_schemes_file = cache_path .. '/used_random_colors'

local used_schemes_file_exists =
	n.nvim_call_function('filereadable', { used_schemes_file })
if used_schemes_file_exists == 0 then
	os.execute('mkdir -p ' .. cache_path .. ' && touch ' .. used_schemes_file)
end

local get_all_schemes = function()
	local paths_string = n.nvim_call_function('globpath', {
		n.nvim_get_option('packpath'), 'pack/*/opt/*/colors/*.vim' })
	local paths = n.nvim_call_function('split', { paths_string, '\n' })
	
	local names = {}
	for index, path in pairs(paths) do
		table.insert(names, n.nvim_call_function('fnamemodify', { path, ':t:r' }))
	end

	return names
end

local get_available_schemes = function(all_schemes, used_schemes)
	local lookup = { }
	for i, v in ipairs(used_schemes) do
		lookup[v] = true
	end

	local available_schemes = { }
	for i, v in ipairs(all_schemes) do
		if (not lookup[v]) then
			table.insert(available_schemes, v)
		end
	end

	if #available_schemes == 0 then
		os.execute('echo "" > ' .. used_schemes_file)
		return all_schemes
	else
		return available_schemes
	end
end

local get_used_schemes = function()
	local used_schemes = {}
	for line in io.lines(used_schemes_file) do
		table.insert(used_schemes, line)
	end

	return used_schemes
end

local random_number = function(limit)
	return (os.time() % limit) + 1
end

local set_scheme = function()
	local all_schemes = get_all_schemes()
	local used_schemes = get_used_schemes()

	local available_schemes = get_available_schemes(all_schemes, used_schemes)

	local scheme = available_schemes[random_number(#available_schemes)]
	n.nvim_command('colorscheme ' .. scheme)
	os.execute('echo ' .. scheme .. ' >> ' .. used_schemes_file)
end

return set_scheme
