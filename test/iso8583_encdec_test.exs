defmodule Iso8583EncdecTest do
  use ExUnit.Case

  test "parse f 35, f63 and f64" do
    bmp = "0000000020000003"
    f35 = "35123456789012345678901234567890123450"
    f63 = "06123456"
    f64 = "35363738"

    msg = bmp <> f35 <> f63 <> f64

    msg = Base.decode16!(msg)
    parsed_msg = BitmapBinHeaderBcd_MixedDataType.parse_msg(msg)

    assert Map.has_key?(parsed_msg, 63)
    assert Map.get(parsed_msg, 63) == "12"

    assert Map.has_key?(parsed_msg, 64)
    assert Map.get(parsed_msg, 64) == "5678"

  end

  test "parse alphanum field data_type with 0 digits bcd header, 2 digits bcd header and 3 digits bcd header" do
    bmp = "0000000000000007"
    f62 = "35363738"
    f63 = "0435363738"
    f64 = "000435363738"

    msg = bmp <> f62 <> f63 <> f64
    msg = Base.decode16!(msg)

    parsed_msg = BmpBinHeaderBcd_AlphanumDataType.parse_msg(msg)

    assert Map.get(parsed_msg, 62) == "5678"
    assert Map.get(parsed_msg, 63) == "5678"
    assert Map.get(parsed_msg, 64) == "5678"

  end

  test "parse numeric field data_type with 0 digits bcd header, 2 digits bcd header and 3 digits bcd header" do
    bmp = "0000000000000007"
    f62 = "5678"
    f63 = "045678"
    f64 = "00045678"

    msg = bmp <> f62 <> f63 <> f64
    msg = Base.decode16!(msg)

    parsed_msg = BmpBinHeaderBcdDataNumBcd_NumericDataType.parse_msg(msg)

    assert Map.get(parsed_msg, 62) == "5678"
    assert Map.get(parsed_msg, 63) == "5678"
    assert Map.get(parsed_msg, 64) == "5678"

  end

  test "parse alphanumeric field data_type with 0 digits ascii header, 2 digits ascii header and 3 digits ascii header" do
    bmp = "30303030303030303030303030303037"
    f62 = "35363738"
    f63 = "303435363738"
    f64 = "30303435363738"

    msg = bmp <> f62 <> f63 <> f64
    msg = Base.decode16!(msg)

    parsed_msg = BmpAsciiHeaderAscii_AlphanumericDataType.parse_msg(msg)

    assert Map.get(parsed_msg, 62) == "5678"
    assert Map.get(parsed_msg, 63) == "5678"
    assert Map.get(parsed_msg, 64) == "5678"

  end

  test "parse numeric field data_type with 0 digits ascii header, 2 digits ascii header and 3 digits ascii header" do
    bmp = "30303030303030303030303030303037"
    f62 = "35363738"
    f63 = "303435363738"
    f64 = "30303435363738"

    msg = bmp <> f62 <> f63 <> f64
    msg = Base.decode16!(msg)

    parsed_msg = BmpAsciiHeaderAscii_NumericDataType.parse_msg(msg)

    assert Map.get(parsed_msg, 62) == "5678"
    assert Map.get(parsed_msg, 63) == "5678"
    assert Map.get(parsed_msg, 64) == "5678"

  end

  test "parse Z field data_type with 2 digits ascii header and 3 digits ascii header" do
    bmp = "30303030303030303030303030303033"
    f63 = "33353132333435363738393031323334353637383930313233343536373839303132333435"
    f64 = "303335313233343536373839303132333435363738393031323334353637383930313233343530"

    msg = bmp <> f63 <> f64
    msg = Base.decode16!(msg)

    parsed_msg = BmpAsciiHeaderAscii_ZDataType.parse_msg(msg)

    assert Map.get(parsed_msg, 63) == "12345678901234567890123456789012345"
    assert Map.get(parsed_msg, 64) == "12345678901234567890123456789012345"

  end

end


defmodule BitmapBinHeaderBcd_MixedDataType do
  use Iso8583Dec, header_encoding: :bcd,
    default_encoding: :bcd,
    bitmap_format: :bin

  define(35, "z.. 39", encoding: :bcd)
  define(63, "n.. 2")
  define(64, "an 4")

end

defmodule BmpBinHeaderBcd_AlphanumDataType do
  use Iso8583Dec, header_encoding: :bcd,
    default_encoding: :bcd,
    bitmap_format: :bin

  define(62, "an 4")
  define(63, "an.. 4")
  define(64, "an... 4")

end

defmodule BmpBinHeaderBcdDataNumBcd_NumericDataType do
  use Iso8583Dec, header_encoding: :bcd,
    default_encoding: :bcd,
    bitmap_format: :bin

  define(62, "n 4")
  define(63, "n.. 4")
  define(64, "n... 4")

end

defmodule BmpAsciiHeaderAscii_AlphanumericDataType do
  use Iso8583Dec, header_encoding: :ascii,
    default_encoding: :ascii,
    bitmap_format: :ascii

  define(62, "an 4")
  define(63, "an.. 4")
  define(64, "an... 4")

end

defmodule BmpAsciiHeaderAscii_NumericDataType do
  use Iso8583Dec, header_encoding: :ascii,
    default_encoding: :ascii,
    bitmap_format: :ascii

  define(62, "n 4")
  define(63, "n.. 4")
  define(64, "n... 4")

end

defmodule BmpAsciiHeaderAscii_ZDataType do
  use Iso8583Dec, header_encoding: :ascii,
    default_encoding: :ascii,
    bitmap_format: :ascii

  define(63, "z.. 37")
  define(64, "z... 37")
end
