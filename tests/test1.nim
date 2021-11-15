import std/unittest
from std/httpclient import newHttpClient, close, get, code, body
from std/httpcore import Http400, `==`
from std/strformat import fmt

from findbrainly/config import serverPort

const url = fmt"http://localhost:{serverPort}/"

suite "findbrainly":
  setup:
    let client = newHttpClient()
  teardown:
    close client

  test "No query [GET /single]":
    check client.get(url & "single").code == Http400
  test "No query [GET /multi]":
    check client.get(url & "multi").code == Http400

# TODO: Tests
