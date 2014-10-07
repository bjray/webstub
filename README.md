To use:

- (optional) install rvm

  ```bash
  curl -sSL https://get.rvm.io | bash -s stable
  ```

- install ruby 2.1.2

  ```bash
  rvm install ruby-2.1.2
  ```

- install the bundler gem and run it

  ```bash
  cd /path/to/this/directory
  gem install bundler && bundle install
  ```

- also install foreman

  ```bash
  gem install foreman
  ```

- run foreman

  ```bash
  foreman start
  ```

- test it's running (from another terminal)

  ```bash
  curl -X GET localhost:5000
  ```
