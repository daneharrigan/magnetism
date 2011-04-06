class Archive < ActiveRecord::Base
  include Liquify::Methods

  belongs_to :page, :foreign_key => :blog_section_id
  liquify_methods :publish_range, :article_count

  def self.recount(parent, date)
    date = date.beginning_of_month.to_date
    archive = parent.archives.where(:publish_range => date).first

    if archive
      end_date = date.end_of_month.end_of_day
      article_count = parent.pages.where(:publish => true, :publish_at => (date.to_time..end_date)).where(['publish_at <= ?', Time.now]).count
      if article_count.zero?
        archive.destroy
      else
        archive.update_attribute(:article_count, article_count)
      end
    else
      parent.archives.create(:publish_range => date.to_date, :article_count => 1)
    end
  end
end
