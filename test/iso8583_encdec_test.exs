defmodule Iso8583EncdecTest do
  use ExUnit.Case
  doctest Iso8583Encdec

  test "dec 2 digit bcd" do
    bmp = "0000000000000003"
    msg = "0612345631323334"
    IO.inspect String.length(bmp)

    msg = bmp <> msg

    msg = Base.decode16!(msg)
    IO.inspect msg
    IO.inspect TestModule.parse_msg(msg)
  end
end
