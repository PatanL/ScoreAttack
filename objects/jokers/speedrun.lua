SMODS.Joker({
	key = "speedrun",
	atlas = "j_speedrun",
	rarity = 2,
	cost = 6,
	unlocked = true,
	discovered = true,
	blueprint_compat = true,
	config = { extra = {} },
	loc_vars = function(self, info_queue, card)
		return { vars = {} }
	end,
	calculate = function(self, card, context)
		-- Trigger when setting the blind if it's a Boss (Score Attack)
		if context.setting_blind and G.GAME.blind.boss and not (context.blueprint_card or card).getting_sliced then
			if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
				G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
				G.E_MANAGER:add_event(Event({
					func = function()
						local new_card = create_card('Spectral', G.consumeables, nil, nil, nil, nil, nil, 'sa_speedrun')
						new_card:add_to_deck()
						G.consumeables:emplace(new_card)
						G.GAME.consumeable_buffer = 0
						return true
					end
				}))
				return {
					message = localize('k_plus_spectral'),
					colour = G.C.SECONDARY_SET.Spectral,
					card = card
				}
			end
		end
	end
})