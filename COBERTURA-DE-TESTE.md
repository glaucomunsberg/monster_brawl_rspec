# Tests

Este documento explica cada teste nos arquivos `monster_controller_spec.rb` e `monster_spec.rb`.

## Monster Controller Spec Tests

### 1. Recuperar todos os monstros corretamente
Este teste verifica se todos os monstros são recuperados corretamente do banco de dados.

```ruby
it 'should get all monsters correctly' do
  create_monsters
  get :index
  response_data = JSON.parse(response.body)['data']

  expect(response).to have_http_status(:ok)
  expect(response_data[0]['name']).to eq('Dead Unicorn')
end
```

### 2. Recuperar um único monstro corretamente
Este teste verifica se um monstro pode ser recuperado corretamente usando seu ID.

```ruby
it 'should get a single monster correctly' do
  create_monsters
  get :show, params: { id: 1 }
  response_data = JSON.parse(response.body)['data']

  expect(response).to have_http_status(:ok)
  expect(response_data['name']).to eq('Dead Unicorn')
end
```

### 3. Retornar erro 404 se o monstro não existir
Este teste garante que um erro 404 seja retornado ao tentar recuperar um monstro inexistente.

```ruby
it 'should get 404 error if monster does not exists' do
  get :show, params: { id: 99 }

  expect(response).to have_http_status(:not_found)
  expect(JSON.parse(response.body)['message']).to eq('The monster does not exists.')
end
```

### 4. Criar um novo monstro
Este teste verifica se um novo monstro pode ser criado com sucesso.

```ruby
it 'should create a new monster' do
  monster_attributes = FactoryBot.attributes_for(:monster)

  post :create, params: { monster: monster_attributes }

  response_data = JSON.parse(response.body)['data']

  expect(response).to have_http_status(:created)
  expect(response_data['name']).to eq('My monster Test')
end
```

### 5. Atualizar um monstro corretamente
Este teste verifica se um monstro pode ser atualizado corretamente.

```ruby
it 'should update a monster correctly' do
  create_monsters
  monster_attributes = FactoryBot.attributes_for(:monster)
  put :update, params: { id: 1, monster: monster_attributes }

  expect(response).to have_http_status(:ok)
end
```

### 6. Falhar ao atualizar um monstro inexistente
Este teste garante que a atualização falha com erro 404 quando o monstro não existe.

```ruby
it 'should fail update when monster does not exist' do
  monster_attributes = FactoryBot.attributes_for(:monster)
  put :update, params: { id: 99, monster: monster_attributes }

  expect(response).to have_http_status(:not_found)
  expect(JSON.parse(response.body)['message']).to eq('The monster does not exists.')
end
```

### 7. Deletar um monstro corretamente
Este teste verifica se um monstro pode ser deletado corretamente.

```ruby
it 'should delete a monster correctly' do
  create_monsters
  delete :destroy, params: { id: 1 }

  expect(response).to have_http_status(:see_other)
end
```

### 8. Falhar ao deletar um monstro inexistente
Este teste garante que a operação de exclusão falhe com erro 404 quando o monstro não existir.

```ruby
it 'should fail delete when monster does not exist' do
  delete :destroy, params: { id: 99 }

  expect(response).to have_http_status(:not_found)
  expect(JSON.parse(response.body)['message']).to eq('The monster does not exists.')
end
```

### 9. Importar todos os objetos do CSV para o banco de dados com sucesso
Este teste verifica se todos os objetos de um arquivo CSV são importados corretamente.

```ruby
it 'should import all the CSV objects into the database successfully' do
  file = fixture_file_upload('files/monsters.csv', 'text/csv')
  post :import, params: { file: file }

  expect(response).to have_http_status(:created)
end
```

---

## Battle Controller Spec Tests

### 1. Recuperar todas as batalhas corretamente
Este teste verifica se todas as batalhas são recuperadas corretamente do banco de dados.

```ruby
it 'should get all battles correctly' do
  create_battles
  get :index
  response_data = JSON.parse(response.body)['data']

  expect(response).to have_http_status(:ok)
  expect(response_data.count).to eq(2)
end
```

### 2. Criar batalha com erro de requisição se um parâmetro for nulo
Este teste garante que um erro de requisição seja retornado quando um dos parâmetros for nulo.

```ruby
it 'should create battle with bad request if one parameter is null' do
  post :create, params: { monsterA: @monster1.id, monsterB: nil }

  expect(response).to have_http_status(:bad_request)
  expect(JSON.parse(response.body)['message']).to eq('The monster does not exists.')
end
```

### 3. Criar batalha com erro de requisição se um monstro não existir
Este teste garante que um erro de requisição seja retornado quando um dos monstros não existir.

```ruby
it 'should create battle with bad request if monster does not exist' do
  post :create, params: { monsterA: @monster1.id, monsterB: 99 }

  expect(response).to have_http_status(:bad_request)
  expect(JSON.parse(response.body)['message']).to eq('The monster does not exists.')
end
```

### 4. Criar batalha corretamente com o monstro A vencendo
Este teste verifica se uma batalha é criada corretamente com o monstro A vencendo.

```ruby
it 'should create battle correctly with monsterA winning' do
  post :create, params: { monsterA: @monster1.id, monsterB: @monster2.id }

  expect(response).to have_http_status(:created)
  expect(JSON.parse(response.body)['data']['winner']).to eq(@monster1.id)
end
```

### 5. Criar batalha corretamente com o monstro B vencendo (defesa igual e maior velocidade)
Este teste verifica se uma batalha é criada corretamente com o monstro B vencendo quando ambos têm defesa igual, mas o monstro B tem velocidade maior.

```ruby
it 'should create battle correctly with monsterB winning with equal defense and monsterB higher speed' do
  @monster1.update(defense: 40, speed: 10)
  @monster2.update(defense: 40, speed: 20)
  post :create, params: { monsterA: @monster1.id, monsterB: @monster2.id }

  expect(response).to have_http_status(:ok)
  expect(JSON.parse(response.body)['data']['winner_id']).to eq(@monster2.id)
end
```

---

# Resumo

Ao escrever testes, os desenvolvedores muitas vezes negligenciam vários aspectos críticos:

1. **Casos Limite**: Muitas vezes, não são considerados casos limite, como registros inexistentes ou parâmetros nulos, o que pode levar a exceções não tratadas em produção.

2. **Mensagens de Erro**: Garantir que as mensagens de erro sejam claras e informativas é crucial. Por exemplo, um teste deve verificar se a resposta retorna `The monster does not exists.` ao tentar excluir um monstro inexistente.

3. **Códigos de Status**: Os desenvolvedores devem garantir que os códigos de status HTTP corretos sejam retornados para diferentes cenários. Por exemplo, uma exclusão bem-sucedida deve retornar `see_other`, enquanto uma tentativa falha de excluir um monstro inexistente deve retornar `not_found`.

4. **Configuração e Limpeza de Dados**: Configurar e limpar corretamente os dados de teste é essencial para evitar efeitos colaterais entre os testes. Criar batalhas antes de testar a exclusão garante um ambiente de teste correto.
