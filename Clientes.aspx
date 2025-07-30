<%@ Page Language="VB" AutoEventWireup="false" Inherits="TesteVBWebForms.Clientes" Codebehind="Clientes.aspx.vb" UnobtrusiveValidationMode="None" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>CRUD de Clientes</title>
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/jquery.dataTables.min.css" />
    <link rel="stylesheet" href="css/styles.css" />
</head>
<body>
    <h2>Gestão de Clientes</h2>
    <div class="header-actions">
        <button class="cadastrar" type="button" onclick="abrirModal('modalCadastro')">Novo Cliente</button>
    </div>
    <hr />
    <table id="tblClientes" class="display full-width">
        <thead>
            <tr>
                <th>Nome</th>
                <th>E-mail</th>
                <th>Telefone</th>
                <th>Ações</th>
            </tr>
        </thead>
    </table>

    <!-- Modal oculto de cadastro -->
    <div id="bgModal" class="modal-backdrop"></div>
    <div id="modalCadastro" class="modal-window">
        <h3>Novo Cliente</h3>
        <form id="formCadastro">
            <label>Nome:</label><br />
            <input type="text" id="txtNomeNovo" /><br /><br />
            <label>E-mail:</label><br />
            <input type="text" id="txtEmailNovo" /><br /><br />
            <label>Telefone:</label><br />
            <input type="text" id="txtTelNovo" /><br /><br />
            <span id="lblErro" class="error-text"></span><br />
            <button class="cadastrar" type="button" id="btnAdicionar" onclick="adicionarCliente()">Adicionar</button>
            <button class="fechar" type="button" onclick="fecharModal('modalCadastro')">Fechar</button>
        </form>
    </div>

    <!-- Modal oculto de edição -->
    <div id="modalEditar" class="modal-window">
        <h3>Editar Cliente</h3>
        <input type="hidden" id="txtIdEdit" />
        <label>Nome:</label><br />
        <input type="text" id="txtNomeEdit" /><br /><br />
        <label>Email:</label><br />
        <input type="text" id="txtEmailEdit" /><br /><br />
        <label>Telefone:</label><br />
        <input type="text" id="txtTelEdit" /><br /><br />
        <button class="editar" type="button" id="btnSalvarEdicao">Salvar</button>
        <button class="fechar" type="button" onclick="fecharModal('modalEditar');">Fechar</button>
    </div>


    <!-- bibliotecas usadas -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery.mask/1.14.16/jquery.mask.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

    <!-- meu script JS -->
    <script>

        let table;

        // Aplica máscara dinâmica
        aplicarMaskTel('#txtTelNovo');
        aplicarMaskTel('#txtTelEdit');

        // Gerar grid de Clientes cadastrados no banco com DataTables
        table = $('#tblClientes').DataTable({
            ajax: {
                url: 'Clientes.aspx/ListarClientes',
                type: 'POST',
                contentType: 'application/json; charset=utf-8',
                dataType: 'json',
                dataSrc: 'd'
            },
            columns: [
                { data: 'Nome' },
                { data: 'Email' },
                { data: 'Telefone' },
                {
                    data: null,
                    render: function (data, type, row) {
                        return `
                        <button data-modal="modalEditar" class='editar'
                            data-id='${row.Id}' 
                            data-nome='${row.Nome}' 
                            data-email='${row.Email}' 
                            data-telefone='${row.Telefone}'>
                            Editar
                        </button>
                        <button class='excluir' data-id='${row.Id}'>Excluir</button>
                    `;
                    }
                }
            ],
            order: [[0, 'desc']],
            dom: 'lfrtip',
            ordering: false,
            language: {
                search: "Buscar:",
                lengthMenu: "",
                info: "Mostrando _START_ a _END_ de _TOTAL_ registros",
                infoEmpty: "Nenhum registro encontrado",
                paginate: {
                    previous: "Anterior",
                    next: "Próximo"
                },
                zeroRecords: "Nenhum resultado encontrado"
            }
        });

        // abre modal via data-modal - se for 'modalEditar' preenche os dados
        $(document).on('click', '[data-modal]', function () {
            const m = $(this).data('modal');
            if (m === 'modalEditar') {
                const btn = $(this);    
                $('#txtIdEdit').val(btn.data('id'));
                $('#txtNomeEdit').val(btn.data('nome'));
                $('#txtEmailEdit').val(btn.data('email'));
                $('#txtTelEdit').val(btn.data('telefone'));
            }
            $('.modal-backdrop,#' + m).show();
        });
        // fecha o modal
        $(document).on('click', '.modal-backdrop, .fechar', () => {
            $('.modal-backdrop, .modal-window').hide();
            $('#formCadastro')[0].reset();
        });

        // Modal Editar - Botao Salvar
        $('#btnSalvarEdicao').on('click', function () {
            const id = $('#txtIdEdit').val();
            const nome = $('#txtNomeEdit').val();
            const email = $('#txtEmailEdit').val();
            let telefone = $('#txtTelEdit').val();
            editarCliente(id, nome, email, telefone);
        });

        // Botao Excluir
        $('#tblClientes').on('click', '.excluir', function () {
            const id = $(this).data('id');

            confirmar('Excluir este cliente?', () => {
                $.ajax({
                    type: "POST",
                    url: "Clientes.aspx/ExcluirCliente",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    data: JSON.stringify({ id: id })
                }).done(res => {
                    const msg = res.d;
                    toast(msg === 'OK' ? 'success' : 'error', msg === 'OK' ? 'Cliente excluído com sucesso!' : msg);
                    if (msg === 'OK') table.ajax.reload();
                }).fail(() => {
                    toast('error', 'Erro ao excluir o cliente.');
                });
            });
        });

        // Adicionar cliente via ajax no code-behind 
        function adicionarCliente() {
            var nome = $('#txtNomeNovo').val().trim();
            var email = $('#txtEmailNovo').val().trim();
            var telefone = $('#txtTelNovo').val().trim();

            if (!validarNomeCompleto(nome)) {
                toast('error', 'Informe o nome completo.');
                return;
            }

            if (!validarEmail(email)) {
                toast('error', 'E-mail inválido.');
                return;
            }

            if (!validarTelefone(telefone)) {
                toast('error', 'Informe um numero válido com DDD no formato: 00 00000 0000');
                return;
            }

            $.ajax({
                type: "POST",
                url: "Clientes.aspx/AdicionarCliente",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                data: JSON.stringify({ nome: nome, email: email, telefone: telefone }),
                success: function (res) {
                    if (res.d === "OK") {
                        toast('success', 'Cliente adicionado com sucesso!');
                        $('#txtNomeNovo, #txtEmailNovo, #txtTelNovo').val('');
                        $('#tblClientes').DataTable().ajax.reload();
                        fecharModal('modalCadastro');
                    } else {
                        toast('error', res.d);
                    }
                },
                error: function () {
                    toast('error', 'Erro na requisição.');
                }
            });
        }

        // Editar cliente via ajax no code-behind 
        function editarCliente(id, nome, email, telefone) {

            if (!validarNomeCompleto(nome)) {
                toast('error', 'Informe o nome completo.');
                return;
            }

            if (!validarEmail(email)) {
                toast('error', 'E-mail inválido.');
                return;
            }

            if (!validarTelefone(telefone)) {
                toast('error', 'Informe um numero válido com DDD no formato: 00 00000 0000');
                return;
            }

            $.ajax({
                type: "POST",
                url: "Clientes.aspx/EditarCliente",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                data: JSON.stringify({ id: id, nome: nome, email: email, telefone: telefone }),
                success: function (res) {
                    if (res.d === "OK") {
                        toast('success', 'Cliente atualizado com sucesso!');
                        $('#tblClientes').DataTable().ajax.reload();
                        fecharModal('modalEditar'); 
                    } else {
                        toast('error', res.d);
                    }
                },
                error: function () {
                    toast('error', 'Erro ao atualizar cliente.');
                }
            });
        }

        // Funções auxiliares

        function validarNomeCompleto(nome) {
            const partes = nome.trim().split(/\s+/);
            return partes.length >= 2;
        }

        function validarEmail(email) {
            const regex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            return regex.test(email);
        }

        function aplicarMaskTel(selector) {
            $(selector).mask('00 00000 0000', {
                onKeyPress(val, e, field, opts) {
                    const d = val.replace(/\D/g, '');
                    const m = d.length > 10 ? '00 00000 0000' : '00 0000 00009';
                    field.mask(m, opts);
                }
            });
        }

        function validarTelefone(telefone) {
            const apenasNumeros = telefone.replace(/\D/g, '');
            if (apenasNumeros === '') return true;
            if (apenasNumeros.length < 10) return false;
            return apenasNumeros.length === 10 || apenasNumeros.length === 11;
        }

        function abrirModal(idModal) {
            $('#' + idModal + ', #bgModal').show();
        }

        function fecharModal(idModal) {
            $('#' + idModal + ', #bgModal').hide();
        }

        function toast(type, msg) {
            Swal.fire({
                toast: true, icon: type, title: msg,
                position: 'bottom', showConfirmButton: false,
                timer: 3000, timerProgressBar: true
            });
        }

        function confirmar(msg, cb) {
            Swal.fire({
                title: msg, icon: 'warning',
                showCancelButton: true, confirmButtonText: 'Sim'
            }).then(r => r.isConfirmed && cb());
        }

    </script>

</body>
</html>
