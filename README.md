# Multistep form wizard from scratch in Rails
This (Rails 5) project demonstrates how to break up a model-backed form into multiple steps without any gems.  This kind of thing can get pretty complex, but this implementation is fairly straightforward, flexible, and reusable. It can work with Rails 3-4 as well.

### Background
[This railscast](http://railscasts.com/episodes/217-multistep-forms) is a solid approach that I used as a starting point.  But there are a few problems with it that my project attempts to solve:

* Browser back/forward buttons shouldn't break it.
* Clicking "back" through the steps shouldn't validate the current step (maybe a personal preference?).
* Support for edit/update existing record.
* Keep the code out of the controller.
* Abstract the approach for any model.

### Installing

    git clone git://github.com/nerdcave/rails-multistep-form.git
    cd rails-multistep-form
    bundle install
    rake db:migrate
    rake db:test:prepare
    rails s

Run `rspec` to run the tests, and/or visit http://localhost:3000/products.

If you have any issues, be sure you're using **Ruby >= 2.3**.


### Implementation details
* To validate an attribute, all that's needed is a conditional with the step to enforce validation:

```ruby
validates :name, presence: true, if: :step1?
validates :quantity, numericality: true, if: :step2?
```
* If you create/update an object without the multistep form (i.e. in a test or the rails console), the step logic will be ignored and all fields will validate as expected.

### Using in your own project
* Copy these files: **app/models/concerns/multi_step_model.rb** and **app/services/model_wizard.rb**.
* In your model, `include MultiStepModel` and define `self.total_steps`.
* Then just follow the conventions in this project that uses them. Check out the `ProductsController`, in particular, and the view form.

### Features
* Multi or single step create/update.
* Not much code and abstracted to handle most models.
* Validate attributes per step with `stepX?` methods.
* RSpec/Capybara feature tests included.
* Browser back/forward should work as expected (Turbolinks not supported).

### Limitations
While this works for most simple models, it's not flawless. Here are a few issues:
* Browser back/forward buttons break if using Turbolinks.
* Nested models may have issues (broken test case included).
* Complicated fields such as uploads may be a problem.