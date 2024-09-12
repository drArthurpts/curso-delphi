unit UPessoaDAO;

interface

uses
   SqlExpr, DBXpress, SimpleDS, Db, Classes, SysUtils, DateUtils,
   StdCtrls, UGenericDAO, UPessoa;

type

TPessoaDAO  = Class(TGenericDAO)
      public
         constructor Create(pConexao : TSQLConnection);

   end;

implementation

{ TPessoaDAO }

constructor TPessoaDAO.Create(pConexao: TSQLConnection);
begin
   inherited Create;
   vEntidade := 'PESSOA';
end;

end.
 