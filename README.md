To use:

- fork this repo
- clone **your** repo

  ```bash
  cd /path/to/projects/dir
  git clone git@github.com:$your_github_username/webstub.git
  cd webstub
  ```

- (optional) install rvm

  ```bash
  curl -sSL https://get.rvm.io | bash -s stable
  ```

- install ruby 2.1.2

  ```bash
  rvm install ruby-2.1.2
  ```
  
- install the bundler and foreman gems

  ```bash
  gem install bundler foreman 
  ```

- install dependencies

  ```bash
  bundle install
  ```

- run foreman

  ```bash
  foreman start
  ```

- test it's running (from another terminal)

  ```bash
  curl -X GET localhost:5000
  ```
