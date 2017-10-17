namespace :images_reload do
  require 'fileutils'

  desc "Reload all models with only avatar uploader"
  task avatars: :environment do
    Competition.all.each do |competition|
      next if competition.avatar.blank?
      cpl_path = make_a_copy_of_original_uploaded_file competition.avatar
      competition.avatar = File.open cpl_path
      save_and_log_stat competition, 'avatar'
      remove_useless_file cpl_path
    end
    HomeLineItem.all.each do |home_line_item|
      next if home_line_item.avatar.blank?
      cpl_path = make_a_copy_of_original_uploaded_file home_line_item.avatar
      home_line_item.avatar = File.open cpl_path
      save_and_log_stat home_line_item, 'avatar'
      remove_useless_file cpl_path
    end
    Player.all.each do |player|
      next if player.avatar.blank?
      cpl_path = make_a_copy_of_original_uploaded_file player.avatar
      player.avatar = File.open cpl_path
      save_and_log_stat player, 'avatar'
      remove_useless_file cpl_path
    end
  end

  desc "Reload all models with only avatar uploader"
  task home_slides: :environment do
    HomeSlide.all.each do |home_slide|
      tempos = []
      mages = []
      if home_slide.huge_image.present?
        mages << 'huge_image'
        cpl_path = make_a_copy_of_original_uploaded_file home_slide.huge_image
        home_slide.huge_image = File.open cpl_path
        tempos << "#{cpl_path}"
      end
      if home_slide.avatar.present?
        mages << 'avatar'
        cpl_path = make_a_copy_of_original_uploaded_file home_slide.avatar
        home_slide.avatar = File.open cpl_path
        tempos << "#{cpl_path}"
      end
      if home_slide.big_image.present?
        mages << 'big_image'
        cpl_path = make_a_copy_of_original_uploaded_file home_slide.big_image
        home_slide.big_image = File.open cpl_path
        tempos << "#{cpl_path}"
      end
      if home_slide.tile_image.present?
        mages << 'tile_image'
        cpl_path = make_a_copy_of_original_uploaded_file home_slide.tile_image
        home_slide.tile_image = File.open cpl_path
        tempos << "#{cpl_path}"
      end

      save_and_log_stat home_slide, mages.join(', ')
      tempos.each { |tempa| remove_useless_file(tempa) }
    end
  end

  def save_and_log_stat(obj, image_attr_name)
    if obj.save
      puts "#{obj.class.name} ##{obj.id} #{image_attr_name} is reloaded"
    else
      puts "some problems with #{obj.class.name} ##{obj.id} #{image_attr_name} reloading"
    end
  end

  def make_a_copy_of_original_uploaded_file(uploader_instance)
    # returns copied file path
    cpl_path = File.join(Rails.root, "tmp", uploader_instance.file.filename)
    FileUtils.cp uploader_instance.path, cpl_path
    cpl_path
  end

  def remove_useless_file(cpl_path)
    FileUtils.rm cpl_path
  end

end
