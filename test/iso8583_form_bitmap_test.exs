defmodule Iso8583FormBitmapTest do
  use ExUnit.Case

  test "build binary bitmap with field 2, 3 and 4" do
    fields = %{2 => "123", 3 => "456", 4 => "567"}
    bitmap_val = BitmapBinHeader2Bcd_BitmapTest1.build_bitmap(fields, 0)

    assert bitmap_val == <<0::1, 1::1, 1::1, 1::1, 0::1, 0::1, 0::1, 0::1, 0::56>>
  end

  test "build binary bitmap with field 2, 3, 4, 5, 6, 7, 8" do
    fields = %{2 => "123", 3 => "456", 4 => "567", 5 => "567", 6 => "567", 7 => "567", 8 => "567"}
    bitmap_val = BitmapBinHeader2Bcd_BitmapTest1.build_bitmap(fields, 0)

    assert bitmap_val == <<0::1, 1::1, 1::1, 1::1, 1::1, 1::1, 1::1, 1::1, 0::56>>
  end

  test "build binary bitmap with field 2, 3, 4, 5, 6, 7, 8, 24, 62, 63" do
    fields = %{2 => "123", 3 => "456", 4 => "567", 5 => "567", 6 => "567", 7 => "567", 8 => "567", 24 => "666", 62 => "555", 63 => "333"}
    bitmap_val = BitmapBinHeader2Bcd_BitmapTest1.build_bitmap(fields, 0)

    assert bitmap_val == <<0::1, 1::1, 1::1, 1::1, 1::1, 1::1, 1::1, 1::1, 0, 0::1, 0::1, 0::1, 0::1, 0::1, 0::1, 0::1, 1::1, 0::32, 0::1, 0::1, 0::1, 0::1, 0::1, 1::1, 1::1, 0::1>>
  end

  test "build binary bitmap with field 2, 3, 4, 5, 6, 7, 8, 24, 62, 63, 64" do
    fields = %{2 => "123", 3 => "456", 4 => "567", 5 => "567", 6 => "567", 7 => "567", 8 => "567", 24 => "666", 62 => "555", 63 => "333", 64 => "333"}
    bitmap_val = BitmapBinHeader2Bcd_BitmapTest1.build_bitmap(fields, 0)

    assert bitmap_val == <<0::1, 1::1, 1::1, 1::1, 1::1, 1::1, 1::1, 1::1, 0, 0::1, 0::1, 0::1, 0::1, 0::1, 0::1, 0::1, 1::1, 0::32, 0::1, 0::1, 0::1, 0::1, 0::1, 1::1, 1::1, 1::1>>
  end

  test "build binary bitmap with field 2, 3, 4, 5, 6, 7, 8, 24, 62, 63, 65" do
    fields = %{2 => "123", 3 => "456", 4 => "567", 5 => "567", 6 => "567", 7 => "567", 8 => "567", 24 => "666", 62 => "555", 63 => "333", 64 => "333", 65 => "111"}
    bitmap_val = BitmapBinHeader2Bcd_BitmapTest1.build_bitmap(fields, 0)

    assert bitmap_val == <<0::1, 1::1, 1::1, 1::1, 1::1, 1::1, 1::1, 1::1, 0, 0::1, 0::1, 0::1, 0::1, 0::1, 0::1, 0::1, 1::1, 0::32, 0::1, 0::1, 0::1, 0::1, 0::1, 1::1, 1::1, 1::1>>
  end

  test "build binary bitmap with field 2, 65; with first bit turned on" do
    fields = %{2 => "123", 65 => "111"}
    bitmap_val = BitmapBinHeader2Bcd_BitmapTest1.build_bitmap(fields, 1)

    assert bitmap_val == <<1::1, 1::1, 0::6, 0::56, 1::1, 0::7, 0::56>>
  end

  test "build binary bitmap with field 2, 128; with first bit turned on" do
    fields = %{2 => "123", 128 => "222"}
    bitmap_val = BitmapBinHeader2Bcd_BitmapTest1.build_bitmap(fields, 1)

    assert bitmap_val == <<1::1, 1::1, 0::6, 0::56, 0::8, 0::55, 1::1>>
  end

end

defmodule BitmapBinHeader2Bcd_BitmapTest1 do
  use Iso8583Dec, header_encoding: :bcd,
    default_encoding: :bcd,
    bitmap_format: :bin

  define(2, "n 6")
  define(3, "n 6")
  define(4, "n 6")
  define(5, "n 6")
  define(6, "n 6")
  define(7, "n 6")
  define(8, "n 6")
  define(24, "n 6")
  define(62, "n 6")
  define(63, "n 6")
  define(64, "n 6")
  define(65, "n 6")
  define(128, "n 6")

end
