# purger.ps1

### SMB Checker

Check for SMBv1, and automatically try to disable it if it's enabled:

```powershell
.\purger.ps1 -SMBCheck
```

### Remove Users

Delete local users that match a similar string. "John_Cena" users example:
```powershell
.\purger.ps1 -Username "John_Cena"
```

Delete AD domain users that match a similar string. "Admin" users example:
```powershell
.\purger.ps1 -Username "Admin" -Domain
```
