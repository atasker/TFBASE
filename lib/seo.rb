module Seo
  class Basic
    def initialize(seo_obj, no_postfix, default_title = nil)
      @_no_postfix = no_postfix
      default_title ||= 'Ticketfinders | Tickets for Concerts, Sports, Opera, Theater'
      @_default_title = default_title
      if seo_obj
        @_title = seo_obj.title if seo_obj.respond_to? :title
        if seo_obj.respond_to?(:seo_title) && seo_obj.seo_title.present?
          @_title = seo_obj.seo_title
        end

        @_description = seo_obj.seo_descr if seo_obj.respond_to? :seo_descr

        @_keywords = seo_obj.seo_keywords if seo_obj.respond_to? :seo_keywords

        @_image = seo_obj.seo_image if seo_obj.respond_to? :seo_image

        if seo_obj.respond_to?(:no_title_postfix) && seo_obj.no_title_postfix == '1'
          @_no_postfix = true
        end
      end
    end

    def title
      answ = nil
      if @_title.present?
        answ = @_title
        answ += " - " + @_default_title if @_default_title && !@_no_postfix
      else
        answ = @_default_title.to_s
      end
      answ
    end

    def description
      @_description
    end

    def keywords
      @_keywords
    end

    def image
      @_image
    end
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # Module for including in ActiveRecord model with acts_as_seo_carrier
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  module Carrier
    def self.included(base)
      base.store :seodata, accessors: [ :no_title_postfix,
                                        :seo_title,
                                        :seo_descr,
                                        :seo_keywords ], coder: JSON

    end
  end
end

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# ActiveRecord model function for including Seo::Carrier module
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
class << ActiveRecord::Base
  def acts_as_seo_carrier
    include Seo::Carrier
  end
end
