# ustmish_microservices
ustmish microservices repository

дз № 12

- создана ветка docker-2
- cоздал docker host
- создал свой образ ourman/otus-reddit:1.0
- загрузил свой образ в Docker Hub
- задание с * в docker-monolith/docker-1.log
- задание с * 
• Поднятие инстансов с помощью Terraform, их количество задается
переменной - docker-monolith/infra/terraform/stage_with_docker
• Несколько плейбуков Ansible с использованием динамического
инвентори для установки докера и запуска там образа приложения - docker-monolith/infra/ansible/playbooks/install_docker.yml
• Шаблон пакера, который делает образ с уже установленным Docker - docker-monolith/infra/packer/image_with_docker.json

дз № 13 

- создана ветка docker-3
- разбил приложение на несколько компонентов и проверил роботоспособность
- задача со * запустил контейнеры с другими сетевыми алиасами. используя параметры запуска контейнера --env заставил приложение работать:
docker run -d --network=reddit --network-alias=post_db5 --network-alias=comment_db5 mongo:latest
docker run -d --network=reddit --env POST_DATABASE_HOST=post_db5 --network-alias=post5   ourman/post:1.0
docker run -d --network=reddit --env COMMENT_DATABASE_HOST=comment_db5 --network-alias=comment5 ourman/comment:1.0
docker run -d --network=reddit --env COMMENT_SERVICE_HOST=comment5 --env POST_SERVICE_HOST=post5 -p 9292:9292 ourman/ui:1.0
- подключил к приложению volume и убедился что данные сохраняются после перезапуска контейнера
- собрал образ для ui на основе Alpine Linux и немного оптимизировал его.

дз № 14
- создана ветка docker-4
- Разобрался с работой сети в Docker(none, host, bridge).
если  запускаем более одного раза docker run --network host -d nginx
docker выдает только один контейнер, который был запущен первым. все последующие запуски завершаются ошибкой: Address already in use.
docker run --network host -d nginx 
ee0e4cb0d5e8cb4518f3d9d22c62c0f54028249ca08a5ab8026957638657ea98

docker ps
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS               NAMES
ee0e4cb0d5e8        nginx               "nginx -g 'daemon of…"   3 seconds ago       Up 2 seconds                            epic_benz
aea5413c247e        nginx               "nginx -g 'daemon of…"   2 minutes ago       Up 2 minutes                            kind_golick

docker ps
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS               NAMES
aea5413c247e        nginx               "nginx -g 'daemon of…"   2 minutes ago       Up 2 minutes                            kind_golick

контейнер aea5413c247e уже был запущен

docker logs ee0e4cb0d5e8
2019/12/07 20:51:14 [emerg] 1#1: bind() to 0.0.0.0:80 failed (98: Address already in use)
nginx: [emerg] bind() to 0.0.0.0:80 failed (98: Address already in use)
2019/12/07 20:51:14 [emerg] 1#1: bind() to 0.0.0.0:80 failed (98: Address already in use)
nginx: [emerg] bind() to 0.0.0.0:80 failed (98: Address already in use)
2019/12/07 20:51:14 [emerg] 1#1: bind() to 0.0.0.0:80 failed (98: Address already in use)
nginx: [emerg] bind() to 0.0.0.0:80 failed (98: Address already in use)
2019/12/07 20:51:14 [emerg] 1#1: bind() to 0.0.0.0:80 failed (98: Address already in use)
nginx: [emerg] bind() to 0.0.0.0:80 failed (98: Address already in use)
2019/12/07 20:51:14 [emerg] 1#1: bind() to 0.0.0.0:80 failed (98: Address already in use)
nginx: [emerg] bind() to 0.0.0.0:80 failed (98: Address already in use)
2019/12/07 20:51:14 [emerg] 1#1: still could not bind()
nginx: [emerg] still could not bind()

- создали bridge-сеть reddit, запустили наш проект reddit с использованием bridge-сети reddit
- запустили наш проект reddit в 2-х bridge сетях back_net,front_net, чтобы сервис ui не имел доступа к базе данных
- установили docker-compose
- собрали образы приложения reddit с помощью docker-compose и запустили
- изменили docker-compose под кейс с множеством сетей
- параметризировали с помощью переменных окружений(значения переменных находятся в файле .env): порт публикации сервиса ui, версии сервисов

базовое имя проекта = имя папки, где расположен файл docker-compose.yml
задать другое базовое имя проекта: docker-compose --project-name microservice_arhc_1  up -d

дз № 15

- создана ветка gitlab-ci-1
- создали VM для gitlab ci (в ручном режиме)
- развернули Gitlab CI с помощью Docker
- создали проект example (в группе homework) 
- определили CI/CD Pipeline для проекта
- зарегестрировали runner 
- внесли изменения в pipeline (вызов теста в файле simpletest.rb при каждом изменении в коде)
- определили dev окружение
- определили новые этапы stage и production(запуск обоих в ручном режиме) 
- добавили в pipeline условие, которое не разрешае  выкатить на staging и production код, не помеченный тэгом
- добавили создание динамического окружения для каждой ветки в репозитории, кроме ветки master


дз № 16

- создана ветка monitoring-1
- cоздали правило фаервола для Prometheus и Puma
- создали docker-хост в GCE для разворачивания сервисов и мониторинга
- запустили систему мониторинга Prometheus внутри docker-контейнера(воспользовались готовым образом из docker hub)
- определим простой конфигурационный файл prometheus.yml для сбора метрик с наших микросервисов
- собрали на основе готового образа с docker hub свой docker-образ с конфигурацией для мониторинга наших микросервисов
- собрали образы при помощи скриптов docker_build.sh для каждого сервиса
- добавили в docker-compose.yml сервис prometheus, добавили сети  и удалили build(мы уже собрали образы в предыдущем шаге) 
- подняли сервисы docker-compose up -d 
- остановили сервис post и проверили, как изменится статус ui сервиса,который зависим от post
- восстановили post и проверили что статус ui восстановился в нормальное состояние
- добавили в docker-compose.yml сервис node-exporter, добавили для него определение сетей
- добавили в prometheus.yml job для node-exporter
- собрали новый образ для Prometheus
- перезапустили сервисы docker-compose down, docker-compose up -d 
- В Prometheus появился endpoint (node-exporter)
- с помощью yes > /dev/null на docker хосте увидили как меняется нагрузка на cpu

образы: 
https://hub.docker.com/repository/docker/ourman/prometheus
https://hub.docker.com/repository/docker/ourman/post
https://hub.docker.com/repository/docker/ourman/comment
https://hub.docker.com/repository/docker/ourman/ui

дз № 17

- создана ветка moniyoting-2
- вынесли мониторинг в отдельный файл docker-composemonitoring.yml
- добавили сервис cadvisor для наблюдения за состоянием docker контейнеров в dockercompose-monitoring.yml
- добавим информацию о новом сервисе в конфигурацию prometheus, чтобы он начал собирать метрики
- пересобрали образ prometheus
- проверили, что метрики контейнеров собираются prometheus
- добавили сервис grafana в docker-compose-monitoring.yml
- запустили grafana и добавили источник данных 
- загрузили дашборд с официального сайта
- загрузили скачанный скачанный дашборд в grafana
- добавили информацию о post сервисе в конфигурацию prometheus, чтобы он начал собирать метрики после чего пересоберем образ Prometheus 
- построили графики собираемых метрик приложения(изменения счетчика HTTP-запросов по времени; запросов, которые возвращают код ошибки;
- добавили график на дашборд 95 процентиля времени ответа на запрос
- создали дашборд Business_Logic_Monitoring и построили график функции rate(post_count[1h] и rate(comment_count[1h]))
- cобрали образ alertmanager
- добавили alertmanager в компоуз файл мониторинга
- cоздадили файл alerts.yml с определением условия при которых должен срабатывать алерт(алерт будет срабатывать в ситуации, когда одна из наблюдаемых систем
(endpoint) недоступна для сбора метрик)
- добавили копирование alerts.yml в Dockerfile 
- добавили информацию о правилах в конфиг Prometheus
- пересобрали образ Prometheus
- пересоздали docker инфраструктуру мониторинга
- проверили создание алерта после остановки сервисов

образы:
https://hub.docker.com/repository/docker/ourman/alertmanager
https://hub.docker.com/repository/docker/ourman/prometheus
https://hub.docker.com/repository/docker/ourman/post
https://hub.docker.com/repository/docker/ourman/comment
https://hub.docker.com/repository/docker/ourman/ui


дз № 18

- создана ветка logging-1
- Обновили код микросервисов(добавили логирование), собрали новые образы микросервисов
- создали новый докер-хост
- создали docker-compose-logging.yml для нашей системы логирования(elasticsearch, kibana, fluentd)
- cоздали образ Fluentd с нужной конфигурацией
- определили драйвер для логирования для сервиса post внутри compose-файла 
- проверили в Kibana логи
- добавили фильтр для парсинга json логов, приходящих от post сервиса; пересобрали образ fluentd и перезапустили. проверили в Kibana
- определили для ui сервиса драйвер для логирования fluentd в compose-файле, перезапустили ui, проверили формат собираемых сообщений
- добавили регулярное выражение в конфигурацию fluent.conf, обновили образ fluentd, перезапустили сервисы логирования, проверили результат
- добавили несколько Grok-шаблонов, пересобрали fluentd, перезапустили сервисы логирования, проверили результат
- добавили в compose-файл для сервисов логирования сервис распределенного трейсинга Zipkin, добавили сервису сети front_net, back_net
- поправлили docker-compose.yml(добавили для каждого сервиса параметр ZIPKIN_ENABLED)
- перевыкатили сервисы логирования и наше приложение
- проверили результат в Zipkin WEB UI


дз № 19

- установили cfssl, cfssljson и kubectl
- создали сеть kubernetes-the-hard-way
- создаем подсеть kubernetes в сети kubernetes-the-hard-way
- создали правило брандмауэра, которое разрешает внутреннюю связь по всем протоколам
- создали правило брандмауэра, разрешающее внешний SSH, ICMP и HTTPS
- выделили статический IP-адрес, который будет назначег к внешнему балансировщику нагрузки на серверах API Kubernetes
- создали три экземпляра, в которых будет размещено управления Kubernetes
- cоздали один экземпляр, в котором будет размещаться рабочий узел Kubernetes
- cоздали файл конфигурации CA, сертификат и закрытый ключ
- cоздали сертификат клиента администратора и закрытый ключ
- создали сертификат и закрытый ключ для каждого рабочего узла Kubernetes
- cгенерировали клиентский сертификат и приватный ключ kube-controller-manager
- cгенерировали клиентский сертификат kube-proxy и закрытый ключ
- cгенерировали клиентский сертификат kube-планировщика и закрытый ключ
- cгенерировали сертификат и закрытый ключ сервера API Kubernetes
- cгенерировали сертификат учетной записи службы и закрытый ключ
- cкопировали соответствующие сертификаты и закрытые ключи для каждого рабочего экземпляра
- cкопировали соответствующие сертификаты и закрытые ключи для каждого экземпляра контроллера
- cоздали файл kubeconfig для каждого рабочего узла
- cоздали файл kubeconfig для службы kube-proxy
- cоздали файл kubeconfig для службы kube-controller-manager
- cоздали файл kubeconfig для службы kube-scheduler
- cоздали файл kubeconfig для пользователя с правами администратора
- cкопировали соответствующие файлы kubelet и kube-proxy kubeconfig в рабочий экземпляр
- cкопировали соответствующие файлы kube-controller-manager и kube-scheduler kubeconfig в каждый экземпляр контроллера
- cоздали ключ шифрования
- cоздали файл конфигурации шифрования encryption-config.yaml
- cкопировали файл конфигурации шифрования encryption-config.yaml на каждый экземпляр контроллера
- загрузили официальные бинарные файлы etcd из проекта coreos/etcd GitHub
- извлекли и установили сервер etcd и утилиту командной строки etcdctl
- установили имя etcd в соответствии с именем хоста текущего экземпляра
- cоздали файл модуля etcd.service systemd
- запустили сервер etcd
- загрузили официальный Kubernetes
- установили бинарные файлы Kubernetes
- создали файл модуля kube-apiserver.service systemd
- создали файл модуля systemd kube-controller-manager.service
- создали файл конфигурации kube-scheduler.yaml
- создали файл модуля kube-scheduler.service systemd
- установили базовый веб-сервер для обработки проверок состояния HTTP
- cоздали систему: kube-apiserver-to-kubelet ClusterRole с разрешениями для доступа к API Kubelet и выполнения наиболее распространенных задач, связанных с управлением модулями:
- связали систему: kube-apiserver-to-kubelet ClusterRole для пользователя kubernetes
- создали внешние сетевые ресурсы балансировщика нагрузки
- установили и запустили containerd kubelet kube-proxy на worker-ноде
- настроили kubectl для удаленного доступа
- создали сетевые маршруты для worker-sэкземпляра
- развернули надстройку DNS
- выполнили ряд задач, чтобы убедиться, что наш кластер Kubernetes работает правильно
- проверили, что kubectl apply -f <filename> проходит по созданным deployment-ам (ui, post, mongo, comment),поды запускаются
- удалили кластер

