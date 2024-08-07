﻿---
external help file: PoshToolbox-help.xml
Module Name: PoshToolbox
online version: https://gitlab.com/PoshAJ/PoshToolbox/-/blob/main/docs/Use-Ternary.md
schema: 2.0.0
---

# Use-Ternary

## SYNOPSIS

Implements the Ternary operator (?:).

## SYNTAX

```powershell
Use-Ternary -InputObject <Object> [[-IfTrue] <Object>] [[-IfFalse] <Object>] [<CommonParameters>]
```

## DESCRIPTION

The `Use-Ternary` function simulates the effect of the ternary operator for earlier versions of PowerShell before it was introduced.

You can use the ternary operator as a replacement for the if-else statement in simple conditional cases.

## EXAMPLES

## PARAMETERS

### -IfFalse

Specifies the expression to be executed if the \<condition\> expression is false.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -IfTrue

Specifies the expression to be executed if the \<condition\> expression is true.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -InputObject

Specifies the \<condition\> expression to be evaluated and converted to a boolean.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### CommonParameters

This function supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### PSObject

You can pipe an object that represents the expression to be evaluated.

## OUTPUTS

### PSObject

Returns the output that is generated based on evaluating the expression.

## NOTES

## RELATED LINKS

[https://docs.microsoft.com/en-us/dotnet/csharp/language-reference/operators/conditional-operator]()
[https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_operators]()
[https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_pipelines]()
