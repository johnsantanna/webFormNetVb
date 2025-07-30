# webFormVBNet

CRUD de clientes em ASP.NET Web Forms (VB.NET) com DataTables, AJAX, máscaras dinâmicas, validações front‑end/back‑end e notificações SweetAlert2.

## Tecnologias
- ASP.NET Web Forms (VB.NET)  
- .NET Framework ≥ 4.7  
- SQL Server  
- IIS / IIS Express

## Bibliotecas
- jQuery  
- DataTables  
- jQuery Mask Plugin  
- SweetAlert2  

## Passo a passo para rodar

1. **Abra a solução**  
   - No Visual Studio, abra o arquivo `webFormVBNet.sln`.

2. **Restaurar o banco**  
   - No SQL Server Management Studio, abra e execute o `Banco.sql` que está na raiz do projeto.  
   - Isso criará o database `TesteVB`, as tabelas `Usuarios` e `Clientes` e o login `testevbuser`.

3. **Configurar connection string**  
   - No `Web.config`, verifique a seção `<connectionStrings>`:  
     ```xml
     <connectionStrings>
       <add name="strConnTesteVB"
            connectionString="Data Source=.;Initial Catalog=TesteVB;User ID=testevbuser;Password=AppUser123!"
            providerName="System.Data.SqlClient" />
     </connectionStrings>
     ```

4. **Definir página inicial** 
   - No **Solution Explorer**, clique com o botão direito em `Login.aspx` → **Set as Start Page**.

5. **Executar a aplicação**  
   - Pressione **F5** (IIS Express) ou **Ctrl+F5**.  
   - A página de login será exibida.

6. **Login e teste**  
   - Use usuário **admin** e a senha **1234** conforme hash configurado em `Banco.sql`.  
   - Após o login, a tela de gestão de clientes estará disponível.  
   - Teste cadastro, edição e exclusão lógica dos clientes.

