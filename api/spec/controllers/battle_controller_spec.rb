# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BattlesController, type: :controller do # rubocop:disable Metrics/BlockLength
  before(:each) do
    @monster1 = FactoryBot.create(:monster,
                                  name: 'My monster Test 1',
                                  attack: 40,
                                  defense: 20,
                                  hp: 50,
                                  speed: 80,
                                  imageUrl: 'https://example.com/image.jpg')
    @monster2 = FactoryBot.create(:monster,
                                  name: 'My monster Test 2',
                                  attack: 20,
                                  defense: 40,
                                  hp: 70,
                                  speed: 10,
                                  imageUrl: 'https://example.com/image.jpg')

    # Please include additional monsters here for testing purposes.
  end

  def create_battles
    FactoryBot.create_list(:battle, 2)
  end

  it 'should get all battles correctly' do
    create_battles
    get :index
    response_data = JSON.parse(response.body)['data']

    expect(response).to have_http_status(:ok)
    expect(response_data.count).to eq(2)
  end

  it 'should create battle with bad request if one parameter is null' do
    post :create, params: { monsterA: @monster1.id, monsterB: nil }

    expect(response).to have_http_status(:bad_request)
    expect(JSON.parse(response.body)['message']).to eq('The monster does not exists.')
  end

  it 'should create battle with bad request if monster does not exists' do
    post :create, params: { monsterA: @monster1.id, monsterB: 99 }

    expect(response).to have_http_status(:bad_request)
    expect(JSON.parse(response.body)['message']).to eq('The monster does not exists.')
  end

  it 'should create battle correctly with monsterA winning' do
    @monster1.update(attack: 80)
    post :create, params: { monsterA: @monster1.id, monsterB: @monster2.id }

    expect(response).to have_http_status(:ok)
    expect(JSON.parse(response.body)['data']['winner_id']).to eq(@monster1.id)
  end

  it 'should create battle correctly with monsterB winning with equal defense and monsterB higher speed' do
    @monster1.update(defense: 40, speed: 10)
    @monster2.update(defense: 40, speed: 20)
    post :create, params: { monsterA: @monster1.id, monsterB: @monster2.id }

    expect(response).to have_http_status(:ok)
    expect(JSON.parse(response.body)['data']['winner_id']).to eq(@monster2.id)
  end

  it 'should delete a battle correctly' do
    create_battles
    delete :destroy, params: { id: 1 }

    expect(response).to have_http_status(:see_other)
  end

  it 'should fail delete when battle does not exist' do
    delete :destroy, params: { id: 99 }

    expect(response).to have_http_status(:not_found)
    expect(JSON.parse(response.body)['message']).to eq('The battles does not exists.')
  end
end
