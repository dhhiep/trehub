# TreHub
TreHub is a tool to sync between Github issues and Trello cards

## Setup project

##### 1. Setup ENV variables

```bash
cp .env.template .env
```

##### 2. Get github `Personal access tokens` key at [https://github.com/settings/tokens](https://github.com/settings/tokens)

Scopes:
```
repo
read:org
```

## Environment

### I. Development environment (Docker)

##### 1. Store container zsh history to host and initialize container
```bash
touch $HOME/.zsh_trehub_development_app_history_docker
make up
```

##### 2. Execute a command in our container

```bash
make exec

yarn install

bundle exec rake db:create
bundle exec rake db:migrate
bundle exec rake db:seed

bundle exec rails server --port=3000 --binding=0.0.0.0
```

##### 3. Stop our container

```bash
make stop
```

##### 4. Start our container

```bash
make start
```

#### 5. Stop and remove container

```bash
make down
```

### 2. Production environment

##### 1 Running our application in a container

```bash
make up FILE=docker-compose-production.yml
```

##### 2. Stop and remove container

```bash
make down FILE=docker-compose-production.yml
```

##### 3. Build an image

```bash
make build_production_image TAG=trehub
make run_production_container NAME=trehub TAG=trehub:latest
make rm_production_container NAME=trehub
```

##### 4. Clean up dangling Docker images

```bash
make clean
```
