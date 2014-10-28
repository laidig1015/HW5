require 'rails_helper'
require 'spec_helper'

RSpec.describe MoviesController, :type => :controller do
	describe 'searching TMDb' do
		
		it 'should redirect to the movies path given the search is bad' do
			post :search_tmdb, {"search" => ";lafjasjgldsjlfjasl;fjas"}
			expect(response).to have_http_status(302)
		end

		it 'should redirect to the movies path given the search is blank' do
			post :search_tmdb, {"search" => ""}
			expect(response).to have_http_status(302)
		end

		it 'should render the search_tmdb view given the search is successful' do
			post :search_tmdb, {"search" => {"search" => "Inception"}}
			expect(response).to render_template('search_tmdb')
		end

	end

	describe 'adding from TMdb' do

		it 'should not add to the database given an invalid entry' do
			post :add_tmdb
			inception_exists = Movie.exists?(title: 'Inception')
			expect(inception_exists).to eq false
			expect(response).to have_http_status(302)
		end

		it 'should redirect to the movies path when complete' do
			post :add_tmdb, {"tmdb_movies"=>{"42346"=>"1"}}
			expect(response).to have_http_status(302)
		end

		it 'should add it to the database given a valid entry' do
			post :add_tmdb, {"tmdb_movies"=>{"42346"=>"1"}}
			inception_exists = Movie.exists?(title: 'Inception')

			expect(inception_exists).to eq true
		end
	end

	describe 'showing data' do

		it 'should render the show view for the given index' do
			Movie.create!({"title" => 'Inception', "release_date" => "10/15/1991", "rating" => "R"})
			get :show,  {"id" =>  1}
			expect(response).to render_template('show')

		end

	end

	describe 'index and main page' do

		it 'should sort by title' do
			Movie.create!({"title" => 'Inception1', "release_date" => "10/15/1991", "rating" => "R"})
			Movie.create!({"title" => 'Inception2', "release_date" => "10/15/1991", "rating" => "PG"})
			Movie.create!({"title" => 'Inception3', "release_date" => "10/15/1991", "rating" => "PG-13"})
			get :index, {:sort => "title", :ratings => 'R'}
			#expect(response).to render_template('index')
		end

		it 'should render the index view' do
			Movie.create!({"title" => 'Inception', "release_date" => "10/15/1991", "rating" => "R"})
			get :index
			expect(response).to render_template('index')
		end

		it 'should show all generacially' do
			Movie.create!({"title" => 'Inception1', "release_date" => "10/15/1991", "rating" => "R"})
			Movie.create!({"title" => 'Inception2', "release_date" => "10/15/1991", "rating" => "PG"})
			Movie.create!({"title" => 'Inception3', "release_date" => "10/15/1991", "rating" => "PG-13"})
			get :index, {:sort => "release_date", :ratings => {}}
			#expect(response).to render_template('index')
		end

		it 'should show the selected ratings only' do
			Movie.create!({"title" => 'Inception1', "release_date" => "10/15/1991", "rating" => "R"})
			Movie.create!({"title" => 'Inception2', "release_date" => "10/15/1991", "rating" => "PG"})
			Movie.create!({"title" => 'Inception3', "release_date" => "10/15/1991", "rating" => "PG-13"})
			get :index, {"ratings" => "R", "sort" => "title"}
			#expect(response).to render_template('index')
		end

		it 'should sort by release_date' do
			Movie.create!({"title" => 'Inception1', "release_date" => "10/15/1991", "rating" => "R"})
			Movie.create!({"title" => 'Inception2', "release_date" => "10/15/1991", "rating" => "PG"})
			Movie.create!({"title" => 'Inception3', "release_date" => "10/15/1991", "rating" => "PG-13"})
			get :index, {:sort => "release_date", :ratings => 'R'}
			#expect(response).to render_template('index')
		end
	end

	describe 'creating new entries' do

		it 'should create a new movie from the post command' do
			post :create, {:movie => {:title => 'Inception', :release_date => "10/15/1991", :rating => "R"}}
			inception_exists = Movie.exists?(title: 'Inception')
			expect(inception_exists).to eq true
		end

		it 'should render the new view from the GET command' do
			Movie.create!({"title" => 'Inception', "release_date" => "10/15/1991", "rating" => "R"})
			get :new
			expect(response).to render_template('new')
		end

		it 'should redirect to the home page given a successful creation' do
			post :create, {:movie => {:title => 'Inception', :release_date => "10/15/1991", :rating => "R"}}
			expect(response).to have_http_status(302)
		end

	end	

	describe 'editing entries' do


		it 'should render the edit view for the given id' do
			Movie.create!({"title" => 'Inception', "release_date" => "10/15/1991", "rating" => "R"})
			get :edit,  {"id" =>  1}
			expect(response).to render_template('edit')
		end

		it 'should redirect to the home page given a successful creation' do
			Movie.create!({"title" => 'Inception2', "release_date" => "10/15/1991", "rating" => "R"})
			post :update, {:id => 1, :movie => {:title => 'Inception', :release_date => "10/15/1991", :rating => "R"}}
			expect(response).to have_http_status(302)
		end

		it 'should edit a movie from the post command' do
			Movie.create!({"title" => 'Inception2', "release_date" => "10/15/1991", "rating" => "R"})
			post :update, {:id => 1, :movie => {:title => 'Inception', :release_date => "10/15/1991", :rating => "R"}}
			inception_exists = Movie.exists?(title: 'Inception')
			expect(inception_exists).to eq true
		end
	end

	describe 'deleting movies' do

		it 'should redirect to the home page given a successful creation' do
			Movie.create!({"title" => 'Inception', "release_date" => "10/15/1991", "rating" => "R"})
			delete :destroy, {:id => 1}
			expect(response).to have_http_status(302)
		end

		it 'should delete a movie from the database' do
			Movie.create!({"title" => 'Inception', "release_date" => "10/15/1991", "rating" => "R"})
			delete :destroy, {:id => 1}
			inception_exists = Movie.exists?(title: 'Inception')
			expect(inception_exists).to eq false
		end
	end


end
