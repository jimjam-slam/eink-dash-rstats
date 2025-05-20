#* Show the home page template.
#*
#* @get /
#* @serializer html
function() {
  make_home()
}

#* Activate a scene, then reload the home page
#* @post /scene/activate
#* @parser form
#* @serializer html
#* @param 
function(req, res, scene_id) {
  message(paste("Received a scene activation for", scene_id))

  activate_scene(scene_id)
  
  # redirect
  res$status <- 303
  res$setHeader("Location", "/")
  make_redirect_to_home()
}

#* @assets ./assets /assets
list()