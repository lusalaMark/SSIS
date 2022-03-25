//------------------------------------------------------------------------------
// <copyright file="CSSqlFunction.cs" company="Microsoft">
//     Copyright (c) Microsoft Corporation.  All rights reserved.
// </copyright>
//------------------------------------------------------------------------------
using System;
using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using Microsoft.SqlServer.Server;
using Microsoft.VisualBasic;

public partial class UserDefinedFunctions
{
    [Microsoft.SqlServer.Server.SqlFunction]
    public static SqlDouble PV(double Rate, double NPer, double Pmt, double FV = 0, int Due = 0)
    {
        return Financial.PV(Rate, NPer, Pmt, FV, (DueDate)Due);
    }

    [Microsoft.SqlServer.Server.SqlFunction]
    public static SqlDouble Pmt(double Rate, double NPer, double PV, double FV = 0, int Due = 0)
    {
        return Financial.Pmt(Rate, NPer, PV, FV, (DueDate)Due);
    }

    [Microsoft.SqlServer.Server.SqlFunction]
    public static SqlDouble IPmt(double Rate, double Per, double NPer, double PV, double FV = 0, int Due = 0)
    {
        return Financial.IPmt(Rate, Per, NPer, PV, FV, (DueDate)Due);
    }

    [Microsoft.SqlServer.Server.SqlFunction]
    public static SqlDouble PPmt(double Rate, double Per, double NPer, double PV, double FV = 0, int Due = 0)
    {
        return Financial.PPmt(Rate, Per, NPer, PV, FV, (DueDate)Due);
    }

    [Microsoft.SqlServer.Server.SqlFunction]
    public static SqlDouble FV(double Rate, double NPer, double Pmt, double PV = 0, int Due = 0)
    {
        return Financial.FV(Rate, NPer, Pmt, PV, (DueDate)Due);
    }
}
