defmodule Iso8583Dec do

  defmacro __using__(opts) do
    val = if opts[:encoding], do: opts[:encoding], else: :bcd

    Module.put_attribute(__CALLER__.module, :encoding, val)

    quote do
      require Iso8583Dec
      import Iso8583Dec

      def_all_match_bit()
      def_parse_bitmap()
    end

  end



  # bcd
  def translate_length(:bcd = _header_type, :n = _data_type, spec_length) do
    div(spec_length, 2)
  end

  def translate_length(:bcd = _header_type, :b = _data_type, spec_length) do
  # ans, anp, an, as, ns, x+n, a, n, s, b, p, z
  div(spec_length, 8)
  end

  def translate_length(:bcd = _header_type, :z = _data_type, spec_length) do
    div(spec_length + Integer.mod(spec_length, 2), 2)
  end

  def translate_length(:bcd = _header_type, _data_type, spec_length) do
    spec_length
  end

  # ascii
  def translate_length(:ascii = _header_type, :n = _data_type, spec_length) do
    div(spec_length, 2)
  end

  def translate_length(:ascii = _header_type, :b = _data_type, spec_length) do
  # ans, anp, an, as, ns, x+n, a, n, s, b, p, z
  div(spec_length, 8)
  end

  def translate_length(:ascii = _header_type, :z = _data_type, spec_length) do
    div(spec_length + Integer.mod(spec_length, 2), 2)
  end

  def translate_length(:ascii = _header_type, _data_type, spec_length) do
    spec_length
  end



  def translate_data(:bcd, data) do
    Base.encode16(data)
  end

  def translate_data(:ascii, data) do
    data
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
    quote location: :keep do

      def parse_bitmap(
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

      def parse_bitmap(
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


  defmacro def_matched_bit(pos) do
    quote do
      def match_bit(1, unquote(pos)) do
        [unquote(pos)]
      end
    end
  end

  defmacro def_unmatched_bit() do
    quote do
      def match_bit(0, _pos) do
        []
      end
    end
  end

  defmacro def_all_match_bit() do

    quote location: :keep do
      2..128
      |> Enum.map(fn x -> def_matched_bit(x) end)

      def_unmatched_bit()
    end

  end


  defmacro define(pos, conf) do

    # the conf supplied must follow like this example:
    # n..19
    #
    conf = String.replace(conf, " ", "")
    {header_length, data_type, max_data_length} = match_conf(conf)

    encoding = Module.get_attribute(__CALLER__.module, :encoding)

    translated_length = translate_length(encoding, data_type, max_data_length)
    header_format = {header_length, translated_length}

    case header_format do
      {0, max_data_len}
        ->
         quote do
           def parse(unquote(pos), <<field_value::binary-size(unquote(max_data_len))>> <> data_remaining = data) do
             translated_data = translate_data(unquote(encoding), field_value)
             {unquote(pos), {:ok, translated_data, data_remaining}}
           end
         end
     {2, max_data_len}
        ->
         quote do
           def parse(unquote(pos), <<w::4, x::4, rest::binary>> = data) do
             body_len = div(w*10+x, 2)
             <<body_val::binary-size(body_len), rest::binary>> = rest
             translated_data = translate_data(unquote(encoding), body_val)
             {unquote(pos), {:ok, translated_data, rest}}
           end
         end
     {3, max_data_len}
        ->
         quote do
           def parse(unquote(pos), <<_w::4, x::4, y::4, z::4, rest::binary>> = data) do
             body_len = div(x*100+y*10+z, 2)
             <<body_val::binary-size(body_len), rest::binary>> = rest
             translated_data = translate_data(unquote(encoding), body_val)
             {unquote(pos), {:ok, translated_data, rest}}
           end
         end
      _ ->
        quote do
           def parse(unquote(pos), <<field_value::binary-size>> <> data_remaining = data) do
             translated_data = translate_data(unquote(encoding), field_value)
             {unquote(pos), {:ok, translated_data, data_remaining}}
           end
         end
    end

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
