defmodule TestModule do
  use Iso8583Dec, header_encoding: :bcd,
    bitmap_format: :bin

  define(63, "n.. 6")
  define(64, "an 4")


end
