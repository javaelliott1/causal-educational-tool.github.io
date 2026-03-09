# Causal Educational Tool for Final Project


## Learn Section
- Understanding Sample vs. Population vs. Conditional treatment effects
- Predictive vs. Causal Language
- What is BART & BART for causal inference
- These should have interactivity in quizzes or buttons
- Show images that may be helpful on a click
- Show different plots with the story (static plots in succession, not dynamic)
- Be able to show an example dataset (like a dashboard)

## Analysis Section
- Left for future expansion
- Will still show Fake-data simulation (JavaScript takes a small CSV and reads it)
- I *think* what is the best choice for creating this section is:
    A. GitHub pages sends a call to some university server that runs Shiny or some API that runs R.
    B. That R script runs desired model and returns plots (as images or data for JS to plot itself)
    C. GitHub page displays said plots or dashboards
- This lets someone use larger datasets and not run more heavy packages in their browser.
- Still have to use some R server because of the (Pages -> R Server -> Dashboard/Plot) framework, but at least it does not *have* to be Shiny.
