local n = vim.api

local get_schemes = function()
	local paths_string = n.nvim_call_function('globpath', {
		n.nvim_get_option('packpath'), 'pack/colors/opt/*/colors/*.vim' })
	local paths = n.nvim_call_function('split', { paths_string, '\n' })
	
	local names = {}
	for index, path in pairs(paths) do
		table.insert(names, n.nvim_call_function('fnamemodify', { path, ':t:r' }))
	end

	return names
end

local random_number = function(limit)
	local reltime = n.nvim_call_function('reltime', { })
	local reltimestr = n.nvim_call_function('reltimestr', { reltime })
	local capture = string.match(reltimestr, '%.(%d*)')
	local microseconds = capture + 0
	return microseconds % limit
end

local get_scheme = function()
	local schemes = get_schemes()
	local scheme = schemes[random_number(#schemes)]
	n.nvim_command('colorscheme ' .. scheme)
end

return get_scheme
