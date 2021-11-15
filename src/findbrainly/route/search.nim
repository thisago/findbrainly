from std/uri import decodeQuery
from std/sequtils import toSeq
from std/tables import toTable, `[]`, hasKey
from std/strutils import contains, split

import pkg/prologue
from pkg/duckduckgo import search, SearchResult
from pkg/brainlyextractor import getQuestion, Question

import findbrainly/route/base

using
  ctx: Context

proc filterBrainlyPages(results: seq[SearchResult]): Future[seq[Question]] {.async.} =
  ## Filters the search result to get just answered questions
  for r in results:
    if "https://brainly." in r.url:
      if r.url.split("/").len == 5:
        let page = await getQuestion r.url
        if page.answers.len > 0:
          result.add page

func pageScore(question: Question): int =
  ## Get the question score based in
  ## - answer qnt
  ## - comment qnt
  inc result, question.comments.len
  for answer in question.answers:
    inc result, 10
    inc result, answer.comments.len


proc pickBestPage(questions: seq[Question]): Question =
  ## Returns the brainly page with most interaction
  if questions.len > 0:
    var best = (score: 0, i: 0)
    for i, page in questions:
      let score = pageScore page
      if score > best.score:
        best.score = score
        best.i = i
    result = questions[best.i]

func getQuery(ctx): Table[string, string] =
  toTable toSeq uri.decodeQuery ctx.request.url.query

template errNoQuery =
  resp $(%*{"error": "Missing `q` param"}), Http400

proc searchSingle*(ctx) {.async.} =
  setBaseHeaders ctx
  let query = getQuery ctx
  if not query.hasKey "q":
    errNoQuery
    return
  let
    term = query["q"]
    results = await search term
    brainlyPage = pickBestPage await filterBrainlyPages results.results
  resp $(%*brainlyPage)

proc searchMultiple*(ctx) {.async.} =
  setBaseHeaders ctx
  let query = getQuery ctx
  if not query.hasKey "q":
    errNoQuery
    return
  let
    term = query["q"]
    results = await search term
    brainlyPages = await filterBrainlyPages results.results
  resp $(%*brainlyPages)
