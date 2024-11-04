defmodule Iso8583Form3BcdHeaderTest do
  use ExUnit.Case

  test "build z header 16" do
    field_val = "1234567890123456"
    field_pos = 35
    {^field_pos, hval} = BitmapBinHeader3Bcd_MixedDataType.form_header(field_pos, field_val)
    assert Base.encode16(hval) == "0016"
  end

  test "build z header 20" do
    field_val = "12345678901234567890"
    field_pos = 63
    {^field_pos, hval} = BitmapBinHeader3Bcd_MixedDataType.form_header(field_pos, field_val)
    assert Base.encode16(hval) == "0020"
  end

  test "build n header 6" do
    field_val = "123456"
    field_pos = 63
    {^field_pos, hval} = BitmapBinHeader3Bcd_MixedDataType.form_header(field_pos, field_val)
    assert Base.encode16(hval) == "0006"
  end

  test "build n header 8" do
    field_val = "12345678"
    field_pos = 63
    {^field_pos, hval} = BitmapBinHeader3Bcd_MixedDataType.form_header(field_pos, field_val)
    assert Base.encode16(hval) == "0008"
  end

  test "build n header 15" do
    field_val = "123456789012345"
    field_pos = 63
    {^field_pos, hval} = BitmapBinHeader3Bcd_MixedDataType.form_header(field_pos, field_val)
    assert Base.encode16(hval) == "0015"
  end

  test "build n header 60" do
    field_val = "123456789012345678901234567890123456789012345678901234567890"
    field_pos = 63
    {^field_pos, hval} = BitmapBinHeader3Bcd_MixedDataType.form_header(field_pos, field_val)
    assert Base.encode16(hval) == "0060"
  end

  test "build an header 11" do
    field_val = "12345678901"
    field_pos = 64
    {^field_pos, hval} = BitmapBinHeader3Bcd_MixedDataType.form_header(field_pos, field_val)
    assert Base.encode16(hval) == "0011"
  end

  test "build an header 17" do
    field_val = "12345678901234567"
    field_pos = 64
    {^field_pos, hval} = BitmapBinHeader3Bcd_MixedDataType.form_header(field_pos, field_val)
    assert Base.encode16(hval) == "0017"
  end

  test "build an header 37" do
    field_val = "12345678901234567890123456789012345"
    field_pos = 64
    {^field_pos, hval} = BitmapBinHeader3Bcd_MixedDataType.form_header(field_pos, field_val)
    assert Base.encode16(hval) == "0035"
  end


end

defmodule BitmapBinHeader3Bcd_MixedDataType do
  use Iso8583EncDec, header_encoding: :bcd,
    default_encoding: :bcd,
    bitmap_format: :bin

  define(35, "z... 39", encoding: :bcd)
  define(63, "n... 99")
  define(64, "an... 36")

end
