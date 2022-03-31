defmodule Swampland.OneUf do
  def watch_term(term) do
    Swampland.OneUf.Producer.watch_term(term)
  end

  def unwatch_term() do
    Swampland.OneUf.Producer.watch_term(nil)
  end
end
