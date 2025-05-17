library(plumber)
library(glue)

print(paste("Working dir is:", getwd()))
print("Files found:")
print(list.files(getwd()))

# 'plumber.R' is the location of the file shown above
pr("plumber.r") |> pr_run(host = "0.0.0.0", port = 6123)
