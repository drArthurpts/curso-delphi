unit UPrincipalView;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Menus;

type
  TfrmPrincipal = class(TForm)
    MainCadastro: TMainMenu;
    menMenu: TMenuItem;
    menCliente: TMenuItem;
    MenProdutos: TMenuItem;
    menRelatorios: TMenuItem;
    menRelVendas: TMenuItem;
    MenMovimentos: TMenuItem;
    menVendas: TMenuItem;
    menSair: TMenuItem;
    procedure menSairClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

{$R *.dfm}

procedure TfrmPrincipal.menSairClick(Sender: TObject);
begin
  Close; //Fecha o sistema
end;

end.
