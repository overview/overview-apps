Example App
===========

This app showcases a few tools that make it easy to build a flat-file website.
You can use it for websites large and small.

Structure
---------

* `src` contains your code (in JavaScript and
   [CoffeeScript](http://coffeescript.org/), piped through
   [Browserify](http://browserify.org/))
* `jade` contains HTML files (in [Jade](http://jade-lang.com/))
* `less` contains CSS files (in [Less](http://lesscss.org/))
* `test` contains unit tests (using Mocha/Sinon/Chai)

Testing
-------

Run `npm test` to test once and `npm run-script test-forever` to watch your
files and test as they change.

Testing is orchestrated by [Karma](http://karma-runner.github.io/).
[Mocha](http://visionmedia.github.io/mocha/) is the runner;
[Chai](http://chaijs.com/) handles assertions and
[Sinon](http://sinonjs.org/) provides spies and mocks.

Developing
----------

Run `gulp dev` to recompile files on change and start a simple web server on
port 8000. Browse to [http://localhost:8000/show](http://localhost:8000/show)
to test it out; you'll need to instantiate it within your local Overview
instance to get a valid query string.

When you're done, run `gulp` to minify the resulting JavaScript, then commit.

Deploying
---------

1. Upload the entire `dist` directory to a flat file server.
2. Make sure the file server adds `.html` to `.../metadata` and `.../show`.
3. Make sure the file server adds the header `Access-Control-Allow-Origin: *`
   to `.../metadata`.
4. Point Overview to the flat file server.

License
-------

We encourage you to copy this template as a starting point and license your
resulting code however you wish.
