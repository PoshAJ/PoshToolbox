﻿---
external help file: PoshToolbox-help.xml
Module Name: PoshToolbox
online version: https://gitlab.com/PoshAJ/PoshToolbox/-/blob/main/docs/Write-PoshLog.md
schema: 2.0.0
---

# Write-PoshLog

## SYNOPSIS

Writes a log message.

## SYNTAX

```powershell
Write-PoshLog [-Type <String>] [-Message] <String> [<CommonParameters>]
```

## DESCRIPTION

The `Write-PoshLog` cmdlet writes a log message to the PowerShell log.

## EXAMPLES

## PARAMETERS

### -Message

Specifies the log message.

```yaml
Type: String
Parameter Sets: Type
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Type

Specifies the type of event.

```yaml
Type: String
Parameter Sets: Type
Aliases:
Accepted values: Log, Information, Warning, Error

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

You cannot pipe input to this cmdlet.

## OUTPUTS

### None

This cmdlet does not generate any output.

## NOTES

The InformationVariable, WarningVariable, and ErrorVariable parameters of the corresponding `Write-Information`, `Write-Warning`, and `Write-Error` cmdlets are used to determine messages written to the PowerShell log. A specific message(s) can be excluded by using the correct parameter with a variable or null as show below.

Write-Information -InformationVariable null
Write-Warning -WarningVariable null
Write-Error -ErrorVariable null

## RELATED LINKS

[None]()
