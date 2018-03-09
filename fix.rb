class Scene_Battle < Scene_Base
  alias popf_execute_result execute_result unless $@
  def execute_result
    $hide_popup = true
    popf_execute_result
    $hide_popup = false
  end
end

class Scene_Map < Scene_Base
  alias popf_mostra_popup mostra_popup unless $@
  def mostra_popup
    return if $hide_popup
    popf_mostra_popup
  end
end