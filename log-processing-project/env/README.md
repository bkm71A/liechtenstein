# Vagrant environment for Spark labs

## Как запустить

### Требуемое ПО
На вашей машине должен быть установлен [Vagrant](https://www.vagrantup.com) и [VirtualBox](https://www.virtualbox.org) 

### Создание машины
1. Переходим в каталог с файлом Vagrantfile: cd~/big-data-project/env
2. выполняем команду запуска создания VM: vagrant up 
3. ждем завершения установки примерно около часа.
4. логинимся на виртуальную машину vagrant ssh

_Если выхотите подключаться к вирнутальной машине используя строний ssh клинет то подключаться нужно к IP,который прописанн в Vagrantfile на порт 2222.
приватный ключ для подключения находися по пути  ~/big-data-project/env/.vagrant/machines/default/virtualbox/private_key_ (ключ генерируется после успешного выполнения vagrant up)

### Изменение конфигурации машины.
вы можете изменить некоторые параметры vm перед ее установкой в Vagrantfile

```  
MEMSIZE= "10000"      # memory size for VM 
HOST_NAME="BigData"
HOST_IP = "192.168.33.10"   # VM IP address
SHARED_FOLDER="D:/dataset"
``` 
 
* MEMSIZE - размер оперативной памяти для VM
* HOST_NAME - имя VM
* HOST_IP  - внешний IP адрес машины
* SHARED_FOLDER - путь до директории которая будет шарится на виртуальную машину

После изменений параметров машину нужно перезагрузить: vagrant reload

## Окружение:
* [Linux 3.13.0-86-generic #131-Ubuntu SMP Thu May 12 23:33:13 UTC 2016 x86_64 x86_64 x86_64 GNU/Linux](https://atlas.hashicorp.com/ubuntu/boxes/trusty64)
* openjdk java-8
* SCALA >= 2.10
* maven == 3.3.3
* SPARK == 1.6.1
* kafka == 0.10.0.0
* cassandra >= 3.5 
* zookeeper >= 3.4.5
* elasticsearch >= 2.3.3 
* kibana >= 4.5.1 
* zeppelin >= [0.6.0](https://github.com/apache/incubator-zeppelin)

## Опционально
* Hadoop == 2.7.2

Для установки Hadoop необходимо на виртуальной машине вызвать скрипт /vagrant/install/hadoop_install.sh_ (важно что бы каталог /vagrant/install/hadoop/config_ находился рядом - там нужные конфиги :))

## Дополнительное ПО
* git, wget, npm, nano, ncdu, vim, curl, zip, unzip, python-pip

Вы всегда можете изменить версии приложений(или добавить еще) подправив файлик _./install/install.sh_
Либо установить/удалить/изменить приложения можно после того как vm будет создана.
