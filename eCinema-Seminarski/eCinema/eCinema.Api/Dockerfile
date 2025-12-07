FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS base
WORKDIR /app

FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /src
COPY . .

FROM build AS publish
RUN dotnet publish "eCinema.Api/eCinema.Api.csproj" -c Release -o /app

COPY eCinema.Api/Data /app/Data

FROM base AS final
WORKDIR /app
COPY --from=publish /app .

ENTRYPOINT ["dotnet", "eCinema.Api.dll", "--urls", "http://0.0.0.0:80"]
