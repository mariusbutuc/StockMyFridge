# convert to float
# http://stackoverflow.com/questions/2259604/how-to-convert-a-fraction-to-float-in-ruby/2259624#2259624
class String
  def to_frac
    numerator, denominator = split('/').map(&:to_f)
    denominator ||= 1
    numerator/denominator
  end
end