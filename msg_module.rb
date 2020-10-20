# MSG
# Wrapper for MSG Structure
# https://docs.microsoft.com/en-us/windows/win32/api/winuser/ns-winuser-msg
class Msg
  #          HWND UINT WPARAM LPARAM DWORD POINT DWORD
  BYTESIZE = 2 +  4 +  4 +    4 +    4 +   8 +   4

  attr_accessor :window
  attr_accessor :message
  attr_accessor :w_param
  attr_accessor :l_param
  attr_accessor :time
  # @return [Array]
  attr_accessor :cursor_position

  def initialize(buffer)
    data = buffer.unpack('SLI_l_Lll')
    @window = data[0]
    @message = data[1]
    @w_param = data[2]
    @l_param = data[3]
    @time = data[4]
    @cursor_position = [data[5], data[6]]
  end
end