module ConvertHelper
  def tn(num)
    num.to_s.split(//).map{|r|t("n"+r)}.join
  end
end