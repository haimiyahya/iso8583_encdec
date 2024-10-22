defmodule Iso8583EncdecTest do
  use ExUnit.Case
  doctest Iso8583Encdec
  alias BitmapBinaryHeaderBcd, as: Iso8583Parser

  test "parse f63 and f64" do
    bmp = "0000000020000003"
    f35 = "35123456789012345678901234567890123450"
    f63 = "06123456"
    f64 = "35363738"

    msg = bmp <> f35 <> f63 <> f64

    msg = Base.decode16!(msg)
    parsed_msg = Iso8583Parser.parse_msg(msg)

    assert Map.has_key?(parsed_msg, 63)
    assert Map.get(parsed_msg, 63) == "12"

    assert Map.has_key?(parsed_msg, 64)
    assert Map.get(parsed_msg, 64) == "5678"

    IO.inspect(parsed_msg)

  end
end


defmodule BitmapBinaryHeaderBcd do
  use Iso8583Dec, header_encoding: :bcd,
    numeric_encoding: :bcd,
    bitmap_format: :bin

  define(35, "z.. 39")
  define(63, "n.. 2")
  define(64, "an 4")

end
