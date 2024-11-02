defmodule Iso8583Form2AsciiHeaderFormMultipleFieldTest do
  use ExUnit.Case

  test "build z header 16" do
    fields = %{35 => "1234567890123456"}
    msg_val = BitmapBinHeader2Ascii_MixedDataType_FormMultipleField.build_msg(fields)

    IO.inspect(msg_val)
    assert msg_val == <<0::34, 1::1, 0::29>> <> "161234567890123456"
  end



end

defmodule BitmapBinHeader2Ascii_MixedDataType_FormMultipleField do
  use Iso8583Dec, header_encoding: :ascii,
    default_encoding: :ascii,
    bitmap_format: :bin

  define(35, "z.. 39")
  define(63, "n.. 99")
  define(64, "an.. 36")

end
