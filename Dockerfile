# Base image
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app


# Build image
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /source

COPY ["src/Application/Application.csproj", "./Application/Application.csproj"]
COPY ["src/Domain/Domain.csproj", "./Domain/Domain.csproj"]
COPY ["src/Infrastructure/Infrastructure.csproj", "./Infrastructure/Infrastructure.csproj"]
COPY ["src/WebApp/WebApp.csproj", "./WebApp/WebApp.csproj"]

RUN dotnet restore "./WebApp/WebApp.csproj"

COPY src/Application ./Application
COPY src/Domain ./Domain
COPY src/Infrastructure ./Infrastructure
COPY src/WebApi ./WebApi

RUN dotnet publish "./WebApp/WebApp.csproj" -c Release -o /app/publish


# Runtime image
FROM base AS final

WORKDIR /app

COPY --from=build /app/publish .
ENTRYPOINT ["dotnet", "WebApp.dll"]
