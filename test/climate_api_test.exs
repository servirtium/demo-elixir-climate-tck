defmodule ClimateAPITest do
  use ExUnit.Case
  import ClimateAPI

  test "average UK rainfall " do
    assert average_rainfall(1980, 1999, "GBR") == {:ok, 988.8454972331015}
  end

  test "average French rainfall " do
    assert average_rainfall(1980, 1999, "FRA") == {:ok, 913.7986955122727}
  end

  test "average Egypt rainfall " do
    assert average_rainfall(1980, 1999, "EGY") == {:ok, 54.58587712129825}
  end

  test "for Great Britain from 1985 to 1995" do
    assert average_rainfall(1985, 1985, "GBR") == {:error, "No rainfall data found"}
  end

  test "for Middle Earth" do
    assert average_rainfall(1980, 1999, "MDE") == {:error, "No rainfall data found"}
  end
end
