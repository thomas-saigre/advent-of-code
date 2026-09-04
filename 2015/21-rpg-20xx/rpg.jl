using IterTools

mutable struct Fighter
    hit_point::Int
    damage::Int
    armor::Int
end

struct Equipment
    cost::Int
    damage::Int
    armor::Int
end

function equip(p::Fighter, e::Equipment)
    p.damage += e.damage
    p.armor += e.armor
    return e.cost
end

function idx_from_turn(turn::Int)
    return turn % 2 == 1 ? (1, 2) : (2, 1)
end

function fight(player::Fighter, boss::Fighter)
    turn = 1
    fighters = [player, boss]

    while true
        atk, def = idx_from_turn(turn)
        attack_damage = max(fighters[atk].damage - fighters[def].armor, 1)
        fighters[def].hit_point -= attack_damage

        # println(def, " has ", fighters[def].hit_point, " HP")

        if fighters[def].hit_point <= 0
            break
        end

        turn += 1
    end

    winner, looser = idx_from_turn(turn)
    if winner == 1
        # println("Player has won")
        return true
    else
        # println("Boss has won")
        return false
    end
end

weapons = [
    Equipment(8 , 4, 0),
    Equipment(10, 5, 0),
    Equipment(25, 6, 0),
    Equipment(40, 7, 0),
    Equipment(74, 8, 0)
]
armors = [
    Equipment(0  , 0, 0),   # Getting no armor is the same as putting a void armor ;)
    Equipment(13 , 0, 1),
    Equipment(31 , 0, 2),
    Equipment(53 , 0, 3),
    Equipment(75 , 0, 4),
    Equipment(102, 0, 5)
]
rings = [
    Equipment(0  , 0, 0),   # Idem for the rings, but for two
    Equipment(0  , 0, 0),
    Equipment(25 , 1, 0),
    Equipment(50 , 2, 0),
    Equipment(100, 3, 0),
    Equipment(20 , 0, 1),
    Equipment(40 , 0, 2),
    Equipment(80 , 0, 3)
]


function test_fight()
    player = Fighter(8, 5, 5)
    boss = Fighter(12, 7, 2)

    res = fight(player, boss)

    @assert res
end

test_fight()



function run()

    minimal_cost = typemax(Int)
    maximal_cost = 0

    for w in weapons
        for a in armors
            for rs in subsets(rings, 2)
                boss = Fighter(104, 8, 1)
                player = Fighter(100, 0, 0)
                equip(player, w)
                equip(player, a)
                equip(player, rs[1])
                equip(player, rs[2])

                cost = w.cost + a.cost + rs[1].cost + rs[2].cost
                if fight(player, boss)
                    minimal_cost = min(cost, minimal_cost)
                else
                    maximal_cost = max(cost, maximal_cost)
                end
            end
        end
    end

    println("Part I  ", minimal_cost)
    println("Part II ", maximal_cost)
end

run()