SMODS.Joker({
	key = "pizza",
	atlas = "j_pizza",
	rarity = 1,
	cost = 4,
	unlocked = true,
	discovered = true,
	blueprint_compat = true,
	eternal_compat = false,
	config = { extra = { discards = 2 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.discards } }
	end,
	calculate = function(self, card, context)
		if context.end_of_round and G.GAME.blind.boss then
			ease_discard(card.ability.extra.discards)
			local _card = context.blueprint_card or card
			_card:remove_from_deck()
			_card:start_dissolve({ G.C.RED }, nil, 1.6)
			return {
				message = localize("k_eaten_ex"),
				colour = G.C.RED,
			}
		end
	end
})