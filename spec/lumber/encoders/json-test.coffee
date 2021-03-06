###
json-test.js: Tests the json encoder

(c) 2012 Panther Development
MIT LICENSE
###
re = (str) ->
  new RegExp(str.replace(/\\\\(.)/g, "\\$1"))
fs = require "fs"
path = require "path"
mocha = require "mocha"
assert = require("chai").assert
lumber = require "../../../src/lumber"

enc = undefined
describe "Json", ->
  beforeEach ->
    enc = new lumber.encoders.Json()

  it "has the correct defaults", ->
    assert.isFalse enc.colorize
    assert.isTrue enc.timestamp
    assert.equal enc.headFormat, "%L"
    assert.equal enc.dateFormat, "isoDateTime"
    assert.equal enc.contentType, "application/json"

  it "has the correct functions", ->
    assert.isFunction enc.encode

  describe "encode", ->
    it "works without timestamp, or meta", ->
      enc.timestamp = false
      assert.equal enc.encode("info", "The Message"), JSON.stringify(
        level: "info"
        head: "INFO"
        message: "The Message"
      )
      assert.equal enc.encode("warn", "The Message"), JSON.stringify(
        level: "warn"
        head: "WARN"
        message: "The Message"
      )
      assert.equal enc.encode("error", "The Message"), JSON.stringify(
        level: "error"
        head: "ERROR"
        message: "The Message"
      )

    it "works with timestamp, without meta", ->
      enc.timestamp = true
      assert.match enc.encode("info", "The Message"), re(JSON.stringify(
        level: "info"
        head: "INFO"
        message: "The Message"
        timestamp: "[\\d\\-]+T[\\d:]+"
      ))
      assert.match enc.encode("warn", "The Message"), re(JSON.stringify(
        level: "warn"
        head: "WARN"
        message: "The Message"
        timestamp: "[\\d\\-]+T[\\d:]+"
      ))
      assert.match enc.encode("error", "The Message"), re(JSON.stringify(
        level: "error"
        head: "ERROR"
        message: "The Message"
        timestamp: "[\\d\\-]+T[\\d:]+"
      ))

    it "works without timestamp, with meta", ->
      enc.timestamp = false
      assert.equal enc.encode("info", "The Message",
        meta: "data"
      ), JSON.stringify(
        level: "info"
        head: "INFO"
        message: "The Message"
        meta:
          meta: "data"
      )
      assert.equal enc.encode("warn", "The Message",
        meta: "data"
      ), JSON.stringify(
        level: "warn"
        head: "WARN"
        message: "The Message"
        meta:
          meta: "data"
      )
      assert.equal enc.encode("error", "The Message",
        meta: "data"
      ), JSON.stringify(
        level: "error"
        head: "ERROR"
        message: "The Message"
        meta:
          meta: "data"
      )

    it "works with timestamp, and meta", ->
      enc.timestamp = true
      assert.match enc.encode("info", "The Message",
        meta: "data"
      ), re(JSON.stringify(
        level: "info"
        head: "INFO"
        message: "The Message"
        timestamp: "[\\d\\-]+T[\\d:]+"
        meta:
          meta: "data"
      ))
      assert.match enc.encode("warn", "The Message",
        meta: "data"
      ), re(JSON.stringify(
        level: "warn"
        head: "WARN"
        message: "The Message"
        timestamp: "[\\d\\-]+T[\\d:]+"
        meta:
          meta: "data"
      ))
      assert.match enc.encode("error", "The Message",
        meta: "data"
      ), re(JSON.stringify(
        level: "error"
        head: "ERROR"
        message: "The Message"
        timestamp: "[\\d\\-]+T[\\d:]+"
        meta:
          meta: "data"
      ))
