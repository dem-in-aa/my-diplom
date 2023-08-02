# Дипломная работа по специальности «Системный администратор», студент Андрей Демин

### 1. Создание инфраструктуры в yandex-cloud

Структура рабочего каталога terraform:

![](img/tree_terraform.png)


Примечание: в целях безопасности из каталога удален файл **diplom.auto.tfvars**, содержащий **access_token** 

![](img/tfvars.png)

Результаты развертывания инфраструктуры:

а) общее состояние

![](img/1-1.png)
---
б) состояние виртуальных хостов

![](img/vm.png)
---
в) сетевой балансировщик

![](img/netbalancer.png)
---
г) частная подсеть 1   

![](img/priv1.png)
---
д) частная подсеть 2

![](img/priv2.png)
---
е) публичная подсеть

![](img/public.png)
---
ж) публичные ip-адреса

![](img/public-ip.png)
---
з) резевное копирование с помощью снэпшотов

![](img/snap.png)

### 2. Развертывание ПО и его настройка в инфраструктуре 

Структура рабочего каталога ansible:

![](img/tree_ansible.png)

Структура рабочего каталога для конфигурационных файлов:

![](img/tree_config.png)

Проверка доступности ресурсов:

```
ansible -i hosts.ini all -m ping
```
![](img/ping.png)

Проверка наличия проблемных сервисов:

```
ansible all -m command -a "systemctl list-units --type service --state failed"
```

![](img/failed.png)

Примечание: инвентарный файл **hosts.ini** создается при развертывании инфраструктуры
из файла **../terraform/inventory.tf** 



Результаты выполнения **ansible playbooks**:

1. Настройка веб-серверов 

На веб-серверах установлены сервисы:

а) Nginx

б) Node Exporter

в) Nginx Log Exporter

г) Filebeat

Проверка состояния сервисов:

```
ansible web -m command -a "systemctl list-units --type service --state running"
```
Результат: 
 
![](img/web1.png)
---
![](img/web2.png)


2. Проверка работы сетевого балансировщика и доступности веб-серверов и сайта

```
curl -v 158.160.30.67:80
```

![](img/nginx1.png)
---
![](img/nginx2.png)
---
![](img/site1.png)
---
![](img/site2.png)

Примечание: для проверки доступности сайта на втором сервере понадобилось остановить первый сервер
в веб-панели yandex-cloud


3. Настройка систем мониторинга

Проверка состояния сервисов на хосте **prometheus**:

```
ansible prometheus -m command -a "systemctl list-units --type service --state running"
```
Результат:

![](img/prom.png)

Проверка работоспособности сайта **grafana**, состояние **dashboards**

![](img/dash1.png)
---
![](img/dash2.png)
---
![](img/dash3.png)


Примечание: экспорт состояния дашбордов сохранен в **config/dashboards.json**
Логин и пароль к сайту оставлены по-умолчанию (admin:admin)

4. Настройка систем логирования

Проверка состояния сервисов на хосте **elasticsearch**:

```
ansible elasticsearch -m command -a "systemctl status elasticsearch.service"
```
Результат:

![](img/elastic.png)

Проверка состояния сервисов на хосте **kibana**:

```
ansible kibana -m command -a "systemctl status kibana.service"
```
Результат:

![](img/kibana.png)

Состояние мониторинга логов:

![](img/kibanasite1.png)
---
![](img/kibanasite2.png)
---
![](img/kibanasite3.png)
---
![](img/kibanasite4.png)

Примечание: для системы доставки, хранения, обработки и визуализации логов 
использованы deb. дистрибутивы **filebeat, elasticsearch, kibana** версии 7.17.9

