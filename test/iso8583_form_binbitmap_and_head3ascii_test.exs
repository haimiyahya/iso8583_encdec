defmodule Iso8583FormBinBitmapAndHead3AsciiTest do
  use ExUnit.Case

  test "build z header 16" do
    fields = %{35 => "1234567890123456"}
    msg_val = BitmapBinHeader3Ascii_Iso8583FormBitmapAndHead3AsciiTest.build_msg(fields)

    assert msg_val == <<0::34, 1::1, 0::29>> <> "0161234567890123456"
  end

  test "build z header 20" do
    fields = %{35 => "12345678901234567890"}
    msg_val = BitmapBinHeader3Ascii_Iso8583FormBitmapAndHead3AsciiTest.build_msg(fields)

    assert msg_val == <<0::34, 1::1, 0::29>> <> "02012345678901234567890"
  end

  test "build z header 40" do
    fields = %{35 => "1234567890123456789012345678901234567890"}
    msg_val = BitmapBinHeader3Ascii_Iso8583FormBitmapAndHead3AsciiTest.build_msg(fields)

    assert msg_val == <<0::34, 1::1, 0::29>> <> "039123456789012345678901234567890123456789"
  end

  test "build n header 55" do
    fields = %{63 => "1234567890123456789012345678901234567890123456789012345"}
    msg_val = BitmapBinHeader3Ascii_Iso8583FormBitmapAndHead3AsciiTest.build_msg(fields)

    assert msg_val == <<0::62, 1::1, 0::1>> <> "0551234567890123456789012345678901234567890123456789012345"
  end

  test "build n header 99" do
    fields = %{63 => "12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890"}
    msg_val = BitmapBinHeader3Ascii_Iso8583FormBitmapAndHead3AsciiTest.build_msg(fields)

    assert msg_val == <<0::62, 1::1, 0::1>> <> "099123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789"
  end

  test "build an header 16" do
    fields = %{64 => "1234567890123456"}
    msg_val = BitmapBinHeader3Ascii_Iso8583FormBitmapAndHead3AsciiTest.build_msg(fields)

    assert msg_val == <<0::63, 1::1>> <> "0161234567890123456"
  end

  test "build an header 26" do
    fields = %{64 => "12345678901234567890123456"}
    msg_val = BitmapBinHeader3Ascii_Iso8583FormBitmapAndHead3AsciiTest.build_msg(fields)

    assert msg_val == <<0::63, 1::1>> <> "02612345678901234567890123456"
  end

  test "build an header 30" do
    fields = %{64 => "123456789012345678901234567890"}
    msg_val = BitmapBinHeader3Ascii_Iso8583FormBitmapAndHead3AsciiTest.build_msg(fields)

    assert msg_val == <<0::63, 1::1>> <> "030123456789012345678901234567890"
  end

  test "build an header 36" do
    fields = %{64 => "1234567890123456789012345678901234567890"}
    msg_val = BitmapBinHeader3Ascii_Iso8583FormBitmapAndHead3AsciiTest.build_msg(fields)

    assert msg_val == <<0::63, 1::1>> <> "036123456789012345678901234567890123456"
  end

end

defmodule BitmapBinHeader3Ascii_Iso8583FormBitmapAndHead3AsciiTest do
  use Iso8583EncDec, header_encoding: :ascii,
    default_encoding: :ascii,
    bitmap_format: :bin

  define(35, "z... 39")
  define(63, "n... 99")
  define(64, "an... 36")

end
