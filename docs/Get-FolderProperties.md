﻿---
external help file: PoshToolbox-help.xml
Module Name: PoshToolbox
online version: https://gitlab.com/PoshAJ/PoshToolbox/-/blob/main/docs/Get-FolderProperties.md
schema: 2.0.0
---

# Get-FolderProperties

## SYNOPSIS

Displays folder properties.

## SYNTAX

### Path

```powershell
Get-FolderProperties [-Path] <String[]> [-Unit <String>] [<CommonParameters>]
```

### LiteralPath

```powershell
Get-FolderProperties -LiteralPath <String[]> [-Unit <String>] [<CommonParameters>]
```

## DESCRIPTION

The `Get-FolderProperties` function creates a result object for the specified folder path(s). The information displayed replicates the Microsoft Windows Explorer file folder properties window.

## EXAMPLES

## PARAMETERS

### -LiteralPath

Specifies a path to one or more locations. The value of LiteralPath is used exactly as it's typed.

```yaml
Type: String[]
Parameter Sets: LiteralPath
Aliases: PSPath

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Path

Specifies a path to one or more locations. Wildcards are accepted.

```yaml
Type: String[]
Parameter Sets: Path
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -Unit

Specifies the unit of size measurement.

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: KB, MB, GB, TB, PB, EB, ZB, YB, KiB, MiB, GiB, TiB, PiB, EiB, ZiB, YiB

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters

This function supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### String

You can pipe a string that contains a folder path to this function.

## OUTPUTS

### PoshToolbox.GetFolderPropertiesCommand+FolderPropertiesInfo

Returns a FolderPropertiesInfo object for each specified folder.

## NOTES

## RELATED LINKS

[None]()
