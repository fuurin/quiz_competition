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

# apiへ入る
a:
	docker-compose exec api sh

db_reset:
	docker-compose exec api db:migrate:reset

# frontへ入る
f:
	docker-compose exec front sh
