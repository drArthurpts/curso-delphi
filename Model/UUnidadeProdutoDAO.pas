unit UUnidadeProdutoDAO;

interface

uses SqlExpr, DBXpress, SimpleDS, Db , Classes , SysUtils, DateUtils,
     StdCtrls, UGenericDAO, UUnidadeProduto;


type

   TUnidadeProdutoDAO = Class(TGenericDAO)
      public
         constructor Create(pConexao : TSQLConnection);



   end;


implementation

{ TUnidadeProdutoDAO }

constructor TUnidadeProdutoDAO.Create(pConexao: TSQLConnection);
begin
   inherited Create;
   vEntidade := 'UNIDADEDEPRODUTO';
   vConexao  := pConexao;
   vClass    := TUnidadeProduto;
end;

end.
 