# Tests

This document explains each test in the `monster_controller_spec.rb` and `monster_spec.rb` files.

## Monster Controller Spec Tests

### 1. Get all monsters correctly
This test verifies that all monsters are retrieved correctly from the database.

```ruby
it 'should get all monsters correctly' do
  create_monsters
  get :index
  response_data = JSON.parse(response.body)['data']

  expect(response).to have_http_status(:ok)
  expect(response_data[0]['name']).to eq('Dead Unicorn')
end
```

### 2. Get a single monster correctly
This test checks if a single monster can be retrieved correctly using its ID.

```ruby
it 'should get a single monster correctly' do
  create_monsters
  get :show, params: { id: 1 }
  response_data = JSON.parse(response.body)['data']

  expect(response).to have_http_status(:ok)
  expect(response_data['name']).to eq('Dead Unicorn')
end
```

### 3. Get 404 error if monster does not exist
This test ensures that a 404 error is returned when trying to retrieve a monster that does not exist.

```ruby
it 'should get 404 error if monster does not exists' do
  get :show, params: { id: 99 }

  expect(response).to have_http_status(:not_found)
  expect(JSON.parse(response.body)['message']).to eq('The monster does not exists.')
end
```

### 4. Create a new monster
This test verifies that a new monster can be created successfully.

```ruby
it 'should create a new monster' do
  monster_attributes = FactoryBot.attributes_for(:monster)

  post :create, params: { monster: monster_attributes }

  response_data = JSON.parse(response.body)['data']

  expect(response).to have_http_status(:created)
  expect(response_data['name']).to eq('My monster Test')
end
```

### 5. Update a monster correctly

This test checks if a monster can be updated correctly.

```ruby
it 'should update a monster correctly' do
  create_monsters
  monster_attributes = FactoryBot.attributes_for(:monster)
  put :update, params: { id: 1, monster: monster_attributes }

  expect(response).to have_http_status(:ok)
end
```

### 6. Fail update when monster does not exist

This test ensures that an update fails with a 404 error when the monster does not exist.

```ruby
it 'should fail update when monster does not exist' do
  monster_attributes = FactoryBot.attributes_for(:monster)
  put :update, params: { id: 99, monster: monster_attributes }

  expect(response).to have_http_status(:not_found)
  expect(JSON.parse(response.body)['message']).to eq('The monster does not exists.')
end
```
### 7. Delete a monster correctly
This test verifies that a monster can be deleted correctly.

```ruby
it 'should delete a monster correctly' do
  create_monsters
  delete :destroy, params: { id: 1 }

  expect(response).to have_http_status(:see_other)
end
```

### 8. Fail delete when monster does not exist

This test ensures that a delete operation fails with a 404 error when the monster does not exist

```ruby
it 'should fail delete when monster does not exist' do
  delete :destroy, params: { id: 99 }

  expect(response).to have_http_status(:not_found)
  expect(JSON.parse(response.body)['message']).to eq('The monster does not exists.')
end
```

### 9. Import all the CSV objects into the database successfully

This test checks if all objects from a CSV file are imported into the database successfully.

```ruby
it 'should import all the CSV objects into the database successfully' do
  file = fixture_file_upload('files/monsters.csv', 'text/csv')
  post :import, params: { file: file }

  expect(response).to have_http_status(:created)
end
```

### 10. Fail when importing CSV file with inexistent columns
This test ensures that importing a CSV file with nonexistent columns fails with a bad request error.

```ruby
it 'should fail when importing csv file with inexistent columns' do
  file = fixture_file_upload("#{Rails.root}/test/fixtures/files/monsters_inexistent_columns.csv")

  expect(File.exist?(file.path)).to eq(true)

  post :import, params: { file: }

  expect(response).to have_http_status(:bad_request)
  expect(JSON.parse(response.body)['message']).to eq('Wrong data mapping.')
end
```

### 11. Fail when importing CSV file with wrong columns
This test ensures that importing a CSV file with incorrect columns fails with a bad request error.

```ruby
it 'should fail when importing csv file with wrong columns' do
  file = fixture_file_upload("#{Rails.root}/test/fixtures/files/monsters_wrong_columns.csv")

  expect(File.exist?(file.path)).to eq(true)

  post :import, params: { file: }

  expect(response).to have_http_status(:bad_request)
  expect(JSON.parse(response.body)['message']).to eq('Wrong data mapping.')
end
```

### 12. Fail when importing file with different extension
This test ensures that importing a file with a different extension fails with a bad request error.

```ruby
it 'should fail when importing file with different extension' do
  file = fixture_file_upload("#{Rails.root}/test/fixtures/files/monsters.txt")

  expect(File.exist?(file.path)).to eq(true)

  post :import, params: { file: }

  expect(response).to have_http_status(:bad_request)
  expect(JSON.parse(response.body)['message']).to eq('File should be csv.')
end
```

### 13. Fail when importing none file
This test ensures that importing a nonexistent file fails with a bad request error.

```ruby
it 'should fail when importing none file' do
  post :import

  expect(response).to have_http_status(:bad_request)
  expect(JSON.parse(response.body)['message']).to eq('Wrong data mapping.')
end
```

## Battle Controller Spec Tests


## Tests

### 1. Get all battles correctly
This test verifies that all battles are retrieved correctly from the database.

```ruby
it 'should get all battles correctly' do
  create_battles
  get :index
  response_data = JSON.parse(response.body)['data']

  expect(response).to have_http_status(:ok)
  expect(response_data.count).to eq(2)
end
```

### 2. Create battle with bad request if one parameter is null

This test ensures that a bad request error is returned when one of the parameters is null.

```ruby
it 'should create battle with bad request if one parameter is null' do
  post :create, params: { monsterA: @monster1.id, monsterB: nil }

  expect(response).to have_http_status(:bad_request)
  expect(JSON.parse(response.body)['message']).to eq('The monster does not exists.')
end
```

### 3. Create battle with bad request if monster does not exist
This test ensures that a bad request error is returned when one of the monsters does not exist.


```ruby
it 'should create battle with bad request if monster does not exist' do
  post :create, params: { monsterA: @monster1.id, monsterB: 99 }

  expect(response).to have_http_status(:bad_request)
  expect(JSON.parse(response.body)['message']).to eq('The monster does not exists.')
end
```

### 4. Create battle correctly with monsterA winning
This test verifies that a battle is created correctly with monster A winning.


```ruby
it 'should create battle correctly with monsterA winning' do
  post :create, params: { monsterA: @monster1.id, monsterB: @monster2.id }

  expect(response).to have_http_status(:created)
  expect(JSON.parse(response.body)['data']['winner']).to eq(@monster1.id)
end
```

### 5. Create battle correctly with monsterB winning with equal defense and monsterB higher speed
This test verifies that a battle is created correctly with monster B winning when both monsters have equal defense but monster B has higher speed.

```ruby
it 'should create battle correctly with monsterB winning with equal defense and monsterB higher speed' do
  @monster1.update(defense: 40, speed: 10)
  @monster2.update(defense: 40, speed: 20)
  post :create, params: { monsterA: @monster1.id, monsterB: @monster2.id }

  expect(response).to have_http_status(:ok)
  expect(JSON.parse(response.body)['data']['winner_id']).to eq(@monster2.id)
end
```

### 6. Delete a battle correctly

This test verifies that a battle can be deleted correctly.

```ruby
it 'should delete a battle correctly' do
  create_battles
  delete :destroy, params: { id: 1 }

  expect(response).to have_http_status(:see_other)
end
```

### 7. Fail delete when battle does not exist

This test ensures that a delete operation fails with a 404 error when the battle does not exist.

```ruby
it 'should fail delete when battle does not exist' do
  delete :destroy, params: { id: 99 }

  expect(response).to have_http_status(:not_found)
  expect(JSON.parse(response.body)['message']).to eq('The battles does not exists.')
end
```

## RESUME

When writing tests, developers often overlook several critical aspects:

1. **Edge Cases**: Developers may not consider edge cases, such as non-existent records or null parameters, which can lead to unhandled exceptions in production. For example, tests should verify that a delete operation fails with a 404 error when the battle does not exist.

2. **Error Messages**: Ensuring that error messages are clear and informative is crucial. Tests should verify that the correct error messages are returned, such as checking that the response message is 'The battles does not exists.' when attempting to delete a non-existent battle.

3. **Status Codes**: Developers should ensure that the correct HTTP status codes are returned for different scenarios. For instance, a successful delete operation should return a status of see_other, while a failed delete due to a non-existent battle should return not_found.

4. **Data Setup and Cleanup**: Properly setting up and cleaning up test data is essential to avoid side effects between tests. For example, creating battles before testing the delete operation ensures that the test environment is correctly set up.


