# Docker_request
Criando meu primeiro container no Docker para fazer requisições GET e POST em sites de tribunais! 

O primeiro passo é configurar o ambiente Docker. Depois, vamos instalar o container Flare Solver. É necessário especificamente no contexto do tribunal selecionado (STF) para resolver o desafio Captcha e realizar a requisição. Sem isso, dá um erro.

```
docker run -d \
  --name=flaresolverr \
  -p 8191:8191 \
  -e LOG_LEVEL=info \
  --restart unless-stopped \
  ghcr.io/flaresolverr/flaresolverr:latest
  ```

Aproveitamos em aula para criar uma função para cada requisição (GET e POST). 

### Requisição GET:

```
# solicitante informa a URL e o nome que deseja dar à saída 

flaresolverget <- function(url,arquivo){
  # requisição POST no meu container Docker

  r2 <- httr::POST("http://localhost:8191/v1", body = list(cmd = "request.get", 
                                                           url = url,
                                                           maxTimeout = 60000),
                   encode = "json")
  resposta <- r2 |>
    httr::content("text") |> 
    jsonlite::fromJSON()
  resposta
  write(resposta$solution$response,arquivo)
  
} 
flaresolverget(url = "https://portal.stf.jus.br/processos/detalhe.asp?incidente=6500001",
               "requisicao_6500001.html")
```
### Requisição POST:
Ela é bem parecida com o Get, como podemos ver a menção na documentação do repositório (https://github.com/FlareSolverr/FlareSolverr)

> his is the same as request.get but it takes one more param:

| Parameter	| Notes |
|-----------|-------|
| postData	| Must be a string with application/x-www-form-urlencoded. Eg: a=b&c=d |

```
flaresolverpost <- function(url,body,arquivo){

  body <- httr:::compose_query(body)

  r2 <- httr::POST("http://localhost:8191/v1", body = list(cmd = "request.post", 
                                                           url = url,
                                                           `application/x-www-form-urlencoded`= body,                                                           maxTimeout = 60000),
                   encode = "json")
  resposta <- r2 |>
    httr::content("text") |> 
    jsonlite::fromJSON()
  resposta
  write(resposta$solution$response,arquivo)
  ```

  Essa forma de requisição é bem interessante e por vezes necessária, pois lidamos com muitos desafios técnicos na coleta de informações de processos via webscraping (e captcha é um deles). Para utilizar uma função que já existe, podemos contar com o Docker ;)