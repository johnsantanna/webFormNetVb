Imports System.Data.SqlClient
Imports System.Security.Cryptography

Partial Class Login
    Inherits Page

    Protected Sub btnEntrar_Click(sender As Object, e As EventArgs)
        lblMsg.Text = ""
        Dim usuario = txtUser.Text.Trim()
        Dim senha = txtPass.Text.Trim()

        If String.IsNullOrEmpty(usuario) Or String.IsNullOrEmpty(senha) Then
            lblMsg.Text = "Informe usuário e senha."
            Return
        End If

        ' Faz um hash da senha informada usando SHA-256 e transforma o resultado em Base64 pra checar no banco
        Dim hashBytes() As Byte = SHA256.Create().ComputeHash(Encoding.UTF8.GetBytes(senha))
        Dim senhaHash As String = Convert.ToBase64String(hashBytes)

        Dim connStr = ConfigurationManager.ConnectionStrings("strConnTesteVB").ConnectionString
        Using cn As New SqlConnection(connStr)
            Using cmd As New SqlCommand("SELECT Id FROM Usuarios WHERE Usuario=@u AND SenhaHash=@h", cn)
                cmd.Parameters.AddWithValue("@u", usuario)
                cmd.Parameters.AddWithValue("@h", senhaHash)
                cn.Open()
                Dim userId = cmd.ExecuteScalar()
                If userId IsNot Nothing Then
                    Session("usuario_logado") = CInt(userId)
                    Response.Redirect("Clientes.aspx")
                Else
                    lblMsg.Text = "Usuário ou senha inválidos."
                End If
            End Using
        End Using
    End Sub
End Class
