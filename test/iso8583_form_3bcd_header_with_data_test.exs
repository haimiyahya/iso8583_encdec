defmodule Iso8583Form3BcdHeaderWithDataTest do
  use ExUnit.Case

  test "build z header 16" do
    field_val = "1234567890123456"
    field_pos = 35
    {^field_pos, hval} = BitmapBinHeader3Bcd_MixedDataTypeWithData.form_header(field_pos, field_val)
    {^field_pos, body_val} = BitmapBinHeader3Bcd_MixedDataTypeWithData.form_body(field_pos, field_val)
    field_val = hval <> body_val

    assert Base.encode16(hval) == "0016"
    assert field_val == Base.decode16!("00161234567890123456")
  end

  test "build n header 20" do
    field_val = "12345678901234567890"
    field_pos = 63
    {^field_pos, hval} = BitmapBinHeader3Bcd_MixedDataTypeWithData.form_header(field_pos, field_val)
    {^field_pos, body_val} = BitmapBinHeader3Bcd_MixedDataTypeWithData.form_body(field_pos, field_val)
    field_val = hval <> body_val

    assert Base.encode16(hval) == "0020"
    assert field_val == Base.decode16!("0020") <> Base.decode16!("12345678901234567890")
  end

  test "build n header 6" do
    field_val = "123456"
    field_pos = 63
    {^field_pos, hval} = BitmapBinHeader3Bcd_MixedDataTypeWithData.form_header(field_pos, field_val)
    {^field_pos, body_val} = BitmapBinHeader3Bcd_MixedDataTypeWithData.form_body(field_pos, field_val)
    field_val = hval <> body_val

    assert Base.encode16(hval) == "0006"
    assert field_val == Base.decode16!("0006") <> Base.decode16!("123456")
  end

  test "build n header 8" do
    field_val = "12345678"
    field_pos = 63
    {^field_pos, hval} = BitmapBinHeader3Bcd_MixedDataTypeWithData.form_header(field_pos, field_val)
    {^field_pos, body_val} = BitmapBinHeader3Bcd_MixedDataTypeWithData.form_body(field_pos, field_val)
    field_val = hval <> body_val

    assert Base.encode16(hval) == "0008"
    assert field_val == Base.decode16!("0008") <> Base.decode16!("12345678")
  end

  test "build n header 15" do
    field_val = "123456789012345"
    field_pos = 63
    {^field_pos, hval} = BitmapBinHeader3Bcd_MixedDataTypeWithData.form_header(field_pos, field_val)
    {^field_pos, body_val} = BitmapBinHeader3Bcd_MixedDataTypeWithData.form_body(field_pos, field_val)
    field_val = hval <> body_val

    assert Base.encode16(hval) == "0015"
    assert field_val == Base.decode16!("0015") <> Base.decode16!("1234567890123450")
  end

  test "build n header 60" do
    field_val = "123456789012345678901234567890123456789012345678901234567890"
    field_pos = 63
    {^field_pos, hval} = BitmapBinHeader3Bcd_MixedDataTypeWithData.form_header(field_pos, field_val)
    {^field_pos, body_val} = BitmapBinHeader3Bcd_MixedDataTypeWithData.form_body(field_pos, field_val)
    field_val = hval <> body_val

    assert Base.encode16(hval) == "0060"
    assert field_val == Base.decode16!("0060") <> Base.decode16!("123456789012345678901234567890123456789012345678901234567890")
  end

  test "build an header 11" do
    field_val = "12345678901"
    field_pos = 64
    {^field_pos, hval} = BitmapBinHeader3Bcd_MixedDataTypeWithData.form_header(field_pos, field_val)
    {^field_pos, body_val} = BitmapBinHeader3Bcd_MixedDataTypeWithData.form_body(field_pos, field_val)
    field_val = hval <> body_val

    assert Base.encode16(hval) == "0011"
    assert field_val == Base.decode16!("0011") <> "12345678901"
  end

  test "build an header 17" do
    field_val = "12345678901234567"
    field_pos = 64
    {^field_pos, hval} = BitmapBinHeader3Bcd_MixedDataTypeWithData.form_header(field_pos, field_val)
    {^field_pos, body_val} = BitmapBinHeader3Bcd_MixedDataTypeWithData.form_body(field_pos, field_val)
    field_val = hval <> body_val

    assert Base.encode16(hval) == "0017"
    assert field_val == Base.decode16!("0017") <> "12345678901234567"
  end

  test "build an header 37" do
    field_val = "12345678901234567890123456789012345"
    field_pos = 64
    {^field_pos, hval} = BitmapBinHeader3Bcd_MixedDataTypeWithData.form_header(field_pos, field_val)
    {^field_pos, body_val} = BitmapBinHeader3Bcd_MixedDataTypeWithData.form_body(field_pos, field_val)
    field_val = hval <> body_val

    assert Base.encode16(hval) == "0035"
    assert field_val == Base.decode16!("0035") <> "12345678901234567890123456789012345"
  end


end

defmodule BitmapBinHeader3Bcd_MixedDataTypeWithData do
  use Iso8583EncDec, header_encoding: :bcd,
    default_encoding: :bcd,
    bitmap_format: :bin

  define(35, "z... 39", encoding: :bcd)
  define(63, "n... 99")
  define(64, "an... 36")

end
