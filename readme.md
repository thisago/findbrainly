# findbrainly

Easy API to find Brainly questions using Duckduckgo

This API searches in Duckduckgo and extract every brainly page to assert that question is solved.

<!-- If no solved results was returned by Duckduckgo, the API will try to search again but with less chars -->

## Routes

- [x] `GET /single` - Send `q` param with query to get best question
- [x] `GET /multi` - Send `q` param with query to get all solved questions
