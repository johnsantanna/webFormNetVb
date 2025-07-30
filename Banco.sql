-- 1) Criação do banco
CREATE DATABASE TesteVB;
GO
USE TesteVB;
GO

-- 2) Tabela de Usuários
CREATE TABLE Usuarios (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Usuario NVARCHAR(50) NOT NULL UNIQUE,
    SenhaHash NVARCHAR(100) NOT NULL
);

INSERT INTO Usuarios (Usuario, SenhaHash)
VALUES (
  'admin',
  'A6xnQhbz4Vx2HuGl4lXwZ5U2I8iziLRFnhP5eNfIRvQ='
);

-- 3) Tabela de Clientes
CREATE TABLE Clientes (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Nome NVARCHAR(100) NOT NULL,
    Email NVARCHAR(100) NOT NULL,
    Telefone NVARCHAR(20) NULL,
	IdUsuarioDeletou VARCHAR(100),
	DataDeletou DATETIME
);

-- 4) Login SQL Server
CREATE LOGIN testevbuser WITH PASSWORD = 'AppUser123!';
GO

-- 5) Usuário no banco vinculado ao login
CREATE USER testevbuser FOR LOGIN testevbuser;
GO

-- 6) Permissões de leitura e escrita
ALTER ROLE db_datareader ADD MEMBER testevbuser;
ALTER ROLE db_datawriter ADD MEMBER testevbuser;
GO
