# Stage 1: Build
FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /src

# Copy csproj and restore as distinct layers
COPY ["BlazorFileUpload/BlazorFileUpload.csproj", "BlazorFileUpload/"]
RUN dotnet restore "BlazorFileUpload/BlazorFileUpload.csproj"

# Copy the rest of the code
COPY . .
WORKDIR "/src/BlazorFileUpload"
RUN dotnet build "BlazorFileUpload.csproj" -c Release -o /app/build

# Stage 2: Publish
FROM build AS publish
RUN dotnet publish "BlazorFileUpload.csproj" -c Release -o /app/publish /p:UseAppHost=false

# Stage 3: Runtime
FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS final
WORKDIR /app
COPY --from=publish /app/publish .
EXPOSE 80
EXPOSE 443
ENTRYPOINT ["dotnet", "BlazorFileUpload.dll"]

