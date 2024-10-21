defmodule Iso8583EncdecTest do
  use ExUnit.Case
  doctest Iso8583Encdec
  alias BitmapBinaryHeaderBcd, as: Iso8583Parser

  test "parse f63 and f64" do
    bmp = "0000000000000003"
    msg = "0612345631323334"
    IO.inspect String.length(bmp)

    msg = bmp <> msg

    msg = Base.decode16!(msg)
    IO.inspect msg
    IO.inspect Iso8583Parser.parse_msg(msg)
  end
end


defmodule BitmapBinaryHeaderBcd do
  use Iso8583Dec, header_encoding: :bcd,
    bitmap_format: :bin

  define(63, "n.. 6")
  define(64, "an 4")

end
