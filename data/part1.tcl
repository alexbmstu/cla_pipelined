# Файл part1.tcl
cd part1
# Директория, где будут созданы все выходные данные
set compile_directory lab1_part1
# Модуль верхнего уровеня:
set top_name adder
# входные исходные файлы:
set hdl_files [ list \
../adder.v]
# Создадим директорию проекта
if {![file isdirectory $compile_directory]} {
    file mkdir $compile_directory
}
# Настройки проекта
project new $top_name.ise
project set family Virtex6
project set device xc6vlx240t
project set package ff1156
project set speed -1
# Добавление исходных описаний в проект
foreach filename $hdl_files {
    xfile add $filename
    puts "Добавление файла $filename в проект."
}
