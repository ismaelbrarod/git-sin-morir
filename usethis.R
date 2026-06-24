library(usethis)
library(gitcreds)

usethis::use_git_config(user.name = "ismael_bravo",
                        user.email = "ibravor@uc.cl")

usethis::edit_git_config()

# Conectar RStudio con Github

create_github_token()

gitcreds_set()
