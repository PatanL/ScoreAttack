SMODS.Joker:take_ownership('bloodstone', {
    -- We don't need to specify key here, take_ownership handles it
    atlas = "j_bloodstone", 
    rarity = 2,
    cost = 7,
    config = { extra = { odds = 2, Xmult = 1.5 } },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                (G.GAME and G.GAME.probabilities.normal or 1),
                card.ability.extra.odds,
                card.ability.extra.Xmult,
            },
        }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            if context.other_card:is_suit("Hearts") and pseudorandom("bloodstone") < G.GAME.probabilities.normal / card.ability.extra.odds then
                return {
                    x_mult = card.ability.extra.Xmult,
                    card = card,
                }
            end
        end
    end
})