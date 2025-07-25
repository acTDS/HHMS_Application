# Hướng Dẫn Debug trong Visual Studio - HHMS Application

## Các File Debug Đã Được Thêm

Để đảm bảo Visual Studio có thể chạy và debug project HHMS Application, các file sau đã được tạo/cập nhật:

### 1. File Cấu Hình Debug

- **`.vs/launch.vs.json`** - Cấu hình launch cho Visual Studio
- **`HHMS_Application.csproj.user`** - Cài đặt debug project-specific
- **`Properties/AssemblyInfo.cs`** - Thông tin assembly và debug metadata
- **`Properties/launchSettings.json`** - Profile chạy ứng dụng (đã cập nhật)

### 2. File Đã Sửa

- **`nuget.config`** - Loại bỏ đường dẫn Windows-specific gây lỗi build
- **`Directory.Build.props`** - Sửa XML format để build được
- **`.gitignore`** - Cho phép commit các file debug cần thiết

## Hướng Dẫn Sử Dụng

### Mở Project trong Visual Studio

1. **Mở Visual Studio 2022**
2. **File → Open → Project/Solution**
3. **Chọn file `HHMS_Application.sln`**
4. **Wait for project to load và restore NuGet packages**

### Cấu Hình Debug

#### Debug Configuration Options:
- **HHMS_Application (Debug)** - Chế độ debug với full symbol information
- **HHMS_Application (Release)** - Chế độ release optimized
- **HHMS_Application (Executable)** - Chạy trực tiếp file .exe

#### Chọn Configuration:
1. **Solution Configuration dropdown** → chọn **"Debug"**
2. **Solution Platform dropdown** → chọn **"Any CPU"**

### Chạy và Debug

#### Start Debugging (F5):
```
Debug → Start Debugging
hoặc nhấn F5
```

#### Start Without Debugging (Ctrl+F5):
```
Debug → Start Without Debugging
hoặc nhấn Ctrl+F5
```

#### Set Breakpoints:
1. **Click vào margin bên trái dòng code** (hoặc F9)
2. **Red dot sẽ xuất hiện** indicating breakpoint
3. **Chạy debug (F5)** và app sẽ dừng tại breakpoint

### Debug Controls

Khi đang trong debug mode:

- **F5** - Continue execution
- **F10** - Step Over (thực hiện dòng hiện tại)
- **F11** - Step Into (đi vào function)
- **Shift+F11** - Step Out (thoát khỏi function)
- **Ctrl+Shift+F5** - Restart debugging
- **Shift+F5** - Stop debugging

### Debug Windows

Mở các cửa sổ debug hữu ích:

```
Debug → Windows → [chọn window]
```

**Recommended windows:**
- **Locals** - Xem biến local
- **Watch** - Monitor specific variables
- **Call Stack** - Xem call stack
- **Output** - Xem build/debug messages
- **Error List** - Xem errors và warnings

### Troubleshooting

#### Lỗi "Cannot start debugging"
1. **Đảm bảo project build thành công** (Build → Build Solution)
2. **Check Error List** cho build errors
3. **Clean và Rebuild** solution (Build → Clean Solution, sau đó Build → Rebuild Solution)

#### Breakpoints không hoạt động
1. **Check Debug configuration** (not Release)
2. **Đảm bảo symbol files (.pdb) được tạo**
3. **Verify Breakpoint** location hợp lệ (not comment hoặc declaration)

#### Debugging chậm
1. **Close unnecessary windows** trong Visual Studio
2. **Disable real-time anti-virus scanning** cho project folder
3. **Increase virtual memory** nếu cần

### Debug trong Windows Forms

#### Form Designer Issues:
- Nếu Form Designer không mở: **Right-click form file → Open With → Windows Forms Designer**
- Nếu control không hiển thị: **Rebuild project** và refresh designer

#### Runtime Debugging:
- **Exception Helper** sẽ hiển thị khi có exception
- **Use Debug.WriteLine()** để log messages ra Output window
- **Console.WriteLine()** không hoạt động trong Windows Forms

### Environment Variables

Project được cấu hình với:
- **Development environment**: `DOTNET_ENVIRONMENT=Development`
- **Production environment**: `DOTNET_ENVIRONMENT=Production`

### Advanced Debugging

#### SQL Debugging:
```
Project Properties → Debug → Check "Enable SQL Server debugging"
```

#### Mixed-Mode Debugging:
```
Project Properties → Debug → Check "Enable native code debugging"
```

#### Remote Debugging:
```
Debug → Attach to Process... → Connect to remote machine
```

## Kiểm Tra Debug Setup

Chạy checklist sau để đảm bảo debug hoạt động:

- [ ] Project builds successfully (Build → Build Solution)
- [ ] No errors trong Error List
- [ ] Debug configuration selected
- [ ] Có thể set breakpoints
- [ ] F5 launches application
- [ ] Debug windows accessible
- [ ] Step debugging works (F10, F11)

## Lưu Ý Quan Trọng

1. **Luôn build project trước khi debug** để có latest changes
2. **Save files before debugging** để tránh mất code changes
3. **Close debug session properly** (Shift+F5) before making code changes
4. **Use meaningful variable names** để debugging dễ dàng hơn
5. **Add logging** cho production debugging

## Support

Nếu vẫn gặp vấn đề với debugging:

1. **Check TROUBLESHOOTING_VISUAL_STUDIO.md** cho common issues
2. **Xem Visual Studio Output window** cho detailed error messages
3. **Create GitHub issue** với full error details và steps to reproduce

---

*File này được tạo để đảm bảo Visual Studio có thể debug HHMS Application properly. Tất cả các file debug cần thiết đã được include trong repository.*