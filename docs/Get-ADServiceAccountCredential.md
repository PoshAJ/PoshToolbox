﻿---
external help file: PoshToolbox-help.xml
Module Name: PoshToolbox
online version: https://gitlab.com/PoshAJ/PoshToolbox/-/blob/main/docs/Get-ADServiceAccountCredential.md
schema: 2.0.0
---

# Get-ADServiceAccountCredential

## SYNOPSIS

Gets a credential object based on a service account identity.

## SYNTAX

```powershell
Get-ADServiceAccountCredential [-Identity] <String[]> [-Server <String>] [<CommonParameters>]
```

## DESCRIPTION

The `Get-ADServiceAccountCredential` function creates a credential object for a specified identity by retrieving the password from Active Directory. You can use the credential object in security operations.

## EXAMPLES

## PARAMETERS

### -Identity

Specifies an Active Directory service account object by providing one of the following property values. The acceptable values for this parameter are:

- A distinguished name
- A GUID (objectGUID)
- A security identifier (objectSid)
- A SAM account name (sAMAccountName)

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: distinguishedName, objectGuid, objectSid, sAMAccountName

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -Server

Specifies the Active Directory Domain Services instance to connect to, by providing one of the following values for a corresponding domain name or directory server.

Domain name values:

- Fully qualified domain name (FQDN)
- NetBIOS name

Directory server values:

- Fully qualified directory server name
- NetBIOS name
- Fully qualified directory server name and port

```yaml
Type: String
Parameter Sets: (All)
Aliases:

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

You can pipe a string that contains the identity parameter to this function.

## OUTPUTS

### PSCredential

Returns a credential object for the specified identity.

## NOTES

You can use the PSCredential object that `Get-ADServiceAccountCredential` creates in functions that request user authentication, such as those with a Credential parameter.

## RELATED LINKS

[https://github.com/Ryan2065/gMSACredentialModule]()
[https://learn.microsoft.com/en-us/azure/active-directory/fundamentals/service-accounts-group-managed]()
