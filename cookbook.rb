require 'csv'
require 'open-uri'
require 'nokogiri'

class Cookbook
  attr_accessor :recipes, :results2

  def initialize(csv_file)
    @recipes = []
    @csv_file = csv_file
    load_csv
  end

  def all
    @recipes.each_with_index do |recipe, index|
      puts "#{index + 1} .- #{recipe.name} || #{recipe.duration}"
    end
  end

  def add_recipe(recipe)
    # task is an instance of Task
    @recipes << recipe
    save
  end

  def remove_recipe(index)
    @recipes.delete_at(index)
    save
  end

  def import(ingredient)
    puts "Looking for #{ingredient} on Marmiton..."
    url = "http://www.marmiton.org/recettes/recherche.aspx?type=all&aqt=#{ingredient}"
    html_file = open(url).read
    html_doc = Nokogiri::HTML(html_file)
    @results =[]
    @results2 =[]
      html_doc.search('.recipe-card').each do |element|
      name = element.search('.recipe-card__title').text.strip
      description = element.search('.recipe-card__description').text.strip
      duration = element.search('.recipe-card__duration__value').text
      recipe = Recipe.new(name, description, duration)
      @results << recipe
      end
      @results2 = @results.first(10)
      @results2.each_with_index do |recipe, index|
      print ">#{index + 1}  #{recipe.name} #{recipe.duration}"
      puts " "
      puts "#{recipe.description}"
    end
  end

  def select(index)
    puts "your recipe title #{@results2[index-1].name} was added"
    @results2[index-1]
  end

  # def mark(mark)
  #   if mark == 0
  #     puts "Please pick a number"
  #   else
  #     @recipes[mark - 1][:mark] = !items[item_marked - 1][:mark]
  #     puts "The item #{items[item_marked - 1][:name]} got marked"
  #   end
  # end

  private

  def load_csv
    CSV.foreach(@csv_file) do |row|
      @recipes << Recipe.new(row[0], row[1], row[2])
    end
  end

  def save
    csv_options = { col_sep: ',', force_quotes: true, quote_char: '"' }
    CSV.open(@csv_file, 'wb', csv_options) do |csv|
      @recipes.each do |recipe|
        csv << [recipe.name, recipe.description, recipe.duration]
      end
    end
  end
end
