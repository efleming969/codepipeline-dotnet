FROM microsoft/dotnet:2.0-sdk AS build
WORKDIR /app

# copy csproj and restore as distinct layers
COPY *.sln .
COPY acme.web/*.csproj ./acme.web/
RUN dotnet restore

# copy everything else and build app
COPY acme.web/. ./acme.web/
WORKDIR /app/acme.web
RUN dotnet publish -o out /p:PublishWithAspNetCoreTargetManifest="false"

FROM microsoft/dotnet:2.0-runtime
ENV ASPNETCORE_URLS http://+:80
WORKDIR /app
COPY --from=build /app/acme.web/out ./
ENTRYPOINT ["dotnet", "acme.web.dll"]
