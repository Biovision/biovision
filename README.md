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
gem 'dotenv-rails'

gem 'autoprefixer-rails', group: :production

gem 'biovision', git: 'https://github.com/Biovision/biovision.git'
# gem 'biovision', path: '/Users/maxim/Projects/Biovision/gems/biovision'

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
написания это `19` строка).

Нужно выставить уровень сообщения об ошибках в `:warn` 
(`config.log_level = :warn` в районе `54` строки).

## Добавления в config/application.rb

Это добавляется в блок конфигурирования. Без этой настройки часовой пояс будет
задан как UTC.

```ruby
  config.time_zone = 'Moscow'
```

## Дополнения в config/puma.rb

Нужно обязательно закомментировать строку с портом, так как используется сокет. 
На момент написания документации это `12` строка: 
`port ENV.fetch("PORT") { 3000 }`

```ruby
if ENV['RAILS_ENV'] == 'production'
  shared_path = '/var/www/example.com/shared'
  logs_dir    = "#{shared_path}/log"

  state_path "#{shared_path}/tmp/puma/state"
  pidfile "#{shared_path}/tmp/puma/pid"
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
надо набрать :wq).

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

На серверной стороне нужно создать папку для пумы и файла с ключом шифрования: 

```bash
mkdir -p /var/www/example.com/shared/tmp/puma
mkdir -p /var/www/example.com/shared/config.
```

После этого локально запустить `mina setup`. Для нормальной работы нужно 
не забыть скопировать на сервер `.env` и `config/master.key`.

```bash
scp .env biovision:/var/www/example.com/shared
scp config/master.key biovision:/var/www/example.com/shared/config
```

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
