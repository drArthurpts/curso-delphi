unit UClientePesqView;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, ComCtrls;

type
  TfrmClientesPesq = class(TForm)
    stbBarraStatus: TStatusBar;
    pnlBotoes: TPanel;
    btnLimpar: TBitBtn;
    btnConfirmar: TBitBtn;
    btnSair: TBitBtn;
    pnlFiltro: TPanel;
    pnlResultado: TPanel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmClientesPesq: TfrmClientesPesq;

implementation

{$R *.dfm}

end.
