require "sqlite3"
require 'json'
db = SQLite3::Database.new "Economic_base.db"

scale_of_the_obj_automat_k1 = 'Автоматизація бізнес-процесів одного відомства '
customer_type_k2 = 'Центральний державний орган'
type_of_software_k3 = 'Клієнт-серверне (товстий клієнт)'
numb_of_logic_lines_code_kp = 'Java'
develop_indicat_r  = ['Середній рівень', 'Середній рівень','Низький рівень','Високий рівень','Середній рівень' ]
multipliers_costs_z  = ['Високий рівень', 'Середній рівень','Середній рівень','Низький рівень','Низький рівень',
      'Середній рівень','Низький рівень' ]
language = 'visual_c'
funtions = ['Організація введення інформації', 'Генерація структури бази даних', 'Формування баз даних',
            'Генерація робочих програм', 'Монітор ПЗ (керування роботою компонентів)']

def funct_size_app_software(scale_of_the_obj_automat_k1,customer_type_k2,type_of_software_k3,db)
  k = [scale_of_the_obj_automat_k1,customer_type_k2,type_of_software_k3]
  extracted_data_fs = {}
  k.each_with_index do |k,i|
    db.execute("SELECT k#{i+1} FROM table_where_k#{i+1} WHERE descrip = '#{k}' ") do |row|
       extracted_data_fs["k#{i+1}"] = row.first
    end
  end
  (extracted_data_fs['k1'] + extracted_data_fs['k2'] + extracted_data_fs['k3'])**2.35
end

def size_of_the_code(funct_size_app_software,db,numb_logic_lines_code)
  number_of_logical_lines_of_code = []
  db.execute("SELECT number_of_code FROM lenght_code WHERE language = '#{numb_logic_lines_code}' ") do |row|
    number_of_logical_lines_of_code.push(row)
  end
  ((funct_size_app_software * number_of_logical_lines_of_code[0][0]) / 1000)
end

def scale_complexity_creation_soft(develop_indicat_r,db)
  develop_indicat_array = []
  develop_indicat_r.each_with_index  do |r ,i |
    db.execute("SELECT R#{i+1} FROM table_where_r WHERE stage = '#{r}' ") do |row|
       develop_indicat_array.push(row.first.to_f)
    end
  end
  0.91 + 0.01 * develop_indicat_array.sum
end

def indicator_of_cost_labor_develop(multipliers_costs_z,db)
  multipliers_costs_array = []
  multipliers_costs_z.each_with_index  do |z ,i |
    db.execute("SELECT Z#{i+1} FROM table_where_z WHERE stage = '#{z}' ") do |row|
      multipliers_costs_array.push(row.first.to_f)
    end
  end
  multipliers_costs_array.inject(:*)
end

def total_volume(language,db,funtions)
  volume_array = []
  funtions.each do |z |
    db.execute("SELECT #{language} FROM table_where_v WHERE name = '#{z}' ") do |row|
      volume_array.push(row.first)
    end
  end
  volume_array.sum
end

p funct_size_app_software_result = funct_size_app_software(scale_of_the_obj_automat_k1,customer_type_k2,
                                                           type_of_software_k3,db)
p rk = size_of_the_code(funct_size_app_software_result,db,numb_of_logic_lines_code_kp)
p e = scale_complexity_creation_soft(develop_indicat_r,db)
p z = indicator_of_cost_labor_develop(multipliers_costs_z,db)
p the_complexity_of_development_of_application_man_months = 2.94 * rk**e * z
p total_volume(language,db,funtions)
