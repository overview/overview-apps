Promise = require('bluebird')
chai = require('chai')
sinon = require('sinon')
sinonChai = require('sinon-chai')

chai.use(sinonChai)

Promise.longStackTraces()
Promise.onPossiblyUnhandledRejection(->)

global.Promise = Promise
global.sinon = sinon
global.expect = chai.expect
