SMODS.Joker({
	key = "skip_off",
	atlas = "j_skip_off",
	rarity = 2,
	cost = 5,
	unlocked = true,
	discovered = true,
	blueprint_compat = false,
	config = { extra = { hands = 0, discards = 0, per_skip_h = 1, per_skip_d = 1 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.per_skip_h, card.ability.extra.per_skip_d, card.ability.extra.hands, card.ability.extra.discards } }
	end,
	calculate = function(self, card, context)
		if context.skip_blind then
			card.ability.extra.hands = card.ability.extra.hands + card.ability.extra.per_skip_h
			card.ability.extra.discards = card.ability.extra.discards + card.ability.extra.per_skip_d
			return {
				message = localize('k_upgrade_ex'),
				card = card
			}
		end
		if context.setting_blind and not context.blueprint then
			ease_hands_played(card.ability.extra.hands)
			ease_discard(card.ability.extra.discards)
		end
	end
})