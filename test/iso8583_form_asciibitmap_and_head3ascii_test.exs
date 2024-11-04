defmodule Iso8583FormAsciiBitmapAndHead3AsciiTest do
  use ExUnit.Case

  test "build z header 16" do
    fields = %{35 => "1234567890123456"}
    msg_val = BitmapAsciiHeader3Ascii_Iso8583FormBitmapAndHead3AsciiTest.build_msg(fields)

    bitmap = <<0::34, 1::1, 0::29>>
    bitmap_ascii = Base.encode16(bitmap)

    assert msg_val == bitmap_ascii <> "0161234567890123456"
  end

  test "build z header 20" do
    fields = %{35 => "12345678901234567890"}
    msg_val = BitmapAsciiHeader3Ascii_Iso8583FormBitmapAndHead3AsciiTest.build_msg(fields)

    bitmap = <<0::34, 1::1, 0::29>>
    bitmap_ascii = Base.encode16(bitmap)

    assert msg_val == bitmap_ascii <> "02012345678901234567890"
  end

  test "build z header 40" do
    fields = %{35 => "1234567890123456789012345678901234567890"}
    msg_val = BitmapAsciiHeader3Ascii_Iso8583FormBitmapAndHead3AsciiTest.build_msg(fields)

    bitmap = <<0::34, 1::1, 0::29>>
    bitmap_ascii = Base.encode16(bitmap)

    assert msg_val == bitmap_ascii <> "039123456789012345678901234567890123456789"
  end

  test "build n header 55" do
    fields = %{63 => "1234567890123456789012345678901234567890123456789012345"}
    msg_val = BitmapAsciiHeader3Ascii_Iso8583FormBitmapAndHead3AsciiTest.build_msg(fields)

    bitmap = <<0::62, 1::1, 0::1>>
    bitmap_ascii = Base.encode16(bitmap)

    assert msg_val == bitmap_ascii <> "0551234567890123456789012345678901234567890123456789012345"
  end

  test "build n header 99" do
    fields = %{63 => "12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890"}
    msg_val = BitmapAsciiHeader3Ascii_Iso8583FormBitmapAndHead3AsciiTest.build_msg(fields)

    bitmap = <<0::62, 1::1, 0::1>>
    bitmap_ascii = Base.encode16(bitmap)

    assert msg_val == bitmap_ascii <> "099123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789"
  end

  test "build an header 16" do
    fields = %{64 => "1234567890123456"}
    msg_val = BitmapAsciiHeader3Ascii_Iso8583FormBitmapAndHead3AsciiTest.build_msg(fields)

    bitmap = <<0::63, 1::1>>
    bitmap_ascii = Base.encode16(bitmap)

    assert msg_val == bitmap_ascii <> "0161234567890123456"
  end

  test "build an header 26" do
    fields = %{64 => "12345678901234567890123456"}
    msg_val = BitmapAsciiHeader3Ascii_Iso8583FormBitmapAndHead3AsciiTest.build_msg(fields)

    bitmap = <<0::63, 1::1>>
    bitmap_ascii = Base.encode16(bitmap)

    assert msg_val == bitmap_ascii <> "02612345678901234567890123456"
  end

  test "build an header 30" do
    fields = %{64 => "123456789012345678901234567890"}
    msg_val = BitmapAsciiHeader3Ascii_Iso8583FormBitmapAndHead3AsciiTest.build_msg(fields)

    bitmap = <<0::63, 1::1>>
    bitmap_ascii = Base.encode16(bitmap)

    assert msg_val == bitmap_ascii <> "030123456789012345678901234567890"
  end

  test "build an header 36" do
    fields = %{64 => "1234567890123456789012345678901234567890"}
    msg_val = BitmapAsciiHeader3Ascii_Iso8583FormBitmapAndHead3AsciiTest.build_msg(fields)

    bitmap = <<0::63, 1::1>>
    bitmap_ascii = Base.encode16(bitmap)

    assert msg_val == bitmap_ascii <> "036123456789012345678901234567890123456"
  end

end

defmodule BitmapAsciiHeader3Ascii_Iso8583FormBitmapAndHead3AsciiTest do
  use Iso8583Dec, header_encoding: :ascii,
    default_encoding: :ascii,
    bitmap_format: :ascii

  define(35, "z... 39")
  define(63, "n... 99")
  define(64, "an... 36")

end
