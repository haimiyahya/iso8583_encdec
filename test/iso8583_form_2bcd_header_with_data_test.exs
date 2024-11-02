defmodule Iso8583Form2BcdHeaderWithDataTest do
  use ExUnit.Case

  test "build z header 16" do
    field_val = "1234567890123456"
    field_pos = 35
    {^field_pos, hval} = BitmapBinHeader2Bcd_MixedDataType_HeaderWithDataTest.form_header(field_pos, field_val)
    {^field_pos, body_val} = BitmapBinHeader2Bcd_MixedDataType_HeaderWithDataTest.form_body(field_pos, field_val)
    assert Base.encode16(hval) == "16"
    field_val = hval <> body_val
    assert Base.encode16(field_val) == "161234567890123456"
  end

  test "build z header 20" do
    field_val = "12345678901234567890"
    field_pos = 63
    {^field_pos, hval} = BitmapBinHeader2Bcd_MixedDataType_HeaderWithDataTest.form_header(field_pos, field_val)
    {^field_pos, body_val} = BitmapBinHeader2Bcd_MixedDataType_HeaderWithDataTest.form_body(field_pos, field_val)
    assert Base.encode16(hval) == "20"
    field_val = hval <> body_val
    assert Base.encode16(field_val) == "2012345678901234567890"
  end

  test "build n header 6" do
    field_val = "123456"
    field_pos = 63
    {^field_pos, hval} = BitmapBinHeader2Bcd_MixedDataType_HeaderWithDataTest.form_header(field_pos, field_val)
    {^field_pos, body_val} = BitmapBinHeader2Bcd_MixedDataType_HeaderWithDataTest.form_body(field_pos, field_val)
    assert Base.encode16(hval) == "06"
    field_val = hval <> body_val
    assert Base.encode16(field_val) == "06123456"
  end

  test "build n header 8" do
    field_val = "12345678"
    field_pos = 63
    {^field_pos, hval} = BitmapBinHeader2Bcd_MixedDataType_HeaderWithDataTest.form_header(field_pos, field_val)
    {^field_pos, body_val} = BitmapBinHeader2Bcd_MixedDataType_HeaderWithDataTest.form_body(field_pos, field_val)
    assert Base.encode16(hval) == "08"
    field_val = hval <> body_val
    assert Base.encode16(field_val) == "0812345678"
  end

  test "build n header 15" do
    field_val = "123456789012345"
    field_pos = 63
    {^field_pos, hval} = BitmapBinHeader2Bcd_MixedDataType_HeaderWithDataTest.form_header(field_pos, field_val)
    {^field_pos, body_val} = BitmapBinHeader2Bcd_MixedDataType_HeaderWithDataTest.form_body(field_pos, field_val)
    assert Base.encode16(hval) == "15"
    field_val = hval <> body_val
    assert Base.encode16(field_val) == "151234567890123450"
  end

  test "build n header 60" do
    field_val = "123456789012345678901234567890123456789012345678901234567890"
    field_pos = 63
    {^field_pos, hval} = BitmapBinHeader2Bcd_MixedDataType_HeaderWithDataTest.form_header(field_pos, field_val)
    {^field_pos, body_val} = BitmapBinHeader2Bcd_MixedDataType_HeaderWithDataTest.form_body(field_pos, field_val)
    assert Base.encode16(hval) == "60"
    field_val = hval <> body_val
    assert Base.encode16(field_val) == "60123456789012345678901234567890123456789012345678901234567890"
  end

  test "build an header 11" do
    field_val = "12345678901"
    field_pos = 64
    {^field_pos, hval} = BitmapBinHeader2Bcd_MixedDataType_HeaderWithDataTest.form_header(field_pos, field_val)
    {^field_pos, body_val} = BitmapBinHeader2Bcd_MixedDataType_HeaderWithDataTest.form_body(field_pos, field_val)
    assert Base.encode16(hval) == "11"
    field_val2 = hval <> body_val
    assert field_val2 == Base.decode16!("11") <> "12345678901"
  end

  test "build an header 17" do
    field_val = "12345678901234567"
    field_pos = 64
    {^field_pos, hval} = BitmapBinHeader2Bcd_MixedDataType_HeaderWithDataTest.form_header(field_pos, field_val)
    {^field_pos, body_val} = BitmapBinHeader2Bcd_MixedDataType_HeaderWithDataTest.form_body(field_pos, field_val)
    assert Base.encode16(hval) == "17"
    field_val2 = hval <> body_val
    assert field_val2 == Base.decode16!("17") <> "12345678901234567"
  end

  test "build an header 37" do
    field_val = "12345678901234567890123456789012345"
    field_pos = 64
    {^field_pos, hval} = BitmapBinHeader2Bcd_MixedDataType_HeaderWithDataTest.form_header(field_pos, field_val)
    {^field_pos, body_val} = BitmapBinHeader2Bcd_MixedDataType_HeaderWithDataTest.form_body(field_pos, field_val)
    assert Base.encode16(hval) == "35"
    field_val2 = hval <> body_val
    assert field_val2 == Base.decode16!("35") <> "12345678901234567890123456789012345"
  end


end

defmodule BitmapBinHeader2Bcd_MixedDataType_HeaderWithDataTest do
  use Iso8583Dec, header_encoding: :bcd,
    default_encoding: :bcd,
    bitmap_format: :bin

  define(35, "z.. 39")
  define(63, "n.. 99")
  define(64, "an.. 36")

end
