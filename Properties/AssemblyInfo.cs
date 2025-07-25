using System.Reflection;
using System.Runtime.CompilerServices;
using System.Runtime.InteropServices;

// General Information about an assembly is controlled through the following
// set of attributes. Change these attribute values to modify the information
// associated with an assembly.
[assembly: AssemblyTitle("HHMS Application")]
[assembly: AssemblyDescription("Hotel and Hospitality Management System Application")]
[assembly: AssemblyConfiguration("")]
[assembly: AssemblyCompany("HHMS Development Team")]
[assembly: AssemblyProduct("HHMS Application")]
[assembly: AssemblyCopyright("Copyright © HHMS Development Team 2024")]
[assembly: AssemblyTrademark("")]
[assembly: AssemblyCulture("")]

// Setting ComVisible to false makes the types in this assembly not visible
// to COM components.  If you need to access a type in this assembly from
// COM, set the ComVisible attribute to true on that type.
[assembly: ComVisible(false)]

// The following GUID is for the ID of the typelib if this project is exposed to COM
[assembly: Guid("66bd5876-4d13-4800-bebd-b5c6955ca090")]

// Version information for an assembly consists of the following four values:
//
//      Major Version
//      Minor Version
//      Build Number
//      Revision
//
// You can specify all the values or you can default the Build and Revision Numbers
// by using the '*' as shown below:
// [assembly: AssemblyVersion("1.0.*")]
[assembly: AssemblyVersion("1.0.0.0")]
[assembly: AssemblyFileVersion("1.0.0.0")]

// Allow unit testing assemblies to access internal members
[assembly: InternalsVisibleTo("HHMS_Application.Tests")]

// Enable debugging for better developer experience
#if DEBUG
[assembly: AssemblyMetadata("BuildType", "Debug")]
#else
[assembly: AssemblyMetadata("BuildType", "Release")]
#endif