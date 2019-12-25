#==============================================================================
# ** classe Bitmap
#------------------------------------------------------------------------------
#  Aggiunta di metodi alla classe Bitmap
#==============================================================================
class Bitmap
  #--------------------------------------------------------------------------
  # * Disegna un testo formattato (torna a capo automaticamente)
  #   Supporta anche le emoji.
  #   x:      coordinata X
  #   y:      coordinata Y
  #   width:  larghezza del box
  #   text:   testo da scrivere
  #   max:    numero massimo di righe
  #   colors: regole di colore per tag speciali
  #   test:   non scrive nulla ma restituisce il numero di righe che scriverebbe
  # @param [Integer] x
  # @param [Integer] y
  # @param [Integer] width
  # @param [String] text
  # @param [Integer] max
  # @param [Tag_Rules] colors
  #--------------------------------------------------------------------------
  def draw_formatted_text(x, y, width, text, max = nil, colors = nil, test = false)
    @emojis = 0
    @normal_color = self.font.color
    return {:x => 0, :y => 0, :lines => 0} if text.nil? || text.empty?
    @color_rules = colors if colors != nil
    @paragraph_lines = 0
    mh = nil
    mh = max * line_height if max
    end_y = y
    pos = {}
    text.split(/[\n\r]+/).each do |paragraph|
      pos = draw_text_paragraph(x, end_y, width, check_emoji(paragraph), mh, test)
      end_y += pos[:y]
    end
    pos[:y] = end_y
    pos
  end
  #--------------------------------------------------------------------------
  # * Scrive il paragrafo corrente
  #   x:          posizione X
  #   y:          posizione Y
  #   width:      larghezza del testo
  #   paragraph:  testo del apragrafo
  #   mh:         massima altezza raggiungibile, altrimenti dà eccezione
  #   - Restituisce la posizione Y raggiunta + 24
  # @param [Fixnum] x
  # @param [Fixnum] y
  # @param [Fixnum] width
  # @param [String] paragraph
  # @param [Fixnum] mh
  # @param [Object] test
  #--------------------------------------------------------------------------
  def draw_text_paragraph(x, y, width, paragraph, mh, test = false)
    words = paragraph.split(/[ ]/)
    xx = 0
    xy = {:x => xx, :y => y}
    words.each do |word|
      if emoji?(word)
        xy = draw_emoji(x, xy[:y], xy[:x], width, word, mh, test)
      else
        xy = draw_word(x, xy[:y], xy[:x], width, word, mh, test)
      end
    end
    {:x => xy[:x], :y => xy[:y] - y + 24, :lines => @paragraph_lines, :chars => 0}
  end
  #--------------------------------------------------------------------------
  # * Disegna la parola singola
  #   x: posizione x della bitmap
  #   y: posizione y della bitmap
  #   xx: posizione x del paragrafo
  #   word: parola
  #   mh: massima altezza
  #   - Restituisce la posizione y raggiunta
  # @raise [TooMuchTextException]
  # @return [Hash]
  #--------------------------------------------------------------------------
  def draw_word(x, y, xx, width, word, mh, test)
    space = xx == 0 ? '' : ' '
    #if @color_rules && @color_rules.meet_rule?(word)
    #  change_color(@color_rules.last_rule_color)
    #  word = @color_rules.last_word
    #end
    close = false
    if @color_rules
      if @color_rules.opening?(word)
        word = word.gsub(@color_rules.open_char)
        change_color(@color_rules.color)
      end
      if @color_rules.closing?(word)
        word = word.gsub(@color_rules.close_char)
        close = true
      end
    end
    #if word =~ /@(.+)/
    #  self.font.color = @colors[:tag]
    #else
    # self.font.color = @colors[:normal]
    # end
    word_width = text_size(space + word).width
    if !(word_width > width) && (xx + word_width > width)
      xx = 0
      y += 24
      @paragraph_lines += 1
      raise TooMuchTextEception.new('Limite superato') if mh && y > mh
      space = ''
    end
    draw_text(x + xx, y, word_width, 24, space + word) unless test
    change_color(@normal_color) if close
    xx += word_width
    {:x => xx, :y => y}
  end
  #--------------------------------------------------------------------------
  # * Disegna un'emoji
  #   x: posizione x della bitmap
  #   y: posizione y della bitmap
  #   xx: posizione x del paragrafo
  #   word: parola
  #   mh: massima altezza
  #   - Restituisce la posizione y raggiunta
  # @param [Integer] x
  # @param [Integer] y
  # @param [Integer] xx
  # @param [Integer] width
  # @param [String] char
  # @param [Integer] mh
  # @raise [TooMuchTextException]
  # @return [Hash]
  #--------------------------------------------------------------------------
  def draw_emoji(x, y, xx, width, char, mh, test)
    @emojis = 0 unless @emojis
    bitmap = Cache.system('Emojiset')
    em_index = Emoji.get(char)
    rect = Rect.new(em_index % 16 * 24, em_index / 16 * 24, 24, 24)
    if xx > width - 24
      xx = 0
      y += 24
      raise TooMuchTextEception.new('Limite superato') if mh && y > mh
    end
    self.blt(x+xx, y, bitmap, rect) unless test
    xx += 24
    @emojis += 1
    {:x => xx, :y => y}
  end
  #--------------------------------------------------------------------------
  # * Imposta il colore del testo
  # @param [Color] color
  #--------------------------------------------------------------------------
  def change_color(color)
    self.font.color = color
  end
  #--------------------------------------------------------------------------
  # * Testa quante righe vengono scritte
  # @param [Integer] x
  # @param [Integer] y
  # @param [Integer] width
  # @param [String] paragraph
  # @param [Tag_Rules] color_rules
  #--------------------------------------------------------------------------
  def test_paragraph(x, y, width, paragraph, color_rules = nil)
    draw_formatted_text(x, y, width, paragraph, nil, color_rules, true)
  end
  #--------------------------------------------------------------------------
  # * Controlla se è un'emoji
  #--------------------------------------------------------------------------
  def check_emoji(string)
    string2 = string.clone
    Emoji.chars.each{|char| string2.gsub!(char, " #{char} ")}
    string2
  end
  #--------------------------------------------------------------------------
  # * Restituisce l'array delle emoji
  #--------------------------------------------------------------------------
  def emojis
    return 0 unless @emojis
    @emojis
  end
  #--------------------------------------------------------------------------
  # * Restituisce true se la parola è un emoji
  #--------------------------------------------------------------------------
  def emoji?(word) Emoji.has?(word); end
  #--------------------------------------------------------------------------
  # * Disegna un'icona nella bitmap
  # @param [Integer] icon_index
  # @param [Integer] x
  # @param [Integer] y
  # @param [Boolean] enabled
  #--------------------------------------------------------------------------
  def draw_icon(icon_index, x, y, enabled = true)
    bitmap = Cache.system('Iconset')
    rect = Rect.new(icon_index % 16 * 24, icon_index / 16 * 24, 24, 24)
    self.blt(x, y, bitmap, rect, enabled ? 255 : 128)
  end
  #--------------------------------------------------------------------------
  # * Returns a glowed bitmap copy
  # @param [Integer] strenght
  # @return [Bitmap]
  #--------------------------------------------------------------------------
  def glow(strenght = 2)
    copy = self.clone
    strenght.times{copy.blur}
    copy.blt(0, 0, self, Rect.new(0, 0, copy.width, copy.height))
    copy
  end
  #--------------------------------------------------------------------------
  # * Draws a glowed text
  # @param [Integer] x
  # @param [Integer] y
  # @param [Integer] width
  # @param [Integer] height
  # @param [String] text
  # @param [Integer] align
  # @param [Integer] glow_str
  # @param [Color] glow_color
  #--------------------------------------------------------------------------
  def draw_glowed_text(x, y, width, height, text, align = 0, glow_str = 2, glow_color = self.font.color)
    padding = [glow_str, 3].min
    src_bitmap = Bitmap.new(width + padding * 2, height + padding * 2)
    rect = Rect.new(0, 0, width + padding*2, height + padding*2)
    src_bitmap.font.name = self.font.name
    src_bitmap.font.color = self.font.color
    src_bitmap.font.shadow = false
    src_bitmap.font.bold = self.font.bold
    src_bitmap.font.italic = self.font.italic
    src_bitmap.font.outline = self.font.outline
    src_bitmap.font.size = self.font.size
    glw_bitmap = src_bitmap.clone
    src_bitmap.draw_text(padding, padding, width, height, text, align)
    glw_bitmap.font.color = glow_color
    glw_bitmap.draw_text(padding, padding, width, height, text, align)
    glow_str.times{glw_bitmap.blur}
    glw_bitmap.blt(0, 0, src_bitmap, rect)
    self.blt(x-padding, y-padding, glw_bitmap, rect)
  end
end

#==============================================================================
# ** Color_Rule
#------------------------------------------------------------------------------
#  Classe che gestisce la regola di colorazione di una frase
#==============================================================================
class Color_Rule
  attr_reader :close_char
  attr_reader :open_char
  #--------------------------------------------------------------------------
  # * Inizializzazione
  # @param [Regexp] open_p
  # @param [Regexp] close_p
  # @param [Color] color
  #--------------------------------------------------------------------------
  def initialize(open_p, close_p, color)
    @open_char = open_p
    @close_char = close_p
    @color = color
  end
  #--------------------------------------------------------------------------
  # * La parola contiene un pattern di apertura?
  #--------------------------------------------------------------------------
  def opening?(word); word =~ open_char; end
  #--------------------------------------------------------------------------
  # * La parola contiene un pattern di chiusura?
  #--------------------------------------------------------------------------
  def closing?(word); word =~ close_char; end
  #--------------------------------------------------------------------------
  # * Restituisce il colore del testo
  # @return [Color]
  #--------------------------------------------------------------------------
  def color; @color; end
end

#==============================================================================
# ** Tag_Rules
#------------------------------------------------------------------------------
#  Classe che gestisce le regole di colorazione della parola tramite pattern
#==============================================================================
class Tag_Rules
  #--------------------------------------------------------------------------
  # * Inizializzazione. Aggiungi il colore normale
  # @param [Color] normal_color
  #--------------------------------------------------------------------------
  def initialize(normal_color)
    @normal_color = normal_color
    @last_word = ''
    @rules = []
  end
  #--------------------------------------------------------------------------
  # * Aggiunge una regola in questo modo: patten, colore[, carattere]
  #   esempio: /@(.+)/, Color.new(255,0,0), '@'
  # @param [Regexp] rule
  # @param [Color] color
  # @param [String] char
  #--------------------------------------------------------------------------
  def add(rule, color, char = '')
    @rules.push({:rule => rule, :color => color, :char => char})
  end
  #--------------------------------------------------------------------------
  # * Controlla che la parola rispetti una regola
  # @param [String] word
  # @return [Boolean]
  #--------------------------------------------------------------------------
  def meet_rule?(word)
    @last_rule = nil
    @rules.each{|rule|
      if word =~ rule[:rule]
        @last_rule = rule
        @last_word = rule[:char] + $1
        return true
      end
    }
    false
  end
  #--------------------------------------------------------------------------
  # * Restituisce il colore dell'ultima regola
  # @return [Color]
  #--------------------------------------------------------------------------
  def last_rule_color
    return nil unless @last_rule
    @last_rule[:color]
  end
  #--------------------------------------------------------------------------
  # * Restituisce il colore predefinito
  # @return [Color]
  #--------------------------------------------------------------------------
  def normal_color; @normal_color; end
  #--------------------------------------------------------------------------
  # * Restituisce la parola cercata
  # @return [String]
  #--------------------------------------------------------------------------
  def last_word; @last_word; end
end

#==============================================================================
# ** Window_Base
#------------------------------------------------------------------------------
#  Aggiunta del comando draw_emoji (come draw_icon, ma prende le emoji)
#==============================================================================
class Window_Base < Window
  #--------------------------------------------------------------------------
  # * Draw Emoji
  #     emoji_index : Emoji number
  #     x     : draw spot x-coordinate
  #     y     : draw spot y-coordinate
  #     enabled    : Enabled flag. When false, draw semi-transparently.
  #--------------------------------------------------------------------------
  def draw_emoji(type, icon_index, x, y, enabled = true)
    bitmap = Cache.system(sprintf('emoji_%s', type))
    rect = Rect.new(icon_index % 16 * 24, icon_index / 16 * 24, 24, 24)
    self.contents.blt(x, y, bitmap, rect, enabled ? 255 : 128)
  end
end

#==============================================================================
# ** Emoji
#------------------------------------------------------------------------------
#  Contiene l'elenco delle emoji supportate.
#==============================================================================
module Emoji
  #--------------------------------------------------------------------------
  # * Elenco degli emoji supportati con relativo ID icona
  # noinspection RubyStringKeysInHashInspection,RubyDuplicatedKeysInHashInspection
  #--------------------------------------------------------------------------
  LIST = {
      '😄' => 0, '😃' => 2, '😉' => 4, '😙' => 5, '😖' => 6, '😩' => 7, '😔' => 8,
      '😓' => 9, '😒' =>10, '😑' =>11, '😐' =>12, '😘' =>13, '😨' =>15, '😇' =>16,
      '😆' =>17, '😅'=> 18, '😂'=> 19, '😁' =>20, '😳' =>21, '😪' =>22, '😵' =>23,
      '😱' =>24, '😭' =>25, '😣' =>26, '😰' =>27, '😲' =>29, '😮' =>30, '😬' =>31,
      '😊' =>32, '😋' =>33, '😌' =>34, '😍' =>35, '😎' =>36, '😏' =>37, '😚' =>38,
      '😛' =>39, '😜' =>40, '😝' =>41, '😫' =>42, '😲' =>43, '😶' =>44, '😠' =>45,
      '😗' =>46, '😥' =>47, '😣' =>48, '😤' =>49, '😰' =>50, '😦' =>51, '😧' =>52,
      '😡' =>53, '😰' =>54, '👿' =>55, '😈' =>56, '😼' =>57, '😸' =>58, '😻' =>59,
      '😹' =>60, '🙀' =>61, '👽' =>62, '🔥' =>64, '❄' =>65, '⚡️' =>66, '💧' =>67,
      '🍁' =>68, '🍃' =>69, '☀️' =>70, '🌙' =>71, '💀' =>75, '💩' =>76, '❤️' =>77,
      '💔' =>78, '💌' =>79, '💠'=>101, '💢'=>102, '♻️'=>103, '⚠️'=>104, '♨️'=>105,
      '♠️'=>106, '♣️'=>107, '♥️'=>108, '♦️'=>109, 'ℹ️'=>110, '✅'=>111, '🚾'=>112,
      '⛔️'=>113, '👋'=>114, '👍'=>115, '👎'=>116, '👌'=>117, '✌️'=>118,
      '👊'=>119, '✊'=>120, '💪'=>121, '🙌'=>122, '👏'=>123, '🙏'=>124, '🖐'=>125,
      '🖕'=>126, '🖖'=>127
  }

  EMOJIS = {
      :faces => '😀😃😄😁😆😅😂🤣☺️😊😇🙂🙃😉😌😍😘😗😙😚😋😜😝😛🤑🤗🤓😎🤡🤠😏😒😞😔😟😕🙁☹️😣😖😫😩😤😠😡😶😐😑😯😦😧😮😲😵😳😱😨😰😢😥🤤😭😓😪😴🙄🤔🤥😬🤐🤢🤧😷🤒🤕😈👿👹👺💩👻💀☠️👽👾🤖🎃😺😸😹😻😼😽🙀😿😾👐🙌👏🙏🤝👍👎👊✊🤛🤜🤞✌️🤘👌👈👉👆👇☝️✋🤚🖐🖖👋🤙💪🖕✍️🤳💅🖖💄💋👄👅👂👃👣👁👀',
      :nature => '🐶🐱🐭🐹🐰🦊🐻🐼🐨🐯🦁🐮🐷🐽🐸🐵🙊🙉🙊🐒🐔🐧🐦🐤🐣🐥🦆🦅🦉🦇🐺🐗🐴🦄🐝🐛🦋🐌🐚🐞🐜🕷🕸🐢🐍🦎🦂🦀🦑🐙🦐🐠🐟🐡🐬🦈🐳🐋🐊🐆🐅🐃🐂🐄🦌🐪🐫🐘🦏🦍🐎🐖🐐🐏🐑🐕🐩🐈🐓🦃🕊🐇🐁🐀🐿🐾🐉🐲🌵🎄🌲🌳🌴🌱🌿☘️🍀🎍🎋🍃🍂🍁🍄🌾💐🌷🌹🥀🌻🌼🌸🌺🌎🌍🌏🌕🌖🌗🌘🌑🌒🌓🌔🌚🌝🌞🌛🌜🌙💫⭐️🌟✨⚡️🔥💥☄️☀️🌤⛅️🌥🌦🌈☁️🌧⛈🌩🌨☃️⛄️❄️🌬💨🌪🌫🌊💧💦☔️',
      :food => '🍏🍎🍐🍊🍋🍌🍉🍇🍓🍈🍒🍑🍍🥝🥑🍅🍆🥒🥕🌽🌶🥔🍠🌰🥜🍯🥐🍞🥖🧀🥚🍳🥓🥞🍤🍗🍖🍕🌭🍔🍟🥙🌮🌯🥗🥘🍝🍜🍲🍥🍣🍱🍛🍚🍙🍘🍢🍡🍧🍨🍦🍰🎂🍮🍭🍬🍫🍿🍩🍪🥛🍼☕️🍵🍶🍺🍻🥂🍷🥃🍸🍹🍾🥄🍴🍽',
      :games => '⚽️🏀🏈⚾️🎾🏐🏉🎱🏓🏸🥅🏒🏑🏏⛳️🏹🎣🥊🥋⛸🎿⛷🏂🚵🎽🏅🎖🥇🥈🥉🏆🏵🎗🎫🎟🎭🎨🎬🎤🎧🎼🎹🥁🎷🎺🎸🎻🎲🎯🎳🎮🎰',
      :tech => '️📱📲💻⌨️🖥🖨🖱🖲🕹🗜💽💾💿📀📼📷📸📹🎥📽🎞📞☎️📟📠📺📻🎙🎚🎛⏱⏲⏰🕰⌛️⏳📡🔋🔌💡🔦🕯🗑🛢💸💵💴💶💷💰💳💎⚖️🔧🔨⚒🛠⛏🔩⚙️⛓🔫💣🔪🗡⚔️🛡🚬⚰️⚱️🏺🔮📿💈⚗️🔭🔬🕳💊💉🌡🚽🚰🚿🛁🛀🛎🔑🗝🚪🛋🛏🛌🖼🛍🛒🎁🎈🎏🎀🎊🎉🎎🏮🎐✉️📩📨📧💌📥📤📦🏷📪📫📬📭📮📯📜📃📄📑📊📈📉🗒🗓📆📅📇🗃🗳🗄📋📁📂🗂🗞📰📓📔📒📕📗📘📙📚📖🔖🔗📎🖇📐📏📌📍📌🎌🏳️🏴🏁🏳️‍🌈✂️🖊🖋✒️🖌🖍📝✏️🔍🔎🔏🔐🔒🔓',
      :symbols => '❤️💛💚💙💜🖤💔❣️💕💞💓💗💖💘💝💟☮️✝️☪️🕉☸️✡️🔯🕎☯️☢️☣️🆘❌⭕️🚫💯💢♨️🚷🔰♻️✅❇️✳️❎🌐💠🌀💤🏧🚾♿️🅿🔃🎵🎶➕➖➗✖️💲✔️☑️🔘⚪️⚫️🔴'
  }

  #--------------------------------------------------------------------------
  # * restituisce tutti i caratteri emoji
  # @return [String]
  #--------------------------------------------------------------------------
  def self.all_chars; EMOJIS.values.join; end
  #--------------------------------------------------------------------------
  # * true se è un carattere emoji.
  #--------------------------------------------------------------------------
  def self.has?(emoji_char); all_chars.include?(emoji_char); end
  #--------------------------------------------------------------------------
  # * restituisce il carattere emoji selezionato
  #--------------------------------------------------------------------------
  def self.get(emoji_char); LIST[emoji_char]; end
  #--------------------------------------------------------------------------
  # * restituisce tutti i caratteri emoji
  #--------------------------------------------------------------------------
  def self.chars; EMOJIS.values; end
  #--------------------------------------------------------------------------
  # * Restituisce le emoji in Array<Emojie>
  #--------------------------------------------------------------------------
  def self.elements
    return @elements if @elements != nil
    @elements = []
    EMOJIS.each_pair{|type, string|
      (0..string.size).each{|i|
        @elements.push(Emojie.new(string[i], type, i))
      }
    }
    return @elements
  end
end

#==============================================================================
# ** Emojie
#------------------------------------------------------------------------------
#  Classe che contiene i dati di una Emoji
#==============================================================================
class Emojie
  attr_reader :char   # carattere unicode
  attr_reader :icon   # icona del gioco
  attr_reader :type   # tipo emoji
  #--------------------------------------------------------------------------
  # * Inizializzazione
  #   char:       carattere
  #   icon_index: id icona
  #--------------------------------------------------------------------------
  def initialize(char, type, icon_index)
    @char = char
    @icon = icon_index
    @type = type
  end
end

class Tone
  # creates a tone from a color
  # @return [Tone]
  # @param [Color] color
  def self.from_color(color)
    Tone.new(color.red, color.green, color.blue)
  end
end

#==============================================================================
# ** Color
#------------------------------------------------------------------------------
# Aggiunta dei colori statici
#==============================================================================
class Color
  alias rgba_initialize initialize unless $@

  # * Inizializzazione con l'aggiunta di valore esadecimale
  # @param [Object] args R,G,B,A o hex string
  def initialize(*args)
    if args[0].is_a?(String)
      hex_initialize(*args)
    else
      rgba_initialize(*args)
    end
  end
  #--------------------------------------------------------------------------
  # * Inizializzazione esadecimale
  #--------------------------------------------------------------------------
  def hex_initialize(hex, opacity = 255)
    if hex =~ /^#([A-Fa-f0-9]{2})([A-Fa-f0-9]{2})([A-Fa-f0-9]{2})$/
      red = $1.to_i(16)
      green = $2.to_i(16)
      blue = $3.to_i(16)
      rgba_initialize(red, green, blue, opacity)
    else
      raise HexErrorFormatColorException.new('Errore: Stringa esadecimale non corretta')
    end
  end

  # restituisce il colore deopacizzato
  # @param [Integer] alpha nuova trasparenza
  # @return [Color]
  def deopacize(alpha = 128)
    self.alpha = alpha
    self
  end
  #--------------------------------------------------------------------------
  # * Costanti che restituiscono colori CSS
  #--------------------------------------------------------------------------
  ALICEBLUE             = Color.new('#F0F8FF')
  ANTIQUEWHITE          = Color.new('#FAEBD7')
  AQUA                  = Color.new('#00FFFF')
  AQUAMARINE            = Color.new('#7FFFD4')
  AZURE                 = Color.new('#F0FFFF')
  BEIGE                 = Color.new('#F5F5DC')
  BISQUE                = Color.new('#FFE4C4')
  BLACK                 = Color.new(0,0,0,255)
  BLUE                  = Color.new(0,0,255,255)
  BLUEVIOLET            = Color.new('#8A2BE2')
  BROWN                 = Color.new('#A52A2A')
  BURLYWOOD             = Color.new('#DEB887')
  CADETBLUE             = Color.new('#5F9EA0')
  CHARTREUSE            = Color.new('#7FFF00')
  CHOCOLATE             = Color.new('#D2691E')
  CORAL                 = Color.new('#FF7F50')
  CORNFLOWER_BLUE       = Color.new('#6495ED')
  CORNSILK              = Color.new('#FFF8DC')
  CRIMSON               = Color.new('#DC143C')
  CYAN                  = Color.new('#00FFFF')
  DARKBLUE              = Color.new('#00008B')
  DARKCYAN              = Color.new('#008B8B')
  DARKGOLDENROD         = Color.new('#B8860B')
  DARKGRAY              = Color.new('#A9A9A9')
  DARKGREY              = Color.new('#A9A9A9')
  DARKGREEN             = Color.new('#006400')
  DARKKHAKI             = Color.new('#BDB76B')
  DARKMAGENTA           = Color.new('#8B008B')
  DARKOLIVEGREEN        = Color.new('#556B2F')
  DARKORANGE            = Color.new('#FF8C00')
  DARKORCHID            = Color.new('#9932CC')
  DARKRED               = Color.new('#8B0000')
  DARKSALMON            = Color.new('#E9967A')
  DARKSEAGREEN          = Color.new('#8FBC8F')
  DARKSLATEBLUE         = Color.new('#483D8B')
  DARKSLATEGRAY         = Color.new('#2F4F4F')
  DARKSLATEGREY         = Color.new('#2F4F4F')
  DARKTURQUOISE         = Color.new('#00CED1')
  DARKVIOLET            = Color.new('#9400D3')
  DEEPPINK              = Color.new('#FF1493')
  DEEPSKYBLUE           = Color.new('#00BFFF')
  DIMGRAY               = Color.new('#696969')
  DIMGREY               = Color.new('#696969')
  DODGERBLUE            = Color.new('#1E90FF')
  FIREBRICK             = Color.new('#B22222')
  FLORALWHITE           = Color.new('#FFFAF0')
  FORESTGREEN           = Color.new('#228B22')
  FUCHSIA               = Color.new('#FF00FF')
  GAINSBORO             = Color.new('#DCDCDC')
  GHOSTWHITE            = Color.new('#F8F8FF')
  GOLD                  = Color.new('#FFD700')
  GOLDENROD             = Color.new('#DAA520')
  GRAY                  = Color.new('#808080')
  GREY                  = Color.new('#808080')
  GREEN                 = Color.new('#008000')
  GREENYELLOW           = Color.new('#ADFF2F')
  HONEYDEW              = Color.new('#F0FFF0')
  HOTPINK               = Color.new('#FF69B4')
  INDIANRED             = Color.new('#CD5C5C')
  INDIGO                = Color.new('#4B0082')
  IVORY                 = Color.new('#FFFFF0')
  KHAKI                 = Color.new('#F0E68C')
  LAVENDER              = Color.new('#E6E6FA')
  LAVENDERBLUSH         = Color.new('#FFF0F5')
  LAWNGREEN             = Color.new('#7CFC00')
  LEMONCHIFFON          = Color.new('#FFFACD')
  LIGHTBLUE             = Color.new('#ADD8E6')
  LIGHTCORAL            = Color.new('#F08080')
  LIGHTCYAN             = Color.new('#E0FFFF')
  LIGHTGOLDENRODYELLOW  = Color.new('#FAFAD2')
  LIGHTGRAY             = Color.new('#D3D3D3')
  LIGHTGREY             = Color.new('#D3D3D3')
  LIGHTGREEN            = Color.new('#90EE90')
  LIGHTPINK             = Color.new('#FFB6C1')
  LIGHTSALMON           = Color.new('#FFA07A')
  LIGHTSEAGREEN         = Color.new('#20B2AA')
  LIGHTSKYBLUE          = Color.new('#87CEFA')
  LIGHTSLATEGRAY        = Color.new('#778899')
  LIGHTSLATEGREY        = Color.new('#778899')
  LIGHTSTEELBLUE        = Color.new('#B0C4DE')
  LIGHTYELLOW           = Color.new('#FFFFE0')
  LIME                  = Color.new('#00FF00')
  LIMEGREEN             = Color.new('#32CD32')
  LINEN                 = Color.new('#FAF0E6')
  MAGENTA               = Color.new('#FF00FF')
  MAROON                = Color.new('#800000')
  MEDIUMAQUAMARINE      = Color.new('#66CDAA')
  MEDIUMBLUE            = Color.new('#0000CD')
  MEDIUMORCHID          = Color.new('#BA55D3')
  MEDIUMPURPLE          = Color.new('#9370D8')
  MEDIUMSEAGREEN        = Color.new('#3CB371')
  MEDIUMSLATEBLUE       = Color.new('#7B68EE')
  MEDIUMSPRINGGREEN     = Color.new('#00FA9A')
  MEDIUMTURQUOISE       = Color.new('#48D1CC')
  MEDIUMVIOLETRED       = Color.new('#C71585')
  MIDNIGHTBLUE          = Color.new('#191970')
  MINTCREAM             = Color.new('#F5FFFA')
  MISTYROSE             = Color.new('#FFE4E1')
  MOCCASIN              = Color.new('#FFE4B5')
  NAVAJOWHITE           = Color.new('#FFDEAD')
  NAVY                  = Color.new('#000080')
  OLDLACE               = Color.new('#FDF5E6')
  OLIVE                 = Color.new('#808000')
  OLIVEDRAB             = Color.new('#6B8E23')
  ORANGE                = Color.new('#FFA500')
  ORANGERED             = Color.new('#FF4500')
  ORCHID                = Color.new('#DA70D6')
  PALEGOLDENROD         = Color.new('#EEE8AA')
  PALEGREEN             = Color.new('#98FB98')
  PALETURQUOISE         = Color.new('#AFEEEE')
  PALEVIOLETRED         = Color.new('#D87093')
  PAPAYAWHIP            = Color.new('#FFEFD5')
  PEACHPUFF             = Color.new('#FFDAB9')
  PERU                  = Color.new('#CD853F')
  PINK                  = Color.new('#FFC0CB')
  PLUM                  = Color.new('#DDA0DD')
  POWDERBLUE            = Color.new('#B0E0E6')
  PURPLE                = Color.new('#800080')
  RED                   = Color.new('#FF0000')
  ROSYBROWN             = Color.new('#BC8F8F')
  ROYALBLUE             = Color.new('#4169E1')
  SADDLEBROWN           = Color.new('#8B4513')
  SALMON                = Color.new('#FA8072')
  SANDYBROWN            = Color.new('#F4A460')
  SEAGREEN              = Color.new('#2E8B57')
  SEASHELL              = Color.new('#FFF5EE')
  SIENNA                = Color.new('#A0522D')
  SILVER                = Color.new('#C0C0C0')
  SKYBLUE               = Color.new('#87CEEB')
  SLATEBLUE             = Color.new('#6A5ACD')
  SLATEGRAY             = Color.new('#708090')
  SLATEGREY             = Color.new('#708090')
  SNOW                  = Color.new('#FFFAFA')
  SPRINGGREEN           = Color.new('#00FF7F')
  STEELBLUE             = Color.new('#4682B4')
  TAN                   = Color.new('#D2B48C')
  TEAL                  = Color.new('#008080')
  THISTLE               = Color.new('#D8BFD8')
  TOMATO                = Color.new('#FF6347')
  TURQUOISE             = Color.new('#40E0D0')
  VIOLET                = Color.new('#EE82EE')
  WHEAT                 = Color.new('#F5DEB3')
  WHITE                 = Color.new('#FFFFFF')
  WHITESMOKE            = Color.new('#F5F5F5')
  YELLOW                = Color.new('#FFFF00')
  YELLOWGREEN           = Color.new('#9ACD32')
end

#==============================================================================
# ** TooMuchTextEception
#------------------------------------------------------------------------------
#  Eccezione generata artificialmente
#==============================================================================
class TooMuchTextEception < Exception; end
class HexErrorFormatColorException < Exception; end
#fine dello script