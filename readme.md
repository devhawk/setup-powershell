Setup-Powershell
================

Working for the Windows team, I setup *lots* of Windows machines. In order to make this less of a hassle, I've got scripts to help setup a freshly paved machine. This is one of those scripts, intended to setup PowerShell the way I like it.

There are two aspects to this script:

* Configuring PowerShell's execution policy 
* Configuring Windows' built-in Console app settings (font, window size, etc)

For execution policy, I configure both the main PowerShell version as well as the WOW64 version to use [RemoteSigned execution policy](http://technet.microsoft.com/en-us/library/ee176961.aspx)

For console settings, I set the defaults in HKCU:\Console, remove any app-specific console settings under HKCU:\Console and iterate over the all the .lnk files in the start menu and remove their console data block via [IShellLinkDataList::RemoveDataBlock](http://msdn.microsoft.com/en-us/library/bb774918.aspx). Yes, I realize that there are other, better console replacements out there. But it's easier for me to setup the built-in console app the way I like it when I set the PowerShell execution policy rather than always install a new console app on every fresh install.

In order to make this script runnable  on a fresh Windows install, I'm using a batch file rather than a PowerShell script. It's easy to right-click on the setup-powershell.bat file and select "Run as administrator" from the context menu. However, the code to configure the console settings is all PowerShell (including embedded C# to interact with the IShellLinkDataList COM object). I want a single file solution but I also want to be able to edit and test my PowerShell separately. So I wrote a little build script that takes my console management scripts, encodes them as base64 and concatenates the scripts into a single bat file.

To Use
------
Run build.ps1 from a PowerShell console window. The result is setup-powershell.bat without external dependencies that you can run on both x86 and x64 Windows machines.