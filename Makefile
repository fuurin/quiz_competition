# 起動
up:
	docker-compose up

# コンテナを作り直して起動
init:
	docker-compose down
	docker-compose up
	make db_init

# コンテナに加え、それらに結びつくボリューム(DB, registry等)も削除
clean:
	docker-compose stop
	docker-compose rm -v -f

# コンテナ、イメージ、ボリューム、noneのイメージを削除
clean_all:
	docker-compose down --rmi all --volumes
	docker system prune

deploy_all:
	make deploy_api
	make heroku_db_init
	make deploy_admin
	make deploy_service


##### API #####
r: # rails
	docker-compose exec api sh

c:
	docker-compose exec api rails c

# migrationファイルを読み込んでschemaを更新しつつseedする
db_init:
	docker-compose exec api rails db:migrate:reset
	docker-compose exec api rails db:seed

# migrationを最新まで進める
db_migrate:
	docker-compose exec api rails db:migrate

# 今あるschemaをそのまま使ってDBをリセットする
# db:resetはseedも実行してくれる
db_reset:
	docker-compose exec api rails db:reset

ce:
	docker-compose exec api rails credendials:edit

cs:
	docker-compose exec api rails credendials:show

deploy_api:
	cd api; \
	git add -A; \
	git commit -m 'commit for deploy'; \
	git push heroku master

heroku_api_info:
	heroku info -a quiz-competition-api

heroku_db:
	heroku pg:psql postgresql-fitted-77400 -a quiz-competition-api

heroku_db_init:
	heroku pg:reset -a quiz-competition-api --confirm quiz-competition-api
	heroku run -a quiz-competition-api rails db:migrate
	heroku run -a quiz-competition-api rails db:seed


##### admin #####
a: # admin
	docker-compose exec admin sh

deploy_admin:
	cd admin; \
	git add -A; \
	git commit -m 'commit for deploy'; \
	git push heroku master

heroku_admin_info:
	heroku info -a quiz-competition-admin


##### service #####
s: # service
	docker-compose exec service sh

deploy_service:
	cd service; \
	git add -A; \
	git commit -m 'commit for deploy'; \
	git push heroku master

heroku_service_info:
	heroku info -a quiz-competition-service
