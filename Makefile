default: clean ssl
	docker-compose build
	@docker-compose up -d rails_db
	@docker-compose run --no-deps --rm rails_app bundle install -j4

up: migrate install
	docker-compose up

migrate:
	@while ! docker-compose run --rm rails_db ls /var/lib/mysql/development > /dev/null ; do sleep 4; echo "."; done
	docker-compose run --rm rails_app bin/rails db:migrate RAILS_ENV=development

install:
	@docker-compose run --no-deps --rm rails_app bundle install -j4
	@docker-compose run --no-deps --rm rails_app npm install

ssl:
	mkdir -p .sslkey .ssl
	openssl genrsa -out .sslkey/server.key 2048
	openssl genrsa -out .ssl/domain.key 2048
	openssl rsa -in .ssl/domain.key -out .sslkey/domain.key.rsa

	openssl req -new -key .sslkey/server.key -subj "/C=/ST=/L=/O=/CN=/emailAddress=/" -out .sslkey/server.csr
	openssl req -new -key .sslkey/domain.key.rsa -subj "/C=US/ST=California/L=Orange/O=IndieWebCamp/CN=company/" -out .ssl/domain.csr -config conf/domain.conf

	openssl x509 -req -days 365 -in .sslkey/server.csr -signkey .sslkey/server.key -out .sslkey/server.crt
	openssl x509 -req -extensions v3_req -days 365 -in .ssl/domain.csr -signkey .sslkey/domain.key.rsa -out .ssl/domain.crt -extfile conf/domain.conf

	sudo security add-trusted-cert -d -r trustRoot -k /Library/Keychains/System.keychain .ssl/domain.crt

clean:
	@-rm -rf .sslkey .ssl
	@-docker-compose down
	@-docker volume rm work_rails-mysql-data work_rails-bundle-data

scss-lint:
	docker-compose run --rm rails_app bundle exec scss-lint ./app/assets/stylesheets/**/*.css.scss

haml-lint:
	docker-compose run --rm rails_app bundle exec haml-lint ./app/**/*.html.haml

brakeman:
	docker-compose run --rm rails_app bundle exec brakeman -q -A -w1

rubocop:
	docker-compose run --no-deps --rm rails_app bundle exec rubocop

shell:
	docker-compose run --rm rails_app bundle exec /bin/sh
