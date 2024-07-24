# Base runtime image
FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

# Build stage
FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /BlazorFileUpload

# Copy project files and restore dependencies
COPY ["BlazorFileupload/BlazorFileupload.csproj", "BlazorFileupload/"]
COPY ["UploadFilesLibrary/UploadFilesLibrary.csproj", "UploadFilesLibrary/"]
RUN dotnet restore "BlazorFileupload/BlazorFileupload.csproj"

# Copy the rest of the code and build the application
COPY . .
WORKDIR "/BlazorFileupload/BlazorFileupload"
RUN dotnet build "BlazorFileupload.csproj" -c Release -o /app/build

# Publish stage
FROM build AS publish
RUN dotnet publish "BlazorFileupload.csproj" -c Release -o /app/publish /p:UseAppHost=false

# Final runtime image
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "BlazorFileupload.dll"]
