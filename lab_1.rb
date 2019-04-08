require "sqlite3"

db = SQLite3::Database.new "Economic_base.db"

K1 = 'Автоматизація бізнес-процесів одного відомства '
K2 = 'Центральний державний орган'
K3 = 'Клієнт-серверне (товстий клієнт)'
KP = 'Java'
r_input  = ['Середній рівень', 'Середній рівень','Низький рівень','Високий рівень','Середній рівень' ]
z_input  = ['Високий рівень', 'Середній рівень','Середній рівень','Низький рівень','Низький рівень',
      'Середній рівень','Низький рівень' ]


def from_db(k1,k2,k3,db)
  k = [k1,k2,k3]
  rezult = []
  k.each_with_index do |k,i|
    db.execute("select k#{i+1} from table_where_k#{i+1} where descrip = '#{k}' ") do |row|
      rezult.push(row)
    end
  end
  return rezult
end

a = from_db(K1,K2,K3,db)

def fr(k1,k2,k3)
  ((k1 + k2 + k3)**2.35)
end

fr_final = fr(a[0][0],a[1][0],a[2][0])

def rk(fr,db,kp_input)
  kp = []
  db.execute("select number_of_code from lenght_code where language = '#{kp_input}' ") do |row|
    kp.push(row)
  end
  ((fr * kp[0][0]) / 1000)
end

rk(fr_final,db,KP)

def t(r_input,db)
  r_cont = []
  r_input.each_with_index  do |r ,i |
    db.execute("select R#{i+1} from table_where_r where stage = '#{r}' ") do |row|
      r_cont.push(row)
    end
  end
  #use mapping
  r_cont = [r_cont[0][0].to_f ,r_cont[1][0].to_f,r_cont[2][0].to_f ,r_cont[3][0].to_f , r_cont[4][0].to_f]
  0.91 + 0.01 * r_cont.sum
end

final_e = t(r_input,db)

def T(z_input,db,e)
  z_cont = []
  z_input.each_with_index  do |z ,i |
    db.execute("select R#{i+1} from table_where_r where stage = '#{z}' ") do |row|
      z_cont.push(row)
    end
  end
  #use mapping
  z_cont = [z_cont[0][0].to_f ,z_cont[1][0].to_f,r_cont[2][0].to_f ,r_cont[3][0].to_f , r_cont[4][0].to_f]
  0.91 + 0.01 * r_cont.sum
end

# Z = dob(Zi)
# T = 2.94 * sqr((RK),E) * Z