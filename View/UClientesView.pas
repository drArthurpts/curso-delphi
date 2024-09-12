unit UClientesView;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ExtCtrls, Mask, Buttons, UEnumerationUtil;

type
  TfrmClientes = class(TForm)
    stbBaraStatus: TStatusBar;
    pnlBotoes: TPanel;
    pnlArea: TPanel;
    lblCodigo: TLabel;
    editCodigo: TEdit;
    chkAtivo: TCheckBox;
    rdgTipoPessoa: TRadioGroup;
    lblCPFCNPJ: TLabel;
    edtCPFCNPJ: TMaskEdit;
    lblNome: TStaticText;
    edtNome: TEdit;
    grbEndereco: TGroupBox;
    lblEndereco: TLabel;
    edtEndereco: TEdit;
    lblNumero: TLabel;
    edtNumero: TEdit;
    lblComplemento: TLabel;
    edtComplemento: TEdit;
    lblBairro: TLabel;
    edtBairro: TEdit;
    lblUF: TLabel;
    cmbUF: TComboBox;
    lblCidade: TLabel;
    edtCidade: TEdit;
    btnIncluir: TBitBtn;
    btnAlterar: TBitBtn;
    btnExcluir: TBitBtn;
    btnConsultar: TBitBtn;
    btnListar: TBitBtn;
    btnPesquisar: TBitBtn;
    btnConfirmar: TBitBtn;
    btnCancelar: TBitBtn;
    btnSair: TBitBtn;
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnIncluirClick(Sender: TObject);
    procedure btnAlterarClick(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure btnConsultarClick(Sender: TObject);
    procedure btnListarClick(Sender: TObject);
    procedure btnPesquisarClick(Sender: TObject);
    procedure btnConfirmarClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnSairClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
    vKey : Word;

    //VAriaveis de classes
    vEstadoTela : TEstadoTela;

    procedure CamposEnabled(pOpcao : Boolean);
    procedure LimpaTela;
    procedure DefineEstadoTela;
    function ProcessaConfirmacao : Boolean;
    function ProcessaInclusao  : Boolean;
    function ProcessaCliente : Boolean;

    function ProcessaPessoa : Boolean;
    function ProcessaEndereco : Boolean;
  public
    { Public declarations }

  end;

var
  frmClientes: TfrmClientes;

implementation

uses
  uMessageUtil;
  
{$R *.dfm}

procedure TfrmClientes.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
      vKey := Key;

      case vKey of
         VK_RETURN:
         begin
           Perform(WM_NEXTDLGCTL, 0, 0);
         end;

         VK_ESCAPE:
         begin
         if (vEstadoTela <> etPadrao) then
         begin
         if (TMessageUtil.Pergunta(
         'Deseja realmente abortar essa opera��o?')) then
         begin
            vEstadoTela := etPadrao;
            DefineEstadoTela;
            end;
         end
         else
         begin
           if (TMessageUtil.Pergunta(
           'Deseja sair da rotina? ')) then
              Close;
              end;
         end;
      end;
end;

procedure TfrmClientes.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
      Action := caFree;
      frmClientes := nil;
end;

procedure TfrmClientes.CamposEnabled(pOpcao: Boolean);
var
   i : Integer;
begin
   for i := 0 to pred(ComponentCount) do
   begin
      if (Components[i] is TEdit) then
         (Components[i] as TEdit).Enabled := pOpcao;

      if (Components[i] is TMaskEdit) then
         (Components[i] as TMaskEdit).Enabled := pOpcao;

      if (Components[i] is TRadioGroup) then
         (Components[i] as TRadioGroup).Enabled := pOpcao;

      if (Components[i] is TComboBox) then
         (Components[i] as TComboBox).Enabled := pOpcao;

      if (Components[i] is TCheckBox) then
         (Components[i] as TCheckBox).Checked := False;
   end;

   grbEndereco.Enabled := pOpcao;

end;

procedure TfrmClientes.LimpaTela;
var
   i : Integer;
begin
   for i := 0 to pred(ComponentCount) do
   begin
      if (Components[i] is TEdit) then
         (Components[i] as TEdit).Text := EmptyStr;

      if (Components[i] is TMaskEdit) then
         (Components[i] as TMaskEdit).Text := EmptyStr;

      if (Components[i] is TRadioGroup) then
         (Components[i] as TRadioGroup).ItemIndex := 0;

      if (Components[i] is TComboBox) then
         begin
         (Components[i] as TComboBox).Clear;
         (Components[i] as TComboBox).ItemIndex := -1;
         end;

      if (Components[i] is TCheckBox) then
         (Components[i] as TCheckBox).Checked := False;


   end;
end;

procedure TfrmClientes.DefineEstadoTela;
begin
   btnIncluir.Enabled   := (vEstadoTela in [etPadrao]);
   btnAlterar.Enabled   := (vEstadoTela in [etPadrao]);
   btnExcluir.Enabled   := (vEstadoTela in [etPadrao]);
   btnConsultar.Enabled := (vEstadoTela in [etPadrao]);
   btnListar.Enabled    := (vEstadoTela in [etPadrao]);
   btnPesquisar.Enabled := (vEstadoTela in [etPadrao]);

   btnConfirmar.Enabled :=
      vEstadoTela in [etIncluir, etAlterar, etExcluir, etConsultar];

   btnCancelar.Enabled :=
      vEstadoTela in [etIncluir, etAlterar, etExcluir, etConsultar];

   case vEstadoTela of
      etPadrao:
      begin
         CamposEnabled(False);
         LimpaTela;

         stbBaraStatus.Panels[0].Text := EmptyStr;
         stbBaraStatus.Panels[1].Text := EmptyStr;

         if (frmClientes <> nil) and
         (frmClientes.Active) and
         (frmClientes.CanFocus) then
         btnIncluir.SetFocus;

         Application.ProcessMessages;    
      end;
      etIncluir:
      begin
         stbBaraStatus.Panels[0].Text := 'Inclus�o';
         CamposEnabled(True);

         editCodigo.Enabled := False;

         chkAtivo.Checked := True;

         if edtNome.CanFocus then
            edtNome.SetFocus; 
      end;
   end;
end;

procedure TfrmClientes.btnIncluirClick(Sender: TObject);
begin
   vEstadoTela := etIncluir;
   DefineEstadoTela;
end;

procedure TfrmClientes.btnAlterarClick(Sender: TObject);
begin
   vEstadoTela := etAlterar;
   DefineEstadoTela;
end;

procedure TfrmClientes.btnExcluirClick(Sender: TObject);
begin
   vEstadoTela := etExcluir;
   DefineEstadoTela;
end;

procedure TfrmClientes.btnConsultarClick(Sender: TObject);
begin
   vEstadoTela := etConsultar;
   DefineEstadoTela;
end;

procedure TfrmClientes.btnListarClick(Sender: TObject);
begin
   vEstadoTela := etListar;
   DefineEstadoTela;
end;

procedure TfrmClientes.btnPesquisarClick(Sender: TObject);
begin
   vEstadoTela := etPesquisar;
   DefineEstadoTela;
end;

procedure TfrmClientes.btnConfirmarClick(Sender: TObject);
begin
   ProcessaConfirmacao;
end;

procedure TfrmClientes.btnCancelarClick(Sender: TObject);
begin
   vEstadoTela := etPadrao;
   DefineEstadoTela;
end;

procedure TfrmClientes.btnSairClick(Sender: TObject);
begin
   if (vEstadoTela <> etPadrao) then
   begin
      if (TMessageUtil.Pergunta('Deseja realmente abortar essa opera��o?')) then
      begin
         vEstadoTela := etPadrao;
         DefineEstadoTela;
      end;
   end
   else
      Close;
end;

procedure TfrmClientes.FormCreate(Sender: TObject);
begin
   vEstadoTela := etPadrao;
end;

procedure TfrmClientes.FormShow(Sender: TObject);
begin
   DefineEstadoTela;
end;

procedure TfrmClientes.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   vKey := VK_CLEAR;
end;

function TfrmClientes.ProcessaConfirmacao: Boolean;
begin
   Result:= False;

      try
        case vEstadoTela of
            etIncluir : Result := ProcessaInclusao;

        end;
        if not Result then
         Exit;
      except
         on E : Exception do
         TMessageUtil.Alerta(E.Message);
      end;

      Result := True;
end;

function TfrmClientes.ProcessaInclusao: Boolean;
begin
   try
      Result := False;

      if ProcessaCliente then
      begin
         TMessageUtil.Informacao('Cliente cadastrado com sucesso! ' + #13 +
                                 'C�digo cadastrado: ');
         vEstadoTela := etPadrao;
         DefineEstadoTela;

         Result := True;
      end;
   except
       on E : Exception do
       begin
          Raise Exception.Create(
          'Falha ao incluir os dados do cliente [View]: '#13 +
          e.Message);
       end;
   end;
end;

function TfrmClientes.ProcessaCliente: Boolean;
begin
   try
      if (ProcessaPessoa) and
         (ProcessaEndereco) then
      begin
         //Grava��o no banco

         Result := True;
      end;
   except
     on E : Exception do
     begin
         Raise  Exception.Create(
         'Falha ao gavar os dados dos clientes [View]: '#13 +
         e.Message);
     end;
   end;
end;

function TfrmClientes.ProcessaPessoa: Boolean;
begin
   try
      Result := False;

//      if not ValidaCliente then
//         Exit;

      Result := True
   except
       on E : Exception do
       begin

          Raise Exception.Create(
          'Falha ao processar os dados da Pessoa [View]: ' + #13 + e.Message);
       end
   end;
end;

function TfrmClientes.ProcessaEndereco: Boolean;
begin
   try
       Result := True;
   except
      on E : Exception do
      begin
         Raise Exception.Create(
            'Falha ao preencher os dados de endere�o do cliente [View]' + #13  +
            e.Message);

      end;
   end;

end;

end.

