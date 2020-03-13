require 'pry'

class FiguresController < ApplicationController

  get '/figures' do
    @figures = Figure.all

    erb :'figures/index'
  end

  get '/figures/new' do
    @titles = Title.all
    @landmarks = Landmark.all

    erb :'figures/new'
  end

  get '/figures/:id/edit' do
    @figure = Figure.find(params[:id])
    @titles = Title.all
    @landmarks = Landmark.all

    erb :'figures/edit'
  end

  get '/figures/:id' do
    @figure = Figure.find(params[:id])

    erb :'figures/show'
  end

  post '/figures' do
    params.delete_if {|key, value| value[:name] == ""}
    p params
    p "*******************"

    figure = Figure.create(name: params[:figure][:name])
    if params[:figure].has_key?(:title_ids)
      params[:figure][:title_ids].each do |id|
        title = Title.find(id)
        FigureTitle.create(figure: figure, title: title)
        # figure.titles << title
      end
    end
    if params.has_key?(:new_title)
      new_title = Title.create(name: params[:new_title][:name])
      FigureTitle.create(figure: figure, title: new_title)
    end
    if params[:figure].has_key?(:landmark_ids)
      params[:figure][:landmark_ids].each do |id|
        figure.landmarks << Landmark.find(id)
      end
    end
    if params.has_key?(:new_landmark)
      landmark_hash = params[:new_landmark]
      Landmark.create(
        name: landmark_hash[:name],
        year_completed: landmark_hash[:year_completed],
        figure: figure
      )
    end
    figure.save
    # binding.pry

    redirect '/figures'
  end

  patch '/figures/:id' do
    p params
    p "*******************"
    params[:new_title].delete_if {|key, value| value == ""}
    params[:new_landmark].delete_if {|key, value| value == ""}
    @original_figure = Figure.find(params[:id])
    @original_figure.update(name: params[:figure][:name])
    params[:figure][:title_ids].each do |id|
      title = Title.find(id)
      @original_figure.titles << title
    end
    if params[:new_title].has_key?(:name)
      new_title = Title.create(name: params[:new_title][:name])
      FigureTitle.create(figure: @original_figure, title: new_title)
    end
    params[:figure][:landmark_ids].each do |id|
      landmark = Landmark.find(id)
      @original_figure.landmarks << landmark
    end
    if params[:new_landmark].has_key?(:name)
      landmark_hash = params[:new_landmark]
      Landmark.create(
        name: landmark_hash[:name],
        year_completed: landmark_hash[:year_completed],
        figure: @original_figure
      )
    end
    @original_figure.save

    redirect "/figures/#{@original_figure.id}"
  end
end
