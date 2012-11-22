class Article < ActiveRecord::Base
  attr_accessible :number, :body

  def to_fb
    "مسودة الدستور، مادة #{tn(self.number)}: #{self.body}"
  end


  private
  def tn(num)
    num.to_s.split(//).map{|r|I18n.t("n"+r)}.join
  end
end
