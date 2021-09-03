.DEFAULT_GOAL := help

# References:
# - Makefile self documenting
#   https://gist.github.com/prwhite/8168133
.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "; printf "\nUsage: \033[36m\033[0m\n"}; {printf "  \033[36m%-30s\033[0m %s\n", $$1, $$2}'

# Default variables
FILE="docker-compose-development.yml"
SERVICE_NAME="development_app"
SERVICE_SHELL="zsh"
PORT=3000

# Usage:
#   make clean
clean: ## Clean up dangling Docker images (Ex: make clean)
	docker rmi `docker images --filter "dangling=true" -q --no-trunc` -f

# Usage:
# - Development environment:
#     make down
# - Production environment:
#     make down FILE=docker-compose-production.yml
down: ## Stop and remove container (Ex: make down FILE=docker-compose-production.yml)
	docker-compose --file $(FILE) down

# Usage:
# - Development environment:
#     make build
# - Production environment:
#     make build FILE=docker-compose-production.yml
build: ## Build image (Ex: make build FILE=docker-compose-production.yml)
	docker-compose --file $(FILE) build
	$(MAKE) --ignore-errors clean

# Usage:
# - Development environment:
#     make up
# - Production environment:
#     make up FILE=docker-compose-production.yml
up: down ## Build and run our container (Ex: make up FILE=docker-compose-production.yml SERVICE_NAME=app SERVICE_SHELL=bash)
	docker-compose --file $(FILE) up --build --detach
	docker-compose --file $(FILE) run --rm $(SERVICE_NAME) $(SERVICE_SHELL) -c 'RAILS_ENV=production bundle exec rake db:migrate'
	$(MAKE) --ignore-errors clean

# Usage:
# - Development environment:
#     make exec
#       bundle exec rails server --binding 0.0.0.0
# - Production environment:
#     make exec FILE=docker-compose-production.yml SERVICE_NAME=app SERVICE_SHELL=bash
#       ps aux
exec: ## Execute command in a our container (Ex: make exec FILE=docker-compose-production.yml SERVICE_NAME=app SERVICE_SHELL=bash)
	docker-compose --file $(FILE) exec $(SERVICE_NAME) $(SERVICE_SHELL)

# Usage:
# - Development environment:
#     make db_migrate
# - Production environment:
#     make db_migrate FILE=docker-compose-production.yml SERVICE_NAME=app SERVICE_SHELL=bash
db_migrate: ## Runs a one-time db:migrate command (Ex: make db_migrate FILE=docker-compose-production.yml SERVICE_NAME=app SERVICE_SHELL=bash)
	docker-compose --file $(FILE) run --rm $(SERVICE_NAME) $(SERVICE_SHELL) -c 'RAILS_ENV=production bundle exec rake db:migrate'

# Usage:
# - Development environment:
#     make top
# - Production environment:
#     make top FILE=docker-compose-production.yml SERVICE_NAME=app
top: ## Display the running processes (Ex: make top FILE=docker-compose-production.yml SERVICE_NAME=app)
	docker-compose --file $(FILE) top $(SERVICE_NAME)

# Usage:
# - Development environment:
#     make images
# - Production environment:
#     make images FILE=docker-compose-production.yml
images: ## List images (Ex: make images FILE=docker-compose-production.yml)
	docker-compose --file $(FILE) images

# Usage:
# - Development environment:
#     make ps
# - Production environment:
#     make ps FILE=docker-compose-production.yml
ps: ## List containers (Ex: make ps FILE=docker-compose-production.yml)
	docker-compose --file $(FILE) ps

# Usage:
# - Development environment:
#     make stop
# - Production environment:
#     make stop FILE=docker-compose-production.yml
stop: ## Stop our container (Ex: make stop FILE=docker-compose-production.yml)
	docker-compose --file $(FILE) stop

# Usage:
# - Development environment:
#     make start
# - Production environment:
#     make start FILE=docker-compose-production.yml
start: ## Start our container (ex: make start FILE=docker-compose-production.yml)
	docker-compose --file $(FILE) start

# Usage:
# - Development environment:
#     make restart
# - Production environment:
#     make restart FILE=docker-compose-production.yml
restart: ## Restart our container (Ex: make restart FILE=docker-compose-production.yml)
	docker-compose --file $(FILE) restart

# Usage:
#   make build_production_image TAG=core_base
build_production_image: ## Build production image from Dockerfile (Ex: make build_production_image TAG=core_base)
	docker build --file ./docker/production/Dockerfile \
	             --build-arg BUNDLER_VERSION=2.1.4 \
	             --build-arg WORKSPACE=/var/workspace \
	             --build-arg RAILS_PORT=3000 \
	             --tag $(TAG) .
	$(MAKE) --ignore-errors clean

# Usage:
#   make rm_production_container NAME=core_base
rm_production_container: ## Build production image from Dockerfile (Ex: make rm_production_container NAME=core_base)
	docker rm --force $(NAME)

# Usage:
#   make run_production_container NAME=core_base TAG=core_base:latest
run_production_container: ## Build production image from Dockerfile (Ex: make run_production_container NAME=core_base TAG=core_base:latest)
	$(MAKE) --ignore-errors rm_production_container
	docker run --publish 3000:3000 \
	           --interactive --tty --detach \
	           --restart always \
	           --volume $(pwd)/log:/var/workspace/log \
	           --volume $(pwd)/storage:/var/workspace/storage \
	           --name $(NAME) \
	           $(TAG)

# References:
# - Check process port
#   https://stackoverflow.com/questions/3855127/find-and-kill-process-locking-port-3000-on-mac
# Usage:
#   make check_process_port
#   make check_process_port PORT=5432
check_process_port: ## Check process port - Default: PORT=3000 (Ex: make check_process_port; make check_process_port PORT=5432)
	lsof -i tcp:$(PORT)

# References:
# - Check LISTEN port
#   https://unix.stackexchange.com/questions/26887/lsof-and-listening-ports
# Usage:
#   make check_listen_port
check_listen_port: ## Check LISTEN port (Ex: make check_listen_port)
	lsof -iTCP -sTCP:LISTEN -P -n
