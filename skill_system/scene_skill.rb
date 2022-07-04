class Scene_NewSkill < Scene_MenuBase
  def start
    super
    create_command_window
    create_actor_window
    create_help_window
    create_key_command_window
    create_info_window
    create_skill_list_window
    create_passive_list_window
    create_learn_list_window
    create_learn_prompt_window
    show_only_active_window
    create_main_viewports
    create_skill_compare_windows
    create_upgrade_command_window
    create_animated_items
  end

  # @return [Hash{Symbol->Window_Skill or Window_PassiveList or Window_LearnList}]
  def list_windows
    {
      :skills => @skills_window,
      :passives => @passives_window,
      :learn => @learns_window
    }
  end

  # restituisce la finestra selezionata
  # @return [Window_Skill, Window_PassiveList, Window_LearnList]
  def selected_window
    list_windows[@command_window.item]
  end

  def deactivate_all_windows
    list_windows.each_value do |window|
      window.deactivate
    end
  end

  def show_only_active_window
    list_windows.each_pair do |symbol, window|
      window.visible = (symbol == @command_window.item)
    end
  end

  def dialog_adjust_y
    100
  end

  # Restituisce l'eroe attuale
  # @return [Game_Actor]
  def actor
    @actor
  end

  def reset_keys_window
    @keys_window.columns = 3
    @keys_window.set_command(0, Key_Command_Container.new(:C, Vocab.select))
    @keys_window.set_command(1, Key_Command_Container.new(:B, Vocab.prev_scene_name))
    @keys_window.set_command(2, Key_Command_Container.new([:LEFT, :RIGHT], Vocab.switch_actor))
  end

  def learn_action
    skill = @learns_window.item
    actor.learn skill
    actor.lose_ap skill.ap_cost
    @learns_window.refresh
    @actor_window.refresh
    @skills_window.deep_refresh if skill.is_a?(RPG::Skill)
    @passives_window.deep_refresh if skill.is_a?(RPG::State)
  end

  # posizioni ################

  # larghezza della finestra a sinistra
  def windows_width
    Graphics.width / 2 + 10 # + 64
  end

  # coordinata y delle finestre principali
  def under_help
    @help_window.bottom_corner
  end

  # altezza delle finestre principali
  def window_height
    Graphics.height - under_help - @keys_window.height
  end

  # creazioni ################

  def create_main_viewports
    @hidden_viewport = Viewport.new
    list_windows.each_value { |window| window.viewport = @hidden_viewport }
    @help_window.viewport = @hidden_viewport
    @info_window.viewport = @hidden_viewport
    @animation_viewport = Viewport.new
    @animation_viewport.z = 999
  end

  def create_command_window
    @command_window = Window_SkillCommand.new(0, 0)
    @command_window.set_handler(:skills, method(:command_skills))
    @command_window.set_handler(:passives, method(:command_passives))
    @command_window.set_handler(:learn, method(:command_learning))
    @command_window.set_handler(:cancel, method(:return_scene))
    @command_window.set_handler(:left, method(:prev_actor))
    @command_window.set_handler(:right, method(:next_actor))
    @command_window.set_handler(:cursor_move, method(:on_cursor_move))
    @command_window.activate
  end

  def create_actor_window
    x = @command_window.rx
    width = Graphics.width - @command_window.width
    @actor_window = Window_ActorSmallInfo.new(x, 0, width, actor)
    @command_window.height = @actor_window.height
  end

  def create_help_window
    super
    @help_window.y = @command_window.height
  end

  def create_key_command_window
    @keys_window = Window_KeyHelp.new
    reset_keys_window
  end

  def create_info_window
    x = windows_width
    y = under_help
    width = Graphics.width - x
    height = Graphics.height - y - @keys_window.height
    @info_window = Window_ItemInfo.new(x, y, width, height)
    @info_window.set_actor(actor)
  end

  def create_skill_list_window
    @skills_window = Window_Skill.new(0, under_help, windows_width, window_height, actor)
    @skills_window.deactivate
    @skills_window.info_window = @info_window
    @skills_window.keys_window = @keys_window
    @skills_window.help_window = @help_window
    @skills_window.set_actor actor
    @skills_window.height = window_height
    set_skill_window_handlers
  end

  def set_skill_window_handlers
    @skills_window.set_handler(:ok, method(:command_use))
    @skills_window.set_handler(:cancel, method(:command_back))
    @skills_window.set_handler(:function, method(:command_upgrade_skill))
    @skills_window.set_handler(:shift, method(:command_sort))
  end

  def create_passive_list_window
    @passives_window = Window_PassiveList.new(0, under_help, windows_width, window_height)
    @passives_window.deactivate
    @passives_window.set_actor actor
    @passives_window.help_window = @help_window
    @passives_window.info_window = @info_window
    @passives_window.keys_window = @keys_window
    @passives_window.set_handler(:ok, method(:command_switch_activation))
    @passives_window.set_handler(:function, method(:command_upgrade_passive))
    @passives_window.set_handler(:cancel, method(:command_back))
  end

  def create_learn_list_window
    @learns_window = Window_LearnList.new(0, under_help, windows_width, window_height)
    @learns_window.deactivate
    @learns_window.set_actor actor
    @learns_window.help_window = @help_window
    @learns_window.info_window = @info_window
    @learns_window.keys_window = @keys_window
    @learns_window.set_handler(:ok, method(:command_learn))
    @learns_window.set_handler(:cancel, method(:command_back))
  end

  def create_learn_prompt_window
    @learn_prompt_window = Window_Learn.new(0, 0)
    @learn_prompt_window.center_window
    @learn_prompt_window.y += 100
    @learn_prompt_window.deactivate
    @learn_prompt_window.openness = 0
    @learn_prompt_window.set_handler(:learn, method(:command_learn_ok))
    @learn_prompt_window.set_handler(:cancel, method(:command_learning))
  end

  def create_skill_compare_windows
    width = (Graphics.width - 160) / 2
    @compare1_window = Window_ItemInfo.new(0 - width, @help_window.height, width, Graphics.height - @help_window.height)
    @compare2_window = Window_ItemInfo.new(Graphics.width, @help_window.height, width, Graphics.height - @help_window.height)
    @compare1_window.show_item_name = true
    @compare2_window.show_item_name = true
    @compare1_window.visible = false
    @compare2_window.visible = false
  end

  def create_upgrade_command_window
    x = @compare1_window.width - @compare1_window.padding
    y = Graphics.height/2 + 50
    width = Graphics.width - (@compare1_window.width - @compare1_window.padding) * 2
    @upgrade_window = Window_SkillUpgrade.new(x, y, width)
    @upgrade_window.set_handler(:upgrade, method(:command_upgrade_ok))
    @upgrade_window.set_handler(:cancel, method(:command_upgrade_cancel))
  end

  # eventi ##################

  def on_actor_change
    @skills_window.set_actor(actor)
    @passives_window.set_actor(actor)
    @learns_window.set_actor(actor)
    @info_window.set_actor(actor)
    @actor_window.set_actor(actor)
    @character_sprite.set_actor(actor)
  end

  def on_cursor_move
    show_only_active_window
  end

  def on_window_move_end
    @arrow_sprites.visible = true
    @upgrade_window.activate
    @upgrade_window.open
    @upgrade_window.index = 0
  end

  # comandi ##################

  # attiva la finestra delle abilità
  def command_skills
    @skills_window.set_key_commands
    @skills_window.activate
  end

  def command_passives
    @passives_window.activate
  end

  def command_learning
    @learns_window.activate
    @learn_prompt_window.close
    unfade_windows
    close_animation_learn
  end

  def command_back
    @command_window.activate
    list_windows.each_value { |window| window.index = -1 }
    @help_window.set_text('')
    reset_keys_window
    @info_window.set_item nil
    @req_level_sprite.visible = false
    @ap_cost_sprite.visible = false
    @last_index = nil
  end

  def command_upgrade_skill
    command_upgrade(@skills_window.item, @skills_window)
  end

  def command_upgrade_passive
    command_upgrade(@passives_window.item, @passives_window)
  end

  # @param [Learnable, RPG::Skill, RPG::State] skill
  # @param [Window_Skill, Window_PassiveList] origin_window
  def command_upgrade(skill, origin_window)
    if actor.skill_max_level_reached?(skill)
      Sound.play_buzzer
      return
    end
    Sound.play_use_skill
    origin_window.deactivate
    lvl_up_skill = skill.next_level_skill
    @ap_cost_sprite.visible = false
    @compare1_window.set_item(skill)
    @compare2_window.set_item(lvl_up_skill)
    @upgrade_window.set_data(actor, skill)
    @help_window.set_item(lvl_up_skill)
    @compare1_window.visible = true
    @compare2_window.visible = true
    Graphics.wait(10)
    hide_all_windows
    @compare1_window.smooth_move(0, @help_window.height, 2, method(:on_window_move_end))
    @compare2_window.smooth_move(Graphics.width - @compare2_window.width, @help_window.height)
  end

  def command_upgrade_ok
    #noinspection RubyMismatchedParameterType
    @upgrade_window.close
    @arrow_sprites.visible = false
    x = (Graphics.width - @compare1_window.width) / 2
    @compare1_window.smooth_move(x, @compare1_window.y)
    @compare2_window.smooth_move(x, @compare2_window.y, 2, method(:trigger_skill_upgrade))
  end

  def command_upgrade_end
    upgrade_end_process(true)
    @actor_window.refresh
  end

  def command_upgrade_cancel
    upgrade_end_process
  end

  def command_sort
    return Sound.play_buzzer unless actor.learn?(@skills_window.skill)
    Sound.play_switch
    @skills_window.set_sorting true
    @skills_window.activate
    @skills_window.set_handler(:ok, method(:command_sort_chosen))
    @skills_window.set_handler(:cancel, method(:cancel_sort))
    @skills_window.set_handler(:function, method(:command_autosort))
    @skills_window.delete_handler(:shift)
  end

  def command_autosort
    Sound.play_sort
    actor.sort_skills
    @skills_window.trigger_sort_success
    cancel_sort
  end

  def command_sort_chosen
    Sound.play_sort
    actor.swap_skills(@skills_window.skill, @skills_window.sorting_skill)
    @skills_window.trigger_sort_success
    cancel_sort
  end

  def command_use

  end

  def command_switch_activation
    Sound.play_switch
    actor.switch_passive_enabled(@passives_window.item)
    @passives_window.redraw_current_item
    @passives_window.activate
    @actor_window.refresh
  end

  def command_learn
    fade_windows
    @learn_prompt_window.set_data(@learns_window.item, actor)
    @learn_prompt_window.open
    @learn_prompt_window.activate
    animate_skill_learn
  end

  def command_learn_ok
    @learn_prompt_window.close
    animate_learning
  end

  def cancel_sort
    @skills_window.activate
    @skills_window.set_sorting false
    set_skill_window_handlers
  end

  def fade_windows
    @hidden_viewport.color = Color::BLACK.deopacize(80)
  end

  def unfade_windows
    @hidden_viewport.color = Color::TRANSPARENT
  end

  def hide_all_windows
    @help_window.smooth_move(0, 0)
    @command_window.smooth_up
    @skills_window.smooth_left
    @info_window.smooth_right
    @actor_window.smooth_up
    @command_window.smooth_up
    @keys_window.smooth_down
  end

  def reset_all_windows
    @help_window.smooth_move(0, @command_window.height)
    @command_window.smooth_reset_position
    @skills_window.smooth_reset_position
    @command_window.smooth_reset_position
    @info_window.smooth_reset_position
    @actor_window.smooth_reset_position
    @keys_window.smooth_reset_position
  end

  def upgrade_end_process(success = false)
    reset_all_windows
    window = @compare1_window.item.is_a?(RPG::Skill) ? @skills_window : @passives_window
    window.activate
    window.redraw_current_item if success
    window.visible = true
    @upgrade_window.close
    @upgraded_skill_icon.visible = false
    @compare1_window.smooth_move(0 - @compare1_window.width, @help_window.height)
    @compare2_window.smooth_move(Graphics.width, @help_window.height)
    @arrow_sprites.visible = false
  end
end