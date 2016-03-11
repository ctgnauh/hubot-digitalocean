chai = require 'chai'
sinon = require 'sinon'
chai.use require 'sinon-chai'

expect = chai.expect

describe 'digitalocean', ->
  beforeEach ->
    @robot =
      respond: sinon.spy()
      hear: sinon.spy()

    require('../src/digitalocean')(@robot)

  it 'registers a respond listener', ->
    expect(@robot.hear).to.have.been.calledWith(/do\s+(\w+)(?:\s+(\w+))?/)
