class LandmarksController < ApplicationController
  # add controller methods

  get '/landmarks' do
    @landmarks = Landmark.all

    erb :'landmarks/index'
  end

  get '/landmarks/new' do
    erb :'landmarks/new'
  end

  get '/landmarks/:id/edit' do
    @landmark = Landmark.find(params[:id])

    erb :'landmarks/edit'
  end

  get '/landmarks/:id' do
    @landmark = Landmark.find(params[:id])

    erb :'landmarks/show'
  end

  post '/landmarks' do
    landmark = params[:landmark]
    Landmark.create(
      name: landmark[:name],
      year_completed: landmark[:year_completed]
    )

    redirect '/landmarks'
  end

  patch '/landmarks/:id' do
    landmark = Landmark.find(params[:id])
    landmark_atts = params[:landmark]
    landmark.update(
      name: landmark_atts[:name],
      year_completed: landmark_atts[:year_completed]
    )
    landmark.save

    redirect "/landmarks/#{landmark.id}"
  end
  
  delete '/landmarks/:id' do
    landmark = Landmark.find(params[:id])
    landmark.destroy
    
    redirect '/landmarks'
  end
end
