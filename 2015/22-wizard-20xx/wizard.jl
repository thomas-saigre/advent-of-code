# okay, I look for some hel on the internet https://github.com/ghaiklor/advent-of-code-2015/blob/master/day-22/part-1/solution.js
mutable struct Player
    history::Vector{Int}
    initial::Any
    isWizard::Bool
    hp::Int
    spent::Int
    armor::Int
    turn::Int
    activeSpells::Vector{Dict{String, Any}}
    spells::Vector{Dict{String, Any}}
    mana::Int
    damageAmt::Int

    function Player(initial, isWizard)
        player = new()
        player.history = Int[]
        player.initial = initial
        player.isWizard = Bool(isWizard)
        player.hp = 0
        player.spent = 0
        player.armor = 0
        player.turn = 0
        player.activeSpells = Dict{String, Any}[]
        player.spells = Dict{String, Any}[]
        player.mana = 0
        player.damageAmt = 0

        if player.isWizard
            player.spells = [
                Dict("cost" => 53, "effect" => (m, o) -> damage!(o, 4)),
                Dict("cost" => 73, "effect" => (m, o) -> (damage!(o, 2); m.hp += 2)),
                Dict("cost" => 113,
                     "start" => (m, o) -> (m.armor += 7),
                     "effect" => (m, o) -> nothing,
                     "end" => (m, o) -> (m.armor -= 7),
                     "duration" => 6),
                Dict("cost" => 173, "effect" => (m, o) -> damage!(o, 3), "duration" => 6),
                Dict("cost" => 229, "effect" => (m, o) -> (m.mana += 101), "duration" => 5),
            ]
        end

        start!(player)
        player
    end
end

function damage!(p::Player, n)
    p.hp -= max(1, n - p.armor)
end

function attack!(p::Player, opponent::Player, spellIdx)
    if !p.isWizard
        damage!(opponent, p.damageAmt)
    else
        spell = p.spells[spellIdx]
        push!(p.history, spellIdx)
        p.spent += spell["cost"]
        p.mana -= spell["cost"]

        if haskey(spell, "duration")
            newSpell = Dict("idx" => spellIdx, "effect" => spell["effect"], "duration" => spell["duration"])
            if haskey(spell, "start")
                spell["start"](p, opponent)
            end
            if haskey(spell, "end")
                newSpell["end"] = spell["end"]
            end
            push!(p.activeSpells, newSpell)
        else
            spell["effect"](p, opponent)
        end
    end
end

function take_turn!(p::Player, opponent::Player)
    p.turn += 1
    for spell in p.activeSpells
        if spell["duration"] > 0
            spell["effect"](p, opponent)
            spell["duration"] -= 1
            if spell["duration"] == 0 && haskey(spell, "end")
                spell["end"](p, opponent)
            end
        end
    end
end

function start!(p::Player)
    p.hp = p.initial.hp
    p.spent = 0
    p.armor = 0
    p.turn = 0
    p.activeSpells = Dict{String, Any}[]
    if p.isWizard
        p.mana = p.initial.mana
    else
        p.damageAmt = p.initial.damageAmt
    end
end

function duplicate(p::Player)
    newPlayer = Player(p.initial, p.isWizard)
    newPlayer.hp = p.hp
    newPlayer.spent = p.spent
    newPlayer.armor = p.armor
    newPlayer.turn = p.turn
    for spell in p.activeSpells
        push!(newPlayer.activeSpells, copy(spell))
    end
    newPlayer.history = copy(p.history)
    if p.isWizard
        newPlayer.mana = p.mana
    else
        newPlayer.damageAmt = p.damageAmt
    end
    newPlayer
end

function fight(player::Player, boss::Player, minimal_cost::Int, part_2::Bool)
    for i in eachindex(player.spells)
        any(s -> s["duration"] > 1 && s["idx"] == i, player.activeSpells) && continue
        player.spells[i]["cost"] > player.mana && continue

        new_player = duplicate(player)
        new_boss = duplicate(boss)

        if part_2
            new_player.hp -= 1
        end

        take_turn!(new_player, new_boss)
        take_turn!(new_boss, new_player)
        attack!(new_player, new_boss, i)

        take_turn!(new_player, new_boss)
        take_turn!(new_boss, new_player)
        attack!(new_boss, new_player, 0)

        if new_boss.hp <= 0
            minimal_cost = min(minimal_cost, new_player.spent)
        elseif new_player.hp > 0 && new_player.spent < minimal_cost
            minimal_cost = fight(new_player, new_boss, minimal_cost, part_2)
        end
    end
    return minimal_cost
end

function partI()
    player = Player((hp=50, mana=500), true)
    boss = Player((hp=71, damageAmt=10), false)
    println(fight(player, boss, typemax(Int), false))
end

function partII()
    player = Player((hp=50, mana=500), true)
    boss = Player((hp=71, damageAmt=10), false)
    println(fight(player, boss, typemax(Int), true))
end

# partI()
partII()