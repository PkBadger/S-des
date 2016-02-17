$lshift1 = "1234067895"
$lshift2 = "2340178956"
$p10 = "2416390875"
$p8 ="52637498"
$ip = "15203746"
$ip1="30246175"
$p4="1320"
$ep = "30121230"
$cambio = "45670123"
$s0 = Array["1032", "3210", "0213", "3132"]
$s1 = Array["0123","2013","3010","2103"]
metod = ARGV[0]

def bruteforce
  brutekeys = Array.new
  file = File.new($plain, "r")
  $plainfile = $plain
  while (line = file.gets)
    line = line.split(",")
    1.upto(1023).each do |n|
      thiskey= "%010b" % n

      $key = thiskey.split("")

      $plain = line[0]
      cipher = encryptb
      if(cipher == line[1].split("")[0..7])
        #brutekeys.push($key.join(""))
        count = counting
        if(count == 245)
          puts "llave final #{$key.join()}"
          return
        end
      end
    end
  end
  file.close

  #puts brutekeys
  num_hash = Hash[brutekeys.uniq.map { |num| [num, brutekeys.count(num)] }]
  most_freq = brutekeys.sort_by { |num| num_hash[num] }.last
  puts " LLave final: #{most_freq}"
end

def counting
  file = File.new($plainfile, "r")
  counter = 0
  while (line = file.gets)
    line = line.split(",")
    $plain = line[0]
    cipher = encryptb
    if(cipher == line[1].split("")[0..7])
      counter += 1
    end
  end
  counter
end

def encryptb

  keyl1 = permutaciones $key, $p10
  keyl1 = permutaciones keyl1, $lshift1
  keyuno = permutaciones keyl1, $p8
  keydos = permutaciones keyl1, $lshift2
  keydos = permutaciones keydos, $p8
  plain1 = permutaciones $plain, $ip
  plain2 = fk plain1, keyuno
  plain2 = permutaciones plain2, $cambio
  plain2 = fk plain2, keydos
  cipher = permutaciones plain2, $ip1
  cipher
end

def encrypt
  #key
  keyl1 = permutaciones $key, $p10
  #print "#{keyl1}\n"
  keyl1 = permutaciones keyl1, $lshift1
  #print "#{keyl1}\n"
  keyuno = permutaciones keyl1, $p8
  #print "LLave 1:#{keyuno}\n"
  keydos = permutaciones keyl1, $lshift2
  #print "#{keydos}\n"
  keydos = permutaciones keydos, $p8
  #print "#{keydos}\n"
  #plain
  plain1 = permutaciones $plain, $ip
  #print "#{plain1}\n"
  plain2 = fk plain1, keyuno
  #puts "Antes del switch: #{plain2}"
  plain2 = permutaciones plain2, $cambio
  #puts "despues del switch: #{plain2}"
  plain2 = fk plain2, keydos
  #puts "Despues del fk2: #{plain2}"
  cipher = permutaciones plain2, $ip1
  puts "Cipheer: #{cipher.join()}"
  cipher
end

def decrypt
  #key
  keyl1 = permutaciones $key, $p10
  #print "#{keyl1}\n"
  keyl1 = permutaciones keyl1, $lshift1
  #print "#{keyl1}\n"
  keyuno = permutaciones keyl1, $p8
  #print "LLave 1:#{keyuno}\n"
  keydos = permutaciones keyl1, $lshift2
  #print "#{keydos}\n"
  keydos = permutaciones keydos, $p8
  #print "#{keydos}\n"
  #cipher
  cipherip = permutaciones $plain, $ip
  cipherfk = fk cipherip, keydos
  cipherSw = permutaciones cipherfk, $cambio
  cipherfk2 = fk cipherSw, keyuno
  plainfinal = permutaciones cipherfk2, $ip1
  puts "plainfinal: #{plainfinal.join()}"
  plainfinal
end

def fk(plain,llave)
  fk1 = permutaciones plain[4..7], $ep
  #print "Fk1: #{fk1}\n"
  fk2 = xor(llave,fk1)
  #print "#{fk2}\n"
  sbox0 = sbox fk2[0..3], $s0
  sbox1 = sbox fk2[4..7], $s1
  #puts "s0: #{sbox0}"
  #puts "s1: #{sbox1}"
  sbox0.concat sbox1
  #puts "concat: #{sbox0}"
  fk3 = permutaciones sbox0, $p4
  #puts "p4: #{fk3}"
  fk4 = xor plain[0..3], fk3
  #puts "FkFinal: #{fk4}"
  fk4.concat plain[4..7]
end

def sbox(text,box)

  row = rowCol text[0],text[3]
  col = rowCol text[1],text[2]
  #puts "row:#{row} col:#{col}"
  texto = checksbox row, col, box
  #puts "tex: #{texto}"
  texto
end

def checksbox(row,col, box)
  num = box[row]
  num = Integer((num.split(""))[col])
  text = Array["0","0"]
  #puts "Num: #{num}"
  if num % 2 == 1
    text[1] = "1"
    num = num - 1
  end
  if num == 2
    text[0] = "1"
  end
  text
end

def rowCol(bit1,bit2)
  sum = 0
  #puts "texto: #{bit1} #{bit2}"
  if bit1 == "1"
    sum = sum + 2
  end
  if bit2 == "1"
    sum = sum+1
  end
  sum
end

def xor(llave,text)
  key2 = Array.new
  llave.each_with_index do |item, index|
    key2[index] = "1"
    if item == text[index]
      key2[index] = "0"
    end
  end
  key2
end

def permutaciones(llave,permut)
  key2 = Array.new
  permut.split("").each_with_index do |item, index|
      key2[index] = llave[Integer(item)]
  end
  key2
end


if metod == "0"
  puts "encrypt"
  $plain = ARGV[1]
  $key = ARGV[2]
  $key = $key.split("")
  $plain = $plain.split("")
  encrypt
elsif metod == "1"
  $plain = ARGV[1]
  $key = ARGV[2]
  $key = $key.split("")
  $plain = $plain.split("")
  decrypt
else
  $plain = ARGV[1]
  bruteforce
end
