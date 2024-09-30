unit UPessoaController;

interface

uses SysUtils, Math, StrUtils, UConexao, UPessoa, UEndereco;

type
   TPessoaController = class
      public
         constructor Create;
         function GravaPessoa(pPessoa : TPessoa;
                              pColEndereco : TColEndereco) : Boolean;

         function ExcluiPessoa (pPessoa : TPessoa) : Boolean;
         function BuscaPessoa(pID : Integer) : TPessoa;

         function BuscaEnderecoPessoa(pID_Pessoa : Integer)  :  TColEndereco;

         function RetornaCondicaoPessoa(
                  pId_Pessoa : Integer;
                   pRelacionada : Boolean = False) : String;

         function ValidaCPF(const CPF : String) : Boolean;

         published
            class function  getInstancia : TPessoaController;

   end;

var
   _instance: TPessoaController;

implementation

uses UPessoaDAO, UEnderecoDAO;

{ TPessoaController }

function TPessoaController.BuscaEnderecoPessoa(
  pID_Pessoa: Integer): TColEndereco;
var
   xEnderecoDAO : TEnderecoDAO;
begin
   try
       try
         Result := nil;

         xEnderecoDAO :=
            TEnderecoDAO.Create(TConexao.getInstance.getConn);

         Result :=
            xEnderecoDAO.RetornaLista(RetornaCondicaoPessoa(pID_Pessoa, True));
       finally
         if (xEnderecoDAO <> nil) then
            FreeAndNil(xEnderecoDAO);
       end;
   except
       on E : Exception do
      begin
         Raise Exception.Create(
            'Falha ao buscar os dados do endere�o da pessoa. [Controller]' + #13+
            e.Message);
      end;
   end;

end;

function TPessoaController.BuscaPessoa(pID: Integer): TPessoa;
var
      xPessoaDAO : TPessoaDAO ;
begin
   try
      try
         Result := nil;

         xPessoaDAO := TPessoaDAO.Create(TConexao.getInstance.getConn);
         Result := xPessoaDAO.Retorna(RetornaCondicaoPessoa(pID));
      finally
         if(xPessoaDAO <> nil) then
         FreeAndNil(xPessoaDAO);
      end;
   except
      on E : Exception do
      begin
         Raise Exception.Create(
            'Falha ao buscar os dados da pessoa. [Controller]' + #13+
            e.Message);
      end;
   end;
end;

constructor TPessoaController.Create;
begin
   inherited Create;
end;

function TPessoaController.ExcluiPessoa(pPessoa: TPessoa): Boolean;
var
   xPessoaDAO   : TPessoaDAO;
   xEnderecoDAO : TEnderecoDAO;
begin
   try
      try
         Result := False;

         TConexao.get.iniciaTransacao;

         xPessoaDAO := TPessoaDAO.Create(TConexao.get.getConn);

         xEnderecoDAO := TEnderecoDAO.Create(TConexao.get.getConn);

         if (pPessoa.Id = 0) then
            Exit
         else
         begin
            xPessoaDAO.Deleta(RetornaCondicaoPessoa(pPessoa.Id));
            xEnderecoDAO.Deleta(RetornaCondicaoPessoa(pPessoa.Id, True));
         end;


         TConexao.get.confirmaTransacao;

         Result := True;

      finally
         if xPessoaDAO <> nil then
            FreeAndNil(xPessoaDAO);

         if xEnderecoDAO <> nil then
            FreeAndNil(xEnderecoDAO);
      end;
   except
       on E : Exception do
       begin
          TConexao.get.cancelaTransacao;
          Raise Exception.Create(
               'Falha ao escluir os dados da pessoa [Controller]: ' + #13 +
                e.Message);
       end;

   end;
end;

class function TPessoaController.getInstancia: TPessoaController;
begin
   if _instance = nil then
      _instance := TPessoaController.Create;

   Result := _instance;

end;

function TPessoaController.GravaPessoa(
   pPessoa: TPessoa ;
   pColEndereco : TColEndereco): Boolean;
var
   xPessoaDAO   : TPessoaDAO;
   xEnderecoDAO : TEnderecoDAO;
   xAux : Integer;

begin
   try
      try
         TConexao.get.iniciaTransacao;
         Result := False;

         xPessoaDAO :=
            TPessoaDAO.Create(TConexao.get.getConn);

         xEnderecoDAO :=
            TEnderecoDAO.Create(TConexao.get.getConn);

         if pPessoa.Id = 0 then
         begin
            xPessoaDAO.Insere(pPessoa);

            for xAux := 0 to pred(pColEndereco.Count) do
               pColEndereco.Retorna(xAux).ID_Pessoa := pPessoa.Id;
               

            xEnderecoDAO.InsereLista(pColEndereco)
         end
         else
         begin

            xPessoaDAO.Atualiza(pPessoa, RetornaCondicaoPessoa(pPessoa.Id));
            
            xEnderecoDAO.Deleta(RetornaCondicaoPessoa(pPessoa.Id, True));
            xEnderecoDAO.InsereLista(pColEndereco);
         end;

         TConexao.get.confirmaTransacao;
      finally
         if (xPessoaDAO <> nil) then
            FreeAndNil(xPessoaDAO);
      end;
   except
      on E : Exception do
      begin
         TConexao.get.cancelaTransacao;
         Raise Exception.Create(
         'Falha ao gravar os dados da pessoa [Controller]. ' + #13 +
         e.Message);
      end;
   end;
end;

function TPessoaController.RetornaCondicaoPessoa(
  pId_Pessoa: Integer ; pRelacionada : Boolean): String;
var
    xChave : String;
begin
   if (pRelacionada = True) then
       xChave := 'ID_PESSOA'
   else
       xChave := 'ID';

   Result :=
   'WHERE ' + #13 +
   '    ' + xChave + '  =  ' + QuotedStr(IntToStr(pId_Pessoa)) + ' '#13;
end;


function TPessoaController.ValidaCPF(const CPF: String): Boolean;
var
  Digito1, Digito2: Integer;
  Soma, Resto, I: Integer;
  CPFArray: array[1..11] of Integer;
begin
  Result := False;


  if Length(CPF) <> 11 then
    Exit;


  if CPF = StringOfChar(CPF[1], 11) then
    Exit;


  for I := 1 to 11 do
    CPFArray[I] := StrToIntDef(CPF[I], -1);


  for I := 1 to 11 do
    if CPFArray[I] = -1 then
      Exit;


  Soma := 0;
  for I := 1 to 9 do
    Soma := Soma + CPFArray[I] * (10 - I);

  Resto := Soma mod 11;
  if Resto < 2 then
    Digito1 := 0
  else
    Digito1 := 11 - Resto;


  Soma := 0;
  for I := 1 to 9 do
    Soma := Soma + CPFArray[I] * (11 - I);
  Soma := Soma + Digito1 * 2;

  Resto := Soma mod 11;
  if Resto < 2 then
    Digito2 := 0
  else
    Digito2 := 11 - Resto;

  
  Result := (Digito1 = CPFArray[10]) and (Digito2 = CPFArray[11]);
end;
   end.


