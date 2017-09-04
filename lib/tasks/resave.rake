namespace :resave do
  desc "Save all the objects with class included FriendlySlugable"
  task friendly_slugable: :environment do
    [Category, Competition, Event, Player].each do |fs_class|
      puts "Resave all the #{fs_class.name}"
      count = fs_class.where(slug: [nil, '']).count
      succ = 0
      fail = 0
      print "#{count} to do"
      fs_class.where(slug: [nil, '']).each_with_index do |fs_obj, indx|
        next if fs_obj.slug.present?
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
