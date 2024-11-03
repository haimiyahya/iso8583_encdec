defmodule Iso8583FormBitmapAndHead0Test do
  use ExUnit.Case

  test "build z header 0 test 1" do
    fields = %{35 => "1234567890123456"}
    msg_val = BitmapBinHeader0_Iso8583FormBitmapAndHead0Test.build_msg(fields)

    assert msg_val == <<0::34, 1::1, 0::29>> <> "123456789012345600000000000000000000000"
  end

  test "build z header 0 test 2" do
    fields = %{35 => "12345678901234567890"}
    msg_val = BitmapBinHeader0_Iso8583FormBitmapAndHead0Test.build_msg(fields)

    assert msg_val == <<0::34, 1::1, 0::29>> <> "123456789012345678900000000000000000000"
  end

  test "build z header 0 test 3" do
    fields = %{35 => "1234567890123456789012345678901234567890"}
    msg_val = BitmapBinHeader0_Iso8583FormBitmapAndHead0Test.build_msg(fields)

    assert msg_val == <<0::34, 1::1, 0::29>> <> "123456789012345678901234567890123456789"
  end

  test "build n header 0 test 1" do
    fields = %{63 => "1234567890123456789012345678901234567890123456789012345"}
    msg_val = BitmapBinHeader0_Iso8583FormBitmapAndHead0Test.build_msg(fields)

    assert msg_val == <<0::62, 1::1, 0::1>> <> "123456789012345678901234567890123456789012345678901234500000000000000000000000000000000000000000000"
  end

  test "build n header 0 test 2" do
    fields = %{63 => "12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890"}
    msg_val = BitmapBinHeader0_Iso8583FormBitmapAndHead0Test.build_msg(fields)

    assert msg_val == <<0::62, 1::1, 0::1>> <> "123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789"
  end

  test "build an header 0 test 1" do
    fields = %{64 => "1234567890123456"}
    msg_val = BitmapBinHeader0_Iso8583FormBitmapAndHead0Test.build_msg(fields)

    assert msg_val == <<0::63, 1::1>> <> "1234567890123456                    "
  end

  test "build an header 0 test 2" do
    fields = %{64 => "12345678901234567890123456"}
    msg_val = BitmapBinHeader0_Iso8583FormBitmapAndHead0Test.build_msg(fields)

    assert msg_val == <<0::63, 1::1>> <> "12345678901234567890123456          "
  end

  test "build an header 0 test 3" do
    fields = %{64 => "123456789012345678901234567890"}
    msg_val = BitmapBinHeader0_Iso8583FormBitmapAndHead0Test.build_msg(fields)

    assert msg_val == <<0::63, 1::1>> <> "123456789012345678901234567890      "
  end

  test "build an header 0 test 4" do
    fields = %{64 => "1234567890123456789012345678901234567890"}
    msg_val = BitmapBinHeader0_Iso8583FormBitmapAndHead0Test.build_msg(fields)

    assert msg_val == <<0::63, 1::1>> <> "123456789012345678901234567890123456"
  end

end

defmodule BitmapBinHeader0_Iso8583FormBitmapAndHead0Test do
  use Iso8583Dec, header_encoding: :ascii,
    default_encoding: :ascii,
    bitmap_format: :bin

  define(35, "z 39")
  define(63, "n 99")
  define(64, "an 36")

end
