# frozen_string_literal: true

class BattlesController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :show_not_found_error

  def index
    @battles = Battle.all
    render json: { data: @battles }, status: :ok
  end

  def create
    @battle = Battle.create(
      monsterA: Monster.find(params[:monsterA]),
      monsterB: Monster.find(params[:monsterB])
    )
    if @battle.save
      render json: { data: @battle }, status: :ok
    else
      render json: { message: 'Winner not set' }, status: :bad_request
    end
  end

  def destroy
    @battle = Battle.find(params[:id])
    if @battle.destroy
      redirect_to root_path, status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound
    render json: { message: 'The battles does not exists.' }, status: :not_found
  end

  private

  def show_not_found_error
    render json: { message: 'The monster does not exists.' }, status: :bad_request
  end
end
