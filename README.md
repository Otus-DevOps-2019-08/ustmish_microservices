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
