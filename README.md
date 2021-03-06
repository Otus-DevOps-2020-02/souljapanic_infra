# souljapanic_infra
souljapanic Infra repository

[![Build Status](https://travis-ci.com/Otus-DevOps-2020-02/souljapanic_infra.svg?branch=master)](https://travis-ci.com/Otus-DevOps-2020-02/souljapanic_infra)

### Исследовать способ подключения к someinternalhost в одну строку:

#### Решение \#1:

```
ssh-add <приватный ключ пользователя> - Добавить приватный ключ в ssh-agent
ssh -i <приватный ключ пользователя> -J <имя пользователя>@<public ipadd bastion> <имя пользователя>@<internal ipadd someinternalhost> - Подключение к someinternalhost с помощью ssh через bastion
```

##### Пример команды:

* ssh -i ~/.ssh/user -J user@8.8.8.8 user@172.16.17.2

#### Решение \#2:

##### Добавить в файл ~/.ssh/config:

```
Host bastion
    User <имя пользователя>
    HostName <public ipaddr bastion>
    IdentityFile <приватный ключ пользователя>
```

##### Пример файл ~/.ssh/config:

```
Host bastion
    User user
    HostName 8.8.8.8
    IdentityFile /Users/user/.ssh/user
```

##### Подключение к bastion:

* ssh bastion

##### Подключение к someinternalhost:

```
ssh -J bastion <имя пользователя>@<internal ipadd someinternalhost>
```

##### Пример подключения к someinternalhost:

* ssh -J bastion user@172.16.17.2

### Решение для подключения к someinternalhost с помощью команды вида: ssh someinternalhost:

#### Решение \#1:

##### Добавить в файл ~/.ssh/config:

```
Host bastion
    User <имя пользователя>
    HostName <public ipaddr bastion>
    IdentityFile <приватный ключ пользователя>

Host internal01
  User <имя пользователя>
  HostName <internal ipadd someinternalhost>
  ProxyJump bastion
```

##### Пример файл ~/.ssh/config:

```
Host bastion
    User user
    HostName 8.8.8.8
    IdentityFile /Users/user/.ssh/user

Host internal01
  User user
  HostName 172.16.17.2
  ProxyJump bastion
```

##### Пример подключения к someinternalhost:

* ssh internal01

### Настройка VPN:

#### Конфигурация:

```
bastion_IP = 35.210.213.90
someinternalhost_IP = 10.132.0.6
```

#### Шаги:

* На bastion загружен файл https://gist.github.com/Nklya/df07e99e63e4043e6a699060a7e30b66
* С помощью файла установлен VPN сервер и база данных Mongo
* Настроен VPN сервер, слушает порт 18314
* Создана организация и пользователь для првоерки подключения
* Создано правило firewall (vpn-18314) для доступа к VPN на bastion
* В настройки bastion в консоли добавлен тег сети vpn-18314
* WEB интерфейс доступе по url: https://35.210.213.90.sslip.io/login


### cloud-testapp

#### Настройка системы и развёртывание приложения

##### Шаги настройки и развёртывания:

```
* Установка ruby с помощью сценария: install_ruby.sh
* Установка mongodb с помощью сценария: install_mongodb.sh
* Развёртывание приложения с помощью сценария: deploy.sh
```

#### Дополнительное задание:

##### Команды для выполнения дополнительно задания:

```
* Создание instance и использование startup-script-url: gcloud compute instances create reddit-app-test --scopes storage-ro --metadata startup-script-url=gs://soulja_infra_bucket/startup_script.sh --boot-disk-size=10GB --image-family ubuntu-1604-lts --image-project=ubuntu-os-cloud --machine-type=g1-small --tags puma-server-test --restart-on-failure
* Создание правила firewall для instance puma-server-test: gcloud compute firewall-rules create puma-server-test --allow=tcp:9292 --direction=INGRESS --target-tags=puma-server-test
```

#### Проверка instance:

```
testapp_IP = 35.187.126.53
testapp_port = 9292
```

#### Проверка startup-script%

```
* sudo journalctl -u google-startup-scripts.service
```

### packer-base

#### Основное задание:

```
* Был разобран принцип работы Packer builder
* Был разобран принци работы Packer provisioners
* Были подготовлены (изменены) сценарии для установки Ruby (packer/scripts/install_ruby.sh) и Mongo (packer/scripts/install_mongodb.sh)
* Был собран образ семейства reddit-base с ruby и mongo
```

##### Команды для сборки образа:

* packer validate packer/ubuntu16.json - проверка корректности файла конфигурации
* packer build packer/ubuntu16.json - сборка образа

#### Дополнительное задание:

```
* Был разобран принцип работы variables
* Подготовлен пример файла переменных packer/variables.json.example
* Был подготовлен файл конфигурации для Immutable infrastructure и собран образ семейства reddit-full
* Был подготовлен systemd unit для запуска приложения при старте instance (packer/files/app.service)
* Был подготовлен сценарий config-scripts/create-reddit-vm.sh для заказа instance из образа reddit-full и настройки firewall
```

##### Команды для сборки образа:

* packer validate -var-file=packer/variables.json packer/ubuntu16.json - проверка корректности файла конфигурации и переменных
* packer build -var-file=packer/variables.json packer/immutable.json - сборка образа

##### Заказ instance с помощью сценария config-scripts/create-reddit-vm.sh

* ./config-scripts/create-reddit-vm.sh

### terraform-1

#### Описание:

```
* Версия terraform: v0.12.24
* Версия google proveder: 2.15
* Необходим собранный образ: reddit-base
* Необходимо удалить ssh ключи из metadata проекта
* main.tf: основной файл конфигурации
* variables.tf: файл объявления переменных
* terraform.tfvars: файл с переменными (их значения)
```

#### Основное задание:

```
* Был разобран принцип работы terraform
* Был разобран принцип работы переменных для terraform
* Был заказан instance, настроен firewall и выполнено развёртывание приложения с помощью terraform
```

#### Команды:

```
terraform init - инициализация, загрузка провайдера
terraform plan - смотрим, какие работы будут выполнены
terraform apply - применяем изменения описанные в файле main.tf
terraform destroy - удаляем ресурсы описанные в файле main.tf
terraform output - выводит переменные из файла outputs.tf
```

#### Дополнительное задание:

```
* С помощью terraform научились добавлять в metadata ssh ключи и добавлять пользователй для instance. Добавление ssh ключа (публичного) через WEB консоль и повторный запуск terraform, где данный ключ не описан, происходит удаление ключа, который не описан в terraform. Необходимо новые ключи добавлять через terraform, если работа с GCP ведётся через него. Но, так как был добавлен новый ключ для пользователя (для примера appuser_web), то этот пользователь был добавлен в существующие instances, но без файла authorized_keys.
* При настройке балансировщика, отключение сервиса puma на одном из instance к проблем не приведёт. Но описание в файле main.tf каждого instance неудобно, приводит к увеличению кода.
* Определенапеременная count, создание instance происходит с помощью переменной count.
```

### terraform-2

#### Основное задание:

```
* Разобрали работу terraform с модулями
* Разобрали работу terraform с разными окружениями (stage&prod)
* Разобрали создание storage в GCP с помощью terraform (файл кофнигурации storage-bucket.tf)
```

#### Команды:

```
* terraform get - подключение модулей
* terraform init - инициализация, при использование внешних модулей
* terraform plan -var-file=./stage/terraform.tfvars stage - просмотр изменений для окружения stage
* terraform plan -var-file=./prod/terraform.tfvars prod - просмотрт изменений для окружения prod
* terraform apply -var-file=./stage/terraform.tfvars stage - применение изменений для окружения stage
* terraform apply -var-file=./prod/terraform.tfvars prod - применение изменений для окружения prod
```

#### Дополнительное задание:

```
* Разобрали принцип хранения файлов состояния в Google Cloud Storage. Так как наши окружения имеют оданаковый набор переменных и их значение, то для хранения файлов состояния мы не используем префикс, чтобы после создания элементов в окружении stage, применив изменения из окружения prod был прочитан файл состояния и выполнялись только изменения необходимых элементов, а не их заказ с такими же именами, который приведёт к ошибке. Конфигурация для хранения файлов состояния: prod/backend.tf и stage/backend.tf.
* Развернули два instance, на одном запущено приложение, на другом база данных. Первым разворачивается база данных с помощью модуля db, получает внутренний ipadd и передаёт его, как переменную модули app и происходит развёртывание instance app. ipaddr instance db необходим для подключения приложения к базе данных. На instance  db так же выполняется правка настроек mongo, чтобы mongo слушал на всех интерфейсах (terraform/modules/db/files/deploy.sh).
```

### ansible-1

#### Основное задание:

```
* Команда: ansible app -m command -a 'rm -rf ~/reddit2' удалили директорию с исходным кодом/ Повторный запуск playbook clone выполнил клонирование репозитория в директорию reddir2.
```

#### Дополнительное задание:

```
* inventory.gcp.yml - файл для генерации динамического inventory
* ansible-inventory -i inventory.gcp.yml --graph - просмотр inventory
* ansible-inventory -i inventory.gcp.yml --list --output inventory.json - запись inventory в inventory.json
* ansible all -i inventory.gcp.yml -m ping - проверка работоспособности ansible с динамическим inventory
```

### ansible-2

#### Основное задание:

```
* Научились использовать handlers в playbook
* Научились использовать tag и limit для запуска playbook
* Научились выполнять проверку playbook
* Научились импортировать playbook'и
```

#### Дополнительное задание:

```
* Научились использовать ansible совместно с packer
```

### ansible-3

#### Основное задание:

```
* Научились работать с ansible vault, community roles, вести репозиторий для разных окружений
```

#### Дополнительное задание:

```
* Научились выполнять настройку travis-ci
```

#### ansible-4

#### Основное задание

```
* Научились использовать vagrant для тестирования ansible playbook's и roles (ansible/Vagrantfile)
* Научились использовать molecule для тестирвоания ролей
* Научились использовать ansible роли для packer
```

##### Пример команд:

```
* cd ansible; vagrant up - настройка среды
* cd ansible; vagrant destroy -f - удаление среды
* cd ansible; provision appserver - выполнение playbook для app
* cd ansible; provision dbserver - выполнение playbook для db
* cd ansible/roles/db; molecule init scenario --scenario-name default -r db -d vagrant - инициализация ьщдусгду
* cd ansible/roles/db; molecule create - создание среды (ansible/roles/db/molecule/default/molecule.yml)
* cd ansible/roles/db; molecule list - просмотр созданной среды
* cd ansible/roles/db; molecule converge - запуск playbook для тестирования (ansible/roles/db/molecule/default/playbook.yml)
* cd ansible/roles/db; molecule verify - проверка тестов (ansible/roles/db/molecule/default/tests/test_default.py)
* cd ansible/roles/db;molecule destroy - удаление среды
```

#### Дополнительное задание:

```
* Вынесли роль db в отдельный репозиторий: https://github.com/souljapanic/db
* Пример файла travis-ci: .travis.yml.db.example
* Подключили новый репозиторий к Slack (уведомления о проверки travis-ci)
```
