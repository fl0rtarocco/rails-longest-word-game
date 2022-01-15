require 'json'
require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = Array.new(10) { ('A'..'Z').to_a.sample }
  end

  def score
    word = params[:word].upcase
    grid = params[:grid].gsub(' ', '').split('')
    response = check_dictionary(word)
    @message = if test_passed(word, grid) && response['found']
                 "Congratulations! #{word} is a valid English word!"
               elsif !test_passed(word, grid) && response['found']
                 "Sorry but #{word} can't be built out of #{params[:grid].gsub(' ', ',')}"
               else
                 "Sorry but #{word} doesn't seem to be a valid English word..."
               end
  end

  def test_passed(word, grid)
    test_passed = true
    word.split('').each do |letter|
      if grid.index(letter)
        grid.delete_at(grid.index(letter))
      else
        test_passed = false
        break
      end
    end
    test_passed
  end

  def check_dictionary(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    word_serialized = URI.open(url).read
    JSON.parse(word_serialized)
  end
end
