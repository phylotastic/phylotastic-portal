namespace :import do

  desc "Import countries from csv file"
  task :countries => [:environment] do

    file = "db/countries.csv"

    CSV.foreach(file, :headers => true) do |row|
      Country.create({
        :name => row[0]
      })
    end
  end
end