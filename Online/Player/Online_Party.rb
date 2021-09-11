class Online_Party
  # @return [Array<Online_Actor>]
  attr_reader :actors

  def initialize(data)
    json_party = base64_decode data
    party = JSON.decode json_party
    @actors = party.map{ |member_data| Online_Actor.new(member_data) }
  end
end

class Online_Actor < Game_Actor

  def setup(data)
    actor_id = data['id']
    super(actor_id)
    @level = data['level']
    @maxhp_plus = data['mhp_p']
    @maxmp_plus = data['mmp_p']
    @atk_plus = data['atk_p']
    @def_plus = data['def_p']
    @spi_plus = data['spi_p']
    @agi_plus = data['agi_p']
    @skills = data['skills']
    @learned_passives = data['passives']
    @weapon_id = data['weapons'].first
    @equip_type = data['equip_types'].map{|t|t.to_sym}
    recover_all
  end
end