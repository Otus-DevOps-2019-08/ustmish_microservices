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

