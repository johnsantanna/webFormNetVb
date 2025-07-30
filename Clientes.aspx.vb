Imports System.Web.Services
Imports System.Web.Script.Services
Imports System.Data.SqlClient

Public Class Cliente
    Public Property Id As Integer
    Public Property Nome As String
    Public Property Email As String
    Public Property Telefone As String
End Class

Partial Class Clientes
    Inherits Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
        If Context.CurrentHandler Is Me Then
            If Session("usuario_logado") Is Nothing Then
                Response.Redirect("Login.aspx")
                Exit Sub
            End If
        End If

        If Not IsPostBack Then
            ListarClientes()
        End If
    End Sub

    <WebMethod()>
    <ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
    Public Shared Function ListarClientes() As List(Of Cliente)
        Dim lista As New List(Of Cliente)()
        Dim connStr As String = ConfigurationManager.ConnectionStrings("strConnTesteVB").ConnectionString

        Using conn As New SqlConnection(connStr)
            Dim cmd As New SqlCommand("SELECT Id, Nome, Email, Telefone FROM Clientes WHERE DataDeletou IS NULL", conn)
            conn.Open()
            Using reader As SqlDataReader = cmd.ExecuteReader()
                While reader.Read()
                    lista.Add(New Cliente With {
                        .Id = reader("Id"),
                        .Nome = reader("Nome").ToString(),
                        .Email = reader("Email").ToString(),
                        .Telefone = reader("Telefone").ToString()
                    })
                End While
            End Using
        End Using

        Return lista
    End Function

    <WebMethod()>
    <ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
    Public Shared Function AdicionarCliente(nome As String, email As String, telefone As String) As String
        Try
            If String.IsNullOrWhiteSpace(nome) OrElse Not nome.Contains(" ") Then
                Return "Nome inválido."
            End If

            If String.IsNullOrWhiteSpace(email) OrElse Not email.Contains("@") Then
                Return "Email inválido."
            End If

            Dim connStr = ConfigurationManager.ConnectionStrings("strConnTesteVB").ConnectionString
            Using conn As New SqlConnection(connStr)
                Dim cmd As New SqlCommand("INSERT INTO Clientes (Nome, Email, Telefone) VALUES (@Nome, @Email, @Telefone)", conn)
                cmd.Parameters.AddWithValue("@Nome", nome)
                cmd.Parameters.AddWithValue("@Email", email)
                cmd.Parameters.AddWithValue("@Telefone", telefone)
                conn.Open()
                cmd.ExecuteNonQuery()
            End Using

            ListarClientes()
            Return "OK"
        Catch ex As Exception
            Return "Erro: " & ex.Message
        End Try
    End Function

    <WebMethod()>
    <ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
    Public Shared Function EditarCliente(id As Integer, nome As String, email As String, telefone As String) As String
        Try
            If String.IsNullOrWhiteSpace(nome) OrElse Not nome.Contains(" ") Then
                Return "Nome inválido."
            End If

            If String.IsNullOrWhiteSpace(email) OrElse Not email.Contains("@") Then
                Return "Email inválido."
            End If

            Dim connStr = ConfigurationManager.ConnectionStrings("strConnTesteVB").ConnectionString
            Using conn As New SqlConnection(connStr)
                Dim cmd As New SqlCommand("UPDATE Clientes SET Nome = @Nome, Email = @Email, Telefone = @Telefone WHERE Id = @Id", conn)
                cmd.Parameters.AddWithValue("@Id", id)
                cmd.Parameters.AddWithValue("@Nome", nome)
                cmd.Parameters.AddWithValue("@Email", email)
                cmd.Parameters.AddWithValue("@Telefone", telefone)
                conn.Open()
                cmd.ExecuteNonQuery()
            End Using

            ListarClientes()
            Return "OK"
        Catch ex As Exception
            Return "Erro: " & ex.Message
        End Try
    End Function

    <WebMethod()>
    <ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
    Public Shared Function ExcluirCliente(id As Integer) As String
        Try
            Dim usuario = HttpContext.Current.Session("usuario_logado")
            If usuario Is Nothing Then
                Return "Usuário não autenticado."
            End If

            Dim connStr = ConfigurationManager.ConnectionStrings("strConnTesteVB").ConnectionString
            Using conn As New SqlConnection(connStr)
                Dim cmd As New SqlCommand("UPDATE Clientes SET IdUsuarioDeletou = @Usuario, DataDeletou = GETDATE() WHERE Id = @Id", conn)
                cmd.Parameters.AddWithValue("@Id", id)
                cmd.Parameters.AddWithValue("@Usuario", usuario.ToString())
                conn.Open()
                cmd.ExecuteNonQuery()
            End Using

            ListarClientes()
            Return "OK"
        Catch ex As Exception
            Return "Erro: " & ex.Message
        End Try
    End Function


End Class
