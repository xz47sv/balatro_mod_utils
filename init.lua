UTILS = {}

local STACK = {}

local split_path = function(path)
    return path:match('^(.*)/([^/]*)$')
end

local require_many = function(...)
    local res = {}

    for _, module in ipairs({ ... }) do
        local m = UTILS.require(module)
        if type(m) == 'table' and not UTILS.tbl_islist(m) then
            res = UTILS.tbl_merge('force', false, res, m)
        end
    end

    return res
end

UTILS.require = function(...)
    if select('#', ...) ~= 1 then
        return require_many(...)
    end

    local module = select(1, ...)

    local dirname, basename = split_path(module)
    basename = basename or module

    local to_pop = 0
    if dirname then
        table.insert(STACK, dirname)
        to_pop = to_pop + 1
    end

    if #STACK ~= 0 then
        module = table.concat(STACK, '/') .. '/' .. basename
    end

    local prefix = split_path(SMODS.current_mod.main_file)
    if prefix then
        prefix = prefix .. '/'
    else
        prefix = ''
    end

    local info = NFS.getInfo(SMODS.current_mod.path .. '/' .. prefix .. module)
    if info and info.type == 'directory' then
        table.insert(STACK, basename)
        to_pop = to_pop + 1
        module = module .. '/init.lua'
    else
        module = module .. '.lua'
    end

    local res = assert(SMODS.load_file(prefix .. module))()

    for _ = 1, to_pop do
        table.remove(STACK)
    end

    return res
end

UTILS.require('lib', 'overrides/game', 'overrides/mouse')
