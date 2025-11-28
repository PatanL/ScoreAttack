SMODS.Blind({
    key = 'score_attack',
    name = 'Score Attack',
    loc_txt = {
        name = 'Score Attack',
        text = {
            'Score as high as you can!',
            'Cannot lose lives.'
        }
    },
    chips = 1, 
    dollars = 8,
    mult = 1,
    boss = {min = 1, max = 10},
    boss_colour = G.C.RED,
    atlas = "sa_blind_chip",
    pos = {x = 0, y = 0},
    discovered = true,
    order = 100,
    in_pool = function(self) return false end,
    set_blind = function(self, blind, reset, silent)
        -- Set chips to a massive number so the bar is always full/challenging
        G.GAME.blind.chips = 1e300
        G.GAME.blind.chip_text = "∞"
        
        -- Force UI update
        if G.HUD_blind then
            local count = G.HUD_blind:get_UIE_by_ID('HUD_blind_count')
            if count then count.config.object:update() end
        end
    end,
    disable = function(self) end
})