local M = {}

M.tbl_islist = function(t)
    if type(t) ~= 'table' then
        return false
    end

    local j = 1
    for _ in pairs(t) do
        if t[j] == nil then
            return false
        end
    end

    return true
end

M.tbl_keys = function(t)
    local keys = {}
    for k in pairs(t) do
        table.insert(keys, k)
    end

    return keys
end

M.tbl_values = function(t)
    local values = {}
    for _, v in pairs(t) do
        table.insert(values, v)
    end

    return values
end

M.tbl_any = function(t, callback)
    callback = callback or function(_, v) return v end

    for k, v in M.kpairs(t) do
        if callback(k, v) then return true end
    end

    return false
end

local can_merge = function(v)
    return type(v) == 'table' and M.tbl_islist(v)
end

M.tbl_merge = function(behaviour, deep_merge, ...)
    local res = {}

    for i, tbl in ipairs({ ... }) do
        if tbl then
            for k, v in pairs(tbl) do
                if deep_merge and can_merge(v) then
                    res[k] = M.tbl_merge(behaviour, true, res[k], v)
                elseif type(behaviour) == 'function' then
                    res[k] = behaviour(k, res[k], v)
                elseif behaviour ~= 'force' and res[k] ~= nil then
                    if behaviour == 'error' then
                        error('key found in more than one map: ' .. k)
                    end
                else
                    res[k] = v
                end
            end
        end
    end

    return res
end

-- XXX: should we handle lists in deep copying/merging?
M.tbl_copy = function(deep_copy, t)
    return M.tbl_merge('force', deep_copy, t)
end

return M
