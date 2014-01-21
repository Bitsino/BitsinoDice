class Numeric

  def in_satoshi
    (self * 100000000).to_i
  end

  def from_satoshi
    self / 100000000.0
  end

end