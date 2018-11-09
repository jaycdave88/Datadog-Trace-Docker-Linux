FROM microsoft/dotnet:2.1-sdk as build

WORKDIR /src

COPY dd-trace-csharp-linux-example.csproj /src/
RUN dotnet restore

COPY Program.cs /src/
RUN dotnet publish -c Release

FROM microsoft/dotnet:2.1-sdk

RUN apt-get update && apt-get install -y bash curl

RUN mkdir -p /opt/datadog
RUN curl -LO https://github.com/DataDog/dd-trace-csharp/releases/download/v0.5.0-beta/datadog-dotnet-apm_0.5.0_amd64.deb
RUN apt install ./datadog-dotnet-apm_0.5.0_amd64.deb

ENV CORECLR_ENABLE_PROFILING=1
ENV CORECLR_PROFILER={846F5F1C-F9AE-4B07-969E-05C26BC060D8}
ENV CORECLR_PROFILER_PATH=/opt/datadog/Datadog.Trace.ClrProfiler.Native.so
ENV DD_INTEGRATIONS=/opt/datadog/integrations.json

RUN curl -L -o /bin/wait-for-it https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh && \
    chmod +x /bin/wait-for-it

COPY --from=build /src/bin/Release/netcoreapp2.1/publish/ /app
