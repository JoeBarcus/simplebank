postgres:
		docker run --name postgres12 --network bank-network -p 5432:5432 -e POSTGRES_USER=root -e POSTGRES_PASSWORD=secret -d postgres:12-alpine

createdb:
	  docker exec -it postgres12 createdb --username=root --owner=root simple_bank

startdb:
		docker start postgres12

dropdb:
		docker exec -it postgres12 dropdb simple_bank

migrateup:
		migrate -path db/migration -database "postgresql://root:secret@localhost:5432/simple_bank?sslmode=disable" -verbose up

migratedown:
		migrate -path db/migration -database "postgresql://root:secret@localhost:5432/simple_bank?sslmode=disable" -verbose down

migrateup1:
		migrate -path db/migration -database "postgresql://root:secret@localhost:5432/simple_bank?sslmode=disable" -verbose up 1

migratedown1:
		migrate -path db/migration -database "postgresql://root:secret@localhost:5432/simple_bank?sslmode=disable" -verbose down 1


sqlc:
		sqlc generate

server:
		go run main.go

test:
		go test -v -cover ./...

mock:
		mockgen -package mockdb -destination db/mock/store.go github.com/techschool/simplebank/db/sqlc Store	

.PHONY: createdb dropdb postgres migrateup migratedown sqlc test server mock startdb migrateup1 migratedown1
