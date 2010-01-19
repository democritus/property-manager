module UnitConversionHelper

  def m2_to_ft2(m2)
    ft2 = ((m2 ** 0.5 * 100 / 2.54 / 12) ** 2).to_i
  end

end