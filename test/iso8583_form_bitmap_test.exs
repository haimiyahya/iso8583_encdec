defmodule Iso8583FormBitmapTest do
  use ExUnit.Case

  test "build binary bitmap with field 2, 3 and 4" do
    fields = %{2 => "123", 3 => "456", 4 => "567"}
    bitmap_val = BitmapBinHeader2Bcd_BitmapTest1.build_bitmap(fields, 0)

    IO.inspect bitmap_val
  end

end

defmodule BitmapBinHeader2Bcd_BitmapTest1 do
  use Iso8583Dec, header_encoding: :bcd,
    default_encoding: :bcd,
    bitmap_format: :bin

  define(2, "n 6")
  define(3, "n 6")
  define(4, "n 6")

end
