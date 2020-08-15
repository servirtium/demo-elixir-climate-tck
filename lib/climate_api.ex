defmodule ClimateAPI do
  import SweetXml

  @host "http://climatedataapi.worldbank.org"

  def path(from_year, to_year, country_code) do
    "/climateweb/rest/v1/country/annualavg/pr/#{from_year}/#{to_year}/#{country_code}.xml"
  end

  @spec average_rainfall(integer(), integer(), String.t()) :: float()
  def average_rainfall(domain \\ @host, from_year, to_year, country_code) do
    url = domain <> path(from_year, to_year, country_code)

    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: "Invalid country code" <> _}} ->
        {:error, "Invalid country code"}

      {:ok, %HTTPoison.Response{status_code: _, body: body}} ->
        case body |> xpath(~x"/list//annualData/double/text()"fl) do
          [] -> {:error, "No rainfall data found for years #{from_year} to #{to_year}"}
          rainfall_data -> {:ok, Enum.sum(rainfall_data) / length(rainfall_data)}
        end

      _ ->
        {:error, "No rainfall data found for years #{from_year} to #{to_year}"}
    end
  end
end
