## Financial Planner

This application estimates a person's first social security benefits check given a birthdate, current income, and projected claim date.

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. See deployment for notes on how to deploy the project on a live system.

### Prerequisites

```
ruby 2.3.1
bundler 1.14.6
rails 5.0.2
```

### Installing
From the command terminal, clone the repository to your local directory...
```
$ git clone https://github.com/izzydoesit/financial_planner.git
$ cd financial_planner
```

Then run bundle command to install all dependencies and run the server.  

```
$ bundle install
$ rails server
```
then visit 'localhost:3000' in your browser

## Deployment

You must have Heroku CLI installed and be logged in to Heroku in order to deploy live via Heroku servers (Please see the documentation to get set up with Heroku)

Then, after installation and login, via the command line...
```
$ heroku create 
$ git push heroku master
$ heroku open
```

## Built With

* [Ruby on Rails](http://api.rubyonrails.org/) - Primary framework used
* [PostgreSQL](https://www.postgresql.org/docs/) - Database used
* [Bootstrap 4](https://getbootstrap.com) - Library used for styling & layout

## Authors

* **Israel Matos** - [Github](https://github.com/izzydoesit)

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details