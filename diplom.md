Цели:

Подготовить облачную инфраструктуру на базе облачного провайдера Яндекс.Облако.

Запустить и сконфигурировать Kubernetes кластер.

Установить и настроить систему мониторинга.

Настроить и автоматизировать сборку тестового приложения с использованием Docker-контейнеров.

Настроить CI для автоматической сборки и тестирования.

Настроить CD для автоматического развёртывания приложения.

Этапы выполнения:

---

**Создание облачной инфраструктуры**

Для начала необходимо подготовить облачную инфраструктуру в ЯО при помощи Terraform.

Особенности выполнения:

Бюджет купона ограничен, что следует иметь в виду при проектировании инфраструктуры и использовании ресурсов; Для облачного k8s используйте региональный мастер(неотказоустойчивый). Для self-hosted k8s минимизируйте ресурсы ВМ и долю ЦПУ. В обоих вариантах используйте прерываемые ВМ для worker nodes.
Предварительная подготовка к установке и запуску Kubernetes кластера.

Создайте сервисный аккаунт, который будет в дальнейшем использоваться Terraform для работы с инфраструктурой с необходимыми и достаточными правами. Не стоит использовать права суперпользователя


![image](https://github.com/user-attachments/assets/c828794b-242f-4cd6-a055-bb5f5dd200fc)


Подготовьте backend для Terraform:

а. Рекомендуемый вариант: S3 bucket в созданном ЯО аккаунте(создание бакета через TF) 

б. Альтернативный вариант: Terraform Cloud

![image](https://github.com/user-attachments/assets/c7f6ca61-6f45-42e2-bea2-70a68e472ee2)


Создайте VPC с подсетями в разных зонах доступности.

![image](https://github.com/user-attachments/assets/95b12a06-9a76-43b0-bff7-b4f874d87912)


Убедитесь, что теперь вы можете выполнить команды terraform destroy и terraform apply без дополнительных ручных действий.

![image](https://github.com/user-attachments/assets/8f3d19f1-f0a7-4d0b-953b-2d64e4c8ad95)

![image](https://github.com/user-attachments/assets/85804ec8-da22-4fff-a9b5-86adf6e07788)

![image](https://github.com/user-attachments/assets/d7656ac8-8aff-4739-ab25-656e1009dfc0)


В случае использования Terraform Cloud в качестве backend убедитесь, что применение изменений успешно проходит, используя web-интерфейс Terraform cloud.

Ожидаемые результаты:

Terraform сконфигурирован и создание инфраструктуры посредством Terraform возможно без дополнительных ручных действий.

Полученная конфигурация инфраструктуры является предварительной, поэтому в ходе дальнейшего выполнения задания возможны изменения.

---

**Создание Kubernetes кластера**

На этом этапе необходимо создать Kubernetes кластер на базе предварительно созданной инфраструктуры. Требуется обеспечить доступ к ресурсам из Интернета.

Это можно сделать двумя способами:

Рекомендуемый вариант: самостоятельная установка Kubernetes кластера.

а. При помощи Terraform подготовить как минимум 3 виртуальных машины Compute Cloud для создания Kubernetes-кластера. Тип виртуальной машины следует выбрать самостоятельно с учётом требовании к производительности и стоимости. Если в дальнейшем поймете, что необходимо сменить тип инстанса, используйте Terraform для внесения изменений.

![image](https://github.com/user-attachments/assets/a72d6ca5-6885-4cbd-a191-171218b856f3)



б. Подготовить ansible конфигурации, можно воспользоваться, например Kubespray

```ansible-playbook -u ubuntu -i inventory/mycluster/inventory.ini cluster.yml -b -v --private-key=~/.ssh/id_ed25519```

![image](https://github.com/user-attachments/assets/bd9f78f1-20b5-4d8c-ab92-48de9c943988)


в. Задеплоить Kubernetes на подготовленные ранее инстансы, в случае нехватки каких-либо ресурсов вы всегда можете создать их при помощи Terraform.

Альтернативный вариант: воспользуйтесь сервисом Yandex Managed Service for Kubernetes

а. С помощью terraform resource для kubernetes создать региональный мастер kubernetes с размещением нод в разных 3 подсетях

б. С помощью terraform resource для kubernetes node group

Ожидаемый результат:

Работоспособный Kubernetes кластер.

В файле ~/.kube/config находятся данные для доступа к кластеру.

![image](https://github.com/user-attachments/assets/75001a4c-5642-4707-be0c-70c3b483a8c9)


Команда kubectl get pods --all-namespaces отрабатывает без ошибок.

![image](https://github.com/user-attachments/assets/8a861830-c4a3-4541-8222-9bab45c4ed80)

---

**Создание тестового приложения**

Для перехода к следующему этапу необходимо подготовить тестовое приложение, эмулирующее основное приложение разрабатываемое вашей компанией.

Способ подготовки:

Рекомендуемый вариант:

а. Создайте отдельный git репозиторий с простым nginx конфигом, который будет отдавать статические данные.

б. Подготовьте Dockerfile для создания образа приложения.

![image](https://github.com/user-attachments/assets/0367d81c-5370-4ae7-8095-2c0864563540)


Альтернативный вариант:

а. Используйте любой другой код, главное, чтобы был самостоятельно создан Dockerfile.

Ожидаемый результат:

Git репозиторий с тестовым приложением и Dockerfile.

https://github.com/AlexanderSchelokov/nginx/tree/main

Регистри с собранным docker image. В качестве регистри может быть DockerHub или Yandex Container Registry, созданный также с помощью terraform.

![image](https://github.com/user-attachments/assets/03b1e99b-b7e6-42b2-bac9-3e550fafec2d)


**Подготовка cистемы мониторинга и деплой приложения**

Уже должны быть готовы конфигурации для автоматического создания облачной инфраструктуры и поднятия Kubernetes кластера.

Теперь необходимо подготовить конфигурационные файлы для настройки нашего Kubernetes кластера.

Цель:

Задеплоить в кластер prometheus, grafana, alertmanager, экспортер основных метрик Kubernetes.

![image](https://github.com/user-attachments/assets/23f68e2f-3e8a-492e-9fb5-599c94e4f293)

Задеплоить тестовое приложение, например, nginx сервер отдающий статическую страницу.

![image](https://github.com/user-attachments/assets/5800f4c4-cad2-4e0a-a168-27837f8af409)

Способ выполнения:

Воспользоваться пакетом kube-prometheus, который уже включает в себя Kubernetes оператор для grafana, prometheus, alertmanager и node_exporter. Альтернативный вариант - использовать набор helm чартов от bitnami.

Если на первом этапе вы не воспользовались Terraform Cloud, то задеплойте и настройте в кластере atlantis для отслеживания изменений инфраструктуры. Альтернативный вариант 3 задания: вместо Terraform Cloud или 

atlantis настройте на автоматический запуск и применение конфигурации terraform из вашего git-репозитория в выбранной вами CI-CD системе при любом комите в main ветку. Предоставьте скриншоты работы пайплайна из 

CI/CD системы.

Ожидаемый результат:

Git репозиторий с конфигурационными файлами для настройки Kubernetes.

Http доступ к web интерфейсу grafana.

![image](https://github.com/user-attachments/assets/e846e13d-3f28-4d9f-bcb0-66a6efad241a)

Дашборды в grafana отображающие состояние Kubernetes кластера.

![image](https://github.com/user-attachments/assets/f21ba46b-6f94-4e9c-98b0-a4b93cecb436)

Http доступ к тестовому приложению.

![image](https://github.com/user-attachments/assets/e9f8f652-d5c9-472d-87d2-aab9fd9a1229)

---

**Установка и настройка CI/CD**

Осталось настроить ci/cd систему для автоматической сборки docker image и деплоя приложения при изменении кода.

Цель:

Автоматическая сборка docker образа при коммите в репозиторий с тестовым приложением.

Автоматический деплой нового docker образа.

Можно использовать teamcity, jenkins, GitLab CI или GitHub Actions.

![image](https://github.com/user-attachments/assets/453eab1b-66a0-49b1-a7da-885a3a5eea38)
![image](https://github.com/user-attachments/assets/ce3cc6a2-acbc-4ad1-b2cd-d242d89a683e)

```ubuntu@node1:~/kubernetes-jenkins$ kubectl get pods -n devops-tools```

![image](https://github.com/user-attachments/assets/502aec72-561f-4869-bfdd-ee33f4fd0459)

![image](https://github.com/user-attachments/assets/8ddf91da-7634-44ad-91f0-d89997d67a6d)

![image](https://github.com/user-attachments/assets/587f8eea-bf32-44ca-b155-da740707915d)



Ожидаемый результат:

Интерфейс ci/cd сервиса доступен по http.

![image](https://github.com/user-attachments/assets/ccea4209-e7b6-4ef6-acd5-8261104c33f7)

При любом коммите в репозиторие с тестовым приложением происходит сборка и отправка в регистр Docker образа.

При создании тега (например, v1.0.0) происходит сборка и отправка с соответствующим label в регистри, а также деплой соответствующего Docker образа в кластер Kubernetes.


Ссылка на pipeline https://github.com/AlexanderSchelokov/nginx/blob/main/Jenkinsfile


![image](https://github.com/user-attachments/assets/ae3ed3de-8af0-443b-90c1-59928a3851e4)


![image](https://github.com/user-attachments/assets/274126af-8e3c-46e8-9cd4-a2e8a1103845)

![image](https://github.com/user-attachments/assets/b119630b-679e-420f-99a2-c168afa3809f)

![image](https://github.com/user-attachments/assets/ee0bfc74-6ee5-4e59-81f5-80713ad2ea31)

![image](https://github.com/user-attachments/assets/c1edd394-cf82-48c6-abb4-f6b8eb7e5a42)

![image](https://github.com/user-attachments/assets/3a475364-3597-4ebb-ba23-4c0656ff5f80)



---

Что необходимо для сдачи задания?

Репозиторий с конфигурационными файлами Terraform и готовность продемонстрировать создание всех ресурсов с нуля.

Пример pull request с комментариями созданными atlantis'ом или снимки экрана из Terraform Cloud или вашего CI-CD-terraform pipeline.

Репозиторий с конфигурацией ansible, если был выбран способ создания Kubernetes кластера при помощи ansible.

Репозиторий с Dockerfile тестового приложения и ссылка на собранный docker image.

Репозиторий с конфигурацией Kubernetes кластера.

Ссылка на тестовое приложение и веб интерфейс Grafana с данными доступа.

Все репозитории рекомендуется хранить на одном ресурсе (github, gitlab)
