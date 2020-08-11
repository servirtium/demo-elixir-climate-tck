defmodule ClimateAPITest do
  use ExUnit.Case

  test "average UK rainfall " do
    assert ClimateAPI.average_rainfall(1980, 1999, "GBR") == 988.8454972331015
  end

  test "average French rainfall " do
    assert ClimateAPI.average_rainfall(1980, 1999, "FRA") == 913.7986955122727
  end

  test "average Egypt rainfall " do
    assert ClimateAPI.average_rainfall(1980, 1999, "EGY") == 54.58587712129825
  end
end
