# purger.ps1

Script needs to be run in an admin or domain admin elevated Powershell prompt. To temporarily bypass Powershell execution policies in this terminal, run::

```powershell
powershell -ep bypass
```

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
