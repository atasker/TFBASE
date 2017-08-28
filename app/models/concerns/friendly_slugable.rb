module FriendlySlugable
  extend ActiveSupport::Concern

  included do
    validates :slug, uniqueness: true
    before_validation :prepare_slug
  end

  def to_param
    slug.present? ? slug : super()
  end

  private

  def prepare_slug(fallback = nil)
    str = slug.present? ? slug : fallback.to_s
    str = str.parameterize.dasherize
    self.slug = str unless str == slug
  end
end
