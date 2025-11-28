SMODS.Joker({
	key = "conjoined_joker",
	atlas = "j_conjoined_joker",
	rarity = 2,
	cost = 6,
	unlocked = true,
	discovered = true,
	blueprint_compat = true,
	config = { extra = { x_mult_gain = 0.5, x_mult = 1 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.x_mult_gain, card.ability.extra.x_mult } }
	end,
	calculate = function(self, card, context)
		-- Update X Mult based on current hands left
		if context.joker_main and G.GAME.blind.boss then
			local hands_left = G.GAME.current_round.hands_left
			local current_x_mult = 1 + (hands_left * card.ability.extra.x_mult_gain)
			return {
				message = localize{type='variable',key='a_xmult',vars={current_x_mult}},
				Xmult_mod = current_x_mult
			}
		end
	end
})