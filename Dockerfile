#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS base
WORKDIR /app
EXPOSE 8080
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /BlazorFileUpload
COPY ["BlazorFileupload/BlazorFileupload.csproj", "BlazorFileupload/"]
COPY ["UploadFilesLibrary/UploadFilesLibrary.csproj", "UploadFilesLibrary/"]


RUN dotnet restore "BlazorFileupload/BlazorFileupload.csproj"
COPY . .
WORKDIR "/BlazorFileupload/BlazorFileupload"
RUN dotnet build "BlazorFileuplaod.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "BlazorFileupload.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "BlazorFileupload.dll"]

