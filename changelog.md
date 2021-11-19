# Changelog

## Version 0.3.0 (11/19/2021)

- Removed code duplication in `findbrainly/route/search`
- Added a verification to query text length. It need to be larger than 0

---

## Version 0.2.1 (11/18/2021)

- Changed order of search fallback; first search without filter to get better results

---

## Version 0.2.0 (11/17/2021)

- Added duckduckgo search filter to show just Brainly sites
- Added a logging in Brainly extraction
- If filtered search didn't returned anything, the search will be remade with plain term

---

## Version 0.1.1 (11/15/2021)

- Catching exception in brainly page parsing

---

## Version 0.1.0 (11/15/2021)

- Added `GET /single` to get best brainly question
- Added `GET /multi` to get all brainly questions
