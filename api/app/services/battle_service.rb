class BattleService
  def initialize(battle)
    @battle = battle
  end

  def calculete_winner
    monster_a, monster_b = battle_monsters_order

    while @battle.winner_id.nil?

      # Monsters will battle in turns until one wins;
      # all turns should be calculated in the same request;
      # for that reason, the battle endpoint should return winner data in just one call.

      # Subtract the damage from the HP (HP = HP - damage).
      monster_b.update(hp: monster_b.hp - calculate_damage(monster_a, monster_b))

      # Who wins the battle is the monster who subtracted the enemy’s HP to zero
      if monster_b.hp <= 0
        @battle.winner = monster_a
      else
        monster_a.update(hp: monster_a.hp - calculate_damage(monster_b, monster_a))
        @battle.winner = monster_b if monster_a.hp <= 0
      end
    end
  end

  private

  # For calculating the damage, subtract the defense from the attack (attack - defense);
  #   the difference is the damage; if the attack is equal to or lower than the defense,
  #   the damage is 1.

  def calculate_damage(monster_a, monster_d)
    if monster_a.attack > monster_d.defense
      monster_a.attack - monster_d.defense
    else
      1
    end
  end

  # The monster with the highest speed makes the first attack,
  def battle_monsters_order
    if faster_monster?(@battle.monsterA, @battle.monsterB)
      [@battle.monsterA, @battle.monsterB]
    else
      [@battle.monsterB, @battle.monsterA]
    end
  end

  # if both speeds are equal, the monster with the higher attack goes first.
  def faster_monster?(monster1, monster2)
    monster1.speed > monster2.speed || (
        monster1.speed == monster2.speed && monster1.attack > monster2.attack)
  end
end
