local SA = SMODS.current_mod

-- Manual Localization Injection
SMODS.process_loc_text(G.localization.descriptions.Blind, "bl_sa_score_attack", {
    name = "Score Attack",
    text = {
        "Score as high as you can!",
        "Cannot lose lives."
    }
})

-- 1. Define Atlases
SMODS.Atlas({
    key = "blind_chip",
    path = "player_blind_row.png",
    px = 34,
    py = 34,
    frames = 21,
    atlas_table = "ANIMATION_ATLAS"
})

local assets = {
    bloodstone = "j_bloodstone_sandbox.png",
    defensive_joker = "j_defensive_joker.png",
    lets_go_gambling = "j_lets_go_gambling.png",
    pacifist = "j_pacifist.png",
    pizza = "j_pizza.png",
    skip_off = "j_skip_off.png",
    speedrun = "j_speedrun.png",
    conjoined_joker = "j_conjoined_joker.png",
    penny_pincher = "j_penny_pincher.png",
    taxes = "j_taxes.png"
}

for key, filename in pairs(assets) do
    SMODS.Atlas({
        key = "j_" .. key,
        path = filename,
        px = 71,
        py = 95
    })
end

-- 2. Load Objects
SMODS.load_file("objects/blinds/score_attack.lua", "ScoreAttack")

if not G.P_BLINDS['bl_sa_score_attack'] then
    G.P_BLINDS['bl_sa_score_attack'] = {
        key = 'bl_sa_score_attack',
        name = 'Score Attack',
        mult = 1,
        dollars = 5,
        boss = {min = -1, max = -1},
        boss_colour = G.C.RED,
        atlas = "sa_blind_chip",
        pos = {x = 0, y = 0}
    }
end

-- Load Enhancements
    
-- local chunk, err = SMODS.load_file("objects/enhancements/sa_glass.lua", "ScoreAttack")
-- if not chunk then
--     sendDebugMessage("FAILED TO LOAD sa_glass.lua: " .. tostring(err), "ScoreAttack")
-- else
--     local status, err2 = pcall(chunk)
--     if not status then
--         sendDebugMessage("FAILED TO EXECUTE sa_glass.lua: " .. tostring(err2), "ScoreAttack")
--     end
-- end

  
-- Load all jokers
local jokers = {
    "bloodstone", 
    "defensive_joker", 
    "sa_hanging_chad", 
    "lets_go_gambling", 
    "pacifist", 
    "pizza", 
    "skip_off",
    "speedrun", 
    "conjoined_joker", 
    "penny_pincher", 
    "taxes"
}

for _, joker in ipairs(jokers) do
    local file_path = "objects/jokers/" .. joker .. ".lua"
    local chunk = SMODS.load_file(file_path, "ScoreAttack")
    if chunk then
        local status, err = pcall(chunk)
        if not status then
            sendDebugMessage("Error loading joker " .. joker .. ": " .. tostring(err), "ScoreAttack")
        else
            sendDebugMessage("Loaded joker: " .. joker, "ScoreAttack")
        end
    else
        sendDebugMessage("Could not find file for joker: " .. joker, "ScoreAttack")
    end
end

-- 3. Game Logic Hooks
local get_new_boss_ref = get_new_boss
function get_new_boss()
    if G.GAME.round_resets.ante > 1 then
        return "bl_sa_score_attack"
    end
    return get_new_boss_ref()
end

-- Define banned consumables here
local banned_cards = {
    "c_justice",
    "v_directors_cut", 
    "j_hanging_chad",
    "v_retcon",       
}

local set_ability_ref = Card.set_ability
function Card:set_ability(center, initial, delay_sprites)
    set_ability_ref(self, center, initial, delay_sprites)
    if center.key == 'm_glass' then
        self.ability.x_mult = 1.5
        self.ability.Xmult = 1.5
        self.ability.extra = 4
    end
end

local start_run_ref = Game.start_run
function Game:start_run(args)
    start_run_ref(self, args)

    if G.GAME.round_resets.blind_choices and G.GAME.round_resets.ante > 1 then
        G.GAME.round_resets.blind_choices.Boss = 'bl_sa_score_attack'
    end
    
    -- Apply bans
    for _, key in ipairs(banned_cards) do
        G.GAME.banned_keys[key] = true
    end
    
    -- Initialize custom tracking variables
    G.GAME.sa_shop_spent = 0
    G.GAME.sa_last_shop_spent = 0

    -- -- DEBUG: Spawn jokers for testing
    -- G.E_MANAGER:add_event(Event({
    --     func = function()
    --         local debug_jokers = {
    --             "j_sa_hanging_chad",
    --             "j_sa_defensive_joker",
    --             "j_sa_lets_go_gambling",
    --             "j_sa_pacifist",
    --             "j_sa_pizza",
    --             "j_sa_skip_off",
    --             "j_sa_speedrun",
    --             "j_sa_conjoined_joker",
    --             "j_sa_penny_pincher",
    --             "j_sa_taxes"
    --         }
            
    --         for _, key in ipairs(debug_jokers) do
    --             if G.jokers.config.card_limit <= #G.jokers.cards then
    --                 G.jokers.config.card_limit = G.jokers.config.card_limit + 1
    --             end
    --             SMODS.add_card({
    --                 key = key,
    --                 area = G.jokers
    --             })
    --         end

    --         sendDebugMessage("Start spawning of glass")
    --         -- Spawn our custom Glass Card to test 1.5x mult
    --         local glass_card = SMODS.add_card({
    --             set = 'Base',
    --             area = G.hand
    --         })
            
    --         -- Try to find the center with various key possibilities
    --         local keys_to_check = {
    --             'm_sa_glass',
    --             'sa_m_sa_glass',
    --             'sa_glass',
    --             'glass'
    --         }
            
    --         local found_center = nil
    --         for _, k in ipairs(keys_to_check) do
    --             if G.P_CENTERS[k] then
    --                 sendDebugMessage("Found glass center with key: " .. k, "ScoreAttack")
    --                 found_center = G.P_CENTERS[k]
    --                 break
    --             end
    --         end
            
    --         if found_center then
    --             glass_card:set_ability(found_center)
    --         else
    --             sendDebugMessage("CRITICAL ERROR: No glass center found!", "ScoreAttack")
    --             -- Print all keys starting with 'm_' or 'sa_' to help debug
    --             for k, v in pairs(G.P_CENTERS) do
    --                 if string.find(k, "^m_") or string.find(k, "^sa_") then
    --                     sendDebugMessage("Available key: " .. k, "ScoreAttack")
    --                 end
    --             end
    --         end


    --         return true
    --     end
    -- }))
end

-- Hook to track money spent for Penny Pincher
local ease_dollars_ref = ease_dollars
function ease_dollars(mod, instant)
    if mod < 0 and G.STATE == G.STATES.SHOP then
        G.GAME.sa_shop_spent = (G.GAME.sa_shop_spent or 0) + math.abs(mod)
    end
    ease_dollars_ref(mod, instant)
end

-- Reset shop spend tracker on new round
local update_new_round_ref = Game.update_new_round
function Game:update_new_round(dt)
    if G.GAME.sa_shop_spent then
        G.GAME.sa_last_shop_spent = G.GAME.sa_shop_spent
        G.GAME.sa_shop_spent = 0
    end
    update_new_round_ref(self, dt)
end

sendDebugMessage("Score Attack Mod Loaded!", "ScoreAttack")

local get_blind_amount_ref = get_blind_amount
function get_blind_amount(ante)
    if G.GAME.round_resets.blind_choices.Boss == 'bl_sa_score_attack' and G.GAME.blind_on_deck == 'Boss' then
        return 1e300 
    end
    return get_blind_amount_ref(ante)
end

-- -- DEBUG: Press 'P' to simulate 1000 shop rolls
-- local love_keypressed_ref = love.keypressed
-- function love.keypressed(key)
--     if key == 'p' then
--         sendDebugMessage("--- DEBUGGING POOLS ---", "ScoreAttack")
        
--         local my_jokers = {
--             "j_sa_defensive_joker",
--             "j_sa_lets_go_gambling",
--             "j_sa_pacifist",
--             "j_sa_pizza",
--             "j_sa_skip_off",
--             "j_sa_speedrun",
--             "j_sa_conjoined_joker",
--             "j_sa_penny_pincher",
--             "j_sa_taxes",
--             "j_bloodstone",
--             "j_hanging_chad"
--         }

--         -- 1. Check G.P_CENTER_POOLS['Joker'] (This is what get_current_pool uses)
--         local main_pool = G.P_CENTER_POOLS['Joker']
--         for _, k in ipairs(my_jokers) do
--             local found = false
--             for _, v in ipairs(main_pool) do
--                 if v.key == k then found = true break end
--             end
            
--             if found then
--                 sendDebugMessage(k .. " is in G.P_CENTER_POOLS['Joker']", "ScoreAttack")
--             else
--                 sendDebugMessage(k .. " is NOT in G.P_CENTER_POOLS['Joker'] - Injecting...", "ScoreAttack")
--                 local center = G.P_CENTERS[k]
--                 if center then
--                     table.insert(main_pool, center)
--                 end
--             end
--         end

--         sendDebugMessage("--- STARTING SHOP SIMULATION (1000 Rolls) ---", "ScoreAttack")
        
--         local counts = {}
--         local total = 0
        
--         for i = 1, 1000 do
--             local rarity_poll = math.random()
--             local rarity = 1 -- Common
--             if rarity_poll > 0.95 then rarity = 3 -- Rare
--             elseif rarity_poll > 0.70 then rarity = 2 -- Uncommon
--             end
            
--             local pool = get_current_pool('Joker', rarity, nil, 'sim')
            
--             if pool and #pool > 0 then
--                 local result_key = pool[math.random(#pool)]
--                 counts[result_key] = (counts[result_key] or 0) + 1
--                 total = total + 1
--             end
--         end

--         for k, v in pairs(counts) do
--             local percent = (v / total) * 100
--             if string.find(k, "sa_") or k == "j_bloodstone" or k == "j_hanging_chad" then
--                 sendDebugMessage(string.format(">> %s: %d (%.2f%%)", k, v, percent), "ScoreAttack")
--             end
--         end
--         sendDebugMessage("--- SIMULATION COMPLETE ---", "ScoreAttack")
--     end
    
--     if love_keypressed_ref then love_keypressed_ref(key) end
-- end

