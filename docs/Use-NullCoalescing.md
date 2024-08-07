﻿---
external help file: PoshToolbox-help.xml
Module Name: PoshToolbox
online version: https://gitlab.com/PoshAJ/PoshToolbox/-/blob/main/docs/Use-NullCoalescing.md
schema: 2.0.0
---

# Use-NullCoalescing

## SYNOPSIS

Implements the Null-coalescing operator (??).

## SYNTAX

```powershell
Use-NullCoalescing -InputObject <Object> [-IfNull] <Object> [<CommonParameters>]
```

## DESCRIPTION

The `Use-NullCoalescing` function simulates the effect of the null-coalescing operator for earlier versions of PowerShell before it was introduced.

The null-coalescing operator ?? returns the value of its left-hand operand if it isn't null. Otherwise, it evaluates the right-hand operand and returns its result. The ?? operator doesn't evaluate its right-hand operand if the left-hand operand evaluates to non-null.

## EXAMPLES

## PARAMETERS

### -IfNull

Specifies the expression to be executed if the \<condition\> expression is null.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -InputObject

Specifies the \<condition\> expression to be evaluated and returned if not null.

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

[https://docs.microsoft.com/en-us/dotnet/csharp/language-reference/operators/null-coalescing-operator]()
[https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_operators]()
[https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_pipelines]()
