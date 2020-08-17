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
      Plug.Cowboy.http(
        Plug.Servirtium.Playback,
        [filename: "test/interactions/rainfall_1980_1999_gbr.md"],
        port: 34567
      )

      assert ClimateAPI.average_rainfall("localhost:34567", 1980, 1999, "GBR") ==
               {:ok, 988.8454972331015}

      Plug.Cowboy.shutdown(Plug.Servirtium.Playback.HTTP)
    end

    test "average French rainfall" do
      Plug.Cowboy.http(
        Plug.Servirtium.Playback,
        [filename: "test/interactions/rainfall_1980_1999_fra.md"],
        port: 34568
      )

      assert ClimateAPI.average_rainfall("localhost:34568", 1980, 1999, "FRA") ==
               {:ok, 913.7986955122727}

      Plug.Cowboy.shutdown(Plug.Servirtium.Playback.HTTP)
    end

    test "average Egyptian rainfall" do
      Plug.Cowboy.http(
        Plug.Servirtium.Playback,
        [filename: "test/interactions/rainfall_1980_1999_egy.md"],
        port: 34569
      )

      assert ClimateAPI.average_rainfall("localhost:34569", 1980, 1999, "EGY") ==
               {:ok, 54.58587712129825}

      Plug.Cowboy.shutdown(Plug.Servirtium.Playback.HTTP)
    end

    test "no data available for Great Britain from 1985 to 1995" do
      Plug.Cowboy.http(
        Plug.Servirtium.Playback,
        [filename: "test/interactions/rainfall_1985_1995_gbr.md"],
        port: 34570
      )

      assert ClimateAPI.average_rainfall("localhost:34570", 1985, 1995, "GBR") ==
               {:error, "No rainfall data found for years 1985 to 1995"}

      Plug.Cowboy.shutdown(Plug.Servirtium.Playback.HTTP)
    end

    test "Error Middle Earth isn't a real place" do
      Plug.Cowboy.http(
        Plug.Servirtium.Playback,
        [filename: "test/interactions/rainfall_1980_1999_mde.md"],
        port: 34571
      )

      assert ClimateAPI.average_rainfall("localhost:34571", 1980, 1999, "MDE") ==
               {:error, "Invalid country code"}

      Plug.Cowboy.shutdown(Plug.Servirtium.Playback.HTTP)
    end
  end

  describe "Servirtium pass through record mode" do
    test "average UK rainfall" do
      Plug.Cowboy.http(
        Plug.Servirtium.Recorder,
        [
          base_url: "http://climatedataapi.worldbank.org",
          filename: "test/interactions/rainfall_1980_1999_gbr_record.md"
        ],
        port: 34572
      )

      assert ClimateAPI.average_rainfall("localhost:34572", 1980, 1999, "GBR") ==
               {:ok, 988.8454972331015}

      Plug.Cowboy.shutdown(Plug.Servirtium.Recorder.HTTP)
    end

    test "average French rainfall" do
      Plug.Cowboy.http(
        Plug.Servirtium.Recorder,
        [
          base_url: "http://climatedataapi.worldbank.org",
          filename: "test/interactions/rainfall_1980_1999_fra_record.md"
        ],
        port: 34573
      )

      assert ClimateAPI.average_rainfall("localhost:34573", 1980, 1999, "FRA") ==
               {:ok, 913.7986955122727}

      Plug.Cowboy.shutdown(Plug.Servirtium.Recorder.HTTP)
    end

    test "average Egyptian rainfall" do
      Plug.Cowboy.http(
        Plug.Servirtium.Recorder,
        [
          base_url: "http://climatedataapi.worldbank.org",
          filename: "test/interactions/rainfall_1980_1999_egy_record.md"
        ],
        port: 34574
      )

      assert ClimateAPI.average_rainfall("localhost:34574", 1980, 1999, "EGY") ==
               {:ok, 54.58587712129825}

      Plug.Cowboy.shutdown(Plug.Servirtium.Recorder.HTTP)
    end

    test "no data available for Great Britain from 1985 to 1995" do
      Plug.Cowboy.http(
        Plug.Servirtium.Recorder,
        [
          base_url: "http://climatedataapi.worldbank.org",
          filename: "test/interactions/rainfall_1985_1995_gbr_record.md"
        ],
        port: 34575
      )

      assert ClimateAPI.average_rainfall("localhost:34575", 1985, 1995, "GBR") ==
               {:error, "No rainfall data found for years 1985 to 1995"}

      Plug.Cowboy.shutdown(Plug.Servirtium.Recorder.HTTP)
    end

    test "Error Middle Earth isn't a real place" do
      Plug.Cowboy.http(
        Plug.Servirtium.Recorder,
        [
          base_url: "http://climatedataapi.worldbank.org",
          filename: "test/interactions/rainfall_1980_1999_mde_record.md"
        ],
        port: 34576
      )

      assert ClimateAPI.average_rainfall("localhost:34576", 1980, 1999, "MDE") ==
               {:error, "Invalid country code"}

      Plug.Cowboy.shutdown(Plug.Servirtium.Recorder.HTTP)
    end
  end
end
