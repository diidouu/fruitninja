@echo off
echo Building Biblio for Windows...

if not exist "build\Windows-Release" mkdir "build\Windows-Release"
cd "build\Windows-Release"

echo Configuring with CMake...
cmake -G "MinGW Makefiles" -DCMAKE_BUILD_TYPE=Release ..\..
if %errorlevel% neq 0 (
    echo CMake configuration failed!
    pause
    exit /b 1
)

echo Building project...
cmake --build . --config Release
if %errorlevel% neq 0 (
    echo Build failed!
    pause
    exit /b 1
)

echo Deploying Qt dependencies...
windeployqt.exe biblio.exe --qmldir ..\.. --verbose 2
if %errorlevel% neq 0 (
    echo Deployment failed!
    pause
    exit /b 1
)

echo Build completed successfully!
echo Executable is in: build\Windows-Release\biblio.exe
pause
