$imported = {} if $imported == nil
$imported["H87_Homesave"] = 2.0
#===============================================================================
# MYDOCUMENTS SAVING
#===============================================================================
# Author: Holy87
# Version: 2.0
# User difficulty: ★
#-------------------------------------------------------------------------------
# This script changes the savegames path: not in the game root anymore, but
# in C:\Users\Username\MyDocuments\GameTitle\Saves or
# in C:\Users\Username\MyDocuments\My Games\GameTitle\Saves or
# in C:\Users\Username\Saved Games\GameTitle\Saves
# Not only this script will make your game more professional, but will allow
# you to install the game in different paths having the saves in the same
# folder. You could also share the project in a CD disk and can play to your
# frients without installing anithyng on the PC.
#-------------------------------------------------------------------------------
# Instructions:
# Install this script under Materials and above the Main. 
# IMPORTANT: REQUIRES HOLY87 UNIVERSAL MODULE.
#-------------------------------------------------------------------------------
# Compatibility:
# DataManager: alias methos
#   settings_path
#   save_file_exists?
#   make_filename
#-------------------------------------------------------------------------------

#==============================================================================
# ** SETTINGS
#==============================================================================
module Homesave
  # choose where the game saves location is
  # saved_games: C:\Users\user\Saved Games\Project Name\Saves
  # my_documents: C:\Users\user\Documents\Project Name\Saves
  # my_games: C:\Users\user\Documents\My Games\Project Name\Saves
  SAVES_HOME = :saved_games

  # the saves folder name
  SAVES_FOLDER = "Salvataggi" #change this string for saves folder
end

#==============================================================================
# ** Homesave
#------------------------------------------------------------------------------
#  This is the core of the script.
#==============================================================================
module Homesave
  # returns the complete path for save files
  # ex. C:/Users/user/Documents/Game/Saves
  # @return [String]
  def self.saves_path
    path = project_data_directory + '/' + saves_directory
    Dir.mkdir(path) unless File.directory?(path)
    path
  end

  # Returns the game folder name
  # @return [String]
  def self.game_directory_name
    load_data("Data/System.rvdata2").game_title
  end

  # returns the main project data directory (if you want to
  # add more directories it should be useful to call this
  # instead of the save, for ex. mods)
  # @return [String]
  def self.project_data_directory
    case SAVES_HOME
    when :my_documents
      fpath = Win.get_folder_path(:docs)
    when :saved_games
      fpath = Win.saved_games_folder
    when :my_games
      fpath = Win.get_folder_path(:docs) + '/My Games'
    else
      fpath = '.'
    end
    Dir.mkdir(fpath) unless File.directory?(fpath)
    fpath << '/' + game_directory_name
    Dir.mkdir(fpath) unless File.directory?(fpath)
    fpath
  end

  # Returns the Saves folder name
  # @return [String]
  def self.saves_directory
    SAVES_FOLDER
  end

  # @return [String]
  # @deprecated use saves_path
  def self.folder_path
    saves_path
  end
end #homesave

#==============================================================================
# ** DataManager
#------------------------------------------------------------------------------
#  Path editing
#==============================================================================
module DataManager
  class << self
    alias sett_filename settings_path #alias method settings_path (supp)
    alias exst_filename save_file_exists? #alias method save_file_exists?
    alias save_filename make_filename #alias method make_filename
  end

  # Changes the game_settings path (universal module)
  def self.settings_path
    Homesave.saves_path + "/" + sett_filename
  end

  # Changes the path where saves are checked
  def self.save_file_exists?
    temp = Dir.pwd
    Dir.chdir(Homesave.saves_path)
    exist = exst_filename
    Dir.chdir(temp)
    return exist
  end

  # changes the saves path
  def self.make_filename(index)
    Homesave.saves_path + "/" + save_filename(index)
  end
end #DataManager