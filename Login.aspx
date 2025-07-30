<%@ Page Language="VB" AutoEventWireup="false" Inherits="TesteVBWebForms.Login" Codebehind="Login.aspx.vb" UnobtrusiveValidationMode="None" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Login</title>
</head>
<body>
    <form id="form1" runat="server">
        <div style="width:300px;margin:50px auto;">
            <h2>Faça seu login</h2>
            <asp:Label runat="server" Text="Usuário:" AssociatedControlID="txtUser" /><br />
            <asp:TextBox ID="txtUser" runat="server" Width="100%" /><br /><br />

            <asp:Label runat="server" Text="Senha:" AssociatedControlID="txtPass" /><br />
            <asp:TextBox ID="txtPass" runat="server" TextMode="Password" Width="100%" /><br /><br />

            <asp:Button ID="btnEntrar" runat="server" Text="Entrar" OnClick="btnEntrar_Click" Width="100%" /><br /><br />

            <asp:Label ID="lblMsg" runat="server" ForeColor="Red" />
        </div>
    </form>
</body>
</html>
