defmodule ClimateAPITest do
  use ExUnit.Case

  describe "Call remote server" do
    test "average UK rainfall" do
      assert ClimateAPI.average_rainfall(1980, 1999, "GBR") == {:ok, 988.8454972331015}
    end

    test "average French rainfall" do
      assert ClimateAPI.average_rainfall(1980, 1999, "FRA") == {:ok, 913.7986955122727}
    end

    test "average Egypt rainfall" do
      assert ClimateAPI.average_rainfall(1980, 1999, "EGY") == {:ok, 54.58587712129825}
    end

    test "no data available for Great Britain from 1985 to 1995" do
      assert ClimateAPI.average_rainfall(1985, 1995, "GBR") ==
               {:error, "No rainfall data found for years 1985 to 1995"}
    end

    test "Error Middle Earth isn't a real place" do
      assert ClimateAPI.average_rainfall(1980, 1999, "MDE") == {:error, "Invalid country code"}
    end
  end

  describe "Servirtium playback mode" do
    test "average UK rainfall" do
      Plug.Cowboy.http(Servirtium, [playback: "test/interactions/rainfall_1980_1999_gbr.md"],
        port: 34567
      )

      assert ClimateAPI.average_rainfall("localhost:34567", 1980, 1999, "GBR") ==
               {:ok, 988.8454972331015}

      Plug.Cowboy.shutdown(Servirtium.HTTP)
    end

    test "average French rainfall" do
      Plug.Cowboy.http(Servirtium, [playback: "test/interactions/rainfall_1980_1999_fra.md"],
        port: 34568
      )

      assert ClimateAPI.average_rainfall("localhost:34568", 1980, 1999, "FRA") ==
               {:ok, 913.7986955122727}

      Plug.Cowboy.shutdown(Servirtium.HTTP)
    end

    test "average Egyptian rainfall" do
      Plug.Cowboy.http(Servirtium, [playback: "test/interactions/rainfall_1980_1999_egy.md"],
        port: 34569
      )

      assert ClimateAPI.average_rainfall("localhost:34569", 1980, 1999, "EGY") ==
               {:ok, 54.58587712129825}

      Plug.Cowboy.shutdown(Servirtium.HTTP)
    end

    test "no data available for Great Britain from 1985 to 1995" do
      Plug.Cowboy.http(Servirtium, [playback: "test/interactions/rainfall_1985_1995_gbr.md"],
        port: 34570
      )

      assert ClimateAPI.average_rainfall("localhost:34570", 1985, 1995, "GBR") ==
               {:error, "No rainfall data found for years 1985 to 1995"}

      Plug.Cowboy.shutdown(Servirtium.HTTP)
    end

    test "Error Middle Earth isn't a real place" do
      Plug.Cowboy.http(Servirtium, [playback: "test/interactions/rainfall_1980_1999_mde.md"],
        port: 34571
      )

      assert ClimateAPI.average_rainfall("localhost:34571", 1980, 1999, "MDE") ==
               {:error, "Invalid country code"}

      Plug.Cowboy.shutdown(Servirtium.HTTP)
    end
  end
end
