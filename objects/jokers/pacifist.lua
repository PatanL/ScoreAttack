SMODS.Joker({
	key = "pacifist",
	atlas = "j_pacifist",
	rarity = 1,
	cost = 4,
	unlocked = true,
	discovered = true,
	blueprint_compat = true,
	config = { extra = { x_mult = 10 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.x_mult } }
	end,
	calculate = function(self, card, context)
		if context.cardarea == G.jokers and context.joker_main and not G.GAME.blind.boss then
			return {
				x_mult = card.ability.extra.x_mult,
			}
		end
	end
})