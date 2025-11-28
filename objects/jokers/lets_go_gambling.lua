SMODS.Joker({
    key = "lets_go_gambling",
    atlas = "j_lets_go_gambling", -- Fixed: Matches core.lua definition
    rarity = 2,
    cost = 6,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    config = { extra = { odds = 4, xmult = 4, dollars = 10 } },
    loc_vars = function(self, info_queue, card)
        local num, den = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, "sa_lgg")
        return { vars = { num, den, card.ability.extra.xmult, card.ability.extra.dollars } }
    end,
    calculate = function(self, card, context)
        if context.cardarea == G.jokers and context.joker_main then
            if SMODS.pseudorandom_probability(card, "sa_lgg", 1, card.ability.extra.odds) then
                return {
                    x_mult = card.ability.extra.xmult,
                    dollars = card.ability.extra.dollars
                }
            end
        end
    end
})