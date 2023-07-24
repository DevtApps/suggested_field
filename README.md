
# SuggestedField

Implementação simples de um TextField com sugestões




## Instalação

Instale o SuggestedField adicionando o pacote no arquivo pubspec.yaml

      suggested_field: ^0.0.1


    
## Demonstração


### Construtor 


    SuggestedField(
      closeOnEmpty: true,
      suggestions: [],
      loading: false,
      onTap: (suggestion){
            //suggestion clicked
      })

`closeOnEmpty` - Informa se a caixa de sugestões deve ser exibida quando não há sugestões disponíveis

`suggestions` - Lista de objetos Suggestion

`loading` - Se true, exibe um loading na caixa de sugestões

`onTap` - Método chamado ao clicar em uma sugestão



### Classe Suggestion

    Suggestion(subtitle: "Sou uma sugestão", title: "Sou um título", value: "sou um valor dinamico")


`title`  - Primeiro texto exibido no item de sugestão

`subtitle` - Se passado, é exibido abaixo do title

`value` - Valor obrigatório e dinamico, é devolvido no método onTap do SuggestedField
## Licença

[MIT](https://choosealicense.com/licenses/mit/)


## Etiquetas



[![MIT License](https://img.shields.io/badge/License-MIT-green.svg)](https://choosealicense.com/licenses/mit/)
[![GPLv3 License](https://img.shields.io/badge/License-GPL%20v3-yellow.svg)](https://opensource.org/licenses/)
[![AGPL License](https://img.shields.io/badge/license-AGPL-blue.svg)](http://www.gnu.org/licenses/agpl-3.0)

