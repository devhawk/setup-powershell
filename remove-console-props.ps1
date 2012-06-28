#http://blog.sourcewarp.com/2010/05/windows-powershell-shortcut-ishelllink.html

function Test-Administrator  
{  
    $user = [Security.Principal.WindowsIdentity]::GetCurrent();
    (New-Object Security.Principal.WindowsPrincipal $user).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)  
}

if (-not (Test-Administrator))
{
  write-host "this funtion can only be run by an admin";
  exit;
}

$shelllinkAPI = @"
using System;
using System.Runtime.InteropServices;


namespace DevHawk {

    [ComImport(),
    InterfaceType(ComInterfaceType.InterfaceIsIUnknown),
    Guid("0000010B-0000-0000-C000-000000000046")]
    public interface IPersistFile
    {
        #region Methods inherited from IPersist

        void GetClassID(
            out Guid pClassID);

        #endregion

        [PreserveSig()]
        int IsDirty();

        void Load(
            [MarshalAs(UnmanagedType.LPWStr)] string pszFileName,
            int dwMode);

        void Save(
            [MarshalAs(UnmanagedType.LPWStr)] string pszFileName,
            [MarshalAs(UnmanagedType.Bool)] bool fRemember);

        void SaveCompleted(
            [MarshalAs(UnmanagedType.LPWStr)] string pszFileName);

        void GetCurFile(
            out IntPtr ppszFileName);

    }
    
    [ComImport(),
    InterfaceType(ComInterfaceType.InterfaceIsIUnknown),
    Guid("45E2b4AE-B1C3-11D0-B92F-00A0C90312E1")]
    public interface IShellLinkDataList
    {
        void AddDataBlock(
            IntPtr pDataBlock);

        void CopyDataBlock(
            uint dwSig,
            out IntPtr ppDataBlock);

        void RemoveDataBlock(
            uint dwSig);

        void GetFlags(
            out int dwFlags);

        void SetFlags(
            uint dwFlags);
    }
    
    public static class ShellLink
    {
        public static void Load(object shellLink, string fileName, int mode) 
        {
            ((IPersistFile)shellLink).Load(fileName, mode);
        }
        
        public static void RemoveDataBlock(object shellLink, uint dwSig)
        {
            ((IShellLinkDataList)shellLink).RemoveDataBlock(dwSig);
        }
        
        public static void Save(object shellLink)
        {
            ((IPersistFile)shellLink).Save(null, true);
        }
        
        public const uint CONSOLE_PROPS = 0xA0000002;
    }
}
"@

add-type -TypeDefinition $shelllinkAPI

dir "C:\ProgramData\Microsoft\Windows\Start Menu\" -Recurse -Include *.lnk | %{
    $name = $_.Name
    
    Try
    {
        $shellLink = new-object -ComObject lnkfile
        [DevHawk.ShellLink]::Load($shellLink, $_.FullName, 2);
        [DevHawk.ShellLink]::RemoveDataBlock($shellLink, [DevHawk.ShellLink]::CONSOLE_PROPS);
        [DevHawk.ShellLink]::Save($shellLink);
    }
    Catch [System.Exception]
    {
        write-host "  couldn't update $name"
    }

}