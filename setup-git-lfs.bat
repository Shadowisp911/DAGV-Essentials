@echo off
setlocal enabledelayedexpansion

echo ============================================
echo   Git + LFS Setup for 3D/Animation Project
echo ============================================
echo.

REM --- Ask user for the repo folder location ---
set "REPO_PATH="
set /p REPO_PATH=Enter the full path to your repo folder (or press Enter to use current folder): 

if not "!REPO_PATH!"=="" (
    if not exist "!REPO_PATH!" (
        echo ERROR: That path does not exist: !REPO_PATH!
        pause
        exit /b 1
    )
    cd /d "!REPO_PATH!"
)

echo.
echo Using folder: %cd%
echo.

REM --- Check we're in a git repo ---
git rev-parse --is-inside-work-tree >nul 2>&1
if errorlevel 1 (
    echo ERROR: This folder is not a Git repository.
    echo Run "git init" first, then re-run this script.
    pause
    exit /b 1
)

REM --- Make sure git-lfs is installed ---
git lfs version >nul 2>&1
if errorlevel 1 (
    echo ERROR: Git LFS does not appear to be installed.
    echo Install it from https://git-lfs.github.com and try again.
    pause
    exit /b 1
)

echo Initializing Git LFS...
git lfs install

echo.
echo Writing .gitignore...
(
echo # Blender backup ^& temp files
echo *.blend1
echo *.blend2
echo *.blend3
echo *.blend@
echo *~
echo.
echo # Blender auto-save
echo *.blend.autosave
echo.
echo # Cache ^& bake data
echo *_cache/
echo blendcache_*/
echo *.abc.cache
echo.
echo # Rendered output ^(remove these lines if you want renders tracked^)
echo /renders/
echo /output/
echo *.png.cache
echo.
echo # OS junk
echo .DS_Store
echo Thumbs.db
echo desktop.ini
echo.
echo # Editor/IDE junk
echo .vscode/
echo .idea/
echo *.swp
echo.
echo # Substance Painter temp
echo *.spt
echo autosave/
echo.
echo # Python cache ^(Blender scripting^)
echo __pycache__/
echo *.pyc
echo.
echo # Log files
echo *.log
) > .gitignore

echo .gitignore written.
echo.

echo Setting up Git LFS tracking...

REM 3D model / scene files
git lfs track "*.blend"
git lfs track "*.fbx"
git lfs track "*.obj"
git lfs track "*.mtl"
git lfs track "*.dae"
git lfs track "*.abc"
git lfs track "*.ma"
git lfs track "*.mb"

REM Textures / images
git lfs track "*.png"
git lfs track "*.tga"
git lfs track "*.exr"
git lfs track "*.hdr"
git lfs track "*.tiff"
git lfs track "*.psd"

REM Animation / motion capture
git lfs track "*.bvh"

REM Video / render output
git lfs track "*.mov"
git lfs track "*.mp4"
git lfs track "*.avi"

REM Substance material files
git lfs track "*.sbsar"
git lfs track "*.spp"

echo.
echo Staging .gitignore and .gitattributes...
git add .gitignore .gitattributes

echo.
echo ============================================
echo   Done. Review the files below, then commit:
echo   git commit -m "Configure gitignore and LFS tracking"
echo ============================================
echo.

git status

pause
