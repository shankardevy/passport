defmodule Passport do
  defmacro __using__(_) do
    quote do
      import Passport.Plug
    end
  end
end
