local glass = SMODS.Enhancement({
    key = "m_sa_glass",
    prefix_config = { key = false, atlas = false },
    name = "Glass Card",
    -- atlas = "centers", -- Commented out to test registration
    -- pos = { x = 6, y = 0 }, 
    config = { Xmult = 1.5, extra = 4 },
    loc_txt = {
        name = "Glass Card",
        text = {
            "{X:mult,C:white} X#1# {} Mult",
            "{C:green}#2# in #3#{} chance to",
            "destroy card"
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.x_mult, G.GAME.probabilities.normal, card.ability.extra } }
    end,
})
