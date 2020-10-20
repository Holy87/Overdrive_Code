class Window_SaveConfirm < Window_Command
  def initialize(x, y, saving = false)
    @saving = saving
    super(x, y)
    @index = 0
    self.back_opacity = 255
    self.openness = 0
  end

  def make_command_list
    if @saving
      add_command(Vocab::SAVE_OVERRIDE_QUESTION, :save_override)
    else
      add_command(Vocab::SAVE_LOAD_QUESTION, :do_load)
    end
    add_command(Vocab::SAVE_RENAME, :rename)
    add_command(Vocab::SAVE_DELETE, :delete)
    add_command(Vocab::SAVE_NON, :cancel)
  end
end
