# Biovision

Новая версия Biovision CMS. Используйте на свой страх и риск.

## Добавления в `.gitignore`

```
/public/uploads

/spec/examples.txt
/spec/support/uploads/*

.env
```

## После изменений в `.gitignore`

Далее, первым делом надо из папки sample в корне проекта `biovision` скопировать
файлы в корень своего проекта (прямо поверх того, что там уже есть).

Не забудь отредактировать `.env`, девелопернейм!

Ещё нужно поменять `example.com` на актуальное название.

Также стоит удалить `app/assets/application.css`, так как используется scss,
и локаль `config/locales/en.yml`, если не планируется использование английской
локали.

## Добавления в `Gemfile`

```ruby
# gem 'biovision', path: '/Users/maxim/Projects/Biovision/gems/biovision'
gem 'biovision', git: 'https://github.com/Biovision/biovision.git'
gem 'dotenv-rails'

group :development, :test do
  gem 'database_cleaner'
  gem 'factory_bot_rails'
  gem 'rspec-rails'
end

group :development do
  gem 'mina'
end
```

## Изменения в `config/environments/production.rb`

Нужно раскомментировать строку `config.require_master_key = true` (на момент
написания это `21` строка).

Нужно выставить уровень сообщения об ошибках в `:warn`
(`config.log_level = :warn` в районе `53` строки).

## Изменения в `app/mailers/application_mailer.rb`

Нужно удалить строку с отправителем по умолчанию
(`default from: 'from@example.com'`), иначе при отправке писем в бою будет
ошибка с неправильным отправителем, независимо от того, что написано
в конфигурации в `production.rb`.

## Актуализация `config/database.yml`

В файле `config/database.yml` нужно поменять названия баз данных на актуальные:

```yaml
default: &default
  adapter: postgresql
  encoding: unicode
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>

development:
  <<: *default
  database: example # Поменять на актуальное название

test:
  <<: *default
  database: example_test # Такое же, как в development, но с приставкой _test

production:
  <<: *default
  database: example # Такое же, как в development, например
  username: example # Поменять на актуального пользователя
  password: <%= ENV['DATABASE_PASSWORD'] %>
  host: localhost
```

## Добавления в config/application.rb

Это добавляется в блок конфигурирования. Без этой настройки часовой пояс будет
задан как UTC.

```ruby
config.time_zone = 'Moscow'
```

## Добавления в `config/application_controller.rb`

Добавить это в начале класса.

```ruby

def default_url_options
  params.key?(:locale) ? { locale: I18n.locale } : {}
end
```

## Добавления в `package.json` и `application.js`

Нужно добавить `@biovivion/biovision`, чтобы работал JS на клиентской стороне
(`yarn add @biovision/biovision`).

В `pack/javascripts/application.js` нужно добавить
`require("@biovision/biovision")`.

## Добавления в `config/routes.rb`

```ruby

concern :check do
  post :check, on: :collection, defaults: { format: :json }
end

concern :toggle do
  post :toggle, on: :member, defaults: { format: :json }
end

concern :priority do
  post :priority, on: :member, defaults: { format: :json }
end

concern :search do
  get :search, on: :collection
end

concern :stories do
  post 'stories/:slug' => :collection_story, on: :collection, as: :story
  post 'stories/:slug' => :member_story, on: :member, as: :story
end

root 'index#index'  
```

## Дополнения в config/puma.rb

Нужно обязательно закомментировать строку с портом, так как используется сокет.
На момент написания документации это `12` строка:
`port ENV.fetch("PORT") { 3000 }`

```ruby

if ENV['RAILS_ENV'] == 'production'
  shared_path = '/var/www/example.com/shared'
  logs_dir = "#{shared_path}/log"

  state_path "#{shared_path}/tmp/puma/state"
  bind "unix://#{shared_path}/tmp/puma.sock"
  stdout_redirect "#{logs_dir}/stdout.log", "#{logs_dir}/stderr.log", true

  activate_control_app
end
```

## Перед запуском:

После установки приложения нужно накатить миграции (в консоли):

```bash
rails db:create
rails railties:install:migrations
rails db:migrate
```

Для удобства запуска на сервере:

```bash
bundle binstubs bundler --force
bundle binstub puma
```

Также имеет смысл запустить `EDITOR=vim rails credentials:edit`, чтобы создать
зашированный файл с ключом шифрования сессии (чтобы выйти из vim с сохранением,
надо нажать `esc` и набрать `:wq`).

Чтобы проходила сборка на сервере, следует запустить эту команду:

```bash
bundle lock --add-platform x86_64-linux
```

## Настройка БД на сервере

Если нужно создать пользователя (заменить `example` на пользователя из
`config/database.yml` из раздела `production`):

```bash
sudo su postgres
createuser -d -P example
```

Для создания БД (заменить `example` на пользователя из `config/database.yml`
из раздела `production`):

```bash
psql -h localhost -U example postgres
```

```postgresql
create database example template template0 encoding='UTF8' LC_COLLATE='ru_RU.UTF-8' LC_CTYPE='ru_RU.UTF-8';
```

## Настройка отгрузки через mina

Для начала надо запустить в консоли `mina init`. После этого внести изменения
в `config/deploy.rb`.

В начале и середине файла раскомментировать то, что относится к `rbenv`.
Кроме того, следует проверить настройки соединения по SSH
(`set :user, 'developer`).

Для `shared_dirs` и `shared_files` задать примерно такой вид.

```ruby
set :shared_dirs, fetch(:shared_dirs, []).push('public/uploads', 'tmp', 'log')
set :shared_files, fetch(:shared_files, []).push('config/master.key', '.env')
```

Если используется `nvm`, то нужно добавить его инициализацию:

В блок `:remote_environment` добавить строку:

```ruby
invoke :'nvm:load'
```

Сама загрузка `nvm`:

```ruby
namespace :nvm do
  task :load do
    command 'echo "-----> Loading nvm"'
    command %(source ~/.nvm/nvm.sh)
    command 'echo "-----> Now using nvm v.`nvm --version`"'
  end
end
```

На серверной стороне нужно создать папку для пумы и файла с ключом шифрования:

```bash
mkdir -p /var/www/example.com/shared/tmp/puma
mkdir -p /var/www/example.com/shared/tmp/pids
mkdir -p /var/www/example.com/shared/config
```

После этого локально запустить `mina setup`. Для нормальной работы нужно
не забыть скопировать на сервер `.env` и `config/master.key`.

```bash
scp .env biovision:/var/www/example.com/shared
scp config/master.key biovision:/var/www/example.com/shared/config
```

## License

The gem is available as open source under the terms of
the [MIT License](https://opensource.org/licenses/MIT).
