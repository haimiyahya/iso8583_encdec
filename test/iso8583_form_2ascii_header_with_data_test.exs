defmodule Iso8583Form2AsciiHeaderWithDataTest do
  use ExUnit.Case

  test "build z header 16 with data" do
    field_val = "1234567890123456"
    field_pos = 35
    {^field_pos, hval} = BitmapBinHeader2Ascii_MixedDataType_HeaderAndBodyTest.form_header(field_pos, field_val)
    {^field_pos, body_val} = BitmapBinHeader2Ascii_MixedDataType_HeaderAndBodyTest.form_body(field_pos, field_val)
    assert hval == "16"
    field_val = hval <> body_val
    assert field_val == "161234567890123456"
  end

  test "build n header 20" do
    field_val = "12345678901234567890"
    field_pos = 63
    {^field_pos, hval} = BitmapBinHeader2Ascii_MixedDataType_HeaderAndBodyTest.form_header(field_pos, field_val)
    {^field_pos, body_val} = BitmapBinHeader2Ascii_MixedDataType_HeaderAndBodyTest.form_body(field_pos, field_val)
    assert hval == "20"
    field_val = hval <> body_val
    assert field_val == "2012345678901234567890"
  end

  test "build n header 6" do
    field_val = "123456"
    field_pos = 63
    {^field_pos, hval} = BitmapBinHeader2Ascii_MixedDataType_HeaderAndBodyTest.form_header(field_pos, field_val)
    {^field_pos, body_val} = BitmapBinHeader2Ascii_MixedDataType_HeaderAndBodyTest.form_body(field_pos, field_val)
    assert hval == "06"
    field_val = hval <> body_val
    assert field_val == "06123456"
  end

  test "build n header 8" do
    field_val = "12345678"
    field_pos = 63
    {^field_pos, hval} = BitmapBinHeader2Ascii_MixedDataType_HeaderAndBodyTest.form_header(field_pos, field_val)
    {^field_pos, body_val} = BitmapBinHeader2Ascii_MixedDataType_HeaderAndBodyTest.form_body(field_pos, field_val)
    assert hval == "08"
    field_val = hval <> body_val
    assert field_val == "0812345678"
  end

  test "build n header 15" do
    field_val = "123456789012345"
    field_pos = 63
    {^field_pos, hval} = BitmapBinHeader2Ascii_MixedDataType_HeaderAndBodyTest.form_header(field_pos, field_val)
    {^field_pos, body_val} = BitmapBinHeader2Ascii_MixedDataType_HeaderAndBodyTest.form_body(field_pos, field_val)
    assert hval == "15"
    field_val = hval <> body_val
    assert field_val == "15123456789012345"
  end

  test "build n header 60" do
    field_val = "123456789012345678901234567890123456789012345678901234567890"
    field_pos = 63
    {^field_pos, hval} = BitmapBinHeader2Ascii_MixedDataType_HeaderAndBodyTest.form_header(field_pos, field_val)
    {^field_pos, body_val} = BitmapBinHeader2Ascii_MixedDataType_HeaderAndBodyTest.form_body(field_pos, field_val)
    assert hval == "60"
    field_val = hval <> body_val
    assert field_val == "60123456789012345678901234567890123456789012345678901234567890"
  end

  test "build an header 11" do
    field_val = "12345678901"
    field_pos = 64
    {^field_pos, hval} = BitmapBinHeader2Ascii_MixedDataType_HeaderAndBodyTest.form_header(field_pos, field_val)
    {^field_pos, body_val} = BitmapBinHeader2Ascii_MixedDataType_HeaderAndBodyTest.form_body(field_pos, field_val)
    assert hval == "11"
    field_val = hval <> body_val
    assert field_val == "1112345678901"
  end

  test "build an header 17" do
    field_val = "12345678901234567"
    field_pos = 64
    {^field_pos, hval} = BitmapBinHeader2Ascii_MixedDataType_HeaderAndBodyTest.form_header(field_pos, field_val)
    {^field_pos, body_val} = BitmapBinHeader2Ascii_MixedDataType_HeaderAndBodyTest.form_body(field_pos, field_val)
    assert hval == "17"
    field_val = hval <> body_val
    assert field_val == "1712345678901234567"
  end

  test "build an header 35" do
    field_val = "12345678901234567890123456789012345"
    field_pos = 64
    {^field_pos, hval} = BitmapBinHeader2Ascii_MixedDataType_HeaderAndBodyTest.form_header(field_pos, field_val)
    {^field_pos, body_val} = BitmapBinHeader2Ascii_MixedDataType_HeaderAndBodyTest.form_body(field_pos, field_val)
    assert hval == "35"
    field_val = hval <> body_val
    assert field_val == "3512345678901234567890123456789012345"
  end


end

defmodule BitmapBinHeader2Ascii_MixedDataType_HeaderAndBodyTest do
  use Iso8583EncDec, header_encoding: :ascii,
    default_encoding: :ascii,
    bitmap_format: :bin

  define(35, "z.. 39")
  define(63, "n.. 99")
  define(64, "an.. 36")

end
