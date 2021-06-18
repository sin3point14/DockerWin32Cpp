ARG FROM_IMAGE=mcr.microsoft.com/dotnet/framework/sdk:4.8-windowsservercore-ltsc2019
FROM ${FROM_IMAGE}

# Reset the shell.
SHELL ["cmd", "/S", "/C"]

RUN mkdir C:\\TEMP

# Set up environment to collect install errors.
COPY Install.cmd C:\\TEMP
ADD https://aka.ms/vscollect.exe C:\\TEMP\\collect.exe

# Download channel for fixed install.
ARG CHANNEL_URL=https://aka.ms/vs/16/release/channel
ADD ${CHANNEL_URL} C:\\TEMP\\VisualStudio.chman

# Download and install Build Tools for Visual Studio 2017 for native desktop workload.
ADD https://aka.ms/vs/16/release/vs_buildtools.exe C:\\TEMP\\vs_buildtools.exe
RUN C:\\TEMP\Install.cmd C:\\TEMP\vs_buildtools.exe --quiet --wait --norestart --nocache \
    --channelUri C:\\TEMP\VisualStudio.chman \
    --installChannelUri C:\\TEMP\VisualStudio.chman \
    --add Microsoft.VisualStudio.Workload.VCTools --includeRecommended \
    --installPath C:\\BuildTools

RUN mkdir C:\\project
COPY . C:\\project

RUN "C:\\BuildTools\\Common7\\Tools\\VsDevCmd.bat" && msbuild c:\\project\\DockerWin32Cpp.sln /p:Configuration=Release /p:Platform=x64

FROM mcr.microsoft.com/windows/servercore:ltsc2019
ADD https://aka.ms/vs/16/release/vc_redist.x64.exe C:\\TEMP\\vc_redist.x64.exe
RUN start /w C:\\TEMP\\vc_redist.x64.exe /install /quiet /norestart
COPY x64\\Release\\DockerWin32Cpp.exe C:\\binary.exe
CMD ["C:\\binary.exe"]
