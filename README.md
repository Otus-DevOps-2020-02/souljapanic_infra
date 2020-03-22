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
