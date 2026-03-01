local M = {}

M.list_extend = function(dst, src, start, finish)
    for i = start or 1, finish or #src do
        table.insert(dst, src[i])
    end
end

M.list_concat = function(...)
    local res = {}
    for _, l in ipairs({ ... }) do
        M.list_extend(res, l)
    end

    return res
end

M.list_any = function(l, callback)
    callback = callback or function(v) return v end

    for _, v in ipairs(l) do
        if callback(v) then return true end
    end

    return false
end

M.list_find = function(l, callback)
    if type(callback) ~= 'function' then
        callback = function(v) return v == callback end
    end

    for i, v in ipairs(l) do
        if callback(v) then
            return i
        end
    end

    return 0
end

M.list_map = function(l, callback)
    local res = {}
    for _, v in ipairs(l) do
        res.insert(callback(v))
    end

    return res
end

-- XXX: should we handle nested lists and tables?
M.list_copy = function(l)
    local res = {}
    M.list_extend(res, l)
    return res
end

M.list_sorted = function(t, comparator)
    local res = M.list_copy(t)
    table.sort(res, comparator)
    return res
end

return M
