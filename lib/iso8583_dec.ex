defmodule Iso8583Dec do

  defmacro __using__(opts) do
    bitmap_format = if opts[:bitmap_format], do: opts[:bitmap_format], else: :bin
    header_enc = if opts[:header_encoding], do: opts[:header_encoding], else: :bcd
    default_enc = if opts[:default_encoding], do: opts[:default_encoding], else: :bcd
    default_alignment = if opts[:default_alignment], do: opts[:default_alignment], else: :left
    default_numeric_pad_char = if opts[:default_numeric_pad_char], do: opts[:default_numeric_pad_char], else: ?0
    default_alphanumeric_pad_char = if opts[:default_alphanumeric_pad_char], do: opts[:default_alphanumeric_pad_char], else: ?\s

    Module.put_attribute(__CALLER__.module, :bitmap_format, bitmap_format)
    Module.put_attribute(__CALLER__.module, :header_encoding, header_enc)
    Module.put_attribute(__CALLER__.module, :default_encoding, default_enc)
    Module.put_attribute(__CALLER__.module, :default_alignment, default_alignment)
    Module.put_attribute(__CALLER__.module, :default_numeric_pad_char, default_numeric_pad_char)
    Module.put_attribute(__CALLER__.module, :default_alphanumeric_pad_char, default_alphanumeric_pad_char)

    quote do
      require unquote(__MODULE__)
      import unquote(__MODULE__)

      def_all_match_bit()
      def_parse_bitmap()
      def_parse_msg()
      def_build_bitmap()
    end

  end


  # bcd
  def translate_length_to_byte(:n = _type, :bcd = _encoding, specified_len) do
    div(specified_len, 2)
  end

  def translate_length_to_byte(:n = _type, :ascii = _encoding, specified_len) do
    specified_len
  end

  def translate_length_to_byte(:b = _type, :bit = _encoding, specified_len) do
    div(specified_len, 8)
  end

  def translate_length_to_byte(:b = _type, :bcd = _encoding, specified_len) do
    div(specified_len, 2)
  end

  def translate_length_to_byte(:b = _type, :ascii = _encoding, specified_len) do
    specified_len*2
  end

  def translate_length_to_byte(:z = _type, :bcd = _encoding, specified_len) do
    div(specified_len + Integer.mod(specified_len, 2), 2) # make it even
  end

  def translate_length_to_byte(:z = _type, :ascii = _encoding, specified_len) do
    specified_len
  end

  def translate_length_to_byte(_type, _encoding, specified_len) do
    specified_len
  end



  def translate_data_from_raw(:n, :bcd, data) do
    Base.encode16(data)
  end

  def translate_data_from_raw(:n, :ascii, data) do
    data
  end

  def translate_data_from_raw(:z, :bcd, data) do
    Base.encode16(data)
  end

  def translate_data_from_raw(:z, :ascii, data) do
    data
  end

  def translate_data_from_raw(_dt, _enc, data) do
    data
  end


  def translate_data_to_raw(:n, :bcd, data), do: Base.decode16!(data)
  def translate_data_to_raw(:n, :ascii, data), do: data
  def translate_data_to_raw(:z, :bcd, data), do: Base.decode16!(data)
  def translate_data_to_raw(:z, :ascii, data), do: data
  def translate_data_to_raw(_dt, _enc, data), do: data


  def truncate_data(data, max_length) when byte_size(data) >  max_length do
    <<result::binary-size(max_length), _trailer::binary>> = data
    result
  end

  def truncate_data(data, _max_length) do
    data
  end

  def trim_data(data, required_length) do
    <<result::binary-size(required_length), _trailer::binary>> = data
    result
  end

  # ans, anp, an, as, ns, x+n, a, n, s, b, p, z
  # space within the conf is replaced with empty string to simplify the logic

  def match_conf("ans..." <> max_data_length), do: {3, :ans, String.to_integer(max_data_length)}
  def match_conf("anp..." <> max_data_length), do: {3, :ans, String.to_integer(max_data_length)}
  def match_conf("an..." <> max_data_length), do: {3, :an, String.to_integer(max_data_length)}
  def match_conf("as..." <> max_data_length), do: {3, :as, String.to_integer(max_data_length)}
  def match_conf("ns..." <> max_data_length), do: {3, :ns, String.to_integer(max_data_length)}
  def match_conf("x+n..." <> max_data_length), do: {3, :"x+n", String.to_integer(max_data_length)}
  def match_conf("a..." <> max_data_length), do: {3, :a, String.to_integer(max_data_length)}
  def match_conf("n..." <> max_data_length), do: {3, :n, String.to_integer(max_data_length)}
  def match_conf("s..." <> max_data_length), do: {3, :s, String.to_integer(max_data_length)}
  def match_conf("b..." <> max_data_length), do: {3, :b, String.to_integer(max_data_length)}
  def match_conf("p..." <> max_data_length), do: {3, :p, String.to_integer(max_data_length)}
  def match_conf("z..." <> max_data_length), do: {3, :z, String.to_integer(max_data_length)}

  def match_conf("ans.." <> max_data_length), do: {2, :ans, String.to_integer(max_data_length)}
  def match_conf("anp.." <> max_data_length), do: {2, :ans, String.to_integer(max_data_length)}
  def match_conf("an.." <> max_data_length), do: {2, :an, String.to_integer(max_data_length)}
  def match_conf("as.." <> max_data_length), do: {2, :as, String.to_integer(max_data_length)}
  def match_conf("ns.." <> max_data_length), do: {2, :ns, String.to_integer(max_data_length)}
  def match_conf("x+n.." <> max_data_length), do: {2, :"x+n", String.to_integer(max_data_length)}
  def match_conf("a.." <> max_data_length), do: {2, :a, String.to_integer(max_data_length)}
  def match_conf("n.." <> max_data_length), do: {2, :n, String.to_integer(max_data_length)}
  def match_conf("s.." <> max_data_length), do: {2, :s, String.to_integer(max_data_length)}
  def match_conf("b.." <> max_data_length), do: {2, :b, String.to_integer(max_data_length)}
  def match_conf("p.." <> max_data_length), do: {2, :p, String.to_integer(max_data_length)}
  def match_conf("z.." <> max_data_length), do: {2, :z, String.to_integer(max_data_length)}

  def match_conf("ans" <> max_data_length), do: {0, :ans, String.to_integer(max_data_length)}
  def match_conf("anp" <> max_data_length), do: {0, :ans, String.to_integer(max_data_length)}
  def match_conf("an" <> max_data_length), do: {0, :an, String.to_integer(max_data_length)}
  def match_conf("as" <> max_data_length), do: {0, :as, String.to_integer(max_data_length)}
  def match_conf("ns" <> max_data_length), do: {0, :ns, String.to_integer(max_data_length)}
  def match_conf("x+n" <> max_data_length), do: {0, :"x+n", String.to_integer(max_data_length)}
  def match_conf("a" <> max_data_length), do: {0, :a, String.to_integer(max_data_length)}
  def match_conf("n" <> max_data_length), do: {0, :n, String.to_integer(max_data_length)}
  def match_conf("s" <> max_data_length), do: {0, :s, String.to_integer(max_data_length)}
  def match_conf("b" <> max_data_length), do: {0, :b, String.to_integer(max_data_length)}
  def match_conf("p" <> max_data_length), do: {0, :p, String.to_integer(max_data_length)}
  def match_conf("z" <> max_data_length), do: {0, :z, String.to_integer(max_data_length)}


  defmacro def_parse_bitmap() do

    bitmap_format = Module.get_attribute(__CALLER__.module, :bitmap_format)

    quote location: :keep do

      def parse_bmp_from_msg(msg) do
        <<first_char::8, _trailer::binary>> = msg
        parse_bitmap_by_format(unquote(bitmap_format), msg)
      end

      defp parse_bitmap_by_format(:bin, msg) do
        parse_bitmap(msg)
      end

      defp parse_bitmap_by_format(:ascii, <<first_char::8, _trailer::binary>> = data) when first_char >= ?0 and first_char <= ?7 do
        <<bitmap::binary-size(16), trailer::binary>> = data
        parse_bitmap(Base.decode16!(bitmap) <> trailer)
      end

      defp parse_bitmap_by_format(:ascii, <<first_char::8, _trailer::binary>> = data) when first_char >= ?8 and first_char <= ?F do
        <<bitmap::binary-size(32), trailer::binary>> = data

        msg = Base.decode16!(bitmap) <> trailer
        parse_bitmap(msg)
      end

      defp parse_bitmap_by_format(:hex, data) do
        raise "invalid msg format"
      end

      defp parse_bitmap(
          <<0::1,  b2::1,  b3::1,  b4::1,  b5::1,  b6::1,  b7::1,  b8::1,  b9::1, b10::1,
          b11::1, b12::1, b13::1, b14::1, b15::1, b16::1, b17::1, b18::1, b19::1, b20::1,
          b21::1, b22::1, b23::1, b24::1, b25::1, b26::1, b27::1, b28::1, b29::1, b30::1,
          b31::1, b32::1, b33::1, b34::1, b35::1, b36::1, b37::1, b38::1, b39::1, b40::1,
          b41::1, b42::1, b43::1, b44::1, b45::1, b46::1, b47::1, b48::1, b49::1, b50::1,
          b51::1, b52::1, b53::1, b54::1, b55::1, b56::1, b57::1, b58::1, b59::1, b60::1,
          b61::1, b62::1, b63::1, b64::1, data::binary >>) do

        result = get_bit_position(b2, 2) ++ get_bit_position(b3, 3) ++ get_bit_position(b4, 4) ++ get_bit_position(b5, 5) ++ get_bit_position(b6, 6) ++ get_bit_position(b7, 7) ++ get_bit_position(b8, 8) ++ get_bit_position(b9, 9) ++ get_bit_position(b10, 10)
        ++ get_bit_position(b11, 11) ++ get_bit_position(b12, 12) ++ get_bit_position(b13, 13) ++ get_bit_position(b14, 14) ++ get_bit_position(b15, 15) ++ get_bit_position(b16, 16) ++ get_bit_position(b17, 17) ++ get_bit_position(b18, 18) ++ get_bit_position(b19, 19) ++ get_bit_position(b20, 20)
        ++ get_bit_position(b21, 21) ++ get_bit_position(b22, 22) ++ get_bit_position(b23, 23) ++ get_bit_position(b24, 24) ++ get_bit_position(b25, 25) ++ get_bit_position(b26, 26) ++ get_bit_position(b27, 27) ++ get_bit_position(b28, 28) ++ get_bit_position(b29, 29) ++ get_bit_position(b30, 30)
        ++ get_bit_position(b31, 31) ++ get_bit_position(b32, 32) ++ get_bit_position(b33, 33) ++ get_bit_position(b34, 34) ++ get_bit_position(b35, 35) ++ get_bit_position(b36, 36) ++ get_bit_position(b37, 37) ++ get_bit_position(b38, 38) ++ get_bit_position(b39, 39) ++ get_bit_position(b30, 30)
        ++ get_bit_position(b41, 41) ++ get_bit_position(b42, 42) ++ get_bit_position(b43, 43) ++ get_bit_position(b44, 44) ++ get_bit_position(b45, 45) ++ get_bit_position(b46, 46) ++ get_bit_position(b47, 47) ++ get_bit_position(b48, 48) ++ get_bit_position(b49, 49) ++ get_bit_position(b50, 50)
        ++ get_bit_position(b51, 51) ++ get_bit_position(b52, 52) ++ get_bit_position(b53, 53) ++ get_bit_position(b54, 54) ++ get_bit_position(b55, 55) ++ get_bit_position(b56, 56) ++ get_bit_position(b57, 57) ++ get_bit_position(b58, 58) ++ get_bit_position(b59, 59) ++ get_bit_position(b60, 60)
        ++ get_bit_position(b61, 61) ++ get_bit_position(b62, 62) ++ get_bit_position(b63, 63) ++ get_bit_position(b64, 64)

        {result, data}

      end

      defp parse_bitmap(
          <<1::1,  b2::1,  b3::1,  b4::1,  b5::1,  b6::1,  b7::1,  b8::1,  b9::1, b10::1,
          b11::1, b12::1, b13::1, b14::1, b15::1, b16::1, b17::1, b18::1, b19::1, b20::1,
          b21::1, b22::1, b23::1, b24::1, b25::1, b26::1, b27::1, b28::1, b29::1, b30::1,
          b31::1, b32::1, b33::1, b34::1, b35::1, b36::1, b37::1, b38::1, b39::1, b40::1,
          b41::1, b42::1, b43::1, b44::1, b45::1, b46::1, b47::1, b48::1, b49::1, b50::1,
          b51::1, b52::1, b53::1, b54::1, b55::1, b56::1, b57::1, b58::1, b59::1, b60::1,
          b61::1, b62::1, b63::1, b64::1, b65::1, b66::1, b67::1, b68::1, b69::1, b70::1,
          b71::1, b72::1, b73::1, b74::1, b75::1, b76::1, b77::1, b78::1, b79::1, b80::1,
          b81::1, b82::1, b83::1, b84::1, b85::1, b86::1, b87::1, b88::1, b89::1, b90::1,
          b91::1, b92::1, b93::1, b94::1, b95::1, b96::1, b97::1, b98::1, b99::1, b100::1,
          b101::1, b102::1, b103::1, b104::1, b105::1, b106::1, b107::1, b108::1, b109::1, b110::1,
          b111::1, b112::1, b113::1, b114::1, b115::1, b116::1, b117::1, b118::1, b119::1, b120::1,
          b121::1, b122::1, b123::1, b124::1, b125::1, b126::1, b127::1, b128::1, data::binary >>) do

        result = get_bit_position(b2, 2) ++ get_bit_position(b3, 3) ++ get_bit_position(b4, 4) ++ get_bit_position(b5, 5) ++ get_bit_position(b6, 6) ++ get_bit_position(b7, 7) ++ get_bit_position(b8, 8) ++ get_bit_position(b9, 9) ++ get_bit_position(b10, 10)
        ++ get_bit_position(b11, 11) ++ get_bit_position(b12, 12) ++ get_bit_position(b13, 13) ++ get_bit_position(b14, 14) ++ get_bit_position(b15, 15) ++ get_bit_position(b16, 16) ++ get_bit_position(b17, 17) ++ get_bit_position(b18, 18) ++ get_bit_position(b19, 19) ++ get_bit_position(b20, 20)
        ++ get_bit_position(b21, 21) ++ get_bit_position(b22, 22) ++ get_bit_position(b23, 23) ++ get_bit_position(b24, 24) ++ get_bit_position(b25, 25) ++ get_bit_position(b26, 26) ++ get_bit_position(b27, 27) ++ get_bit_position(b28, 28) ++ get_bit_position(b29, 29) ++ get_bit_position(b30, 30)
        ++ get_bit_position(b31, 31) ++ get_bit_position(b32, 32) ++ get_bit_position(b33, 33) ++ get_bit_position(b34, 34) ++ get_bit_position(b35, 35) ++ get_bit_position(b36, 36) ++ get_bit_position(b37, 37) ++ get_bit_position(b38, 38) ++ get_bit_position(b39, 39) ++ get_bit_position(b40, 40)
        ++ get_bit_position(b41, 41) ++ get_bit_position(b42, 42) ++ get_bit_position(b43, 43) ++ get_bit_position(b44, 44) ++ get_bit_position(b45, 45) ++ get_bit_position(b46, 46) ++ get_bit_position(b47, 47) ++ get_bit_position(b48, 48) ++ get_bit_position(b49, 49) ++ get_bit_position(b50, 50)
        ++ get_bit_position(b51, 51) ++ get_bit_position(b52, 52) ++ get_bit_position(b53, 53) ++ get_bit_position(b54, 54) ++ get_bit_position(b55, 55) ++ get_bit_position(b56, 56) ++ get_bit_position(b57, 57) ++ get_bit_position(b58, 58) ++ get_bit_position(b59, 59) ++ get_bit_position(b60, 60)
        ++ get_bit_position(b61, 61) ++ get_bit_position(b62, 62) ++ get_bit_position(b63, 63) ++ get_bit_position(b64, 64) ++ get_bit_position(b65, 65) ++ get_bit_position(b66, 66) ++ get_bit_position(b67, 67) ++ get_bit_position(b68, 68) ++ get_bit_position(b69, 69) ++ get_bit_position(b70, 70)
        ++ get_bit_position(b71, 71) ++ get_bit_position(b72, 72) ++ get_bit_position(b73, 73) ++ get_bit_position(b74, 74) ++ get_bit_position(b75, 75) ++ get_bit_position(b76, 76) ++ get_bit_position(b77, 77) ++ get_bit_position(b78, 78) ++ get_bit_position(b79, 79) ++ get_bit_position(b80, 80)
        ++ get_bit_position(b81, 81) ++ get_bit_position(b82, 82) ++ get_bit_position(b83, 83) ++ get_bit_position(b84, 84) ++ get_bit_position(b85, 85) ++ get_bit_position(b86, 86) ++ get_bit_position(b87, 87) ++ get_bit_position(b88, 88) ++ get_bit_position(b89, 89) ++ get_bit_position(b90, 90)
        ++ get_bit_position(b91, 91) ++ get_bit_position(b92, 92) ++ get_bit_position(b93, 93) ++ get_bit_position(b94, 94) ++ get_bit_position(b95, 95) ++ get_bit_position(b96, 96) ++ get_bit_position(b97, 97) ++ get_bit_position(b98, 98) ++ get_bit_position(b99, 99) ++ get_bit_position(b100, 100)
        ++ get_bit_position(b101, 101) ++ get_bit_position(b102, 102) ++ get_bit_position(b103, 103) ++ get_bit_position(b104, 104) ++ get_bit_position(b105, 105) ++ get_bit_position(b106, 106) ++ get_bit_position(b107, 107) ++ get_bit_position(b108, 108) ++ get_bit_position(b109, 109) ++ get_bit_position(b110, 110)
        ++ get_bit_position(b111, 111) ++ get_bit_position(b112, 112) ++ get_bit_position(b113, 113) ++ get_bit_position(b114, 114) ++ get_bit_position(b115, 115) ++ get_bit_position(b116, 116) ++ get_bit_position(b117, 117) ++ get_bit_position(b118, 118) ++ get_bit_position(b119, 119) ++ get_bit_position(b120, 120)
        ++ get_bit_position(b121, 121) ++ get_bit_position(b122, 122) ++ get_bit_position(b123, 123) ++ get_bit_position(b124, 124) ++ get_bit_position(b125, 125) ++ get_bit_position(b126, 126) ++ get_bit_position(b127, 127) ++ get_bit_position(b128, 128)

        {result, data}

      end

    end

  end

  defmacro def_build_bitmap() do
    bitmap_format = Module.get_attribute(__CALLER__.module, :bitmap_format)

    quote do

      def build_bitmap(fields, 0) do

        <<0::1,  get_position_bit(fields, 2)::1,  get_position_bit(fields, 3)::1,  get_position_bit(fields, 4)::1,  get_position_bit(fields, 5)::1,  get_position_bit(fields, 6)::1,  get_position_bit(fields, 7)::1,  get_position_bit(fields, 8)::1,  get_position_bit(fields, 9)::1, get_position_bit(fields, 10)::1,
        get_position_bit(fields, 11)::1, get_position_bit(fields, 12)::1, get_position_bit(fields, 13)::1, get_position_bit(fields, 14)::1, get_position_bit(fields, 15)::1, get_position_bit(fields, 16)::1, get_position_bit(fields, 17)::1, get_position_bit(fields, 18)::1, get_position_bit(fields, 19)::1, get_position_bit(fields, 20)::1,
        get_position_bit(fields, 21)::1, get_position_bit(fields, 22)::1, get_position_bit(fields, 23)::1, get_position_bit(fields, 24)::1, get_position_bit(fields, 25)::1, get_position_bit(fields, 26)::1, get_position_bit(fields, 27)::1, get_position_bit(fields, 28)::1, get_position_bit(fields, 29)::1, get_position_bit(fields, 30)::1,
        get_position_bit(fields, 31)::1, get_position_bit(fields, 32)::1, get_position_bit(fields, 33)::1, get_position_bit(fields, 34)::1, get_position_bit(fields, 35)::1, get_position_bit(fields, 36)::1, get_position_bit(fields, 37)::1, get_position_bit(fields, 38)::1, get_position_bit(fields, 39)::1, get_position_bit(fields, 40)::1,
        get_position_bit(fields, 41)::1, get_position_bit(fields, 42)::1, get_position_bit(fields, 43)::1, get_position_bit(fields, 44)::1, get_position_bit(fields, 45)::1, get_position_bit(fields, 46)::1, get_position_bit(fields, 47)::1, get_position_bit(fields, 48)::1, get_position_bit(fields, 49)::1, get_position_bit(fields, 50)::1,
        get_position_bit(fields, 51)::1, get_position_bit(fields, 52)::1, get_position_bit(fields, 53)::1, get_position_bit(fields, 54)::1, get_position_bit(fields, 55)::1, get_position_bit(fields, 56)::1, get_position_bit(fields, 57)::1, get_position_bit(fields, 58)::1, get_position_bit(fields, 59)::1, get_position_bit(fields, 60)::1,
        get_position_bit(fields, 61)::1, get_position_bit(fields, 62)::1, get_position_bit(fields, 63)::1, get_position_bit(fields, 64)::1>>

      end

      def build_bitmap(fields, 1) do

        <<1::1,  get_position_bit(fields, 2)::1,  get_position_bit(fields, 3)::1,  get_position_bit(fields, 4)::1,  get_position_bit(fields, 5)::1,  get_position_bit(fields, 6)::1,  get_position_bit(fields, 7)::1,  get_position_bit(fields, 8)::1,  get_position_bit(fields, 9)::1, get_position_bit(fields, 10)::1,
        get_position_bit(fields, 11)::1, get_position_bit(fields, 12)::1, get_position_bit(fields, 13)::1, get_position_bit(fields, 14)::1, get_position_bit(fields, 15)::1, get_position_bit(fields, 16)::1, get_position_bit(fields, 17)::1, get_position_bit(fields, 18)::1, get_position_bit(fields, 19)::1, get_position_bit(fields, 20)::1,
        get_position_bit(fields, 21)::1, get_position_bit(fields, 22)::1, get_position_bit(fields, 23)::1, get_position_bit(fields, 24)::1, get_position_bit(fields, 25)::1, get_position_bit(fields, 26)::1, get_position_bit(fields, 27)::1, get_position_bit(fields, 28)::1, get_position_bit(fields, 29)::1, get_position_bit(fields, 30)::1,
        get_position_bit(fields, 31)::1, get_position_bit(fields, 32)::1, get_position_bit(fields, 33)::1, get_position_bit(fields, 34)::1, get_position_bit(fields, 35)::1, get_position_bit(fields, 36)::1, get_position_bit(fields, 37)::1, get_position_bit(fields, 38)::1, get_position_bit(fields, 39)::1, get_position_bit(fields, 40)::1,
        get_position_bit(fields, 41)::1, get_position_bit(fields, 42)::1, get_position_bit(fields, 43)::1, get_position_bit(fields, 44)::1, get_position_bit(fields, 45)::1, get_position_bit(fields, 46)::1, get_position_bit(fields, 47)::1, get_position_bit(fields, 48)::1, get_position_bit(fields, 49)::1, get_position_bit(fields, 50)::1,
        get_position_bit(fields, 51)::1, get_position_bit(fields, 52)::1, get_position_bit(fields, 53)::1, get_position_bit(fields, 54)::1, get_position_bit(fields, 55)::1, get_position_bit(fields, 56)::1, get_position_bit(fields, 57)::1, get_position_bit(fields, 58)::1, get_position_bit(fields, 59)::1, get_position_bit(fields, 60)::1,
        get_position_bit(fields, 61)::1, get_position_bit(fields, 62)::1, get_position_bit(fields, 63)::1, get_position_bit(fields, 64)::1,
        get_position_bit(fields, 65)::1, get_position_bit(fields, 66)::1, get_position_bit(fields, 67)::1, get_position_bit(fields, 68)::1, get_position_bit(fields, 69)::1, get_position_bit(fields, 70)::1,
        get_position_bit(fields, 71)::1, get_position_bit(fields, 72)::1, get_position_bit(fields, 73)::1, get_position_bit(fields, 74)::1, get_position_bit(fields, 75)::1, get_position_bit(fields, 76)::1, get_position_bit(fields, 77)::1, get_position_bit(fields, 78)::1, get_position_bit(fields, 79)::1, get_position_bit(fields, 80)::1,
        get_position_bit(fields, 81)::1, get_position_bit(fields, 82)::1, get_position_bit(fields, 83)::1, get_position_bit(fields, 84)::1, get_position_bit(fields, 85)::1, get_position_bit(fields, 86)::1, get_position_bit(fields, 87)::1, get_position_bit(fields, 88)::1, get_position_bit(fields, 89)::1, get_position_bit(fields, 90)::1,
        get_position_bit(fields, 91)::1, get_position_bit(fields, 92)::1, get_position_bit(fields, 93)::1, get_position_bit(fields, 94)::1, get_position_bit(fields, 95)::1, get_position_bit(fields, 96)::1, get_position_bit(fields, 97)::1, get_position_bit(fields, 98)::1, get_position_bit(fields, 99)::1, get_position_bit(fields, 100)::1,
        get_position_bit(fields, 101)::1, get_position_bit(fields, 102)::1, get_position_bit(fields, 103)::1, get_position_bit(fields, 104)::1, get_position_bit(fields, 105)::1, get_position_bit(fields, 106)::1, get_position_bit(fields, 107)::1, get_position_bit(fields, 108)::1, get_position_bit(fields, 109)::1, get_position_bit(fields, 110)::1,
        get_position_bit(fields, 111)::1, get_position_bit(fields, 112)::1, get_position_bit(fields, 113)::1, get_position_bit(fields, 114)::1, get_position_bit(fields, 115)::1, get_position_bit(fields, 116)::1, get_position_bit(fields, 117)::1, get_position_bit(fields, 118)::1, get_position_bit(fields, 119)::1, get_position_bit(fields, 120)::1,
        get_position_bit(fields, 121)::1, get_position_bit(fields, 122)::1, get_position_bit(fields, 123)::1, get_position_bit(fields, 124)::1, get_position_bit(fields, 125)::1, get_position_bit(fields, 126)::1, get_position_bit(fields, 127)::1, get_position_bit(fields, 128)::1
        >>

      end

      def build_msg(fields) do

        first_bit_value = case bit_more_than_64_exists?(fields) do
          true -> 1
          false -> 0
        end

        raw_bitmap = build_bitmap(fields, first_bit_value)
        formatted_bitmap = build_bitmap_to_format(unquote(bitmap_format), raw_bitmap)
        formatted_fields = build_fields(first_bit_value, fields)

        formatted_bitmap <> formatted_fields

      end

      defp build_bitmap_to_format(:bin, bitmap) do
        bitmap
      end

      defp build_bitmap_to_format(:ascii, bitmap) do
        Base.encode16(bitmap)
      end

      defp build_fields(0 = _first_bit_value, fields) do
        2..64
        |> Enum.reduce(<<>>, fn x, acc
          ->
            formed_field_val = Map.get(fields, x) |> build_field_if_exists(x)
            acc <> formed_field_val
          end)
      end

      defp build_fields(1 = _first_bit_value, fields) do
        2..128
        |> Enum.reduce(<<>>, fn x, acc
          ->
            formed_field_val = Map.get(fields, x) |> build_field_if_exists(x)
            acc <> formed_field_val
          end)
      end

      defp build_field_if_exists(nil = _field_value, _pos) do
        <<>>
      end

      defp build_field_if_exists(field_value, pos) do
        formed_value = form_field(pos, field_value)
        formed_value
      end

    end

  end


  defmacro def_all_match_bit() do

    quote do
      def get_bit_position(1, x), do: [x]
      def get_bit_position(0, _x), do: []

      def get_position_bit(fields, pos) do
        case Map.has_key?(fields, pos) do
          true -> 1
          false -> 0
        end
      end

      def bit_more_than_64_exists?(fields) do
        65..128
        |> Enum.any?(fn x -> Map.has_key?(fields, x) end)
      end

    end

  end

  defmacro def_parse_msg() do
    quote do
      def parse_msg(msg) do

        {list_of_bitpos, data} = parse_bmp_from_msg(msg)

        extract_data(list_of_bitpos, data, %{})

      end

      def extract_data([], msg, extracted_fields) do
        extracted_fields
      end

      def extract_data(list_of_bitpos, msg, extracted_fields) do

        [curr_pos | trailer_list_pos] = list_of_bitpos

        {pos, body_len, msg_trailer} = parse_header(curr_pos, msg)
        {pos, body_val, msg_trailer} = parse_body(curr_pos, body_len, msg_trailer)

        extracted_fields = Map.put(extracted_fields, pos, body_val)
        extract_data(trailer_list_pos, msg_trailer, extracted_fields)
      end


    end
  end


  defmacro def_parse_body(pos, data_type, encoding, max_data_length, _alignment) do

    quote do

      def parse_body(unquote(pos), body_len, data) do
        byte_length = translate_length_to_byte(unquote(data_type), unquote(encoding), body_len)
        <<body_val_bytes::binary-size(byte_length), rest::binary>> = data
        translated_data = translate_data_from_raw(unquote(data_type), unquote(encoding), body_val_bytes)
        translated_data = trim_data(translated_data, body_len)
        translated_data = truncate_data(translated_data, unquote(max_data_length))
        {unquote(pos), translated_data, rest}
      end

    end

  end

  defmacro def_form_body(pos, data_type, encoding, max_data_length, alignment, header_size, pad_char) do

    quote do
      def form_body(unquote(pos), field_val) do
        data_size = determine_data_size(field_val, unquote(data_type), unquote(encoding), unquote(header_size), unquote(max_data_length))

        truncated_data = truncate_data(field_val, data_size)
        padded_data = pad(truncated_data, unquote(data_type), data_size, unquote(pad_char), unquote(alignment))
        translated_data = translate_data_to_raw(unquote(data_type), unquote(encoding), padded_data)

        {unquote(pos), translated_data}
      end
    end
  end

  defmacro def_form_field(pos) do

    quote do
      def form_field(unquote(pos), field_value) do
        {_bitpos, body_value} = form_body(unquote(pos), field_value)
        {_bitpos, header_value} = form_header(unquote(pos), body_value)

        header_value <> body_value
      end
    end
  end

  # determine the size (fixed or not fixed)
  def determine_data_size(_field_val, dtype, :bcd, 0, max_data_length) when dtype in [:n, :z] do
    max_data_length + Integer.mod(max_data_length, 2)
  end

  def determine_data_size(_field_val, dtype, :ascii, 0, max_data_length) when dtype in [:n, :z] do
    max_data_length
  end

  def determine_data_size(field_val, dtype, :bcd, _head_size, max_data_length) when dtype in [:n, :z] and byte_size(field_val) > max_data_length do
    max_data_length + Integer.mod(max_data_length, 2)
  end

  def determine_data_size(field_val, dtype, :bcd, _head_size, max_data_length) when dtype in [:n, :z] and byte_size(field_val) <= max_data_length do
    byte_size(field_val) + Integer.mod(byte_size(field_val), 2)
  end

  def determine_data_size(field_val, dtype, :ascii, _head_size, max_data_length) when dtype in [:n, :z] and byte_size(field_val) > max_data_length do
    max_data_length
  end

  def determine_data_size(field_val, dtype, :ascii, _head_size, max_data_length) when dtype in [:n, :z] and byte_size(field_val) <= max_data_length do
    byte_size(field_val)
  end

  def determine_data_size(_field_val, _dtype, _encoding, 0, max_data_length) do
    max_data_length
  end

  def determine_data_size(field_val, _dtype, _encoding, _head_size, max_data_length) when byte_size(field_val) > max_data_length do
    max_data_length
  end

  def determine_data_size(field_val, _dtype, _encoding, _head_size, max_data_length) when byte_size(field_val) <= max_data_length do
    byte_size(field_val)
  end

  # not yet defined determine_data_size for the bit data




  def pad(field_val, dtype, required_length, pad_char, :left) when dtype in [:a, :n, :an, :as, :ns, :ans, :s, :z] do
    field_val
    |> String.pad_trailing(required_length, to_string([pad_char]))
  end

  def pad(field_val, dtype, required_length, pad_char, :right) when dtype in [:a, :n, :an, :as, :ns, :ans, :s, :z] do
    field_val
    |> String.pad_leading(required_length, to_string([pad_char]))
  end

  # not yet defined pad for the bit data






  defmacro define(pos, conf, opts \\ []) do

    conf = String.replace(conf, " ", "")
    {header_length, data_type, max_data_length} = match_conf(conf)

    header_encoding = Module.get_attribute(__CALLER__.module, :header_encoding)
    default_encoding = Module.get_attribute(__CALLER__.module, :default_encoding)
    default_alignment = Module.get_attribute(__CALLER__.module, :default_alignment)
    default_numeric_pad_char = Module.get_attribute(__CALLER__.module, :default_numeric_pad_char)
    default_alphanumeric_pad_char = Module.get_attribute(__CALLER__.module, :default_alphanumeric_pad_char)

    default_pad_char = case data_type do
      type when type in [:n, :z] -> default_numeric_pad_char
      _ -> default_alphanumeric_pad_char
    end

    field_encoding = if opts[:encoding], do: opts[:encoding], else: default_encoding
    alignment = if opts[:alignment], do: opts[:alignment], else: default_alignment
    pad_char = if opts[:pad_char], do: opts[:pad_char], else: default_pad_char

    header_format = {header_encoding, header_length, max_data_length}

    case header_format do

      {:bcd, 2, _max}
        ->
          quote do
            def parse_header(unquote(pos), <<w::4, x::4, rest::binary>> = data) do
              {unquote(pos), w*10+x, rest}
            end

            def_parse_body(unquote(pos), unquote(data_type), unquote(field_encoding), unquote(max_data_length), unquote(alignment))

            def form_header(unquote(pos), field_value) do
              data_size = byte_size(field_value)
              data_size_w = div(data_size, 10)
              data_size_x = rem(data_size, 10)
              header_val = <<data_size_w::4, data_size_x::4>>
              {unquote(pos), header_val}
            end

            def_form_body(unquote(pos), unquote(data_type), unquote(field_encoding), unquote(max_data_length), unquote(alignment), 2, unquote(pad_char))

            def_form_field(unquote(pos))
          end
      {:ascii, 2, _max}
        ->
          quote do
            def parse_header(unquote(pos), <<w::8, x::8, rest::binary>> = data) do
              {unquote(pos), (w-48)*10+(x-48), rest}
            end

            def_parse_body(unquote(pos), unquote(data_type), unquote(field_encoding), unquote(max_data_length), unquote(alignment))

            def form_header(unquote(pos), field_value) do
              data_size = byte_size(field_value)
              data_size_w = div(data_size, 10) + 48
              data_size_x = rem(data_size, 10) + 48
              header_val = <<data_size_w::8, data_size_x::8>>
              {unquote(pos), header_val}
            end

            def_form_body(unquote(pos), unquote(data_type), unquote(field_encoding), unquote(max_data_length), unquote(alignment), 2, unquote(pad_char))

            def_form_field(unquote(pos))

          end
      {:bcd, 3, _max}
        ->
          quote do
            def parse_header(unquote(pos), <<_w::4, x::4, y::4, z::4, rest::binary>> = data) do
              {unquote(pos), x*100+y*10+z, rest}
            end

            def_parse_body(unquote(pos), unquote(data_type), unquote(field_encoding), unquote(max_data_length), unquote(alignment))

            def form_header(unquote(pos), field_value) do
              data_size = byte_size(field_value)
              data_size_w = 0
              data_size_x = data_size |> div(100)
              data_size_y = data_size - (data_size_x*100) |> div(10)
              data_size_z = data_size - (data_size_x*100) - (data_size_y*10)
              header_val = <<data_size_w::4, data_size_x::4, data_size_y::4, data_size_z::4>>
              {unquote(pos), header_val}
            end

            def_form_body(unquote(pos), unquote(data_type), unquote(field_encoding), unquote(max_data_length), unquote(alignment), 3, unquote(pad_char))

            def_form_field(unquote(pos))

          end
      {:ascii, 3, _max}
        ->
        quote do
          def parse_header(unquote(pos), <<x::8, y::8, z::8, rest::binary>> = data) do
            {unquote(pos), (x-48)*100+(y-48)*10+(z-48), rest}
          end

          def_parse_body(unquote(pos), unquote(data_type), unquote(field_encoding), unquote(max_data_length), unquote(alignment))

          def form_header(unquote(pos), field_value) do
            data_size = byte_size(field_value)
            data_size_x = div(data_size, 100)
            data_size_y = data_size - (data_size_x*100) |> div(10)
            data_size_z = data_size - (data_size_x*100) - (data_size_y*10)

            data_size_x = data_size_x + 48
            data_size_y = data_size_y + 48
            data_size_z = data_size_z + 48
            header_val = <<data_size_x::8, data_size_y::8, data_size_z::8>>
            {unquote(pos), header_val}
          end

          def_form_body(unquote(pos), unquote(data_type), unquote(field_encoding), unquote(max_data_length), unquote(alignment), 3, unquote(pad_char))

          def_form_field(unquote(pos))

        end
      _
        ->
          quote do
            def parse_header(unquote(pos), data) do
              {unquote(pos), unquote(max_data_length), data}
            end

            def_parse_body(unquote(pos), unquote(data_type), unquote(field_encoding), unquote(max_data_length), unquote(alignment))

            def form_header(unquote(pos), field_value) do
              {unquote(pos), <<>>}
            end

            def_form_body(unquote(pos), unquote(data_type), unquote(field_encoding), unquote(max_data_length), unquote(alignment), 0, unquote(pad_char))

            def_form_field(unquote(pos))

          end
    end

  end


end
