SMODS.Joker({
	key = "defensive_joker",
	atlas = "j_defensive_joker",
	rarity = 1,
	cost = 4,
	unlocked = true,
	discovered = true,
	blueprint_compat = true,
	config = { extra = { chips_per_life = 125 } },
	loc_vars = function(self, info_queue, card)
		local lives_lost = 0
		if G.GAME.starting_params and G.GAME.lives then
			lives_lost = math.max(0, G.GAME.starting_params.lives - G.GAME.lives)
		end
		return { vars = { card.ability.extra.chips_per_life, lives_lost * card.ability.extra.chips_per_life } }
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			local lives_lost = math.max(0, G.GAME.starting_params.lives - G.GAME.lives)
			return {
				chip_mod = lives_lost * card.ability.extra.chips_per_life,
				message = localize{type='variable',key='a_chips',vars={lives_lost * card.ability.extra.chips_per_life}}
			}
		end
	end
})