defmodule Iso8583FormAsciiBitmapAndHead0Test do
  use ExUnit.Case

  test "build z header 0 test 1" do
    fields = %{35 => "1234567890123456"}
    msg_val = BitmapAsciiHeader0_Iso8583FormBitmapAndHead0Test.build_msg(fields)

    bitmap = <<0::34, 1::1, 0::29>>
    bitmap_ascii = Base.encode16(bitmap)

    assert msg_val == bitmap_ascii <> "123456789012345600000000000000000000000"
  end

  test "build z header 0 test 2" do
    fields = %{35 => "12345678901234567890"}
    msg_val = BitmapAsciiHeader0_Iso8583FormBitmapAndHead0Test.build_msg(fields)

    bitmap = <<0::34, 1::1, 0::29>>
    bitmap_ascii = Base.encode16(bitmap)

    assert msg_val == bitmap_ascii <> "123456789012345678900000000000000000000"
  end

  test "build z header 0 test 3" do
    fields = %{35 => "1234567890123456789012345678901234567890"}
    msg_val = BitmapAsciiHeader0_Iso8583FormBitmapAndHead0Test.build_msg(fields)

    bitmap = <<0::34, 1::1, 0::29>>
    bitmap_ascii = Base.encode16(bitmap)

    assert msg_val == bitmap_ascii <> "123456789012345678901234567890123456789"
  end

  test "build n header 0 test 1" do
    fields = %{63 => "1234567890123456789012345678901234567890123456789012345"}
    msg_val = BitmapAsciiHeader0_Iso8583FormBitmapAndHead0Test.build_msg(fields)

    bitmap = <<0::62, 1::1, 0::1>>
    bitmap_ascii = Base.encode16(bitmap)

    assert msg_val == bitmap_ascii <> "123456789012345678901234567890123456789012345678901234500000000000000000000000000000000000000000000"
  end

  test "build n header 0 test 2" do
    fields = %{63 => "12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890"}
    msg_val = BitmapAsciiHeader0_Iso8583FormBitmapAndHead0Test.build_msg(fields)

    bitmap = <<0::62, 1::1, 0::1>>
    bitmap_ascii = Base.encode16(bitmap)

    assert msg_val == bitmap_ascii <> "123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789"
  end

  test "build an header 0 test 1" do
    fields = %{64 => "1234567890123456"}
    msg_val = BitmapAsciiHeader0_Iso8583FormBitmapAndHead0Test.build_msg(fields)

    bitmap = <<0::63, 1::1>>
    bitmap_ascii = Base.encode16(bitmap)

    assert msg_val == bitmap_ascii <> "1234567890123456                    "
  end

  test "build an header 0 test 2" do
    fields = %{64 => "12345678901234567890123456"}
    msg_val = BitmapAsciiHeader0_Iso8583FormBitmapAndHead0Test.build_msg(fields)

    bitmap = <<0::63, 1::1>>
    bitmap_ascii = Base.encode16(bitmap)

    assert msg_val == bitmap_ascii <> "12345678901234567890123456          "
  end

  test "build an header 0 test 3" do
    fields = %{64 => "123456789012345678901234567890"}
    msg_val = BitmapAsciiHeader0_Iso8583FormBitmapAndHead0Test.build_msg(fields)

    bitmap = <<0::63, 1::1>>
    bitmap_ascii = Base.encode16(bitmap)

    assert msg_val == bitmap_ascii <> "123456789012345678901234567890      "
  end

  test "build an header 0 test 4" do
    fields = %{64 => "1234567890123456789012345678901234567890"}
    msg_val = BitmapAsciiHeader0_Iso8583FormBitmapAndHead0Test.build_msg(fields)

    bitmap = <<0::63, 1::1>>
    bitmap_ascii = Base.encode16(bitmap)

    assert msg_val == bitmap_ascii <> "123456789012345678901234567890123456"
  end

end

defmodule BitmapAsciiHeader0_Iso8583FormBitmapAndHead0Test do
  use Iso8583Dec, header_encoding: :ascii,
    default_encoding: :ascii,
    bitmap_format: :ascii

  define(35, "z 39")
  define(63, "n 99")
  define(64, "an 36")

end
