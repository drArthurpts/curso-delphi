object frmPrincipal: TfrmPrincipal
  Left = 351
  Top = 98
  Width = 928
  Height = 480
  Caption = 'Novo Sistema'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainCadastro
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object MainCadastro: TMainMenu
    Left = 32
    Top = 376
    object menMenu: TMenuItem
      Caption = 'Cadastros'
      object menCliente: TMenuItem
        Caption = 'Clientes'
      end
      object MenProdutos: TMenuItem
        Caption = 'Produtos'
      end
    end
    object menRelatorios: TMenuItem
      Caption = 'Relat'#243'rios'
      object menRelVendas: TMenuItem
        Caption = 'Vendas'
      end
    end
    object MenMovimentos: TMenuItem
      Caption = 'Movimentos'
      object menVendas: TMenuItem
        Caption = 'Vendas'
      end
    end
    object menSair: TMenuItem
      Caption = 'Sair'
      OnClick = menSairClick
    end
  end
end
