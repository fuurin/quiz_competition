# 起動
up:
	docker-compose up

# コンテナを作り直して起動
init:
	docker-compose down
	docker-compose up

# コンテナに加え、それらに結びつくボリューム(DB, registry等)も削除
clean:
	docker-compose stop
	docker-compose rm -v -f

# コンテナ、イメージ、ボリューム、noneのイメージを削除
clean_all:
	docker-compose down --rmi all --volumes
	docker system prune

##### API #####
a:
	docker-compose exec api sh

c:
	docker-compose exec api rails c

db_reset:
	docker-compose exec api db:migrate:reset

deploy_api:
	cd api; \
	git add -A; \
	git commit -m 'commit for deploy'; \
	git push heroku master

heroku_db:
	heroku pg:psql postgresql-fitted-77400 -a quiz-competition-api

heroku_db_reset:
	heroku run rails db:migrate:reset && db:seed -a quiz-competition-api

##### front #####
f:
	docker-compose exec front sh

deploy_front:
	cd front; \
	git add -A; \
	git commit -m 'commit for deploy'; \
	git push heroku master
