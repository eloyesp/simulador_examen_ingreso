require 'distribution'

MAT = Distribution::Normal.rng(5, 1.6)
LENGUA = Distribution::Normal.rng(7, 1.9)

def matematica
  resultado = MAT.call
  normalize resultado
end

def lengua
  resultado = LENGUA.call
  normalize resultado
end

def normalize resultado
  if resultado > 10
    resultado = 10
  elsif resultado < 0
    resultado = 0
  end
  resultado.round 2
end

Alumno = Struct.new(:id, :matematica, :lengua) do
  def inspect
    "##{ id }: mat: #{ matematica }, len: #{ lengua }"
  end
end


class Sistema

  def initialize resultados
    @resultados = resultados
  end

  def aprobados
    orden_de_merito.first 210
  end

  private

  def orden_de_merito
    raise NotImplementederror
  end

end

class Normal < Sistema
  def orden_de_merito
    @orden_de_mertito ||= @resultados.sort_by { |resultado| -(nota resultado) }
  end
  
  def nota resultado
    (resultado.matematica + resultado.lengua) / 2.0
  end
end

class Raro < Sistema
  def orden_de_merito
    @orden_de_mertito ||= @resultados.sort_by { |resultado| -(nota resultado) }
  end

  def nota resultado
    resultado.matematica
    # if [resultado.matematica, resultado.lengua].min < 5
      # (resultado.matematica * 6 + resultado.lengua * 4) / 10.0
    # else
      # (resultado.matematica + resultado.lengua) / 2
    # end
  end
end

def prueba
  resultados = 400.times.map do |n|
    Alumno.new n, matematica, lengua
  end
  normal = Normal.new(resultados)
  raro =  Raro.new(resultados)
  ganan = raro.aprobados - normal.aprobados
  ganan.each do |a|
    p a
  #  orden_normal = normal.orden_de_merito.index a
  #  orden_raro = raro.orden_de_merito.index a
  #  puts "pasa de: #{ Normal.new(1).nota a } (orden #{ orden_normal }) a #{ Raro.new(1).nota a } (orden#{ orden_raro }"
  end
  ganan.count
end

p (30.times.map { prueba }.inject(:+) / 30)

# puts "ganan:"
# ganan = raro.aprobados - normal.aprobados
# ganan.each do |a|
#   p a
# end
# p ganan.count
