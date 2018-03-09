#===============================================================================
# ** My_Class
#-------------------------------------------------------------------------------
# TODO: Insert a description here
#===============================================================================
require 'lib/main' if false # you can delete this when the scirpt is complete

class My_Class


# @param [Array<Game_Actor>] gruppo
# @param [String] nome_eroe
# @return [Game_Actor]
def trova_eroe(gruppo, nome_eroe)
  gruppo.find{|actor| actor.name == nome_eroe}
end

end

clas = My_Class.new
clas.trova_eroe($game_party, 'ciao')

fiber = Fiber.new do |value|
  loop {
    Fiber.yield value * 2
  }
end

print fiber.resume(10) #=> 20