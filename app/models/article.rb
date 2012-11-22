# encoding: utf-8
class Article < ActiveRecord::Base
  attr_accessible :number, :body

  def to_fb
    "#{I18n.t('fb_prefix')} #{tn(self.number)}: #{self.body}"
  end

  private
  def tn(num)
    num.to_s.split(//).map{|r|I18n.t("n"+r)}.join
  end
end
