# questo script mi permette di ottenere stringhe personalizzate per il sesso
# del personaggio senza creare condizioni particolari e frasi multiple.
# USO: Crea una stringa con una diversificazione di genere utilizzando gx
# esempio:
# %s è avvelenat\gx[o/a]!
# applico string.gender(:male o :female)
# Stamperà:
# Francesco è avvelenato! -> se maschio
# Monica è avvelenata! -> se femmina

module GENREABLE_STRINGS
  GENDER_REGEX = /\\gx\[(.+\/.+)\]/i
  FEMALE_REGEX = /<female>/i
  FEMALE_ACTORS = [2,5,6,7,10,15,19]
end

class String
  # applica il genere ad una stringa preformattata
  # funziona solo su una singola parola per stringa.
  # @return [String]
  # @param [Symbol] gender_type
  def gender(gender_type = :male)
    if GENREABLE_STRINGS::GENDER_REGEX.match(self)
      apply_gender($1, gender_type)
    else
      self.clone
    end
  end

  # applica il genere ad una stringa preformattata
  # funziona solo su una singola parola per stringa.
  # metodo distruttivo. Modifica la stringa originale.
  # @return [String]
  # @param [Symbol] gender_type
  def gender!(gender_type = :male)
    if GENREABLE_STRINGS::GENDER_REGEX.match(self)
      self = apply_gender($1, gender_type)
    else
      self
    end
  end

  private

  # @param [String] substr
  def apply_gender(substr, gender_type)
    substr = substr.split('/')
    str = gender_type == :male ? substr.first : substr.last
    self.gsub(GENREABLE_STRINGS::GENDER_REGEX, str)
  end
end

class RPG::Enemy
  def gender
    @gender ||= init_gender
  end

  def init_gender
    GENREABLE_STRINGS::FEMALE_REGEX.match(self.note) ? :female : :male
  end
end

class Game_Battler
  # restituisce il sesso del personaggio
  # @return [Symbol]
  def gender
    :male
  end
end

class Game_Actor < Game_Battler
  # restituisce il sesso del personaggio
  # @return [Symbol]
  def gender
    GENREABLE_STRINGS::FEMALE_ACTORS.include?(@actor_id) ? :female : :male
  end
end

class Game_Enemy < Game_Battler
  # restituisce il sesso del personaggio
  # @return [Symbol]
  def gender
    enemy.gender
  end
end