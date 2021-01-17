<!--
*** Thanks for checking out the Best-README-Template. If you have a suggestion
*** that would make this better, please fork the repo and create a pull request
*** or simply open an issue with the tag "enhancement".
*** Thanks again! Now go create something AMAZING! :D
***
***
***
*** To avoid retyping too much info. Do a search and replace for the following:
*** github_username, repo_name, twitter_handle, email, project_title, project_description
-->



<!-- PROJECT SHIELDS -->
<!--
*** I'm using markdown "reference style" links for readability.
*** Reference links are enclosed in brackets [ ] instead of parentheses ( ).
*** See the bottom of this document for the declaration of the reference variables
*** for contributors-url, forks-url, etc. This is an optional, concise syntax you may use.
*** https://www.markdownguide.org/basic-syntax/#reference-style-links
-->


<!-- TABLE OF CONTENTS -->
<summary><h2 style="display: inline-block">Table of Contents</h2></summary>
<ol>
  <li><a href="#about-the-project">About The Project</a>
  <li><a href="#project-board">Project Board</a></li>
  <li><a href="#database-schema">Database Schema</a></li>
  <li><a href="#built-with">Built With</a>
  <li><a href="#setup-instructions">Setup Instructions</a></li>
  <li><a href="#contact">Contact</a></li>
  <li><a href="#acknowledgements">Acknowledgements</a></li>
</ol>

<!-- ABOUT THE PROJECT -->
## About The Project

[grandmazon](https://tranquil-forest-27711.herokuapp.com/) is a module 2 solo project for Turing School of Software & Design's Back-End Engineering (BEE) program. Grandmazon is an extension of the group project "Little Esty Shop", which is a fictitious e-commerce platform where merchants and admins can manage inventory and fulfill customer invoices.


User stories tracked using [Github projects](https://github.com/jlfoxcollis/grandmazon/projects/1).

### Skills Developed by Project
* Designed schema with custom rake task for database seeding
* Used advanced ActiveRecord to perform complex database queries
* Utilized namespacing for efficient and organized routing  
* Practiced MVC concepts, effectively staying within rails conventions
* Consumed github API and utilized POROS as a way to apply OOP principals 
* Implemented Cart & Order setup to create a functionable shopping experience
* Deployed application on [Heroku](https://tranquil-forest-27711.herokuapp.com/)

### Extensions Complete
* Session & account models with Devise Gem
* Implement a CSS framework

<!-- PROJECT BOARD -->
## Project Board
Check out the [Project board](https://github.com/jlfoxcollis/grandmazon/projects/13) for a complete list of features / user stories used to develop this application.

1. [Database Setup](./doc/db_setup.md)
1. [User Stories](./doc/user_stories.md)
1. [Extensions](./doc/extensions.md)

<!-- DATABBASE SCHEMA -->
## Database Schema

![Schema](https://github.com/jlfoxcollis/grandmazon/blob/main/grandmazon-schema.png)

<!-- BUILT WITH -->
## Built With

* [Ruby on Rails](https://rubyonrails.org/)
* [Postgresql](https://www.postgresql.org/)
* [Devise](https://github.com/heartcombo/devise)
* [Bulma](https://bulma.io/)

<!-- SETUP INSTRUCTIONS -->
## Setup Instructions
To get a local copy up and running follow these simple steps.

1. Clone the repo
   ```
   git clone https://github.com/jlfoxcollis/grandmazon
   ```
2. Install dependencies
   ```
   bundle install
   ```
3. DB creation/migration
   ```
   rails db:create
   rails db:migrate
   rails db:seed
   ```
3. Run tests and view test coverage
   ```
   bundle exec rspec
   open coverage/index.html
   ```
4. Run server and navigate to http://localhost:3000/
   ```
   rails s
   ```
   
OR

1. Visit heroku
   ```
  https://tranquil-forest-27711.herokuapp.com/
  ```

1. Login
   ```
   Admin:
   email: admin@example.com
   password: password
   
   User:
   email: alberto@zulauf.org
   password: strongpassword
   ```


<!-- CONTACT -->
## Contact

* [James Fox-Collis](https://github.com/jlfoxcollis) - jlfoxcollis@gmail.com

## Little-esty-shop Group members!

* [Samuel Yeo](https://github.com/SK-Sam) - yeosamuel95@gmail.com
* [Phil McCarthy](https://github.com/philmccarthy) - hi@philmccarthy.dev
* [Ely Hess](https://github.com/elyhess) - ely.hess@me.com



<!-- ACKNOWLEDGEMENTS -->
## Acknowledgements

* [README template](https://github.com/othneildrew/Best-README-Template)
* [Turing School of Software & Design Project Repo](https://github.com/turingschool-examples/little-esty-shop)
