local M = {}

M.func_wrap = function(table, name, wrapper)
    local super = table[name]
    table[name] = function(...)
        return wrapper(super, ...)
    end
end

M.g_func_wrap = function(name, wrapper)
    M.func_wrap(G.FUNCS, name, wrapper)
end

M.uidef_func_wrap = function(name, wrapper)
    M.func_wrap(G.UIDEF, name, wrapper)
end

M._g_func_wrap = function(name, wrapper)
    M.func_wrap(_G, name, wrapper)
end

M.create_box_wrap = function(name, wrapper)
    M._g_func_wrap('create_UIBox_' .. name, wrapper)
end

M.preserve_vars = function(callback, ...)
    local reset = {}
    for _, var in ipairs({ ... }) do
        if type(var) == 'string' then
            var = { _G, var }
        end

        local t, k = table.unpack(var)
        table.insert(reset, { t, k, t[k] })
    end

    local res = callback()

    for _, var in ipairs(reset) do
        local t, k, v = table.unpack(var)
        t[k] = v
    end

    return res
end

return M
