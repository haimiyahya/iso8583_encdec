defmodule Iso8583Dec do

  defmacro __using__(opts) do
    val = if opts[:encoding], do: opts[:encoding], else: :bcd

    Module.put_attribute(__CALLER__.module, :encoding, val)

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
             translated_data = Generator.translate_data(unquote(encoding), field_value)
             {unquote(pos), {:ok, translated_data, data_remaining}}
           end
         end
     {2, max_data_len}
        ->
         quote do
           def parse(unquote(pos), <<w::4, x::4, rest::binary>> = data) do
             body_len = div(w*10+x, 2)
             <<body_val::binary-size(body_len), rest::binary>> = rest
             translated_data = Generator.translate_data(unquote(encoding), body_val)
             {unquote(pos), {:ok, translated_data, rest}}
           end
         end
     {3, max_data_len}
        ->
         quote do
           def parse(unquote(pos), <<_w::4, x::4, y::4, z::4, rest::binary>> = data) do
             body_len = div(x*100+y*10+z, 2)
             <<body_val::binary-size(body_len), rest::binary>> = rest
             translated_data = Generator.translate_data(unquote(encoding), body_val)
             {unquote(pos), {:ok, translated_data, rest}}
           end
         end
      _ ->
        quote do
           def parse(unquote(pos), <<field_value::binary-size>> <> data_remaining = data) do
             translated_data = Generator.translate_data(unquote(encoding), field_value)
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
