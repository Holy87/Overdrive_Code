require File.expand_path('rm_vx_data')

module Script_Updater
  AUTO_DOWNLOAD = false
  # 0: cartella del progetto
  # 1: desktop
  DOWNLOAD_PATH = 0

  HOST = 'http://holyres.altervista.org/rpgm/script_check.php'
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def self.add_script(script_name, version)
    @scripts ||= []
    @scripts.push(Script_Info.new(script_name, version))
  end
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def self.check_for_updates
    request = {data: prepare_request}
    result = submit_post_request(HOST, request)
    handle_result(result)
  end
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def self.handle_result(result)
    if result =~ /\{"scripts":[ ]*(.+)]}/
      show_updated_scripts($1.split(/\{.*\},/))
    else
      puts 'Script Updater: Errore di connessione al server'
    end
  end
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def self.show_updated_scripts(scripts_data)
    if scripts_data.size > 0
      update_script_data(scripts_data)
      @scripts.each {|script| handle_script(script)}
    else
      puts 'Tutti gli script sono aggiornati.'
    end
  end

  def self.update_script_data(scripts_data)
    scripts_data.each{|data|
      if data =~ /\{"name":[ ]*"(.+),[ ]*"version":"(.+)",[ ]*"path":[ ]*"(.+)"\}/i
        script = @scripts.find{|scr| scr.name == $1}
        return if script.nil?
        script.new_version = $2
        script.new_path = $3 if $3 != ''
      end
    }
  end
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  # @param [Script_Info] script
  def self.handle_script(script)
    return if script.up_to_date?
    string = '* script %s: nuova versione disponibile (v.%s)'
    puts sprintf(string, script.name, script.new_version.to_s)
    if can_download?(script)
      HTTP.download(script.new_path, download_path, script.filename)
      loop{break if HTTP.downloaded?(script.filename)}
      puts "Scaricato in #{File.expand_path(download_path)}#{script.filename}"
    end
  end

  def self.download_path
    case DOWNLOAD_PATH
      when 0
        return './'
      when 1
        return Win.get_folder_path(:dskt) + '/'
      else
        return './'
    end
  end

  # @param [Script_Info] script
  def self.can_download?(script)
    return false unless AUTO_DOWNLOAD
    return false if File.exist?(script.filename)
    return false if script.new_path.nil? or script.new_path == ''
    true
  end
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def self.prepare_request
    request = '{"scripts": ['
    request << items_array * ','
    request << ']}'
    request
  end
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def items_array
    string = '{"name":"%s","version":"%s"}'
    @scripts.collect{|script| sprintf(string, script.name, script.version.to_s)}
  end
end

class Script_Info
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  # @param [String] name
  # @param [String] version
  def initialize(name, version)
    @name = name
    @version = Game_Version.new(version)
  end
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  # @return [String]
  def name; @name; end
  #--------------------------------------------------------------------------
  # *
  # @return [Game_Version]
  #--------------------------------------------------------------------------
  def version; @version; end
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def new_version=(version)
    @new_version = Game_Version.new(version)
  end
  #--------------------------------------------------------------------------
  # *
  # @return [Game_Version]
  #--------------------------------------------------------------------------
  def new_version; @new_version; end
  #--------------------------------------------------------------------------
  # *
  # @return [Boolean]
  #--------------------------------------------------------------------------
  def up_to_date?; @version >= @new_version; end
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def new_path=(path); @new_path = path; end
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def new_path; @new_path; end
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def filename
    sprintf('%s_%s.rb', self.name, self.new_version.to_s)
  end
end