defmodule Iso8583Form3AsciiHeaderWithDataTest do
  use ExUnit.Case

  test "build z header 16" do
    field_val = "1234567890123456"
    field_pos = 35
    {^field_pos, hval} = BitmapBinHeader3Ascii_MixedDataType_WithDataTest.form_header(field_pos, field_val)
    {^field_pos, body_val} = BitmapBinHeader3Ascii_MixedDataType_WithDataTest.form_body(field_pos, field_val)
    field_val = hval <> body_val

    assert hval == "016"
    assert field_val == "016" <> Base.decode16!("1234567890123456")
  end

  test "build n header 20" do
    field_val = "12345678901234567890"
    field_pos = 63
    {^field_pos, hval} = BitmapBinHeader3Ascii_MixedDataType_WithDataTest.form_header(field_pos, field_val)
    {^field_pos, body_val} = BitmapBinHeader3Ascii_MixedDataType_WithDataTest.form_body(field_pos, field_val)
    field_val = hval <> body_val

    assert hval == "020"
    assert field_val =="02012345678901234567890"
  end

  test "build n header 6" do
    field_val = "123456"
    field_pos = 63
    {^field_pos, hval} = BitmapBinHeader3Ascii_MixedDataType_WithDataTest.form_header(field_pos, field_val)
    {^field_pos, body_val} = BitmapBinHeader3Ascii_MixedDataType_WithDataTest.form_body(field_pos, field_val)
    field_val = hval <> body_val

    assert hval == "006"
    assert field_val == "006123456"

  end

  test "build n header 8" do
    field_val = "12345678"
    field_pos = 63
    {^field_pos, hval} = BitmapBinHeader3Ascii_MixedDataType_WithDataTest.form_header(field_pos, field_val)
    {^field_pos, body_val} = BitmapBinHeader3Ascii_MixedDataType_WithDataTest.form_body(field_pos, field_val)
    field_val = hval <> body_val

    assert hval == "008"
    assert field_val == "00812345678"
  end

  test "build n header 15" do
    field_val = "123456789012345"
    field_pos = 63
    {^field_pos, hval} = BitmapBinHeader3Ascii_MixedDataType_WithDataTest.form_header(field_pos, field_val)
    {^field_pos, body_val} = BitmapBinHeader3Ascii_MixedDataType_WithDataTest.form_body(field_pos, field_val)
    field_val = hval <> body_val

    assert hval == "015"
    assert field_val == "015123456789012345"
  end

  test "build n header 60" do
    field_val = "123456789012345678901234567890123456789012345678901234567890"
    field_pos = 63
    {^field_pos, hval} = BitmapBinHeader3Ascii_MixedDataType_WithDataTest.form_header(field_pos, field_val)
    {^field_pos, body_val} = BitmapBinHeader3Ascii_MixedDataType_WithDataTest.form_body(field_pos, field_val)
    field_val = hval <> body_val

    assert hval == "060"
    assert field_val == "060123456789012345678901234567890123456789012345678901234567890"
  end

  test "build an header 11" do
    field_val = "12345678901"
    field_pos = 64
    {^field_pos, hval} = BitmapBinHeader3Ascii_MixedDataType_WithDataTest.form_header(field_pos, field_val)
    {^field_pos, body_val} = BitmapBinHeader3Ascii_MixedDataType_WithDataTest.form_body(field_pos, field_val)
    field_val = hval <> body_val

    assert hval == "011"
    assert field_val == "01112345678901"
  end

  test "build an header 17" do
    field_val = "12345678901234567"
    field_pos = 64
    {^field_pos, hval} = BitmapBinHeader3Ascii_MixedDataType_WithDataTest.form_header(field_pos, field_val)
    {^field_pos, body_val} = BitmapBinHeader3Ascii_MixedDataType_WithDataTest.form_body(field_pos, field_val)
    field_val = hval <> body_val

    assert hval == "017"
    assert field_val == "01712345678901234567"
  end

  test "build an header 37" do
    field_val = "12345678901234567890123456789012345"
    field_pos = 64
    {^field_pos, hval} = BitmapBinHeader3Ascii_MixedDataType_WithDataTest.form_header(field_pos, field_val)
    {^field_pos, body_val} = BitmapBinHeader3Ascii_MixedDataType_WithDataTest.form_body(field_pos, field_val)
    field_val = hval <> body_val

    assert hval == "035"
    assert field_val == "03512345678901234567890123456789012345"
  end

end

defmodule BitmapBinHeader3Ascii_MixedDataType_WithDataTest do
  use Iso8583Dec, header_encoding: :ascii,
    default_encoding: :ascii,
    bitmap_format: :bin

  define(35, "z... 39", encoding: :bcd)
  define(63, "n... 99")
  define(64, "an... 36")

end
