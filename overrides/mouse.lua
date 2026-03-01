UTILS.Mousebinds = {}
UTILS.Mousebind = SMODS.GameObject:extend({
    obj_table = UTILS.Mousebinds,
    obj_buffer = {},

    event = 'pressed',

    required_params = { 'button', 'action' },
    set = 'Mousebind',
    register = function(self)
        self.key = self.key or tostring(#self.obj_buffer)
        UTILS.Mousebind.super.register(self)
    end,
    inject = function(_) end
})

for _, event in ipairs({ 'pressed', 'released' }) do
    UTILS.func_wrap(love, 'mouse' .. event, function(super, x, y, button, ...)
        super(x, y, button, ...)

        for _, mousebind in pairs(UTILS.Mousebinds) do
            if mousebind.button == button and mousebind.event == event then
                mousebind:action()
            end
        end
    end)
end
