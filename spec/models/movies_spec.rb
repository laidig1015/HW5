require 'rails_helper'
require 'spec_helper'

RSpec.describe Movie, :type => :model do
  
	describe "Finding Movies in TMDb" do

		it "should return an array of hashes given there are real results" do
			arr = Movie::find_in_tmdb("Inception")
			empty = arr.empty?
			expect(empty).to eq false
			x = arr[1]
			is_hash = (x.class == Hash)
			expect(is_hash).to eq true
		end

		it "should return an empty array if there are no real results" do
			arr = Movie::find_in_tmdb(";adjfa;lsjgjashfjasg;lasjjaslfj")
			empty = arr.empty?
			expect(empty).to eq true
		end
	end

	describe "Creating Movies from TMDb" do

		it 'should add nothing to the database given an empty array is sent' do
			sample_value = []
			Movie::create_from_tmdb(sample_value)
			count = Movie.count

			expect(count).to eq 0
		end

		it 'should add it to the database with a valid entry' do
			sample_value = ["42346"]
			Movie::create_from_tmdb(sample_value)
			inception_exists = Movie.exists?(title: 'Inception')

			expect(inception_exists).to eq true
		end
	end


end
