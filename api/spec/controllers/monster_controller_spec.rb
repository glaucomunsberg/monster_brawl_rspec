# rubocop:disable Style/FrozenStringLiteralComment
require 'rails_helper'

RSpec.describe MonstersController, type: :controller do # rubocop:disable Metrics/BlockLength
  def create_monsters
    FactoryBot.create_list(:monster, 1)
  end

  it 'should get all monsters correctly' do
    create_monsters
    get :index
    response_data = JSON.parse(response.body)['data']

    expect(response).to have_http_status(:ok)
    expect(response_data[0]['name']).to eq('Dead Unicorn')
  end

  it 'should get a single monster correctly' do
    create_monsters
    get :show, params: { id: 1 }
    response_data = JSON.parse(response.body)['data']

    expect(response).to have_http_status(:ok)
    expect(response_data['name']).to eq('Dead Unicorn')
  end

  it 'should get 404 error if monster does not exists' do
    get :show, params: { id: 99 }

    expect(response).to have_http_status(:not_found)
    expect(JSON.parse(response.body)['message']).to eq('The monster does not exists.')
  end

  it 'should create a new monster' do
    monster_attributes = FactoryBot.attributes_for(:monster)

    post :create, params: { monster: monster_attributes }

    response_data = JSON.parse(response.body)['data']

    expect(response).to have_http_status(:created)
    expect(response_data['name']).to eq('My monster Test')
  end

  it 'should update a monster correctly' do
    create_monsters
    monster_attributes = FactoryBot.attributes_for(:monster)
    put :update, params: { id: 1, monster: monster_attributes }

    expect(response).to have_http_status(:ok)
  end

  it 'should fail update when monster does not exist' do
    monster_attributes = FactoryBot.attributes_for(:monster)
    put :update, params: { id: 99, monster: monster_attributes }

    expect(response).to have_http_status(:not_found)
    expect(JSON.parse(response.body)['message']).to eq('The monster does not exists.')
  end

  it 'should delete a monster correctly' do
    create_monsters
    delete :destroy, params: { id: 1 }

    expect(response).to have_http_status(:see_other)
  end

  it 'should fail delete when monster does not exist' do
    delete :destroy, params: { id: 99 }

    expect(response).to have_http_status(:not_found)
    expect(JSON.parse(response.body)['message']).to eq('The monster does not exists.')
  end

  it 'should import all the CSV objects into the database successfully' do
    file = fixture_file_upload("#{Rails.root}/test/fixtures/files/monsters.csv")

    expect(File.exist?(file.path)).to eq(true)

    post :import, params: { file: }

    expect(response).to have_http_status(:ok)
    expect(JSON.parse(response.body)['data']).to eq('Records were imported successfully.')
  end

  it 'should fail when importing csv file with inexistent columns' do
    file = fixture_file_upload("#{Rails.root}/test/fixtures/files/monsters_inexistent_columns.csv")

    expect(File.exist?(file.path)).to eq(true)

    post :import, params: { file: }

    expect(response).to have_http_status(:bad_request)
    expect(JSON.parse(response.body)['message']).to eq('Wrong data mapping.')
  end

  it 'should fail when importing csv file with wrong columns' do
    file = fixture_file_upload("#{Rails.root}/test/fixtures/files/monsters_wrong_columns.csv")

    expect(File.exist?(file.path)).to eq(true)

    post :import, params: { file: }

    expect(response).to have_http_status(:bad_request)
    expect(JSON.parse(response.body)['message']).to eq('Wrong data mapping.')
  end

  it 'should fail when importing file with different extension' do
    file = fixture_file_upload("#{Rails.root}/test/fixtures/files/monsters.txt")

    expect(File.exist?(file.path)).to eq(true)

    post :import, params: { file: }

    expect(response).to have_http_status(:bad_request)
    expect(JSON.parse(response.body)['message']).to eq('File should be csv.')
  end

  it 'should fail when importing none file' do
    post :import

    expect(response).to have_http_status(:bad_request)
    expect(JSON.parse(response.body)['message']).to eq('Wrong data mapping.')
  end
end

# rubocop:enable Style/FrozenStringLiteralComment
