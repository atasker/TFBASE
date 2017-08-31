namespace :resave do
  desc "Save all the objects with class included FriemdlySlugable"
  task friendly_slugable: :environment do
    [Category, Competition, Event, Player].each do |fs_class|
      puts "Resave all the #{fs_class.name}"
      count = fs_class.count
      succ = 0
      fail = 0
      print "#{count} to do"
      fs_class.all.each_with_index do |fs_obj, indx|
        if fs_obj.save
          succ += 1
        else
          fail += 1
        end
        print "\rsaves: (success: #{succ}, failed: #{fail}) of #{count}"
      end
      puts ""
    end
  end

end
