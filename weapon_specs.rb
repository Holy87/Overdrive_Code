# Questo script mostra l'abilità speciale dell'arma modificata accanto al
# titolo.

#===============================================================================
# ** classe Window_Base
#===============================================================================
class Window_Base < Window
  alias add_title_item draw_item_name unless $@
  #-----------------------------------------------------------------------------
  # * alias draw_item_name
  #-----------------------------------------------------------------------------
  def draw_item_name(item, x, y, enabled = true, width = 172)
    add_title_item(item, x, y, enabled, width)
    if item.is_a?(RPG::Weapon) and item.special_text != ""
      draw_specialization(item, x, y, enabled, width)
    end
  end
  #-----------------------------------------------------------------------------
  # * disegna la scritta della specializzazione dell'arma. Restituisce il
  # numero di pixel necessari per la scrittura
  # @param [RPG::Weapon] item
  # @param [Integer] x
  # @param [Integer] y
  # @param [Boolean] enabled
  # @param [Integer] width
  # @return [Integer]
  #-----------------------------------------------------------------------------
  def draw_specialization(item, x, y, enabled = true, width = contents_width)
    x2 = x + 25 + text_size(item.name).width
    w = width - x2 + 2
    old_font = contents.font.size
    old_color = contents.font.color.clone
    contents.font.size = 15
    h = text_size(item.special_text).height
    change_color(equip_power_up_color, enabled)
    draw_text(x2, y, w, h, item.special_text)
    change_color(old_color)
    contents.font.size = old_font
    text_size(item.special_text).width
  end
  #-----------------------------------------------------------------------------
  # * colore power_up
  #-----------------------------------------------------------------------------
  def equip_power_up_color; text_color(14); end
end #window_base

#===============================================================================
# ** classe RPG::Weapon
#===============================================================================
class RPG::Weapon
  #-----------------------------------------------------------------------------
  # * restituisce il testo speciale (se presente)
  #-----------------------------------------------------------------------------
  def special_text
    generate_special_text if @special_text.nil?
    @special_text
  end
  #-----------------------------------------------------------------------------
  # * ottiene il testo scritto nel database
  #-----------------------------------------------------------------------------
  def generate_special_text
    @special_text = ""
    self.note.split(/[\r\n]+/).each { |line|
      case line
        when /<speciale:[ ](.*)>/i
          @special_text = $1
          break
      end
    }
  end
end #rpg_weapon

#==============================================================================
# ** Compatibilità Yanfly
#==============================================================================
if $imported["ItemOverhaul"]
class Window_ItemList < Window_Selectable
  alias nuovo_draw_item2 draw_obj_name unless $@
  #-----------------------------------------------------------------------------
  # * alias draw_obj_name
  #-----------------------------------------------------------------------------
  def draw_obj_name(obj, rect, enabled)
    nuovo_draw_item2(obj, rect, enabled)
    if obj.is_a?(RPG::Weapon) and obj.id > 189
      draw_specialization(obj,rect.x,rect.y,enabled)
    end
  end
end
end
