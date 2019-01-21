FROM microsoft/dotnet:2.1-aspnetcore-runtime AS base
WORKDIR /app
EXPOSE 80

FROM microsoft/dotnet:2.1-sdk AS build
WORKDIR /src
COPY ["GithubCI/GithubCI.csproj", "GithubCI/"]
RUN dotnet restore "GithubCI/GithubCI.csproj"
COPY . .
WORKDIR "/src/GithubCI"
RUN dotnet build "GithubCI.csproj" -c Release -o /app

FROM build AS publish
RUN dotnet publish "GithubCI.csproj" -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "GithubCI.dll"]