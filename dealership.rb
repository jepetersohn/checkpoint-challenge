require 'csv'

module CarLoader
  def self.get_cars_from_csv(filepath)
    @cars = CSV.read(filepath, { :headers => true, :header_converters => :symbol}).map { |car_object| Car.new(car_object) }
  end

  def save
    CSV.open('inventory.csv',"w") do |csv|
      @tasks.each do |task|
        csv << [task.description]
      end
    end
  end
end

class Car
  attr_reader :make, :year, :model, :inventory_number
  def initialize(args)
    @inventory_number = args[:inventory_number]
    @make = args[:make]
    @model = args[:model]
    @year = args[:year]
  end

  def to_s
    "#{self.year} #{self.make} #{self.model} ID: #{self.inventory_number}" + "\n"
  end
end

class Dealership
  include CarLoader
  attr_reader :cars
  def initialize(cars = nil)
    @cars = cars || []
  end

  def all!
    cars.each { |car| car.to_s }
  end

  def find_make(make)
    cars.select { |car| car.to_s if car.make == make}
  end

  def find_pre(year)
    cars.select { |car| car.to_s if car.year < year }
  end

  def find_post(year)
    cars.select { |car| car.to_s if car.year > year }
  end

  def newest_car
    cars.sort_by { |car| car.year }.last
  end
end

cars = CarLoader.get_cars_from_csv("inventory.csv")
dealership = Dealership.new(cars)

if ARGV[0] == "find"
  if ARGV[1] == "all"
    puts dealership.all!
  elsif ARGV[1] == "make"
    puts dealership.find_make(ARGV[2])
  elsif ARGV[1] == "pre"
   puts dealership.find_pre(ARGV[2])
  elsif ARGV[1] == "post"
    puts dealership.find_post(ARGV[2])
  elsif ARGV[1] == "newest"
    puts dealership.newest_car
  end
end



