defmodule Iso8583Form2AsciiHeaderTest do
  use ExUnit.Case

  test "build z header 16" do
    field_val = "1234567890123456"
    field_pos = 35
    {^field_pos, hval} = BitmapBinHeader2Ascii_MixedDataType.form_header(field_pos, field_val)

    assert hval == "16"
  end

  test "build z header 20" do
    field_val = "12345678901234567890"
    field_pos = 63
    {^field_pos, hval} = BitmapBinHeader2Ascii_MixedDataType.form_header(field_pos, field_val)
    assert hval == "20"
  end

  test "build n header 6" do
    field_val = "123456"
    field_pos = 63
    {^field_pos, hval} = BitmapBinHeader2Ascii_MixedDataType.form_header(field_pos, field_val)
    assert hval == "06"
  end

  test "build n header 8" do
    field_val = "12345678"
    field_pos = 63
    {^field_pos, hval} = BitmapBinHeader2Ascii_MixedDataType.form_header(field_pos, field_val)
    assert hval == "08"
  end

  test "build n header 15" do
    field_val = "123456789012345"
    field_pos = 63
    {^field_pos, hval} = BitmapBinHeader2Ascii_MixedDataType.form_header(field_pos, field_val)
    assert hval == "15"
  end

  test "build n header 60" do
    field_val = "123456789012345678901234567890123456789012345678901234567890"
    field_pos = 63
    {^field_pos, hval} = BitmapBinHeader2Ascii_MixedDataType.form_header(field_pos, field_val)
    assert hval == "60"
  end

  test "build an header 11" do
    field_val = "12345678901"
    field_pos = 64
    {^field_pos, hval} = BitmapBinHeader2Ascii_MixedDataType.form_header(field_pos, field_val)
    assert hval == "11"
  end

  test "build an header 17" do
    field_val = "12345678901234567"
    field_pos = 64
    {^field_pos, hval} = BitmapBinHeader2Ascii_MixedDataType.form_header(field_pos, field_val)
    assert hval == "17"
  end

  test "build an header 37" do
    field_val = "12345678901234567890123456789012345"
    field_pos = 64
    {^field_pos, hval} = BitmapBinHeader2Ascii_MixedDataType.form_header(field_pos, field_val)
    assert hval == "35"
  end


end

defmodule BitmapBinHeader2Ascii_MixedDataType do
  use Iso8583EncDec, header_encoding: :ascii,
    default_encoding: :ascii,
    bitmap_format: :bin

  define(35, "z.. 39", encoding: :bcd)
  define(63, "n.. 99")
  define(64, "an.. 36")

end
