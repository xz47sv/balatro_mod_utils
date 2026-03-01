UTILS.Starthooks = {}
UTILS.Starthook = SMODS.GameObject:extend({
    obj_table = UTILS.Starthooks,
    obj_buffer = {},
    required_params = { 'action' },
    set = 'Starthook',
    register = function(self)
        self.key = self.key or tostring(#self.obj_buffer)
        UTILS.Starthook.super.register(self)
    end,
    inject = function(_) end
})

UTILS.run_start_hooks = function()
    for _, hook in ipairs(
        UTILS.list_sorted(
            UTILS.tbl_values(UTILS.Starthooks),
            function(lhs, rhs)
                return (lhs.priority or 0) < (rhs.priority or 0)
            end
        )
    ) do
        hook:action()
    end
end
