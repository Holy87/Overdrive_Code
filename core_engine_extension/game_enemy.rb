#==============================================================================
# ** Game_Enemy
#---------------------------------------------------------------------------
# Metodo per il contagio delle unità
#==============================================================================
class Game_Enemy < Game_Battler
    alias h87attr_perform_collapse perform_collapse unless $@
    alias h87attr_initialize initialize unless $@
  
    def initialize(index, enemy_id)
      h87attr_initialize(index, enemy_id)
      self.anger = max_anger
    end
  
    # @return [Array<RPG::State,RPG::Enemy>]
    def features
      super + [enemy]
    end
  
    def native_cri
      enemy.has_critical ? 8 : 4
    end
  
    def native_hit
      enemy.hit
    end
  
    def native_eva
      enemy.eva
    end
  
    def cri
      super
    end
  
    def eva
      super
    end
  
    def hit
      super
    end
  
    # Morte
    def perform_collapse
      recharge_actors
      if $game_temp.in_battle and dead? and @bomb
        @bomb = false
        @hp = 1 # per non farlo morire prima dell'animazione
        bombific_explode
      else
        h87attr_perform_collapse
      end
    end
  
    # moltiplicatore del livello su status
    def level_multiplier
      1.0 + features_sum(:custom_level_multiplier)
    end
  
    def recharge_actors
      $game_party.members.each { |member| member.kill_recharge }
    end
  
    # determina se il nemico è un boss
    def boss_type?
      enemy.boss_type
    end
  
    # determina se il nemico è protetto da un altro alleato
    def protected?
      return false if protector?
      return false if enemy.has? :unprotected
      return false unless exist?
      #noinspection RubyResolve
      $game_troop.existing_members.select { |member| member.protector? }.any?
    end
  
    # determia se il nemico è un protettore
    def protector?
      has_feature? :protector
    end
  
    # determina se l'attacco è basato dallo spirito
    def attack_with_magic?
      super || attack_magic_rate > 0
    end
  
    # Restituisce true se il battler è affetto da bombificazione
    def bombified?
      self.states.select { |state| state.bombify? }.any?
    end
  
    # Esplode.
    def bombific_explode
      SceneManager.scene.bomb_explode(self)
    end
  
    # Bonus drop a fine battaglia
    def spoil_bonus
      features_sum(:spoil_bonus)
    end
  
    # restituisce il set di elementi sull'attacco
    # @return [Array<Integer>]
    def element_set
      super + [enemy.attack_attr].compact
    end
  
    # @return [Array<RPG::Skill>]
    # @param [Game_Actor] actor
    def assimilable_skills(actor = nil)
      sks = skills.select { |skill| skill.assimilable? }
      if actor
        sks = sks.select { |skill| actor.assimilable?(skill) }
      end
      sks
    end
  end