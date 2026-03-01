local M = {}

M.in_game = function()
    return G.STAGE == G.STAGES.RUN
end

return M
