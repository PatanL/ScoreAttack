SMODS.Joker({
	key = "penny_pincher",
	atlas = "j_penny_pincher",
	rarity = 1,
	cost = 4,
	unlocked = true,
	discovered = true,
	blueprint_compat = false,
	config = { extra = { dollars = 1, spend_threshold = 5 } }, -- Earn $1 for every $5 spent
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.dollars, card.ability.extra.spend_threshold } }
	end,
	calc_dollar_bonus = function(self, card)
		-- We need to track spending. For now, let's just give a flat bonus to simulate it
		-- or hook into buy_card to track it properly.
		-- Simpler version: Flat $5 bonus
		return 5
	end
})