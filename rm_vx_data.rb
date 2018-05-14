# librerie principali
require File.expand_path('lib/main')
# funzioni specifiche per VX
require File.expand_path('rgss2_wrapper')
# script di terzi
require File.expand_path('lib/3rd_party/yem_aggro')
require File.expand_path('lib/3rd_party/tankentai')
require File.expand_path('lib/3rd_party/turn_skills')
require File.expand_path('lib/3rd_party/y6_engine')
require File.expand_path('lib/3rd_party/kgc_largeparty')
# script miei
require File.expand_path('script_updater')
require File.expand_path('controller')
require File.expand_path('key_shower')
require File.expand_path('window_key_help')
require File.expand_path('Localization')
require File.expand_path('system.rb')
require File.expand_path('Online.rb')
require File.expand_path('element_attack')
require File.expand_path('sinergia')
require File.expand_path('support_windows')
require File.expand_path('PlayerInfo')
require File.expand_path('DialogWindow')
require File.expand_path('Options')
require File.expand_path('FaceCache.rb')
require File.expand_path('window_emoji')
require File.expand_path('equip_enchant')
require File.expand_path('yem_equip')
require File.expand_path('yem_skill')
require File.expand_path('window_enanchement')
require File.expand_path('EnhancedSprite')
require File.expand_path('smooth_movements')
require File.expand_path('bitmap')
require File.expand_path('Attributi')
require File.expand_path('item_rarity')
require File.expand_path('battle_hud')
require File.expand_path('scene_item')
require File.expand_path('item_expand')
require File.expand_path('new_equip')
require File.expand_path('achievements')
require File.expand_path('controller')
require File.expand_path('bestiary')
require File.expand_path('scene_status')
require File.expand_path('espers_core')
require File.expand_path('forge')
require File.expand_path('alchemy')

# global variables initialization
$data_items = [RPG::UsableItem.new]
$data_classes = [RPG::Class.new]
$data_animations = [RPG::Animation.new]
$data_common_events = [RPG::CommonEvent.new]
$data_mapinfos = [RPG::MapInfo.new]
$data_tilesets = [RPG::Tileset.new]
$data_actors = [RPG::Actor.new]
$data_armors = [RPG::Armor.new]
$data_weapons = [RPG::Weapon.new]
$data_actors = [RPG::Actor.new]
$data_system = RPG::System.new
$data_states = [RPG::State.new]
$data_enemies = [RPG::Enemy.new]
$game_system = Game_System.new
$game_troop = Game_Troop.new
$game_map = Game_Map.new
$game_variables = Game_Variables.new
$game_switches = Game_Switches.new
$game_timer = Game_Timer.new
$game_self_switches = []
$game_party = Game_Party.new
$game_player = Game_Player.new
$game_temp = Game_Temp.new
$game_message = Game_Message.new
$game_map = Game_Map.new
$game_actors = [Game_Actor.new(0)]
$scene = Scene_Base.new # per RPG VX classico

# noinspection RubyGlobalVariableNamingConvention
$TEST = false
# noinspection RubyGlobalVariableNamingConvention
$BTEST = false