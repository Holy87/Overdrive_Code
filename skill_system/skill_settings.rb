#===============================================================================
# ** Impostazioni
#-------------------------------------------------------------------------------
# definire qui cosa avranno di particolare i vari livelli delle abilità
#===============================================================================
module SkillSettings
  DEFAULT_AP_COST = 0
  AP_VOCAB = 'Punti Abilità'
  AP_ABBREV = 'PA'
  AP_ICON = 29

  POWER_UP_KEY = :X
  SORT_KEY = :A
  SORT_ALL_KEY = :X

  # Elenco dei parametri che devono essere mostrati in verde quando sono maggiori
  # rispetto a quelli precedenti
  GOOD_PARAMS = [:hit, :cri, :state_duration, :state_probability, :recharge, :anger_rate]
  # Viceversa, rossi quando maggiori
  BAD_PARAMS = [:turn_delay, :battle_delay, :damage_delay, :step_delay, :charge,
                :mp_cost, :hp_cost, :anger_cost]

  SKILL_DIFFERENCES = [:hit, :cri, :state_duration, :state_probability, :recharge, :anger_rate,
                       :turn_delay, :battle_delay, :damage_delay, :step_delay, :charge]
  PASSIVE_DIFFERENCES = [:atk_rate, :def_rate, :spi_rate, :agi_rate, :maxhp_rate,
                         :maxmp_rate, :hit, :cri, :eva, :odds, :dom_bonus, :item_save, :magic_def,
                         :magic_dmg, :heal_rate, :anger_bonus, :anger_damage, :anger_kill, :anger_turn,
                         :spirit_attack, :spirit_defense, :spirit_agi, :hp_on_win, :mp_on_win,
                         :state_inf_per, :synth_bonus, :critical_damage, :spoil_bonus, :barrier_rate,
                         :barrier_save, :hp_on_guard, :mp_on_guard, :fu_on_guard, :mp_on_attack,
                         :normal_attack_bonus]





  VOCAB_PASSIVE = 'Passiva'
  VOCAB_SKILLS_CMD = 'Abilità attive'
  VOCAB_PASSIVES_CMD = 'Abilità passive'
  VOCAB_LEARN_CMD = 'Apprendi'
  VOCAB_SORT_CMD = 'Riordina'
  VOCAB_LEARNT = 'Appresa'
  VOCAB_UPGRADE_CMD = 'Potenzia'
  VOCAB_EVOLVE_CMD = 'Evolvi'
  VOCAB_USE_SKILL = 'Usa'
  VOCAB_HIDE_SKILL = 'Nascondi'
  VOCAB_SHOW_SKILL = 'Mostra'
  VOCAB_LEARN_SKILL = 'Impara'
  VOCAB_SORT_SKILL = 'Riordina'
  VOCAB_EXCH_SKILL = 'Sostituisci'
  VOCAB_RELE_SKILL = 'Rilascia'
  VOCAB_SKILL_BACK = 'Indietro'
  VOCAB_NOWSKILL = 'Ora'
  VOCAB_NEXSKILL = 'Prossimo'
  VOCAB_DEFAULT_SORT = 'Ordinamento predefinito'
  VOCAB_LEARN = '%s apprenderà %s.'
  VOCAB_ACTOR_LEARNT = '%s ha appreso %s!'

  REORDER_KEY_COMMAND = :Y
  HIDE_KEY_COMMAND = :X

  SORT_RECT_COLOR_ID = 0#26

  # These hashes adjust what skills each class can learn. Fill in the arrays
  # with the skill ID's of learnable skills. Class 0's hash allows all classes
  # to be able to learn from it. Do not delete class 0.
  CLASS_SKILLS ={
    # ID => [Skill ID's],
    0 => [503], # tutti
    1 => [141..164,61,67,71,447,448],#Templare
    2 => [2,504,95,237,311],
    3 => [61..89,112,113,385,395..402,431,432],#Guaritore
    4 => [91,92,94,96,97,99,101,102,104,116..139,381..387,433..435],#Mago
    6 => [296..319,442,443],#Vendicatore
    7 => [2..19,424,425],#Pasticciere
    8 => [191..219,450,114,115,388..390,450],#Vampiro
    9 => [41..59,271,429,430],#Arciere
    11=> [21..39,426..428],#Spadaccino
    12=> [221..239,438,439],#Guerriero
    13=> [346..369,444],#Bardo
    15=> [165..189,106,436,437,390],#Arcano
    16=> [271..294,441],#Avventuriero
    17=> [321..344,395..398,403..406,445,446],#Alchimista
    18=> [91..115,241..269,440],                 #Elementalista
    19=> [36,63,67,87],#cavaliere magico
  } # Do not remove this.

  # These hashes adjust what passives each class can learn. Fill in the arrays
  # with the skill ID's of status effects. Class 0's hash allows all classes
  # to be able to learn from it. Do not delete class 0.
  CLASS_PASSIVES ={
    # ID => [State ID's],
    0 => [300], # tutti
    1 => [39,41,44,52,58,61,68,146,147,151,156,240,304,328],#Templare
    2 => [39,41,43,56,61,67,315],#Condottiero
    3 => [40,42,45,53,71,159,163,409],#Guaritore
    4 => [40,42,45,47,69,160,163,301],#Mago
    6 => [39,43,154,218,303,304,307,308,311,312,344,345],#Vendicatore
    7 => [43,46,48,55,56,70,71,73,148,153,237,315,339,340,346..348,350,351],#Pasticciere
    8 => [45,46,51,59,65,73,89,158,303,305],#Vampiro
    9 => [46,54,60,74,84,150,162,164,317,335,337,338,339,346,349],#Arciere
    11=> [43,49,56,67,91,92,147,148,149,154,308,309,312,341,343,352],#Spadaccino
    12=> [39,41,43,44,67,68,147,149,153,155,309,310,311,341,353],#Guerriero
    13=> [40,50,51,53,148,291,302,337],#Bardo
    15=> [39,40,43,44,45,46,104,146,156,219,240,292,301,316,327,329,331,332,333,336],#Arcano
    16=> [46,57,62,66,70,73,74,150,162,164,208,237,302,326,334,335],#Avventuriero
    17=> [55,91,152,155,226,239,295,296,297,315,318,342],#Alchimista
    18=> [40,42,45,46,69,90,316],#Elementalista
    19=> [39,43,44,45,46],#cavaliere magico
  } # Do not remove this.

  SKILL_PARAMS_COMPARE = [:overview, :formula, :scope, :costs, :states, :state_duration,
                          :state_bonus, :heal_states, :aggro, :delay, :charge, :recharge,
                          :autostate, :critical_condition
  ]

  # le varie abilità con i cambiamenti rispetto al livello base
  # ID_SKILL => [{liv2},{liv3}...]
  SKILL_LEVELS = {
    4 => [ # doppio colpo
      { :params => { :atk_f => 95, :mp => 11}, :ap => 1000, :level => 10 },
      { :params => { :atk_f => 100, :mp => 12}, :ap => 1500, :level => 20 },
      { :params => { :atk_f => 105, :mp => 13}, :ap => 2000, :level => 30 },
      { :params => { :atk_f => 110, :mp => 13}, :ap => 2000, :level => 40, :item => 140 },
    ],
    5 => [
      { :params => { :spi_f => 100 } }
    ],
    21 => [ # sferzata
      { :params => { :turn_delay => 4 }, :ap => 500},
      { :params => { :atk_f => 145 }, :ap => 750, :level => 10},
      { :params => { :atk_f => 150 }, :ap => 1000, :level => 20},
      { :params => { :name => 'Montante', :charge => 30, :atk_f => 160,
                     :anger_cost => 12, :icon => 1266, :description =>
        'Fa cadere la spada sulla testa del bersaglio, interrompendo il caricamento|'+
        'e causando gravi danni. Richiede una spada equipaggiata.'},
        :ap => 2000, :level => 30, :item => 140},
      { :params => { :turn_delay => 3 }, :ap => 2500, :level => 40},
      { :params => { :atk_f => 165}, :ap => 3000, :level => 50},
      { :params => { :atk_f => 180, :name => 'Sfondamento', :description =>
        'Fa cadere la spada sulla testa del bersaglio, interrompendo il caricamento.|'+
        'Colpo critico certo se il nemico tentenna.', :critical_condition => '!self.parriable?'},
        :ap => 4000, :level => 60, :item => 141},
    ],
    24 => [ # fendente d'aria
      { :params => { :atk_f => 55}, :ap => 300},
      { :params => { :atk_f => 60}, :ap => 350},
      { :params => { :atk_f => 65}, :ap => 400},
      { :params => { :atk_f => 70}, :ap => 450, :level => 20},
      { :params => { :atk_f => 75}, :ap => 500},
      { :params => { :atk_f => 80}, :ap => 600},
      { :params => { :atk_f => 85}, :ap => 700},
      { :params => { :atk_f => 90}, :ap => 800, :level => 40},
      { :params => { :atk_f => 95}, :ap => 900},
      { :params => { :atk_f => 100}, :ap => 1100}
    ],
    26 => [ # scudo infranto
      { :params => { :state_inf_per => 0.2 }, :ap => 400},
      { :params => { :state_inf_per => 0.4 }, :ap => 500},
      { :params => { :state_inf_dur => 1 }, :ap => 600},
      { :params => { :state_inf_per => 0.6 }, :ap => 800, :level => 30},
      { :params => { :state_inf_per => 0.8 }, :ap => 1000},
      { :params => { :state_inf_dur => 2 }, :ap => 1200},
      { :params => { :state_inf_per => 1.0 }, :ap => 1400},
    ],

    # Magie Curative
    61 => [ # cura
      {:params => {:damage => -280, :mp => 5}, :ap => 200},
      {:params => {:damage => -392, :mp => 6}, :ap => 300},
      {:params => {:damage => -548, :mp => 7}, :ap => 400},
      {:params => {:damage => -768, :mp => 8}, :ap => 500},
      {:params => {:name => 'Cura Media', :icon => 230, :mp => 10, :animation => 325,
                   :damage => -1000, :spi_f => 15}, :ap => 600, :level => 25, :item_id => 140},
      # totale fin qui: 2000
      {:params => {:damage => -1320, :mp => 13}, :ap => 800},
      {:params => {:damage => -1742, :mp => 16}, :ap => 1000},
      {:params => {:damage => -2300, :mp => 19}, :ap => 1200},
      {:params => {:damage => -3035, :mp => 21}, :ap => 1400},
      {:params => {:name => 'Cura Superiore', :icon => 231, :spi_f => 20, :animation => 326,
                   :damage => -4000, :mp => 26}, :ap => 1600, :level => 50, :item_id => 141}
    # ulteriori livelli per l'endgame? Fin qui: 2000+6000
    ],
    63 => [ # preghiera
      {:params => {:damage => -280, :mp => 18}, :ap => 250},
      {:params => {:damage => -392, :mp => 21}, :ap => 500},
      {:params => {:damage => -548, :mp => 26}, :ap => 725},
      {:params => {:damage => -768, :mp => 31}, :ap => 1000},
      {:params => {:name => 'Ristorazione', :icon => 230, :mp => 37, :animation => 325,
                   :damage => -1000, :spi_f => 15}, :ap => 2000, :level => 30, :item_id => 140},
      {:params => {:damage => -1320, :mp => 44}, :ap => 1100},
      {:params => {:damage => -1742, :mp => 53}, :ap => 1300},
      {:params => {:damage => -2300, :mp => 63}, :ap => 1500},
      {:params => {:damage => -3035, :mp => 76}, :ap => 1700},
      {:params => {:name => 'Vento Fresco', :icon => 231, :spi_f => 20, :animation => 326,
                   :damage => -4000, :mp => 90}, :ap => 2000, :level => 60, :item_id => 141}
    ],
    67 => [ # soccorso
      {:params => {:minut_state_set => [2,79]}, :ap => 40},
      {:params => {:minut_state_set => [2,3,79]}, :ap => 50},
      {:params => {:minut_state_set => [2,3,79,87]}, :ap => 60},
      {:params => {:minut_state_set => [2,3,4,79,87]}, :ap => 70},
      {:params => {:minut_state_set => [2,3,4,7,79,87]}, :ap => 80},
      {:params => {:minut_state_set => [2,3,4,7,79,87,13,14,16], :mp => 5,
                   :name => 'Guarigione'}, :ap => 100, :level => 20, :item_id => 120},
      {:params => {:minut_state_set => [2,3,4,7,79,87,13,14,16,112]}, :ap => 120},
      {:params => {:minut_state_set => [2,3,4,7,79,87,13,14,16,112,288]}, :ap => 140},
    ],
    68 => [ # trattamento
      {:params => {:minut_state_set => [4,6]}, :ap => 40},
      {:params => {:minut_state_set => [4,5,6]}, :ap => 50},
      {:params => {:minut_state_set => [4,5,6,15]}, :ap => 60},
      {:params => {:minut_state_set => [4,5,6,15,21]}, :ap => 70},
      {:params => {:minut_state_set => [4,5,6,15,21,115]}, :ap => 80},
      {:params => {:minut_state_set => [4,5,6,15,21,82,115], :mp => 10, :name => 'Purifica'},
                  :ap => 100, :level => 20, :item_id => 120},
      {:params => {:minut_state_set => [4,5,6,15,21,82,94,115]}, :ap => 120},
      {:params => {:minut_state_set => [4,5,6,15,21,82,94,113,115]}, :ap => 140},
      {:params => {:minut_state_set => [4,5,6,15,21,82,94,113,115,287]}, :ap => 160},
    ],
    69 => [ # protezione
      {:params => {:recharge => 10}, :ap => 150, :level => 10},
      {:params => {:recharge => 20}, :ap => 300, :level => 20},
      {:params => {:recharge => 30}, :ap => 450, :level => 30},
      {:params => {:recharge => 40}, :ap => 600, :level => 40},
      {:params => {:recharge => 50}, :ap => 750, :level => 50},
    ],
    70 => [ # rigenerazione
      {:params => {:damage => -200,:charge => 30}, :ap => 200},
      {:params => {:damage => -300,:charge => 20}, :ap => 300},
      {:params => {:damage => -400,:charge => 10}, :ap => 400},
      {:params => {:damage => -500,:charge => 0}, :ap => 500},
      {:params => {:damage => -600,:state_inf_dur => 1}, :ap => 700}
    ],
    71 => [ # rinascita
      {:params => {:damage => -180, :mp => 12}, :ap => 100},
      {:params => {:damage => -216, :mp => 14}, :ap => 200},
      {:params => {:damage => -259, :mp => 17}, :ap => 300},
      {:params => {:damage => -311, :mp => 20, :spi_f => 30}, :ap => 500, :level => 20},
      {:params => {:damage => -373, :mp => 24}, :ap => 700},
      {:params => {:damage => -447, :mp => 29}, :ap => 900},
      {:params => {:damage => -537, :mp => 35}, :ap => 1100},
      {:params => {:damage => -773, :mp => 42, :mhp_e => 5, :name => 'Miracolo'},
                  :ap => 1500, :level => 40, :item_id => 141},
      {:params => {:damage => -928, :mp => 51, :mhp_e => 10}, :ap => 1800},
      {:params => {:damage => -1114, :mp => 61, :mhp_e => 15}, :ap => 2100},
      {:params => {:damage => -1337, :mp => 74, :mhp_e => 20}, :ap => 2400},
      {:params => {:damage => -1604, :mp => 89, :mhp_e => 25}, :ap => 2700},
      {:params => {:damage => -1925, :mp => 106, :mhp_e => 30}, :ap => 3000},
    ],
    73 => [ # fenice
      {:params => {:damage => -600, :mhp_e => 11, :mp => 165}, :ap => 500},
      {:params => {:damage => -720, :mhp_e => 12, :mp => 181}, :ap => 700},
      {:params => {:damage => -864, :mhp_e => 13, :mp => 199}, :ap => 900,
       :level => 70, :item_id => 140},
      {:params => {:damage => -1036, :mhp_e => 14, :mp => 219}, :ap => 1100},
      {:params => {:damage => -1244, :mhp_e => 15, :mp => 241, :battle_delay => 2}, :ap => 1300,
       :item_id => 141, :level => 80},
      {:params => {:damage => -1492, :mhp_e => 16, :mp => 265}, :ap => 1500},
      {:params => {:damage => -1791, :mhp_e => 17, :mp => 292}, :ap => 1700},
      {:params => {:damage => -2150, :mhp_e => 18, :mp => 321}, :ap => 2000},
    ],
    74 => [ # trasferimento
      {:params => {:damage => -54, :mp => 54, :mmp_f => 4, :mp_per => 4}, :ap => 200},
      {:params => {:damage => -77, :mp => 77, :mmp_f => 8, :mp_per => 8}, :ap => 600},
      {:params => {:damage => -111, :mp => 111, :mmp_f => 12, :mp_per => 12}, :ap => 1000},
      {:params => {:damage => -161, :mp => 161, :mmp_f => 16, :mp_per => 16}, :ap => 1400},
      {:params => {:damage => -232, :mp => 232, :mmp_f => 20, :mp_per => 20}, :ap => 1800},
    ],

    # Magie offensive -
    91 => [ # fiamma
      {:params => {:damage => 180, :spi_f => 31, :mp => 5}, :ap => 200},
      {:params => {:damage => 216, :spi_f => 32, :mp => 6}, :ap => 300},
      {:params => {:damage => 259, :spi_f => 33, :mp => 7}, :ap => 400},
      {:params => {:damage => 311, :spi_f => 34, :mp => 8}, :ap => 500},
      {:params => {:damage => 400, :spi_f => 35, :mp => 10, :charge => 60,
                   :name => 'Vampata', :animation => 58}, :ap => 600, :level => 25,
                  :item_id => 140},
      {:params => {:damage => 480, :spi_f => 36, :mp => 12}, :ap => 800},
      {:params => {:damage => 576, :spi_f => 37, :mp => 14}, :ap => 1000},
      {:params => {:damage => 691, :spi_f => 38, :mp => 18}, :ap => 1200},
      {:params => {:damage => 829, :spi_f => 39, :mp => 25}, :ap => 1400},
      {:params => {:damage => 1000, :spi_f => 40, :mp => 30, :name => 'Colonna di fuoco',
                   :animation => 518, :charge => 80},
       :ap => 1600, :level => 50, :item_id => 141}
    ],
    94 => [ # incendio
      {:params => {:damage => 180, :spi_f => 31, :mp => 18}, :ap => 250},
      {:params => {:damage => 216, :spi_f => 32, :mp => 21}, :ap => 500},
      {:params => {:damage => 259, :spi_f => 33, :mp => 26}, :ap => 725},
      {:params => {:damage => 311, :spi_f => 34, :mp => 31}, :ap => 1000},
      {:params => {:damage => 400, :spi_f => 35, :mp => 31, :charge => 60,
                   :name => 'Palla di Fuoco', :animation => 58}, :ap => 2000, :level => 30,
       :item_id => 140},
      {:params => {:damage => 480, :spi_f => 36, :mp => 42}, :ap => 1100},
      {:params => {:damage => 576, :spi_f => 37, :mp => 50}, :ap => 1300},
      {:params => {:damage => 691, :spi_f => 38, :mp => 60}, :ap => 1500},
      {:params => {:damage => 829, :spi_f => 39, :mp => 72}, :ap => 1700},
      {:params => {:damage => 1000, :spi_f => 40, :mp => 90, :name => 'Colonna di fuoco',
                   :animation => 518, :charge => 80},
       :ap => 2000, :level => 60, :item_id => 141}
    ],
    96 => [ # stalattiti
      {:params => {:damage => 180, :spi_f => 31, :mp => 5}, :ap => 200},
      {:params => {:damage => 216, :spi_f => 32, :mp => 6}, :ap => 300},
      {:params => {:damage => 259, :spi_f => 33, :mp => 7}, :ap => 400},
      {:params => {:damage => 311, :spi_f => 34, :mp => 8}, :ap => 500},
      {:params => {:damage => 400, :spi_f => 35, :mp => 10, :charge => 60,
                   :name => 'Criostasi', :animation => 62}, :ap => 600, :level => 25,
       :item_id => 140},
      {:params => {:damage => 480, :spi_f => 36, :mp => 12}, :ap => 800},
      {:params => {:damage => 576, :spi_f => 37, :mp => 14}, :ap => 1000},
      {:params => {:damage => 691, :spi_f => 38, :mp => 18}, :ap => 1200},
      {:params => {:damage => 829, :spi_f => 39, :mp => 25}, :ap => 1400},
      {:params => {:damage => 1000, :spi_f => 40, :mp => 30, :name => 'Prigione di ghiaccio',
                   :animation => 517, :charge => 80},
       :ap => 1600, :level => 50, :item_id => 141}
    ],
    99 => [ # bufera
      {:params => {:damage => 180, :spi_f => 31, :mp => 18}, :ap => 250},
      {:params => {:damage => 216, :spi_f => 32, :mp => 21}, :ap => 500},
      {:params => {:damage => 259, :spi_f => 33, :mp => 26}, :ap => 725},
      {:params => {:damage => 311, :spi_f => 34, :mp => 31}, :ap => 1000},
      {:params => {:damage => 400, :spi_f => 35, :mp => 31, :charge => 60,
                   :name => 'Bufera', :animation => 62}, :ap => 2000, :level => 30,
       :item_id => 140},
      {:params => {:damage => 480, :spi_f => 36, :mp => 42}, :ap => 1100},
      {:params => {:damage => 576, :spi_f => 37, :mp => 50}, :ap => 1300},
      {:params => {:damage => 691, :spi_f => 38, :mp => 60}, :ap => 1500},
      {:params => {:damage => 829, :spi_f => 39, :mp => 72}, :ap => 1700},
      {:params => {:damage => 1000, :spi_f => 40, :mp => 90, :name => 'Bora',
                   :animation => 517, :charge => 80},
       :ap => 2000, :level => 60, :item_id => 141}
    ],
    101 => [ # lampo
      {:params => {:damage => 180, :spi_f => 31, :mp => 5}, :ap => 200},
      {:params => {:damage => 216, :spi_f => 32, :mp => 6}, :ap => 300},
      {:params => {:damage => 259, :spi_f => 33, :mp => 7}, :ap => 400},
      {:params => {:damage => 311, :spi_f => 34, :mp => 8}, :ap => 500},
      {:params => {:damage => 400, :spi_f => 35, :mp => 10, :charge => 60,
                   :description => 'Una scarica elettrizzante su un nemico che causa|danni di elemento Elettro,',
                   :name => 'Fulmine', :animation => 66}, :ap => 600, :level => 25,
       :item_id => 140},
      {:params => {:damage => 480, :spi_f => 36, :mp => 12}, :ap => 800},
      {:params => {:damage => 576, :spi_f => 37, :mp => 14}, :ap => 1000},
      {:params => {:damage => 691, :spi_f => 38, :mp => 18}, :ap => 1200},
      {:params => {:damage => 829, :spi_f => 39, :mp => 25}, :ap => 1400},
      {:params => {:damage => 1000, :spi_f => 40, :mp => 30, :name => 'Tuono',
                   :description => 'Scatena un lampo ad altissimo potenziale distruttivo.',
                   :animation => 519, :charge => 80},
       :ap => 1600, :level => 50, :item_id => 141}
    ],
    104 => [ # saette
      {:params => {:damage => 180, :spi_f => 31, :mp => 18}, :ap => 250},
      {:params => {:damage => 216, :spi_f => 32, :mp => 21}, :ap => 500},
      {:params => {:damage => 259, :spi_f => 33, :mp => 26}, :ap => 725},
      {:params => {:damage => 311, :spi_f => 34, :mp => 31}, :ap => 1000},
      {:params => {:damage => 400, :spi_f => 35, :mp => 31, :charge => 60,
                   :description => 'Previsioni del tempo: cielo coperto con 100%|di possibilità di fulmini devastanti.',
                   :name => 'Tempesta', :animation => 66}, :ap => 2000, :level => 30,
       :item_id => 140},
      {:params => {:damage => 480, :spi_f => 36, :mp => 42}, :ap => 1100},
      {:params => {:damage => 576, :spi_f => 37, :mp => 50}, :ap => 1300},
      {:params => {:damage => 691, :spi_f => 38, :mp => 60}, :ap => 1500},
      {:params => {:damage => 829, :spi_f => 39, :mp => 72}, :ap => 1700},
      {:params => {:damage => 1000, :spi_f => 40, :mp => 90, :name => 'Boato',
                   :animation => 519, :charge => 80},
       :ap => 2000, :level => 60, :item_id => 141}
    ],
    106 => [ # bolla
      {:params => {:damage => 300, :spi_f => 32, :mp => 12}, :ap => 250},
      {:params => {:damage => 450, :spi_f => 35, :mp => 15}, :ap => 500, :level => 25},
      {:params => {:damage => 675, :spi_f => 37, :mp => 18}, :ap => 750},
      {:params => {:damage => 1000, :spi_f => 40, :mp => 26}, :ap => 2000, :level => 50},
    ],
    107 => [ # marea
      {:params => {:damage => 300, :spi_f => 32, :mp => 25}, :ap => 300},
      {:params => {:damage => 450, :spi_f => 35, :mp => 15}, :ap => 550, :level => 30},
      {:params => {:damage => 675, :spi_f => 37, :mp => 45}, :ap => 800},
      {:params => {:damage => 1000, :spi_f => 40, :mp => 90}, :ap => 3100, :level => 60},
    ],
    108 => [ # lance di terra
      {:params => {:damage => 300, :spi_f => 32, :mp => 12}, :ap => 250},
      {:params => {:damage => 450, :spi_f => 35, :mp => 15}, :ap => 500, :level => 25},
      {:params => {:damage => 675, :spi_f => 37, :mp => 18}, :ap => 750},
      {:params => {:damage => 1000, :spi_f => 40, :mp => 26}, :ap => 2000, :level => 50},
    ],
    109 => [ # terremoto
      {:params => {:damage => 300, :spi_f => 32, :mp => 30}, :ap => 300},
      {:params => {:damage => 450, :spi_f => 35, :mp => 40}, :ap => 550, :level => 30},
      {:params => {:damage => 675, :spi_f => 37, :mp => 55}, :ap => 800},
      {:params => {:damage => 1000, :spi_f => 40, :mp => 90}, :ap => 3100, :level => 60},
    ],
    110 => [ # turbine
      {:params => {:damage => 300, :spi_f => 32, :mp => 12}, :ap => 250},
      {:params => {:damage => 450, :spi_f => 35, :mp => 15}, :ap => 500, :level => 25},
      {:params => {:damage => 675, :spi_f => 37, :mp => 18}, :ap => 750},
      {:params => {:damage => 1000, :spi_f => 40, :mp => 26}, :ap => 2000, :level => 50},
    ],
    111 => [ # mulinello
      {:params => {:damage => 300, :spi_f => 32, :mp => 30}, :ap => 300},
      {:params => {:damage => 450, :spi_f => 35, :mp => 40}, :ap => 550, :level => 30},
      {:params => {:damage => 675, :spi_f => 37, :mp => 55}, :ap => 800},
      {:params => {:damage => 1000, :spi_f => 40, :mp => 90}, :ap => 3100, :level => 60},
    ],
    112 => [ # luce celeste
      {:params => {:damage => 525, :spi_f => 35, :mp => 25}, :ap => 1000},
      {:params => {:damage => 787, :spi_f => 40, :mp => 40}, :ap => 2000, :level => 35},
      {:params => {:damage => 1200, :spi_f => 45, :mp => 60}, :ap => 4000, :level => 65},
    ],
    113 => [ # luce stellare
      {:params => {:damage => 525, :spi_f => 35, :mp => 42}, :ap => 1500},
      {:params => {:damage => 787, :spi_f => 40, :mp => 70}, :ap => 2500, :level => 35},
      {:params => {:damage => 1200, :spi_f => 45, :mp => 110}, :ap => 4500, :level => 65},
    ],
    114 => [ # ombra
      {:params => {:damage => 525, :spi_f => 35, :mp => 25}, :ap => 1000},
      {:params => {:damage => 787, :spi_f => 40, :mp => 40}, :ap => 2000, :level => 35},
      {:params => {:damage => 1200, :spi_f => 45, :mp => 60}, :ap => 4000, :level => 65},
    ],
    115 => [ # incubo
      {:params => {:damage => 525, :spi_f => 35, :mp => 25}, :ap => 1500},
      {:params => {:damage => 787, :spi_f => 40, :mp => 45}, :ap => 2500, :level => 35},
      {:params => {:damage => 1200, :spi_f => 45, :mp => 65}, :ap => 4500, :level => 65},
    ],
    116 => [ # scoppio
      {:params => {:damage => 1050, :spi_f => 45, :mp => 40}, :ap => 2000, :level => 50},
      {:params => {:damage => 1575, :spi_f => 50, :mp => 80}, :ap => 5000, :level => 70},
    ],
    117 => [ # esplosione
      {:params => {:damage => 1050, :spi_f => 45, :mp => 40}, :ap => 2000, :level => 55},
      {:params => {:damage => 1575, :spi_f => 50, :mp => 80}, :ap => 5000, :level => 75},
    ],
    119 => [ # veleno
      {:params => {:damage => 125, :state_inf_per => 0.07, :mp => 6}, :ap => 150},
      {:params => {:damage => 156, :state_inf_per => 0.15, :mp => 7}, :ap => 250},
      {:params => {:damage => 195, :state_inf_per => 0.22, :mp => 8}, :ap => 350},
      {:params => {:damage => 244, :state_inf_per => 0.3, :mp => 9}, :ap => 450},
      {:params => {:damage => 300, :state_inf_dur => 1, :mp => 15, :icon => 302,
                   :description => 'Genera una nube di gas velenoso che dura più a lungo.',
                   :name => 'Miasma', :animation => 492}, :ap => 550, :level => 30, :item => 140},
      {:params => {:damage => 330, :state_inf_per => 0.5, :mp => 17}, :ap => 650},
      {:params => {:damage => 363, :state_inf_per => 0.6, :mp => 19}, :ap => 750},
      {:params => {:damage => 400, :state_inf_per => 0.7, :mp => 21}, :ap => 850}
    ],
    122 => [ # conversione
      {:params => {:damage => -45, :charge => 50, :hp => 225}, :ap => 500},
      {:params => {:damage => -67, :charge => 40, :hp => 337}, :ap => 700},
      {:params => {:damage => -101, :charge => 30, :hp => 506}, :ap => 900},
      {:params => {:damage => -150, :charge => 20, :hp => 759}, :ap => 1100}
    ],
    123 => [ # gravità
      {:params => {:hp_hi_e => 30, :mp => 10}, :ap => 300},
      {:params => {:hp_hi_e => 35, :mp => 12}, :ap => 400},
      {:params => {:hp_hi_e => 35, :mp => 25, :name => 'Supergravità', :target => :multi,
                   :description => 'Sottrae parte dei PV restanti a tutti i nemici.|Non funziona contro i boss.',
                   :animation => 78}, :ap => 500, :level => 50, :item => 141},
      {:params => {:hp_hi_e => 40, :mp => 30}, :ap => 1000},
      {:params => {:hp_hi_e => 45, :mp => 40}, :ap => 2000},
      {:params => {:hp_hi_e => 50, :mp => 50}, :ap => 3000},
    ],
    125 => [ # supplizio
      { :params => {:hp_lo => 60, :mp => 15}, :ap => 250 },
      { :params => {:hp_lo => 70, :mp => 20}, :ap => 500 },
      { :params => {:hp_lo => 80, :spi_f => 35, :mp => 30}, :ap => 1000, :level => 50 },
      { :params => {:hp_lo => 90, :mp => 50}, :ap => 1250 },
      { :params => {:hp_lo => 100, :spi_f => 40, :mp => 70}, :ap => 1500, :level => 70 },
    ],
    126 => [ # rovi
      { :params => {:damage => 120, :spi_f => 31, :mp => 14}, :ap => 300},
      { :params => {:damage => 144, :spi_f => 32, :mp => 17, :state_inf_per => 0.2}, :ap => 400, :level => 20},
      { :params => {:damage => 172, :spi_f => 33, :mp => 19}, :ap => 500},
      { :params => {:damage => 207, :spi_f => 34, :mp => 23, :state_inf_dur => 1}, :ap => 700, :level => 40},
      { :params => {:damage => 250, :spi_f => 35, :mp => 25}, :ap => 800},
    ],
    127 => [ # plutonium
      {:params => {:state_inf_per => 0.1, :mp => 22}, :ap => 400},
      {:params => {:state_inf_per => 0.2, :mp => 24}, :ap => 550},
      {:params => {:state_inf_dur => 1, :mp => 28}, :ap => 700, :level => 45},
      {:params => {:state_inf_per => 0.3, :mp => 30}, :ap => 850},
      {:params => {:state_inf_per => 0.4, :mp => 32}, :ap => 1000},
      {:params => {:state_inf_dur => 2, :mp => 36}, :ap => 1150, :level => 60},
      {:params => {:state_inf_per => 0.5, :mp => 38}, :ap => 1300},
    ],
    128 => [ # prelievo
      {:params => {:damage => 240, :spi_f => 32, :mp => 18}, :ap => 600},
      {:params => {:damage => 288, :spi_f => 34, :mp => 24}, :ap => 750},
      {:params => {:damage => 345, :spi_f => 36, :mp => 30}, :ap => 900},
      {:params => {:damage => 414, :spi_f => 38, :mp => 37}, :ap => 1050},
      {:params => {:damage => 500, :spi_f => 40, :mp => 50}, :ap => 1300},
    ],
    129 => [ # aspirazione
      {:params => {:damage => 36, :spi_f => 14, :mp => 12}, :ap => 600},
      {:params => {:damage => 43, :spi_f => 18, :mp => 14}, :ap => 750, :level => 45},
      {:params => {:damage => 51, :spi_f => 22, :mp => 17}, :ap => 900},
      {:params => {:damage => 62, :spi_f => 26, :mp => 20}, :ap => 1050, :level => 60},
      {:params => {:damage => 74, :spi_f => 30, :mp => 24}, :ap => 1300},
    ],
    130 => [ # Trabocco
      {:params => {:damage => 110, :spi_f => 21, :mp_hi => 35, :mp => 12}, :ap => 800, :level => 45},
      {:params => {:damage => 121, :spi_f => 22, :mp_hi => 40, :mp => 15}, :ap => 1000, :level => 50},
      {:params => {:damage => 133, :spi_f => 23, :mp_hi => 45, :mp => 19}, :ap => 1200, :level => 55},
      {:params => {:damage => 146, :spi_f => 24, :mp_hi => 50, :mp => 24}, :ap => 1400, :level => 60},
    ],
    120 => [ # nebula
      {:params => {:damage => 195, :mp => 19}, :ap => 300},
      {:params => {:damage => 253, :charge => 55, :mp => 23}, :ap => 450},
      {:params => {:damage => 329, :state_inf_per => 0.2, :mp => 27}, :ap => 600},
      {:params => {:damage => 428, :charge => 40, :mp => 33}, :ap => 750},
      {:params => {:damage => 556, :state_inf_dur => 1, :mp => 40}, :ap => 900}
    ],
    133 => [ # implosione
      {:params => {:damage => 120, :mp_hi_e => 120, :mp => 24}, :ap => 700},
      {:params => {:damage => 144, :mp_hi_e => 140, :mp => 28}, :ap => 900, :level => 60},
      {:params => {:damage => 172, :mp_hi_e => 160, :mp => 34}, :ap => 1200},
      {:params => {:damage => 207, :mp_hi_e => 180, :mp => 41}, :ap => 1400, :level => 70},
      {:params => {:damage => 250, :mp_hi_e => 200, :mp => 50}, :ap => 1600},
    ],
    134 => [ # magnitudo
      {:params => {:damage => 1500, :spi_f => 110, :mp => 60}, :ap => 1000, :level => 50},
      {:params => {:damage => 2250, :spi_f => 120, :mp => 90}, :ap => 1300, :level => 60},
      {:params => {:damage => 3375, :spi_f => 140, :mp => 135}, :ap => 1600, :level => 70},
      {:params => {:damage => 5062, :spi_f => 160, :mp => 202}, :ap => 1900, :level => 80},
    ],

    # mosse tank

    141 => [ # colpo di scudo TODO: aggiornare icona e/o animazione
      {:params => {:def_f => 55, :state_inf_per => 0.05}, :ap => 50},
      {:params => {:def_f => 60, :state_inf_per => 0.10, :mp => 5}, :ap => 75},
      {:params => {:def_f => 65, :state_inf_per => 0.15}, :ap => 100},
      {:params => {:def_f => 70, :state_inf_per => 0.20, :mp => 6}, :ap => 125},
      {:params => {:def_f => 80, :atk_f => 20, :state_inf_per => 0.25, :mp => 10,
                   :description => 'Sbatte lo scudo sul nemico con grande forza,|provocando uno Stordimento.',
                   :name => 'Attacco con scudo', :icon => 426}, :ap => 150, :level => 20, :item => 140},
      {:params => {:def_f => 85, :atk_f => 30, :state_inf_per => 0.30, :mp => 15}, :ap => 200},
      {:params => {:def_f => 90, :atk_f => 40, :state_inf_per => 0.35, :mp => 20}, :ap => 250},
      {:params => {:def_f => 95, :atk_f => 50, :state_inf_per => 0.40, :mp => 25}, :ap => 300},
    ],
    142 => [ # luce dell'alba
      {:params => {:damage => 180, :spi_f => 31, :hp_hi => 12, :mp => 8}, :ap => 100},
      {:params => {:damage => 216, :spi_f => 32, :hp_hi => 14, :mp => 10}, :ap => 200},
      {:params => {:damage => 259, :spi_f => 33, :hp_hi => 16, :mp => 13}, :ap => 350},
      {:params => {:damage => 311, :spi_f => 34, :hp_hi => 18, :mp => 15}, :ap => 500},
      {:params => {:damage => 373, :spi_f => 35, :hp_hi => 20, :mp => 30,
                   :name => 'Luce del Mattino', :icon => '227', :target => :multi},
      :ap => 700, :level => 30, :item => 140},
      {:params => {:damage => 447, :spi_f => 35, :hp_hi => 22, :mp => 34}, :ap => 900},
      {:params => {:damage => 537, :spi_f => 36, :hp_hi => 24, :mp => 38}, :ap => 1100},
      {:params => {:damage => 644, :spi_f => 38, :hp_hi => 26, :mp => 42}, :ap => 1300},
      {:params => {:damage => 773, :spi_f => 39, :hp_hi => 28, :mp => 46}, :ap => 1500},
      {:params => {:damage => 928, :spi_f => 40, :hp_hi => 30, :mp => 50}, :ap => 1700},
    ],
    143 => [ # giudizio
      {:params => {:damage => 50, :grudge => 60, :mp => 8}, :ap => 200},
      {:params => {:damage => 100, :grudge => 70, :mp => 9}, :ap => 300},
      {:params => {:mhp_f => 2, :grudge => 80, :mp => 15, :name => 'Verdetto',
                   :autostate => 136, :description => "Attacca con l'elemento Sacro," +
          " aumenta l'odio del bersaglio verso|\\n[0] e per alcuni turni applica " +
          "l'elemento Sacro sull'arma.", :animation => 525, :icon => 1318}, :ap => 1500, :item => 140, :level => 40},
      {:params => {:mhp_f => 3, :grudge => 90, :mp => 17}, :ap => 1700},
      {:params => {:mhp_f => 5, :grudge => 100, :mp => 19}, :ap => 1900},
      {:params => {:mhp_f => 10, :atk_f => 110, :grudge => 150, :mp=> 22, :mp_cost_per => 5,
                   :turn_delay => 7, :name => 'Epurazione'}, :ap => 4000, :level => 60, :item => 141 }
    ],
    145 => [ # provocazione
      {:params => {:grudge => 75, :mp => 5 }, :ap => 100},
      {:params => {:grudge => 100, :mp => 6 }, :ap => 150},
      {:params => {:grudge => 125, :mp => 7 }, :ap => 200},
      {:params => {:grudge => 0, :aggro => 150, :target => :multi, :mp => 12, :name => "Aura d'Odio",
                   :description => 'Provoca i nemici, incitandoli ad attaccare \n[0].'},
       :ap => 400, :level => 20, :item => 140},
      {:params => {:aggro => 175, :mp => 14 }, :ap => 450},
      {:params => {:aggro => 200, :mp => 16 }, :ap => 500},
      {:params => {:aggro => 250, :mp => 18 }, :ap => 550},
    ],
    146 => [ # muraglia
      {:params => {:recharge => 40}, :ap => 200},
      {:params => {:recharge => 60}, :ap => 400},
      {:params => {:recharge => 80}, :ap => 600}
    ],
    147 => [ # ultima difesa
      {:params => {:battle_delay => 5}, :ap => 500},
      {:params => {:battle_delay => 4}, :ap => 600},
      {:params => {:battle_delay => 3}, :ap => 700},
      {:params => {:battle_delay => 2}, :ap => 800},
    ],

    148 => [ # rinvigorimento
      {:params => {:battle_delay => 5}, :ap => 1000},
      {:params => {:charge => 15}, :ap => 1500},
      {:params => {:battle_delay => 4}, :ap => 2000},
      {:params => {:charge => 0}, :ap => 2500},
      {:params => {:battle_delay => 3}, :ap => 3000},
    ],
    150 => [ # scudo sacro
      {:params => {:charge => 0}, :ap => 100},
      {:params => {:recharge => 20}, :ap => 200},
      {:params => {:state_inf_dur => 1}, :ap => 300},
      {:params => {:target => :multi, :mp => 12, :name => 'Muro Sacro',
                   :description => 'Protegge gli alleati dimezzando i danni oscuri.|Richiede uno scudo equipaggiato.'},
       :ap => 500, :item => 140, :level => 20},
      {:params => {:recharge => 40}, :ap => 600},
      {:params => {:recharge => 60}, :ap => 800},
      {:params => {:state_inf_dur => 2}, :ap => 1000},
    ],
    151 => [ # bastione
      {:params => {:recharge => 20}, :ap => 500},
      {:params => {:recharge => 40}, :ap => 700},
      {:params => {:recharge => 60}, :ap => 900},
      {:params => {:recharge => 80}, :ap => 1200},
      {:params => {:state_inf_dur => 1}, :ap => 1500},
      {:params => {:state_inf_dur => 2}, :ap => 3000},
    ],
    152 => [ # altruismo
      {:params => {:turn_delay => 9, :charge => 40}, :ap => 1500},
      {:params => {:turn_delay => 8, :charge => 30}, :ap => 2000},
      {:params => {:turn_delay => 7, :charge => 20, :state_inf_dur => 1}, :ap => 2500},
      {:params => {:turn_delay => 6, :charge => 10}, :ap => 3000},
      {:params => {:turn_delay => 5, :charge => 0, :state_inf_dur => 2}, :ap => 3500},
    ],
    155 => [ # bandisci
      {:params => {:state_inf_per => 0.05, :mp => 14}, :ap => 300},
      {:params => {:state_inf_per => 0.1, :mp => 15}, :ap => 400},
      {:params => {:turn_delay => 5, :state_inf_per => 0.15, :mp => 16}, :ap => 500},
      {:params => {:state_inf_dur => 1, :state_inf_per => 0.2, :mp => 17}, :ap => 600},
      {:params => {:turn_delay => 4, :state_inf_per => 0.25, :mp => 18}, :ap => 700},
      {:params => {:turn_delay => 3, :state_inf_per => 0.3, :mp => 19}, :ap => 800},
    ],

    160 => [ # sacrificio
      {:params => {:damage => -130, :mhp_f => 23, :mp => 6, :hp_cost_per => 6}, :ap => 450},
      {:params => {:damage => -169, :mhp_f => 26, :mp => 8, :hp_cost_per => 7}, :ap => 550},
      {:params => {:damage => -219, :mhp_f => 29, :mp => 10, :hp_cost_per => 8}, :ap => 650},
      {:params => {:damage => -285, :mhp_f => 32, :mp => 13, :hp_cost_per => 9}, :ap => 750},
      {:params => {:damage => -371, :mhp_f => 35, :mp => 13, :hp_cost_per => 9}, :ap => 850},
      {:params => {:damage => -500, :mhp_f => 400, :mp => 18, :hp_cost_per => 10,
                   :name => 'Immolazione', :icon => 1320, :animation => 526}, :ap => 1000, :level => 50, :item => 140},
    ],

    # VAMPIRO
    191 => [ # morso

    ],
    192 => [ # att. vampirico
      {:params => {:atk_f => 85, :mp => 11}, :ap => 100},
      {:params => {:atk_f => 90, :mp => 12}, :ap => 150},
      {:params => {:atk_f => 95, :mp => 13}, :ap => 200},
      {:params => {:atk_f => 100, :mp => 14}, :ap => 250},
      {:params => {:atk_f => 100, :agi_f => 5, :mp => 15,
                   :name => 'Razzia Vitale', }, :ap => 400, :item => 140, :level => 25},
    ],

    # ALCHIMISTA
    322 => [ # Scomposizione
      {:params => {:damage => 375, :mp => 25}, :ap => 1000, :level => 40},
      {:params => {:damage => 562, :mp => 37}, :ap => 2000, :level => 50},
      {:params => {:damage => 844, :mp => 55}, :ap => 3000, :level => 60}
    ],
    323 => [ # erosione
      {:params => {:state => 103.2, :mp => 6}, :ap => 250},
      {:params => {:state => 103.3, :mp => 7}, :ap => 450},
      {:params => {:mp => 10, :target => :multi, :name => 'Tracollo',
                   :description => 'Diminuisce la resistenza dei nemici all\'elemento Terra.'},
       :ap => 700, :item => 140, :level => 40},
      {:params => {:state => 103.4, :mp => 13}, :ap => 500},
      {:params => {:state => 103.5, :mp => 15}, :ap => 750},
    ]


  }

  # le varie abilità con i cambiamenti rispetto al livello base
  # ID_SKILL => [{liv2},{liv3}...]
  STATE_LEVELS = {
    5 => [
      { :params => { :spi_f => 100 } }
    ],
    39 => [ # vitalità
      { :params => {:mhp => 7}, :ap => 300},
      { :params => {:mhp => 9}, :ap => 400},
      { :params => {:mhp => 11}, :ap => 500},
      { :params => {:mhp => 13}, :ap => 600},
      { :params => {:mhp => 15}, :ap => 700},
      { :params => {:mhp => 17, :name => 'Tenacia'}, :ap => 800, :item => 141, :level => 40, :classes => [1, 6]},
      { :params => {:mhp => 19}, :ap => 900},
      { :params => {:mhp => 21}, :ap => 1000},
      { :params => {:mhp => 23}, :ap => 1100},
      { :params => {:mhp => 25}, :ap => 1200},
    ],
    40 => [ # buona volontà
      { :params => {:mmp => 7}, :ap => 300},
      { :params => {:mmp => 9}, :ap => 400},
      { :params => {:mmp => 11}, :ap => 500},
      { :params => {:mmp => 13}, :ap => 600},
      { :params => {:mmp => 15}, :ap => 700},
      { :params => {:mmp => 17}, :ap => 800, :item => 141, :level => 40, :classes => [3, 15]},
      { :params => {:mmp => 19}, :ap => 900},
      { :params => {:mmp => 21}, :ap => 1000},
      { :params => {:mmp => 23}, :ap => 1100},
      { :params => {:mmp => 25}, :ap => 1200},
    ],
    41 => [
      { :params => {:atk => 7}, :ap => 300},
      { :params => {:atk => 9}, :ap => 400},
      { :params => {:atk => 11}, :ap => 500},
      { :params => {:atk => 13}, :ap => 600},
      { :params => {:atk => 15}, :ap => 700},
      { :params => {:atk => 17}, :ap => 800, :item => 141, :level => 40, :classes => [2, 11, 12]},
      { :params => {:atk => 19}, :ap => 900},
      { :params => {:atk => 21}, :ap => 1000},
      { :params => {:atk => 23}, :ap => 1100},
      { :params => {:atk => 25}, :ap => 1200},
    ],
    42 => [
      { :params => {:def => 7}, :ap => 300},
      { :params => {:def => 9}, :ap => 400},
      { :params => {:def => 11}, :ap => 500},
      { :params => {:def => 13}, :ap => 600},
      { :params => {:def => 15}, :ap => 700},
      { :params => {:def => 17}, :ap => 800, :item => 141, :level => 40, :classes => [1, 12]},
      { :params => {:def => 19}, :ap => 900},
      { :params => {:def => 21}, :ap => 1000},
      { :params => {:def => 23}, :ap => 1100},
      { :params => {:def => 25}, :ap => 1200},
    ],
    43 => [
      { :params => {:spi => 7}, :ap => 300},
      { :params => {:spi => 9}, :ap => 400},
      { :params => {:spi => 11}, :ap => 500},
      { :params => {:spi => 13}, :ap => 600},
      { :params => {:spi => 15}, :ap => 700},
      { :params => {:spi => 17}, :ap => 800, :item => 141, :level => 40, :classes => [4, 18]},
      { :params => {:spi => 19}, :ap => 900},
      { :params => {:spi => 21}, :ap => 1000},
      { :params => {:spi => 23}, :ap => 1100},
      { :params => {:spi => 25}, :ap => 1200},
    ],
    44 => [
      { :params => {:agi => 7}, :ap => 300},
      { :params => {:agi => 9}, :ap => 400},
      { :params => {:agi => 11}, :ap => 500},
      { :params => {:agi => 13}, :ap => 600},
      { :params => {:agi => 15}, :ap => 700},
      { :params => {:agi => 17}, :ap => 800, :item => 141, :level => 40, :classes => [16, 18]},
      { :params => {:agi => 19}, :ap => 900},
      { :params => {:agi => 21}, :ap => 1000},
      { :params => {:agi => 23}, :ap => 1100},
      { :params => {:agi => 25}, :ap => 1200},
    ],
    46 => [
      { :params => {:def_ele_7 => -10}, :ap => 200},
      { :params => {:def_ele_7 => -15}, :ap => 400},
      { :params => {:def_ele_7 => -20}, :ap => 600, :level => 40},
      { :params => {:def_ele_7 => -25}, :ap => 800},
      { :params => {:def_ele_7 => -30}, :ap => 1000},
    ],
    47 => [
      { :params => {:def_ele_9 => -10}, :ap => 300},
      { :params => {:def_ele_9 => -15}, :ap => 500},
      { :params => {:def_ele_9 => -20}, :ap => 700, :level => 40},
      { :params => {:def_ele_9 => -25}, :ap => 900},
      { :params => {:def_ele_9 => -30}, :ap => 1100},
    ],
    48 => [
      { :params => {:def_ele_10 => -10}, :ap => 300},
      { :params => {:def_ele_10 => -15}, :ap => 500},
      { :params => {:def_ele_10 => -20}, :ap => 700, :level => 40},
      { :params => {:def_ele_10 => -25}, :ap => 900},
      { :params => {:def_ele_10 => -30}, :ap => 1100},
    ],
    49 => [
      { :params => {:def_ele_11 => -10}, :ap => 300},
      { :params => {:def_ele_11 => -15}, :ap => 500},
      { :params => {:def_ele_11 => -20}, :ap => 700, :level => 40},
      { :params => {:def_ele_11 => -25}, :ap => 900},
      { :params => {:def_ele_11 => -30}, :ap => 1100},
    ],
    50 => [
      { :params => {:def_ele_14 => -10}, :ap => 300},
      { :params => {:def_ele_14 => -15}, :ap => 500},
      { :params => {:def_ele_14 => -20}, :ap => 700, :level => 40},
      { :params => {:def_ele_14 => -25}, :ap => 900},
      { :params => {:def_ele_14 => -30}, :ap => 1100},
    ],
    51 => [ # insonnia
      { :params => {:def_sta_6 => -10}, :ap => 300},
      { :params => {:def_sta_6 => -15}, :ap => 500},
      { :params => {:def_sta_6 => -20}, :ap => 700, :level => 40},
      { :params => {:def_sta_6 => -25}, :ap => 900},
      { :params => {:def_sta_6 => -30}, :ap => 1100},
    ],
    52 => [ # vigore
      { :params => {:def_sta_9 => -10}, :ap => 300},
      { :params => {:def_sta_9 => -15}, :ap => 500},
      { :params => {:def_sta_9 => -20}, :ap => 700, :level => 40},
      { :params => {:def_sta_9 => -25}, :ap => 900},
      { :params => {:def_sta_9 => -30}, :ap => 1100},
    ],
    53 => [ # tenore
      { :params => {:def_sta_5 => -10}, :ap => 300},
      { :params => {:def_sta_5 => -15}, :ap => 500},
      { :params => {:def_sta_5 => -20}, :ap => 700, :level => 40},
      { :params => {:def_sta_5 => -25}, :ap => 900},
      { :params => {:def_sta_5 => -30}, :ap => 1100},
    ],
    54 => [ # Sesto senso
      { :params => {:def_sta_4 => -10}, :ap => 300},
      { :params => {:def_sta_4 => -15}, :ap => 500},
      { :params => {:def_sta_4 => -20}, :ap => 700, :level => 40},
      { :params => {:def_sta_4 => -25}, :ap => 900},
      { :params => {:def_sta_4 => -30}, :ap => 1100},
    ],
    55 => [ # Calma interiore
      { :params => {:def_sta_21 => -10}, :ap => 300},
      { :params => {:def_sta_21 => -15}, :ap => 500},
      { :params => {:def_sta_21 => -20}, :ap => 700, :level => 40},
      { :params => {:def_sta_21 => -25}, :ap => 900},
      { :params => {:def_sta_21 => -30}, :ap => 1100},
    ],
    58 => [ # difesa sacro
      { :params => {:def_ele_15 => -10}, :ap => 300},
      { :params => {:def_ele_15 => -15}, :ap => 500},
      { :params => {:def_ele_15 => -20}, :ap => 700, :level => 40},
      { :params => {:def_ele_15 => -25}, :ap => 900},
      { :params => {:def_ele_15 => -30}, :ap => 1100},
    ],
    59 => [ # pelle scura
      { :params => {:def_ele_16 => -10}, :ap => 300},
      { :params => {:def_ele_16 => -15}, :ap => 500},
      { :params => {:def_ele_16 => -20}, :ap => 700, :level => 40},
      { :params => {:def_ele_16 => -25}, :ap => 900},
      { :params => {:def_ele_16 => -30}, :ap => 1100},
    ],
    60 => [ # pelle di orca
      { :params => {:def_ele_12 => -10}, :ap => 300},
      { :params => {:def_ele_12 => -15}, :ap => 500},
      { :params => {:def_ele_12 => -20}, :ap => 700, :level => 40},
      { :params => {:def_ele_12 => -25}, :ap => 900},
      { :params => {:def_ele_12 => -30}, :ap => 1100},
    ],
    62 => [ # cacciatesori
      { :params => {:gold_bonus => 20}, :ap => 2000},
      { :params => {:gold_bonus => 30}, :ap => 3000},
      { :params => {:gold_bonus => 40}, :ap => 4000},
      { :params => {:gold_bonus => 50}, :ap => 5000},
    ],

    103 => [ # erosione
      { :params => {:def_ele_13 => 45}},
      { :params => {:def_ele_13 => 60}},
      { :params => {:def_ele_13 => 75}},
      { :params => {:def_ele_13 => 100}}
    ],

    124 => [ # fuocoattacco
      { :params => {:target => :allies}},
      { :params => {:atk_ele_9 => 20}},
      { :params => {:atk_ele_9 => 30}},
    ],
    125 => [ # ghiaccioattacco
      { :params => {:atk_ele_10 => 10}},
      { :params => {:atk_ele_10 => 20}},
      { :params => {:atk_ele_10 => 30}},
    ],
    126 => [ # tuonattacco
      { :params => {:atk_ele_11 => 10}},
      { :params => {:atk_ele_11 => 20}},
      { :params => {:atk_ele_11 => 30}},
    ],
    127 => [ # idroattacco
      { :params => {:atk_ele_12 => 10}},
      { :params => {:atk_ele_12 => 20}},
      { :params => {:atk_ele_12 => 30}},
    ],
    128 => [ # ventoattacco
      { :params => {:atk_ele_13 => 10}},
      { :params => {:atk_ele_13 => 20}},
      { :params => {:atk_ele_13 => 30}},
    ],
    129 => [ # terrattacco
      { :params => {:atk_ele_14 => 10}},
      { :params => {:atk_ele_14 => 20}},
      { :params => {:atk_ele_14 => 30}},
    ],

  }

  # Vocaboli
  REQ_VOCAB = 'Requisiti'
  DMG_VOCAB = 'Danno:'

  AP_COST = /<[aj]p[ _]cost:[ ]*(\d+)>/i
  SKILL_REQ = /<[aj]p[ _]require[ _](skill|passive|item|switch|level|variable):[ ]*([\d.]+)>/i
  SKILLS_REQ = /<[aj]p[ _]require[ _](skills|passives):[ ]*([\d,]+)>/
  ENEMY_SKILL_LEVEL = /<skill[ ]*(\d+)[ ]*(lv|level)[ ]*(\d+)>/i
  AP_ENEMY = /<[aj]p:[ ]*([\d,]+)>/
end

module Vocab
  def self.ap
    SkillSettings::AP_ABBREV
  end

  def self.ap_long
    SkillSettings::AP_VOCAB
  end

  def self.passive
    SkillSettings::VOCAB_PASSIVE
  end

  def self.skills_command
    SkillSettings::VOCAB_SKILLS_CMD
  end

  def self.passives_command
    SkillSettings::VOCAB_PASSIVES_CMD
  end

  def self.learn_command
    SkillSettings::VOCAB_LEARN_CMD
  end

  def self.sort_command
    SkillSettings::VOCAB_SORT_CMD;
  end

  def self.upgrade_command
    SkillSettings::VOCAB_UPGRADE_CMD
  end

  def self.use_skill
    SkillSettings::VOCAB_USE_SKILL
  end

  def self.hide_skill
    SkillSettings::VOCAB_HIDE_SKILL
  end

  def self.show_skill
    SkillSettings::VOCAB_SHOW_SKILL
  end

  def self.learn_skill
    SkillSettings::VOCAB_LEARN_SKILL
  end

  def self.sort_skill
    SkillSettings::VOCAB_SORT_SKILL
  end

  def self.power_up_skill
    SkillSettings::VOCAB_UPGRADE_CMD
  end

  def self.evolve_skill
    SkillSettings::VOCAB_EVOLVE_CMD
  end

  def self.release_skill
    SkillSettings::VOCAB_RELE_SKILL
  end

  def self.exhange_skill
    SkillSettings::VOCAB_EXCH_SKILL
  end

  def self.back_skill
    SkillSettings::VOCAB_SKILL_BACK
  end

  def self.vocab_actual_skill
    SkillSettings::VOCAB_NOWSKILL
  end

  def self.next_skill_level
    SkillSettings::VOCAB_NEXSKILL
  end

  def self.default_sort
    SkillSettings::VOCAB_DEFAULT_SORT
  end

  def self.actor_will_learn
    SkillSettings::VOCAB_LEARN
  end

  def self.learnt
    SkillSettings::VOCAB_LEARNT
  end
end