defmodule Iso8583Dec do

  defmacro __using__(opts) do
    header_enc = if opts[:header_encoding], do: opts[:header_encoding], else: :bcd
    numeric_enc = if opts[:default_numeric_encoding], do: opts[:default_numeric_encoding], else: :bcd
    track2_enc = if opts[:track2_encoding], do: opts[:track2_encoding], else: :bcd
    bitmap_format = if opts[:bitmap_format], do: opts[:bitmap_format], else: :bin

    Module.put_attribute(__CALLER__.module, :header_encoding, header_enc)
    Module.put_attribute(__CALLER__.module, :default_numeric_encoding, numeric_enc)
    Module.put_attribute(__CALLER__.module, :track2_encoding, track2_enc)
    Module.put_attribute(__CALLER__.module, :bitmap_format, bitmap_format)

    quote do
      require unquote(__MODULE__)
      import unquote(__MODULE__)

      def_all_match_bit()
      def_parse_bitmap()
      def_parse_msg()
    end

  end



  # bcd
  def translate_length(:n = _type, :bcd = _encoding, specified_len) do
    div(specified_len, 2)
  end

  def translate_length(:n = _type, :ascii = _encoding, specified_len) do
    specified_len
  end

  def translate_length(:b = _type, :bit = _encoding, specified_len) do
    div(specified_len, 8)
  end

  def translate_length(:b = _type, :bcd = _encoding, specified_len) do
    div(specified_len, 2)
  end

  def translate_length(:b = _type, :ascii = _encoding, specified_len) do
    specified_len*2
  end

  def translate_length(:z = _type, :bcd = _encoding, specified_len) do
    div(specified_len + Integer.mod(specified_len, 2), 2) # make it even
  end

  def translate_length(:z = _type, :ascii = _encoding, specified_len) do
    div(specified_len + Integer.mod(specified_len, 2), 2)
  end

  def translate_length(_type, _encoding, specified_len) do
    specified_len
  end



  def translate_data(:n, :bcd, :bcd, data) do
    Base.encode16(data)
  end

  def translate_data(:n, :bcd, :ascii, data) do
    data
  end

  def translate_data(:z, :bcd, _numeric_encoding, data) do
    Base.encode16(data)
  end

  def translate_data(_data_type, :bcd, _numeric_encoding, data) do
    data
  end

  def translate_data(_data_type, :ascii, _numeric_encoding, data) do
    data
  end

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

        result = match_bit(b2, 2) ++ match_bit(b3, 3) ++ match_bit(b4, 4) ++ match_bit(b5, 5) ++ match_bit(b6, 6) ++ match_bit(b7, 7) ++ match_bit(b8, 8) ++ match_bit(b9, 9) ++ match_bit(b10, 10)
        ++ match_bit(b11, 11) ++ match_bit(b12, 12) ++ match_bit(b13, 13) ++ match_bit(b14, 14) ++ match_bit(b15, 15) ++ match_bit(b16, 16) ++ match_bit(b17, 17) ++ match_bit(b18, 18) ++ match_bit(b19, 19) ++ match_bit(b20, 20)
        ++ match_bit(b21, 21) ++ match_bit(b22, 22) ++ match_bit(b23, 23) ++ match_bit(b24, 24) ++ match_bit(b25, 25) ++ match_bit(b26, 26) ++ match_bit(b27, 27) ++ match_bit(b28, 28) ++ match_bit(b29, 29) ++ match_bit(b30, 30)
        ++ match_bit(b31, 31) ++ match_bit(b32, 32) ++ match_bit(b33, 33) ++ match_bit(b34, 34) ++ match_bit(b35, 35) ++ match_bit(b36, 36) ++ match_bit(b37, 37) ++ match_bit(b38, 38) ++ match_bit(b39, 39) ++ match_bit(b30, 30)
        ++ match_bit(b41, 41) ++ match_bit(b42, 42) ++ match_bit(b43, 43) ++ match_bit(b44, 44) ++ match_bit(b45, 45) ++ match_bit(b46, 46) ++ match_bit(b47, 47) ++ match_bit(b48, 48) ++ match_bit(b49, 49) ++ match_bit(b50, 50)
        ++ match_bit(b51, 51) ++ match_bit(b52, 52) ++ match_bit(b53, 53) ++ match_bit(b54, 54) ++ match_bit(b55, 55) ++ match_bit(b56, 56) ++ match_bit(b57, 57) ++ match_bit(b58, 58) ++ match_bit(b59, 59) ++ match_bit(b60, 60)
        ++ match_bit(b61, 61) ++ match_bit(b62, 62) ++ match_bit(b63, 63) ++ match_bit(b64, 64)

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

        result = match_bit(b2, 2) ++ match_bit(b3, 3) ++ match_bit(b4, 4) ++ match_bit(b5, 5) ++ match_bit(b6, 6) ++ match_bit(b7, 7) ++ match_bit(b8, 8) ++ match_bit(b9, 9) ++ match_bit(b10, 10)
        ++ match_bit(b11, 11) ++ match_bit(b12, 12) ++ match_bit(b13, 13) ++ match_bit(b14, 14) ++ match_bit(b15, 15) ++ match_bit(b16, 16) ++ match_bit(b17, 17) ++ match_bit(b18, 18) ++ match_bit(b19, 19) ++ match_bit(b20, 20)
        ++ match_bit(b21, 21) ++ match_bit(b22, 22) ++ match_bit(b23, 23) ++ match_bit(b24, 24) ++ match_bit(b25, 25) ++ match_bit(b26, 26) ++ match_bit(b27, 27) ++ match_bit(b28, 28) ++ match_bit(b29, 29) ++ match_bit(b30, 30)
        ++ match_bit(b31, 31) ++ match_bit(b32, 32) ++ match_bit(b33, 33) ++ match_bit(b34, 34) ++ match_bit(b35, 35) ++ match_bit(b36, 36) ++ match_bit(b37, 37) ++ match_bit(b38, 38) ++ match_bit(b39, 39) ++ match_bit(b40, 40)
        ++ match_bit(b41, 41) ++ match_bit(b42, 42) ++ match_bit(b43, 43) ++ match_bit(b44, 44) ++ match_bit(b45, 45) ++ match_bit(b46, 46) ++ match_bit(b47, 47) ++ match_bit(b48, 48) ++ match_bit(b49, 49) ++ match_bit(b50, 50)
        ++ match_bit(b51, 51) ++ match_bit(b52, 52) ++ match_bit(b53, 53) ++ match_bit(b54, 54) ++ match_bit(b55, 55) ++ match_bit(b56, 56) ++ match_bit(b57, 57) ++ match_bit(b58, 58) ++ match_bit(b59, 59) ++ match_bit(b60, 60)
        ++ match_bit(b61, 61) ++ match_bit(b62, 62) ++ match_bit(b63, 63) ++ match_bit(b64, 64) ++ match_bit(b65, 65) ++ match_bit(b66, 66) ++ match_bit(b67, 67) ++ match_bit(b68, 68) ++ match_bit(b69, 69) ++ match_bit(b70, 70)
        ++ match_bit(b71, 71) ++ match_bit(b72, 72) ++ match_bit(b73, 73) ++ match_bit(b74, 74) ++ match_bit(b75, 75) ++ match_bit(b76, 76) ++ match_bit(b77, 77) ++ match_bit(b78, 78) ++ match_bit(b79, 79) ++ match_bit(b80, 80)
        ++ match_bit(b81, 81) ++ match_bit(b82, 82) ++ match_bit(b83, 83) ++ match_bit(b84, 84) ++ match_bit(b85, 85) ++ match_bit(b86, 86) ++ match_bit(b87, 87) ++ match_bit(b88, 88) ++ match_bit(b89, 89) ++ match_bit(b90, 90)
        ++ match_bit(b91, 91) ++ match_bit(b92, 92) ++ match_bit(b93, 93) ++ match_bit(b94, 94) ++ match_bit(b95, 95) ++ match_bit(b96, 96) ++ match_bit(b97, 97) ++ match_bit(b98, 98) ++ match_bit(b99, 99) ++ match_bit(b100, 100)
        ++ match_bit(b101, 101) ++ match_bit(b102, 102) ++ match_bit(b103, 103) ++ match_bit(b104, 104) ++ match_bit(b105, 105) ++ match_bit(b106, 106) ++ match_bit(b107, 107) ++ match_bit(b108, 108) ++ match_bit(b109, 109) ++ match_bit(b110, 110)
        ++ match_bit(b111, 111) ++ match_bit(b112, 112) ++ match_bit(b113, 113) ++ match_bit(b114, 114) ++ match_bit(b115, 115) ++ match_bit(b116, 116) ++ match_bit(b117, 117) ++ match_bit(b118, 118) ++ match_bit(b119, 119) ++ match_bit(b120, 120)
        ++ match_bit(b121, 121) ++ match_bit(b122, 122) ++ match_bit(b123, 123) ++ match_bit(b124, 124) ++ match_bit(b125, 125) ++ match_bit(b126, 126) ++ match_bit(b127, 127) ++ match_bit(b128, 128)

        {result, data}

      end

    end

  end


  defmacro def_all_match_bit() do

    quote do
      def match_bit(1, x), do: [x]
      def match_bit(0, _x), do: []
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

        IO.inspect "curr_post: #{curr_pos}"
        IO.inspect "body_len: #{body_len}"
        IO.inspect "msg_trailer: #{Base.encode16(msg_trailer)}"

        {pos, body_val, msg_trailer} = parse_body(curr_pos, body_len, msg_trailer)

        #{pos, result} = parse(curr_pos, msg_trailer)

        #{:ok, field_val, trailer_msg} = result
        extracted_fields = Map.put(extracted_fields, pos, body_val)
        extract_data(trailer_list_pos, msg_trailer, extracted_fields)
      end


    end
  end

  @spec def_parse_body(any(), any(), any(), any(), any()) ::
          {:def,
           [
             {:context, Iso8583Dec}
             | {:do, [...]}
             | {:end, [...]}
             | {:end_of_expression, [...]}
             | {:imports, [...]},
             ...
           ], [[{any(), any()}, ...] | {:parse_body, [...], [...]}, ...]}
  defmacro def_parse_body(pos, data_type, default_encoding, default_numeric_encoding, max_data_length) do

    quote do

      def parse_body(unquote(pos), body_len, data) do
        byte_length = translate_length(unquote(data_type), unquote(default_encoding), body_len)
        IO.inspect("byte_length: #{byte_length}")
        <<body_val_bytes::binary-size(byte_length), rest::binary>> = data
        translated_data = translate_data(unquote(data_type), unquote(default_encoding), unquote(default_numeric_encoding), body_val_bytes)
        translated_data = trim_data(translated_data, body_len)
        translated_data = truncate_data(translated_data, unquote(max_data_length))
        IO.inspect(translated_data)
        {unquote(pos), translated_data, rest}
      end

    end

  end


  defmacro define(pos, conf) do

    conf = String.replace(conf, " ", "")
    {header_length, data_type, max_data_length} = match_conf(conf)

    header_encoding = Module.get_attribute(__CALLER__.module, :header_encoding)
    default_numeric_encoding = Module.get_attribute(__CALLER__.module, :default_numeric_encoding)
    track2_encoding = Module.get_attribute(__CALLER__.module, :track2_encoding)

    data_bytes_length = translate_length(data_type, default_numeric_encoding, max_data_length)
    header_format = {header_encoding, header_length, data_bytes_length, max_data_length}
    header_format2 = {header_encoding, header_length, max_data_length}

    case header_format2 do

      {:bcd, 2, _max}
        ->
          quote do
            def parse_header(unquote(pos), <<w::4, x::4, rest::binary>> = data) do
              {unquote(pos), w*10+x, rest}
            end

            def_parse_body(unquote(pos), unquote(data_type), unquote(default_numeric_encoding), unquote(default_numeric_encoding), unquote(max_data_length))
          end
      {:ascii, 2, _max}
        ->
          quote do
            def parse_header(unquote(pos), <<w::8, x::8, rest::binary>> = data) do
              {unquote(pos), (w-48)*10+(x-48), rest}
            end

            def_parse_body(unquote(pos), unquote(data_type), unquote(default_numeric_encoding), unquote(default_numeric_encoding), unquote(max_data_length))

          end
      {:bcd, 3, _max}
        ->
          quote do
            def parse_header(unquote(pos), <<_w::4, x::4, y::4, z::4, rest::binary>> = data) do
              {unquote(pos), x*100+y*10+z, rest}
            end

            def_parse_body(unquote(pos), unquote(data_type), unquote(default_numeric_encoding), unquote(default_numeric_encoding), unquote(max_data_length))

          end
      {:ascii, 3, _max}
        ->
        quote do
          def parse_header(unquote(pos), <<x::8, y::8, z::8, rest::binary>> = data) do
            {unquote(pos), (x-48)*100+(y-48)*10+(z-48), rest}
          end

          def_parse_body(unquote(pos), unquote(data_type), unquote(default_numeric_encoding), unquote(default_numeric_encoding), unquote(max_data_length))

        end
      _
        ->
          quote do
            def parse_header(unquote(pos), data) do
              {unquote(pos), unquote(max_data_length), data}
            end

            def_parse_body(unquote(pos), unquote(data_type), unquote(default_numeric_encoding), unquote(default_numeric_encoding), unquote(max_data_length))

          end
    end

    # case header_format do
    #  {:bcd, 2, _data_bytes_length, max_data_length}
    #     ->
    #      quote do
    #        def parse(unquote(pos), <<w::4, x::4, rest::binary>> = data) do
    #          body_len_ori = w*10+x
    #          body_len = translate_length(unquote(data_type), unquote(default_numeric_encoding), body_len_ori)
    #          <<body_val::binary-size(body_len), rest::binary>> = rest
    #          translated_data = translate_data(unquote(data_type), unquote(header_encoding), unquote(default_numeric_encoding), body_val)
    #          # follows the header length
    #          translated_data = trim_data(translated_data, body_len_ori)
    #          # truncate too long data
    #          translated_data = truncate_data(translated_data, unquote(max_data_length))

    #          {unquote(pos), {:ok, translated_data, rest}}
    #        end
    #      end
    #   {:ascii, 2, _data_bytes_length, max_data_length}
    #      ->
    #       quote do
    #         def parse(unquote(pos), <<w::8, x::8, rest::binary>> = data) do
    #           body_len_ori = (w-48)*10+(x-48)
    #           body_len = translate_length(unquote(data_type), unquote(default_numeric_encoding), body_len_ori)
    #           <<body_val::binary-size(body_len), rest::binary>> = rest
    #           translated_data = translate_data(unquote(data_type), unquote(header_encoding), unquote(default_numeric_encoding), body_val)
    #           # follows the header length
    #           translated_data = trim_data(translated_data, body_len_ori)
    #           # truncate too long data
    #           translated_data = truncate_data(translated_data, unquote(max_data_length))

    #           {unquote(pos), {:ok, translated_data, rest}}
    #         end
    #       end
    #   {:bcd, 3, _data_bytes_length, max_data_length}
    #     ->
    #      quote do
    #        def parse(unquote(pos), <<_w::4, x::4, y::4, z::4, rest::binary>> = data) do
    #         body_len_ori = x*100+y*10+z
    #          body_len = translate_length(unquote(data_type), unquote(default_numeric_encoding), body_len_ori)
    #          <<body_val::binary-size(body_len), rest::binary>> = rest
    #          translated_data = translate_data(unquote(data_type), unquote(header_encoding), unquote(default_numeric_encoding), body_val)
    #          # follows the header length
    #          translated_data = trim_data(translated_data, body_len_ori)
    #          # truncate too long data
    #          translated_data = truncate_data(translated_data, unquote(max_data_length))
    #          {unquote(pos), {:ok, translated_data, rest}}
    #        end
    #      end
    #   {:ascii, 3, _data_bytes_length, max_data_length}
    #      ->
    #       quote do
    #         def parse(unquote(pos), <<x::8, y::8, z::8, rest::binary>> = data) do
    #           body_len_ori = (x-48)*100+(y-48)*10+(z-48)
    #           body_len = translate_length(unquote(data_type), unquote(default_numeric_encoding), body_len_ori)
    #           <<body_val::binary-size(body_len), rest::binary>> = rest
    #           translated_data = translate_data(unquote(data_type), unquote(header_encoding), unquote(default_numeric_encoding), body_val)
    #           # follows the header length
    #           translated_data = trim_data(translated_data, body_len_ori)
    #           # truncate too long data
    #           translated_data = truncate_data(translated_data, unquote(max_data_length))
    #           {unquote(pos), {:ok, translated_data, rest}}
    #         end
    #       end
    #   {_header_encoding, 0, data_bytes_length, _max_data_length}
    #     ->
    #     quote do
    #       def parse(unquote(pos), <<field_value::binary-size(unquote(data_bytes_length))>> <> data_remaining = data) do
    #         translated_data = translate_data(unquote(data_type), unquote(header_encoding), unquote(default_numeric_encoding), field_value)
    #         {unquote(pos), {:ok, translated_data, data_remaining}}
    #       end
    #     end
    #   _ ->
    #     quote do
    #        def parse(unquote(pos), <<field_value::binary-size>> <> data_remaining = data) do
    #          translated_data = translate_data(unquote(data_type), unquote(header_encoding), unquote(default_numeric_encoding), field_value)
    #          translated_data = truncate_data(translated_data, unquote(max_data_length))
    #          {unquote(pos), {:ok, translated_data, data_remaining}}
    #        end
    #      end
    # end

    #quote do
    #  def parse(unquote(pos), <<field_value::binary-size(unquote(data_length))>> <> data_remaining = data) do
    #    {unquote(pos), {:ok, Base.encode16(field_value), data_remaining}}
    #  end
    #
    #  def parse(unquote(pos), data) do
    #    {unquote(pos), {:error, "failed to parse data", data}}
    #  end
    #end

  end


end
