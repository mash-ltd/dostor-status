class Statement < ActiveRecord::Base
  attr_accessible :body, :number, :article

  private
  def tn(num)
    num.to_s.split(//).map{|r|I18n.t("n"+r)}.join
  end
end
