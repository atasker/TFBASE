class Page < ApplicationRecord

  acts_as_seo_carrier

  validates :path, uniqueness: true
  validate :fixed_page_path_not_changed

  before_validation :prepare_path
  before_destroy    :check_destroying_possibility

  def home?
    path_was == '' && !new_record?
  end

  def fixed?
    !new_record? && path_is_fixed?(path_was)
  end

  def will_be_fixed_after_save?
    path_is_fixed? path
  end

  private

  def path_is_fixed?(check_path)
    Rails.application.config.fixed_pages_paths.include? check_path
  end

  # before validation
  def prepare_path
    unless home?
      str = path
      str = title.to_s if str.blank?
      str_splits = str.split('/').reject {|pps| pps.empty? }
      str_splits = str_splits.map do |pps|
        pps = pps.parameterize.dasherize
        pps = '-' if pps.blank?
        pps
      end

      self.path = str_splits.join('/')
    end
  end

  # validation
  def fixed_page_path_not_changed
    # fixed pages always persisted
    if path_changed? && fixed?
      errors.add(:path, "Can't change path of the fixed page")
    end
  end

  # before destroy
  def check_destroying_possibility
    errors.add :base, "Can't delete the fixed page" if self.fixed?
    errors.add :base, "Can't delete the homepage" if self.home?
    errors.blank?
  end

end
