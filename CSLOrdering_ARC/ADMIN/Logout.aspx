<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Logout.aspx.cs" Inherits="ADMIN_Logout" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <h3>
    <div>
        You have been logged out as your session has been deemed inactive. 
        <asp:LinkButton runat="server" PostBackUrl="~/Login.aspx" Text="Login here"></asp:LinkButton>
    </div>
            </h3>
    </form>
</body>
</html>
