# Multistep form wizard from scratch in Rails
This project demonstrates how to break up a model-backed form into multiple steps without any gems in Rails.  This kind of thing can get pretty complex, but this implementation is fairly straightforward, flexible, and reusable.  This is a Rails 4 project, but this method works just as well in Rails 3.

### Background
[This railscast](http://railscasts.com/episodes/217-multistep-forms) is a solid approach that I used as a starting point.  But there are a few problems with it that my project attempts to solve:

* Browser back/forward buttons shouldn't break it
* Clicking "back" through the steps shouldn't validate the current step (maybe a personal preference?)
* Support for edit/update existing record
* Keep the code out of the controller
* Abstract the approach to handle any object

### Installing

	git clone git://github.com/nerdcave/rails-multistep-form.git
	cd rails-multistep-form
	bundle install
	rake db:migrate
	rake db:test:prepare
	rails s

### Validations
* To validate an attribute, all that's needed is a conditional with the step to enforce validation:

```ruby
validates :name, presence: true, if: :step1?
validates :quantity, numericality: true, if: :step2?
```
* If you create/update an object without the multistep form (i.e. in the rails console), the step logic will be ignored and all fields will validate as expected

### Use in your own project
* This can probably be wrapped up in a gem, but you can just copy these files into your project: **app/models/concerns/multi_step_model.rb** and **app/services/model_wizard.rb**
* Then just follow the conventions used in this project

### Features
* Multistep or single step create/update
* Not much code and well abstracted
* Validate attributes per step very easily
* Some RSpec tests included
* Shouldn't break if you use the browser back/forward buttons
* Easy to integrate into your own project
* Rails 4 project, but works just as well in Rails 3

### Contact me
Have questions or needs some help?  Feel free to email me: <jay@nerdcave.com> or twitter me: [@nerdcave](http://twitter.com/nerdcave).