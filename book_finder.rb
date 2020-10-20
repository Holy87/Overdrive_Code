# mi serve per cercare i libri in tutto il gioco
module GameFinder
  # numero di mappe
  MAP_NUMBER = 450

  # mostra dove si trovano gli switch dei libri
  # @return [String]
  def self.find_books
    result = ''
    (462..494).each do |switch_id|
      result += sprintf("#### Switch %d - %s ####\n", switch_id, $data_system.switches[switch_id])
      result += find_switch_on switch_id
      result += "\n"
    end
    save_results(result, 'books')
  end

  def self.find_armor(armor_id)
    command = 128
    params = [armor_id, 0, 0, 1]
    msgbox pretty_results(find command, params)
  end

  def self.find_weapon(weapon_id)
    command = 127
    params = [weapon_id, 0, 0, 1]
    msgbox pretty_results(find command, params)
  end

  # @param [Integer] switch_id
  # @return [String]
  def self.find_switch_on(switch_id)
    command = 121
    params = [switch_id, switch_id, 0]
    pretty_results(find command, params)
  end

  def self.find_kora_kora
    command = 126
    params = [132, 0, 0, 1]
    save_results pretty_results(find command, params), 'kora'
  end

  # @param [Array<Array<String,Array<String>>>] results
  # @return [String]
  def self.pretty_results(results)
    str = ""
    results.each do |result_map|
      str += result_map[0]
      result_map[1].each do |result_event|
        str += "\n- " + result_event
      end
      str += "\n"
    end
    str
  end

  def self.save_results(data, name)
    file = File.open(name + '.txt', 'w')
    file.write(data)
    file.close
  end

  def self.find(command_id, params)
    maps = generate_map_data
    results = []
    maps.each do |map|
      found = fetch_map(map.events, command_id, params)
      next if found.empty?
      results.push([sprintf('[%03d], %s', map.id, map.map_name), found])
    end
    results
  end

  # @param [Array<RPG::Event>] events
  # @param [Integer] command_id
  # @param [Array] params
  # @return [Array<String>]
  def self.fetch_map(events, command_id, params)
    found = []
    events.each do |event|
      next unless fetch_event(event, command_id, params)
      found.push(sprintf('[%03d] %s', event.id, event.name))
    end
    found
  end

  # @param [RPG::Event] event
  # @param [Integer] command_id
  # @param [Array] params
  def self.fetch_event(event, command_id, params)
    event.pages.select { |page| fetch_event_page(page, command_id, params)}.any?
  end
  
  # @param [RPG::Event::Page] page
  # @param [Integer] command_id
  # @param [Array] params
  # @return [TrueClass, FalseClass]
  def self.fetch_event_page(page, command_id, params)
    page.list.select { |command| command.code == command_id and command.parameters == params}.any?
  end

  # @param [Integer] map_id
  # @return [String]
  def self.map_filename(map_id)
    sprintf("Data/Map%03d.rvdata", map_id)
  end

  # @return [Array<MapEvents_Data>]
  def self.generate_map_data
    data = []
    map_info = load_data('Data/MapInfos.rvdata')
    MAP_NUMBER.times do |map_id|
      next unless File.exist?(map_filename map_id)
      map = load_data(map_filename(map_id))
      data.push(MapEvents_Data.new(map_id, map.events.values, map_info[map_id].name))
    end
    data
  end
end

class MapEvents_Data
  # @return [Integer]
  attr_accessor :map_id
  # @return [Array<RPG::Event>]
  attr_accessor :events
  # @return [String]
  attr_accessor :map_name

  # @param [Integer] map_id
  # @param [Array<RPG::Event>] events
  # @param [String] map_name
  def initialize(map_id, events, map_name)
    @map_id = map_id
    @events = events
    @map_name = map_name
  end
end