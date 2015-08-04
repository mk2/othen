defmodule Othen do

  alias Othen.Thenable

  def new(fun) do
    Thenable.new(fun)
  end

  def resolve(value) when not is_function(value) do
    Thenable.new(value)
  end

  def reject(err) do
    Thenable.rejected(nil, err)
  end

  def all(thenables) do
  end

  def race(thenables) do

  end

end
