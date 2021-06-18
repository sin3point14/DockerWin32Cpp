FROM mcr.microsoft.com/windows/servercore:ltsc2019 win32cpp-run
ADD https://aka.ms/vs/16/release/vc_redist.x64.exe C:\\TEMP\\vc_redist.x64.exe
RUN start /w C:\\TEMP\\vc_redist.x64.exe /install /quiet /norestart
COPY x64\\Release\\DockerWin32Cpp.exe C:\\binary.exe
CMD ["C:\\binary.exe"]
