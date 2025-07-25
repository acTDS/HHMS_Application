# Pre-Debug Check Scripts

These scripts help verify that your HHMS Application project is ready for debugging in Visual Studio.

## When to Use

Run these scripts when you encounter the Visual Studio error:
```
The debug executable 'HHMS_Application.exe' specified in the 'HHMS_Application (Debug)' debug profile does not exist.
```

## Available Scripts

### Windows Batch Script
```cmd
pre-debug-check.bat
```
- Compatible with Command Prompt
- Performs comprehensive project readiness check
- Automatically builds project and verifies executable

### PowerShell Script  
```powershell
.\pre-debug-check.ps1
```
- Enhanced output formatting with colors
- More detailed error reporting
- Compatible with Windows PowerShell and PowerShell Core

## What These Scripts Check

1. **Project File**: Verifies you're in the correct directory
2. **.NET SDK**: Confirms .NET 6.0+ SDK is installed
3. **Package Restore**: Restores NuGet packages
4. **Build**: Builds project in Debug configuration
5. **Executable**: Verifies debug executable exists

## How to Use

1. Open Command Prompt or PowerShell
2. Navigate to the HHMS Application project folder
3. Run one of the scripts:
   ```cmd
   # Using batch script
   pre-debug-check.bat
   
   # Using PowerShell script
   .\pre-debug-check.ps1
   ```
4. Fix any issues reported by the script
5. Try debugging in Visual Studio again

## Common Issues and Solutions

### "Package restore failed"
```cmd
dotnet restore
```

### "Build failed"
- Check that .NET 6.0 Windows Desktop SDK is installed
- Ensure WebView2 runtime is installed
- Review build output for specific errors

### "Debug executable not found"
- Check if build actually succeeded
- Verify project target framework configuration
- Try Clean Solution → Rebuild Solution in Visual Studio

## Related Documentation

- `TROUBLESHOOTING_VISUAL_STUDIO.md` - Complete troubleshooting guide
- `README_VISUAL_STUDIO.md` - Visual Studio setup instructions
- `DEBUG_GUIDE.md` - Detailed debugging guide