This script removes those pesky Team Foundation Server sourcecontrol bindings 
from your Visual Studio solutions and C# project files. It does so by doing the
following:

1. Recursively modifying all *.sln files to remove the GlobalSection about TeamFoundationVersionControl
2. Recursively modifying all *.csproj files to remove the SccProjectName, SccLocalPath, SccAuxPath and SccProvider elements.
3. Recursively deleting all *.vspscc files
4. Recursively deleting all *.vssscc files

Limitations:
It currently only modifies your C# project files. No support for VB or C++ project files is present.

WARNING!
Running this script *WILL* modify your *.sln and *.csproj. Backups are your friend.

Usage:
Go to the directory in which you have your solution. Run the script. Lean back. Enjoy.

Wilbert van Dolleweerd
wilbert@arentheym.com
