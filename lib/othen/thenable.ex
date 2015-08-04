defmodule Othen.Thenable do

  def new(fun) when is_function(fun, 2) do

    IO.puts "FUNCTION HANDLER"

    resolve = fn result -> {:resolve, result} end
    reject  = fn err    -> {:reject,  err}    end

    fn nextFun ->
      case fun.(resolve, reject) do
        {:reject, err} ->
          __MODULE__.rejected(nextFun, err)
        {:resolve, result} ->
          __MODULE__.then(nextFun, result)
        any ->
          __MODULE__.then(nextFun, any)
      end
    end

  end

  def new(value) when not is_function(value) do

    IO.puts "VALUE HANDLER"

    fn nextFun ->
      __MODULE__.then(nextFun, value)
    end

  end

  def then(value) when not is_function(value) do

    IO.puts "VALUE HANDLER"

    fn nextFun ->
      __MODULE__.then(nextFun, value)
    end

  end

  def then(fun, value) when is_function(fun, 1) do

    fn nextFun ->
      case fun.(value) do
        {:reject, err} ->
          __MODULE__.rejected(nextFun, err)
        {:resolve, result} ->
          __MODULE__.then(nextFun, result)
        any ->
          __MODULE__.then(nextFun, any)
      end
    end

  end

  def then({:done, fun}, value) do

    fn nextFun ->
      case fun.(value) do
        {:reject, err} ->
          __MODULE__.rejected(nextFun, err)
        {:resolve, result} ->
          __MODULE__.then(nextFun, result)
        any ->
          __MODULE__.then(nextFun, any)
      end
    end

  end

  def rejected({:catch, fun}, err) when is_function(fun) do

    IO.puts "REJECTED ERROR HANDLER"

    fun.(err)

  end

  def rejected(_, err) do

    IO.puts "REJECTED ANY HANDLER"

    fn nextFun ->
      __MODULE__.rejected(nextFun, err)
    end

  end

  defp doFun(fun, value) do

    try do
      result = fun.(value)
      {:resolve, result}
    catch
      _, err ->
        {:reject, err}
    end

  end

end
