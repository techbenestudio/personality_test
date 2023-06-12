# Preparation

Please do the below steps, install and check if the application was working. So on the workshop we can focus on the topic rather than bringing up the app.

## Install

1. Install docker and docker-compose
2. Clone this repo
3. Rename `.env.example` to `.env` and replace `[your token]` with your OpenAI API token from https://platform.openai.com/account/api-keys
4. Run `docker-compose build`

Please note that if you were using the free tier OpenAI API, there is a rate limit of 3 requests / minute which might affect your advancement during the workshop.

## Start

`docker-compose up`

## Check

Open a browser and go to http://localhost:9292/ If you see 'Hello World' in your browser, you are good to go.

## References

### ChatGPT
https://chat.openai.com/

### OpenAI API reference
https://platform.openai.com/docs/api-reference/chat/create

### OpenAI models
https://platform.openai.com/docs/models

### OpenAI tokenizer
https://platform.openai.com/tokenizer

### Prompt Engineering
https://www.promptingguide.ai/

### Turbo
https://turbo.hotwired.dev/handbook/introduction

#### CDN for Turbo
https://www.skypack.dev/view/@hotwired/turbo

### WebSockets
https://developer.mozilla.org/en-US/docs/Web/API/WebSockets_API
