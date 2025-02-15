class MonstersController < ApplicationController
  require 'csv'

  rescue_from ActiveRecord::RecordNotFound, with: :show_not_found_error

  def index
    @monsters = Monster.order(:id).all
    render json: { data: @monsters }, status: :ok
  end

  def new
    @monster = Monster.new
  end

  def create
    @monster = Monster.new(monster_params)

    if @monster.save
      render json: { data: @monster }, status: :created
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @monster = Monster.find(params[:id])
    render json: { data: @monster }, status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: { message: 'The monster does not exists.' }, status: :not_found
  end

  def edit
    @monster = Monster.find(params[:id])
  end

  def update
    @monster = Monster.find(params[:id])

    if @monster.update(monster_params)
      render json: { data: @monster }, status: :ok
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @monster = Monster.find(params[:id])

    if @monster.destroy
      redirect_to root_path, status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def import # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    file = params[:file]

    if file
      ext = File.extname(file.original_filename)
      unless ['.csv'].include?(ext)
        return render json: { message: 'File should be csv.' }, status: :bad_request
      end

      if (handle = file.tempfile)
        rowData = [] # rubocop:disable Naming/VariableName
        rowData << CSV.parse_line(handle.gets) until handle.eof? # rubocop:disable Naming/VariableName

        csv_data = rowData[1..] # rubocop:disable Naming/VariableName

        begin
          CsvImportService.new.import_monster(rowData, csv_data) # rubocop:disable Naming/VariableName
          render json: { data: 'Records were imported successfully.' }, status: :ok
        rescue ActiveRecord::StatementInvalid
          render json: { message: 'Wrong data mapping.' }, status: :bad_request
        rescue StandardError
          render json: { message: 'Wrong data mapping.' }, status: :bad_request
        end
      end
    else
      render json: { message: 'Wrong data mapping.' }, status: :bad_request
    end
  end

  private

  def show_not_found_error
    render json: { message: 'The monster does not exists.' }, status: :not_found
  end

  def monster_params
    params.require(:monster)
          .permit(:name, :imageUrl, :attack, :defense, :hp, :speed)
  end
end
