# souljapanic_infra
souljapanic Infra repository

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
