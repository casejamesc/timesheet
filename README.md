Personal project - Rails application hosted on Heroku

http://timesheet.casejamesc.com <br>
**this is a freely hosted heroku app using a single dyno. The first user to load the site after 30+ minutes will experience a significant initial delay while the dyno spins up

##### NOTES:

Front-end
  - javascript heavy application, most interactions take place client-side, passing JSON or javascript through AJAX calls
  Will incorporate Backbone framework in the future
  - extended javascript Date Object to include several methods, including conversion to UTC time
  - worked extensively with jQuery UI Calendar widget. Selecting and highlighting appropriate dates in the calendar
  - placed controller and action classes on body tag for page-specific styling. Need to add view class to body as well for situations where the action renders a non default view (different name). Will do this with :content_for in appropriate views.
  - created reusable AJAX call for updating tasks when the user changes the corresponding selected project
  - used Bootstrap to build front-end as quickly as possible 
    
Gems
  - aware of ActiveAdmin and other gems for user authentication and administration, but completed this part manually for knowledge and experience
  - used wickedpdf to generate report pdf, experienced several problems when placing this in production heroku environment. Most issues were resolved by making configuration changes in application.rb
  - used gon gem to expose controller variables to main.js file

Model
  - created non ActiveRecord Model for Reports. This better encapsulated data in the controller, created a resource to create RESTful actions, and allowed me to use validations, etc
  - used model callback to only allow for a single default project and corresponding task at a given time 

Controller
  - used mailer to mail report (invoice) as pdf attachment. Added initializer file to setup outgoing smtp

Views
  - used nav_link helper to highlight current page in navigation menu's (common feature for almost all projects)
  - gained significant experience with form input helpers, including the various alternatives for building select inputs. Used hidden fields. Dealt with multiple submit actions for a single form 
  - used seperate layouts
  - noticed N+1 query in reports, still need to fix

MVC Patterns
  - was exposed to several situations where I didn't have access to variables or methods because of MVC archetecture, and figured out alternatives
    - no access to session in a model
    - no access to controller variables in a model
    - no access to view helpers in a controller, or controller methods in a view. Not sure if it follows the MVC pattern, but I exposed both to each other after researching solutions.
    - placed application logic in controller methods and code that helped to DRY view code helpers

Database
  - converted the project to a postgresql database for deployment on heroku
  - became familiar with Valentino and Mysqlite3 client for interacting with mysqlite3 and postgresql database servers

Heroku
  - setup rails4 app on heroku, using git for version control and deployment

Troubleshooting
  - often used chrome dev tools to troubleshoot AJAX and other issues by examining http request and response headers
  - gained significant experience using the console logs to debug - (logger.debug, queries, pdf/email success, etc)


![Home Screenshot](https://github.com/casejamesc/timesheet/blob/master/app/assets/images/screenshots/1.jpg "home")

![Shifts Screenshot](https://github.com/casejamesc/timesheet/blob/master/app/assets/images/screenshots/2.jpg "shifts")

![Project-Tasks Screenshot](https://github.com/casejamesc/timesheet/blob/master/app/assets/images/screenshots/3.jpg "projects and tasks")

![Report Screenshot](https://github.com/casejamesc/timesheet/blob/master/app/assets/images/screenshots/4.jpg "report")

![PDF Screenshot](https://github.com/casejamesc/timesheet/blob/master/app/assets/images/screenshots/5.jpg "pdf to email")
