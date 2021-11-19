from std/uri import decodeQuery
from std/sequtils import toSeq
from std/tables import toTable, `[]`, hasKey
from std/strutils import contains, split

import pkg/prologue
from pkg/duckduckgo import SearchResult, Search
from pkg/brainlyextractor import getQuestion, Question

import findbrainly/route/base

using
  ctx: Context

proc search(term: string): Future[Search] {.async.} =
  result = await duckduckgo.search term
  echo "Found " & $result.results.len & " random pages"
  if result.results.len == 0:
    echo "Searching with filters"
    result = await duckduckgo.search "inurl:\"https://brainly.\" " & term
    echo "Found " & $result.results.len & " brainly pages"

proc filterBrainlyPages(results: seq[SearchResult]): Future[seq[
    Question]] {.async.} =
  ## Filters the search result to get just answered questions
  for r in results:
    if "https://brainly." in r.url:
      if r.url.split("/").len == 5:
        try:
          stdout.write "Extracting: " & r.url
          let page = await getQuestion r.url
          if page.answers.len > 0:
            result.add page
          echo ""
        except:
          echo ". Error"

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

proc getTerm(ctx): Future[tuple[success: bool; questions: seq[Question]]] {.async.} =
  result.success = true
  setBaseHeaders ctx
  let query = getQuery ctx
  if not query.hasKey "q":
    resp $(%*{"error": "Missing `q` param"}), Http400
    result.success = false
    return
  let term = query["q"]
  if term.len == 0:
    resp $(%*{"error": "No search term provided"}), Http400
    result.success = false
    return
  let results = await search term
  result.questions = await filterBrainlyPages results.results

proc searchSingle*(ctx) {.async.} =
  let x = await getTerm ctx
  if not x.success:
    return
  let brainlyPage = pickBestPage x.questions
  if brainlyPage.url.len > 0:
    resp $(%*brainlyPage)
  else:
    resp "{}"

proc searchMultiple*(ctx) {.async.} =
  let x = await getTerm ctx
  if not x.success:
    return
  resp $(%*x.questions)
