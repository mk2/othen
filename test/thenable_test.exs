defmodule OthenThenableTest do
  use ExUnit.Case

  alias Othen.Thenable

  test "thenable" do

    Thenable.new(fn resolve, reject -> resolve.(:result) end)
            .(fn result -> assert result == :result end)
            .(fn result -> IO.puts "Before 1000 msec"; :timer.sleep(1000) end)
            .(fn result -> IO.puts "After 1000 msec" end)

    Thenable.new(fn resolve, reject -> IO.puts "First"; resolve.(:result); :timer.sleep(1000) end)
            .(fn result -> IO.puts "Second"; :timer.sleep(1000) end)
            .(fn result -> IO.puts "Third"; :timer.sleep(1000) end)

    Thenable.new(fn resolve, reject -> IO.puts "Reject First"; reject.(:err) end)
            .(fn result -> IO.puts "Reject Second"; :timer.sleep(1000) end)
            .(fn result -> IO.puts "Reject Third"; :timer.sleep(1000) end)
            .({:catch, fn err -> IO.puts "error: #{err}"; :timer.sleep(1000) end})

    Thenable.new(fn resolve, reject -> IO.puts "Reject First"; resolve.(:err) end)
            .(fn result -> IO.puts "Reject Second"; :timer.sleep(1000) end)
            .(fn result -> raise :"Error!!" end)
            .({:catch, fn err -> IO.puts "error: #{err}"; :timer.sleep(1000) end})
  end

end
