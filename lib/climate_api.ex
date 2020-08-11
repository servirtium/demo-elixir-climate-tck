defmodule ClimateAPI do
  use HTTPoison.Base
  import SweetXml

  @host "http://climatedataapi.worldbank.org"

  def process_request_url(url) do
    @host <> url
  end

  def process_response_body("Invalid country code" <> _), do: nil

  def process_response_body(body) do
    body
    |> xpath(~x"/list", rainfall: ~x".//annualData/double/text()"fl)
  end

  def path(from_year, to_year, country_code) do
    "/climateweb/rest/v1/country/annualavg/pr/#{from_year}/#{to_year}/#{country_code}.xml"
  end

  @spec average_rainfall(integer(), integer(), String.t()) :: float()
  def average_rainfall(from_year, to_year, country_code) do
    url = path(from_year, to_year, country_code)

    case get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: %{rainfall: rainfall_data}}} ->
        {:ok, Enum.sum(rainfall_data) / length(rainfall_data)}

      _ ->
        {:error, "No rainfall data found"}
    end
  end
end
