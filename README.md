# Использование Docker Compose для разработки и тестирования

1. Какую проблему мы хотим решить:
    1. помочь тестировщикам для тестирования изменений;
    2. дать возможность разработчикам отладки сервиса в связки с другими сервисами.
2. Описываем Docker Compose:
    1. Postgres, Services, Volumes.
    2. Чтобы настройки Docker не влияли на другие контуры, создаем
    3. Задание актуальных версий или использование Build Context?
    4. Git Submodules и сборка приложений.
    5. Ожидание сервисов.
3. Использование Docker Compose для разработки:
    1. Eureka или другие Service Discovery не используем, т.к. все запускается в OpenShift.
    2. В настройках адреса сервисов прописываем как `services.dict.url: ${DICT_URL:http://dictionary-service:8020}`, а в
       Docker Compose в блоке `environment` переопределяем на `host.docker.internal`.
    3. В самом приложении создаем профиль `application-docker-to-local.properties`, где прописываем адреса на localhost.
    

### Git Submodules

```shell
$ git submodule add -b master git@github.com:Romanow/store-service.git modules/store-service
```

### Сборка

```shell
# затягиваем изменения
$ git submodule update --init --remote

# собираем модули
$ ./build-all.sh

# собираем образы docker
$ docker compose build

# запускаем
$ docker compose up -d

# проверяем работу
$ newman run ./postman/collection.json -e ./postman/environment.json
Services

❏ Store service
↳ [store] Health Check
  GET http://localhost:8480/manage/health [200 OK, 304B, 307ms]
  ✓  Health check

↳ [store] Purchase item
  POST http://localhost:8480/api/v1/store/6D2CB5A0-943C-4B96-9AA6-89EAC7BDFD2B/purchase [201 Created, 346B, 3.3s]
  ✓  Purchase item

↳ [store] User order info
  GET http://localhost:8480/api/v1/store/6D2CB5A0-943C-4B96-9AA6-89EAC7BDFD2B/9845ce88-f702-4f41-9cd4-bfe17393e3da [200 OK, 446B, 539ms]
  ✓  User order info

↳ [store] User orders
  GET http://localhost:8480/api/v1/store/6D2CB5A0-943C-4B96-9AA6-89EAC7BDFD2B/orders [200 OK, 448B, 386ms]
  ✓  User orders

↳ [store] Warranty request
  POST http://localhost:8480/api/v1/store/6D2CB5A0-943C-4B96-9AA6-89EAC7BDFD2B/9845ce88-f702-4f41-9cd4-bfe17393e3da/warranty [200 OK, 368B, 853ms]
  ✓  Warranty request

↳ [store] Return order
  DELETE http://localhost:8480/api/v1/store/6D2CB5A0-943C-4B96-9AA6-89EAC7BDFD2B/9845ce88-f702-4f41-9cd4-bfe17393e3da/refund [204 No Content, 201B, 101ms]
  ✓  Return order

┌─────────────────────────┬─────────────────────┬────────────────────┐
│                         │            executed │             failed │
├─────────────────────────┼─────────────────────┼────────────────────┤
│              iterations │                   1 │                  0 │
├─────────────────────────┼─────────────────────┼────────────────────┤
│                requests │                   6 │                  0 │
├─────────────────────────┼─────────────────────┼────────────────────┤
│            test-scripts │                   6 │                  0 │
├─────────────────────────┼─────────────────────┼────────────────────┤
│      prerequest-scripts │                   5 │                  0 │
├─────────────────────────┼─────────────────────┼────────────────────┤
│              assertions │                   6 │                  0 │
├─────────────────────────┴─────────────────────┴────────────────────┤
│ total run duration: 5.6s                                           │
├────────────────────────────────────────────────────────────────────┤
│ total data received: 643B (approx)                                 │
├────────────────────────────────────────────────────────────────────┤
│ average response time: 920ms [min: 101ms, max: 3.3s, s.d.: 1104ms] │
└────────────────────────────────────────────────────────────────────┘

$ docker compose down -v
```