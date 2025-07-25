# Visual Studio Setup Guide for HHMS Application

This document provides step-by-step instructions for setting up and running the HHMS Application in Visual Studio.

## Quick Start

1. **Prerequisites**: Ensure you have Visual Studio 2022 with .NET 6.0 SDK installed
2. **Open Solution**: Open `HHMS_Application.sln` in Visual Studio
3. **Restore Packages**: Right-click solution → "Restore NuGet Packages"
4. **Run**: Press F5 to build and run the application

## System Requirements

- **OS**: Windows 10 (1903+) or Windows 11
- **IDE**: Visual Studio 2022 (recommended) or VS 2019 (16.8+)
- **Framework**: .NET 6.0 SDK
- **Runtime**: Microsoft Edge WebView2 Runtime

## Visual Studio Workloads Required

Install these workloads in Visual Studio Installer:
- ✅ .NET Desktop Development
- ✅ Data storage and processing (for SQL Server features)

## Project Structure

```
HHMS_Application/
├── HHMS_Application.sln          # Solution file (double-click to open)
├── HHMS_Application.csproj       # Project configuration
├── Program.cs                    # Application entry point
├── MainForm.cs                   # Main application window
├── Forms/                        # All Windows Forms
├── Models/                       # Data models
├── Services/                     # Business logic
├── API/                         # API integration
└── UI/                          # Web UI assets
```

## Important Files for Visual Studio

### Configuration Files
- `.editorconfig` - Code formatting standards
- `nuget.config` - NuGet package sources
- `Properties/launchSettings.json` - Debug settings
- `App.config` - Application configuration

### Build Configuration
The project is configured as:
- **Target Framework**: .NET 6.0-windows
- **Output Type**: Windows Application
- **Platform**: Any CPU (can target x64/x86 specifically)

## NuGet Packages Used

- **Microsoft.Web.WebView2** (1.0.2210.55) - Web browser control
- **Microsoft.Data.SqlClient** (5.1.5) - SQL Server connectivity
- **Newtonsoft.Json** (13.0.3) - JSON serialization
- **System.Net.Http** (4.3.4) - HTTP client

## Running the Application

### Debug Mode
1. Set configuration to **Debug**
2. Press **F5** or click **Start Debugging**
3. Application will build and launch with debugger attached

### Release Mode
1. Change configuration to **Release**
2. Press **Ctrl+F5** or **Start Without Debugging**
3. Optimized build with better performance

## Common Issues and Solutions

### WebView2 Runtime Missing
**Error**: Application crashes when loading web content
**Solution**: Install Microsoft Edge WebView2 Runtime from Microsoft's website

### NuGet Package Restore Failed
**Error**: Build errors about missing packages
**Solution**: 
1. Right-click solution → "Restore NuGet Packages"
2. Or use Package Manager Console: `Update-Package -Reinstall`

### .NET 6.0 Not Found
**Error**: Target framework not installed
**Solution**: Download and install .NET 6.0 SDK from Microsoft

### Database Connection Issues
**Error**: Cannot connect to database
**Solution**: 
1. Check SQL Server is running
2. Update connection string in `App.config`
3. Ensure HHMS database exists (run `Database.sql`)

## Development Tips

### IntelliSense
- **Ctrl+Space**: Trigger auto-completion
- **Ctrl+Shift+Space**: Parameter hints
- **F12**: Go to definition
- **Shift+F12**: Find all references

### Debugging
- **F9**: Toggle breakpoint
- **F5**: Continue execution
- **F10**: Step over
- **F11**: Step into

### Building
- **Ctrl+Shift+B**: Build solution
- **F6**: Build current project
- **Ctrl+Alt+F7**: Rebuild solution

## Publishing the Application

### Self-Contained Deployment
1. Right-click project → **Publish**
2. Choose **Folder** target
3. Set **Target Runtime**: win-x64 or win-x86
4. Set **Deployment Mode**: Self-contained
5. Click **Publish**

This creates a standalone application that doesn't require .NET to be installed on target machines.

### Framework-Dependent Deployment
- Smaller file size
- Requires .NET 6.0 runtime on target machine
- Recommended for enterprise environments

## Code Style and Standards

The project includes an `.editorconfig` file that enforces:
- 4-space indentation for C# files
- 2-space indentation for XML/JSON files
- CRLF line endings
- UTF-8 encoding
- Consistent naming conventions

## Version Control

The project uses Git with a comprehensive `.gitignore` file that excludes:
- Build artifacts (`bin/`, `obj/`)
- Visual Studio files (`.vs/`, `*.user`)
- NuGet packages
- Temporary files

## Support

For Visual Studio-specific issues:
1. Check **Error List** window for detailed error messages
2. Use **Output** window to see build/debug information
3. Consult Visual Studio documentation
4. Check Microsoft Developer Community for solutions

---

*For Vietnamese instructions, see [HUONG_DAN_VISUAL_STUDIO.md](HUONG_DAN_VISUAL_STUDIO.md)*