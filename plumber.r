counter <- 0

#* Echo the parameter that was sent in
#*
#* @get /
#* @serializer html
function() {
  return(
    readLines(file.path("templates", "home.html")) |>
      paste(collapse = "\n") |>
      glue())
}

#* Toggle wicker lamp
#*
#* @post /toggle/wicker-lamp
function() {
  warning("POST received!")
  counter <<- counter + 1
  list(msg = "Got a POST request")
}

#* Echo the parameter that was sent in
#*
#* @get /counter
function() {
  list(counter = counter)
}

#* Echo back the input
#* @param msg The message to echo
#* @get /echo
function(msg="") {
  list(msg = paste0("The message is: '", msg, "'"))
}

# #* Plot a histogram
# #* @serializer png
# #* @get /plot
# function() {
#   rand <- rnorm(100)
#   hist(rand)
# }