SMODS.Joker({
    key = "hanging_chad", -- SMODS will prefix this to j_sa_hanging_chad
    name = "Hanging Chad",
    rarity = 1,
    cost = 4,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    pos = { x = 9, y = 6 }, -- Vanilla Hanging Chad position
    atlas = "Joker", -- Vanilla Atlas
    prefix_config = { atlas = false }, -- Don't prefix atlas
    config = { extra = 1 },
    loc_txt = {
        name = "Hanging Chad",
        text = {
            "Retrigger {C:attention}first{} and {C:attention}second{}",
            "played card used in scoring",
            "{C:attention}#1#{} additional time",
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra } }
    end,
    calculate = function(self, card, context)
        if context.cardarea == G.play and context.repetition then
            if context.other_card == context.scoring_hand[1] or context.other_card == context.scoring_hand[2] then
                return {
                    message = localize("k_again_ex"),
                    repetitions = card.ability.extra,
                    card = card,
                }
            end
        end
    end
})