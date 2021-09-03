# TreHub

## Project setup

### Update GithubIssue after generated

    1. Update fields for migration

    ```
    db/migrate/20210825105550_create_github_issues.rb
    ```

    2. Update fields permitted (line 51)

    ```
    app/controllers/github_issues_controller.rb
    ```

    3. Update fields for serializer (line 6)

    ```
    app/serializers/api/v1/github_issue_serializer.rb
    ```

    4. Update fields for admin form

    ```
    app/views/github_issues/_form.html.erb
    ```

### Setup ENV Variables

```bash
cp .env.template .env
```

### Make commands

```bash
make help
```

### Development environment

#### Running our application in a container

```bash
touch $HOME/.zsh_core_base_development_app_history_docker; make up
```

#### Execute a command in our container

```bash
make exec

yarn install

bundle exec rake db:create
bundle exec rake db:migrate
bundle exec rake db:seed

bundle exec rails server --port=3000 --binding=0.0.0.0
```

#### Stop our container

```bash
make stop
```

#### Start our container

```bash
make start
```

#### Stop and remove container

```bash
make down
```

### Production environment

#### Running our application in a container

```bash
make up FILE=docker-compose-production.yml
```

#### Stop and remove container

```bash
make down FILE=docker-compose-production.yml
```

### Build an image

```bash
make build_production_image TAG=core_base
make run_production_container NAME=core_base TAG=core_base:latest
make rm_production_container NAME=core_base
```

#### Clean up dangling Docker images

```bash
make clean
```
