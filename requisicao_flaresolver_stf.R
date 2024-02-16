library(httr2)

url1 <- "https://web.trf3.jus.br/base-textual/"

r1 <- httr::GET(url1)

# requisição no conteiner Docker - depois GET no STF 

r2 <- httr::POST("http://localhost:8191/v1", body = list(cmd = "request.get", 
                                                         url = "https://portal.stf.jus.br/processos/detalhe.asp?incidente=6500001",
                                                         maxTimeout = 60000),
                 encode = "json")
r3 <- httr::GET("https://portal.stf.jus.br/processos/detalhe.asp?incidente=6500001")
resposta <- r2 |>
  httr::content("text") |> 
  jsonlite::fromJSON()
resposta
write(resposta$solution$response,"r2.html")

flaresolverget <- function(url,arquivo){
  
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
  
} 
