#Descrição do aplicativo

O aplicativo se apresenta com duas telas conforme o modelo ‘Master/Detail’. A primeira tela (a tela ‘Master’) apresenta a lisa de todos os contatos. A segunda tela serve para mostrar os detalhes de um contato só.

A criação de um contato fica na primeira tela.
As funcionalidades de modificação e a supressão de um usuário são accessíveis na tela de detalhes.


#Arquitetura do projeto

O aplicativo repõe sobre uma arquitetura MVVM e se decompõe em 3 camadas:
A camada da interface de usuário: ‘View’
Uma camada que contém a lógica de negocio e os dados que a primeira camada apresenta: ‘ViewModel’
A última camada tem a responsabilidade de armazenar os dados em um banco de dados: ‘Model’

O ‘Binding’ entre a primeira camada e o ‘ViewModel’ segue o padrão de programação ‘Reactive Functional Programing’.
O ‘Modelo’ é armazenado em um banco Realm.


# Frameworks usados

Banco de dados: Realm, pois é um framework muito comum nos aplicativos para iPhone.
O framework ‘Reactive Functional Programing’ usado é o RxSwift.
Para baixar os dados, usei o framework Alamofire e BrightFutures. Alamofire permite de realizar buscas http assíncronas. O BrightFutures é usado para evitar o uso de ‘Callback’ e deixa um código mais simples a ler.


# Primeiro passo

Todos os frameworks foram integrados com CocoaPods. É necessário executar o comando ‘pods install’ na pasta do projeto.


# Melhoras

Calculo das imagens no fundo da segunda tela: calcular essas imagens em um ‘Thread’ assíncrono afim de não para a transição entre as telas.

Armazenamento das alterações: as alterações não estão gravadas.



