library(tidyverse)
library(magick)
library(rpart)
library(rpart.plot)
library(gbm)
library(bartCause)


"
Let's consider a hypothetical example where you were given data from a recent running race with 200 runners.
Some of the runners wore the newly developed HyperShoes, while some of the runners wore standard shoes.
The treatment (wearing HyperShoes) was not randomly assigned,
runners choose for themselves which shoes to use. Besides the treatment variable Z (HyperShoes or standard shoes)
and outcome variable Y(running times), the dataset has measurements of age.
How can we determine if wearing HyperShoes caused runners to run faster than they would have run had they worn standard shoes?
"

#just to show what a regresssion tree does, fake regression tree
n   <- 1000
faker <- tibble(
  id = 1:n,
  age= runif(n,18,60),
  y0 = 100 + 0.05*age**2 + rnorm(n,0,3),
  y1 = 100 + age - 10 - 200*(1/age) + rnorm(n,0,3),
  z  = ifelse(age > 50, 0, rbinom(n,1,prob=.5)),
  y  = y1*z + y0*(1-z)
)

faker |> ggplot(aes(x=age,y=y,color=as.factor(z))) + geom_point()

faker.att <- faker |> filter(age <=50)

faker.att |> ggplot(aes(x=age,y=y,color=as.factor(z))) + 
  geom_point() + 
  theme_minimal() + 
  labs(
    x = "Age",
    y = "Running Time",
    color = 'Treated',
    title = 'Our Observed Data'
  )


m <- rpart(
  y ~ z + age,
  control = rpart.control(cp = 0.001,minsplit=2),
  data = faker.att)

rpart.plot(m)

p.1 <- faker.att |> 
  ggplot(aes(x=age,y=y)) + geom_point(alpha=0.6) + 
  theme_minimal() + 
  labs(
    x = "Age",
    y = "Running Time",
    color = 'Treated',
    title = 'Our Observed Data'
  )

p.2 <- faker.att |> 
  ggplot(aes(x=age,y=y,color=as.factor(z))) + 
  geom_point(alpha=0.6) + 
  geom_segment(aes(x=18,xend=50,y=118,yend=118),color='blue',lty='dashed') + 
  geom_segment(aes(x=18,xend=50,y=161,yend=161),color='red',lty='dashed') + 
  theme_minimal() + 
  labs(
    x = "Age",
    y = "Running Time",
    color = 'Treated',
    title = 'Our Observed Data'
  )

p.3 <- faker.att |> 
  ggplot(aes(x=age,y=y,color=as.factor(z))) + 
  geom_point(alpha=0.6) + 
  geom_vline(xintercept = 36,alpha=0.5) + 
  geom_segment(aes(x=18,xend=50,y=118,yend=118),color='blue',lty='dashed') + 
  geom_segment(aes(x=18,xend=36,y=139,yend=139),color='red',lty='dashed') + 
  geom_segment(aes(x=36,xend=50,y=193,yend=193),color='red',lty='dashed') + 
  theme_minimal() + 
  labs(
    x = "Age",
    y = "Running Time",
    color = 'Treated',
    title = 'Our Observed Data'
  )

p.4 <- faker.att |> 
  ggplot(aes(x=age,y=y,color=as.factor(z))) + 
  geom_point(alpha=0.6) + 

  geom_vline(xintercept = 36,alpha=0.5) +  
  geom_segment(aes(x = 18,xend=36,y=109,yend=109),color='blue',lty='dashed') + 
  geom_segment(aes(x = 36,xend=50,y=128,yend=128),color='blue',lty='dashed') +

  geom_vline(xintercept = 28,alpha=0.5) + 
  geom_segment(aes(x = 18,xend=28,y=127,yend=127),color='red',lty='dashed') + 
  geom_segment(aes(x = 28,xend=36,y=152,yend=152),color='red',lty='dashed') +

  geom_vline(xintercept = 43,alpha=0.5) +
  geom_segment(aes(x = 36,xend=43,y=178,yend=178),color='red',lty='dashed') + 
  geom_segment(aes(x = 43,xend=50,y=208,yend=208),color='red',lty='dashed') +
  theme_minimal() + 
  labs(
    x = "Age",
    y = "Running Time",
    color = 'Treated',
    title = 'Our Observed Data'
  )



p.5 <- faker.att |> 
  ggplot(aes(x=age,y=y,color=as.factor(z))) + 
  geom_point(alpha=0.6) + 

  geom_vline(xintercept = 26,alpha=0.5) +
  geom_segment(aes(x = 18,xend=26,y=103,yend=103),color='blue',lty='dashed') + 
  geom_segment(aes(x = 26,xend=36,y=114,yend=114),color='blue',lty='dashed') + 

  geom_vline(xintercept = 36,alpha=0.5) + 
  geom_segment(aes(x = 36,xend=43,y=123,yend=123),color='blue',lty='dashed') +
  
  geom_vline(xintercept = 43, alpha=0.5) + 
  geom_segment(aes(x = 43,xend=50,y=132,yend=132),color='blue',lty='dashed') + 

  geom_vline(xintercept = 24,alpha=0.5) + 
  geom_segment(aes(x = 18,xend=24,y=122,yend=122),color='red',lty='dashed') + 
  geom_segment(aes(x = 24,xend=28,y=135,yend=135),color='red',lty='dashed') + 

  geom_vline(xintercept = 28,alpha=0.5) + 
  
  geom_vline(xintercept = 32,alpha=0.5) + 
  geom_segment(aes(x = 28,xend=32,y=144,yend=144),color='red',lty='dashed') + 
  geom_segment(aes(x = 32,xend=36,y=159,yend=159),color='red',lty='dashed') + 

  geom_vline(xintercept = 39,alpha=0.5) + 
  geom_segment(aes(x = 36,xend=39,y=172,yend=172),color='red',lty='dashed') + 
  geom_segment(aes(x = 39,xend=43,y=185,yend=185),color='red',lty='dashed') + 

  geom_vline(xintercept = 43,alpha=0.5) + 
  geom_segment(aes(x = 43,xend=50,y=208,yend=208),color='red',lty='dashed') + 

  theme_minimal() + 
  labs(
    x = "Age",
    y = "Running Time",
    color = 'Treated',
    title = 'Our Observed Data'
  )

p.6 <- faker.att |> 
  ggplot(aes(x=age,y=y,color=as.factor(z))) + 
  geom_point(alpha=0.6) + 

  geom_vline(xintercept = 26,alpha=0.5) +
  geom_segment(aes(x = 18,xend=26,y=103,yend=103),color='blue',lty='dashed') + 
  geom_segment(aes(x = 26,xend=36,y=114,yend=114),color='blue',lty='dashed') + 

  geom_vline(xintercept = 36,alpha=0.5) + 
  geom_segment(aes(x = 36,xend=43,y=123,yend=123),color='blue',lty='dashed') +
  
  geom_vline(xintercept = 43, alpha=0.5) + 
  geom_segment(aes(x = 43,xend=50,y=132,yend=132),color='blue',lty='dashed') + 

  geom_vline(xintercept = 24,alpha=0.5) + 
  geom_segment(aes(x = 18,xend=24,y=122,yend=122),color='red',lty='dashed') + 
  geom_segment(aes(x = 24,xend=28,y=135,yend=135),color='red',lty='dashed') + 

  geom_vline(xintercept = 28,alpha=0.5) + 
  
  geom_vline(xintercept = 32,alpha=0.5) + 
  geom_segment(aes(x = 28,xend=32,y=144,yend=144),color='red',lty='dashed') + 
  geom_segment(aes(x = 32,xend=36,y=159,yend=159),color='red',lty='dashed') + 

  geom_vline(xintercept = 39,alpha=0.5) + 
  geom_segment(aes(x = 36,xend=39,y=172,yend=172),color='red',lty='dashed') + 
  geom_segment(aes(x = 39,xend=43,y=185,yend=185),color='red',lty='dashed') + 

  geom_vline(xintercept = 43,alpha=0.5) + 
  
  geom_vline(xintercept = 47,alpha=0.5) + 
  geom_segment(aes(x = 43,xend=47,y=202,yend=202),color='red',lty='dashed') + 
  geom_segment(aes(x = 47,xend=50,y=219,yend=219),color='red',lty='dashed') + 
  theme_minimal() + 
  labs(
    x = "Age",
    y = "Running Time",
    color = 'Treated',
    title = 'Our Observed Data'
  )


plots <- list(p.1, p.2, p.3, p.4, p.5, p.6)

# Capture plots directly (no files written)
imgs <- image_graph(width = 600, height = 400, res = 96)

for (p in plots) {
  print(p)
}

dev.off()

# Animate
gif <- image_animate(imgs, fps = 1)

# Save final GIF
image_write(gif, "assets/tree_animation.gif")



#GBRT
gbrt <- gbm(
  formula = y ~ z + age,
  data = faker.att,
  distribution = "gaussian",
  n.trees = 1000,
  interaction.depth = 2
)

yhat <- predict(gbrt, newdata = faker.att, n.trees = model$n.trees)

faker.att |> 
  mutate(
    yhat = yhat
  ) |> 
  ggplot() + 
  geom_point(aes(x=age,y=y,color=as.factor(z)),alpha=0.5) + 
  geom_line(aes(x=age,y=yhat,color=as.factor(z),group=z),linewidth=2) + 
  theme_minimal() + 
  labs(
    x = 'Age',
    y = 'Running Time',
    color = 'Treated'
  )


##BART
bart <- bartCause::bartc(
  response = y,
  treatment = z,
  confounders = age,
  data = faker,
  estimand = 'att',
  keepTrees = TRUE
)

post <- predict(bart,newdata=faker)
bart_yhat <-     post |> colMeans()
bart_yhat.min <- post |> apply(2,quantile,c(0.025))
bart_yhat.max <- post |> apply(2,quantile,c(0.975))

faker |> 
  mutate(
    yhat = bart_yhat,
    yhat.min = bart_yhat.min,
    yhat.max = bart_yhat.max
  ) |> 
  ggplot() + 
  geom_point(aes(x=age,y=y,color=as.factor(z)),alpha=0.5) + 
  geom_ribbon(aes(x=age,y=y,ymin=yhat.min,ymax=yhat.max,group=as.factor(z)),alpha=0.5) + 
  geom_line(aes(x=age,y=yhat,color=as.factor(z)),linewidth=0.8) + 
  theme_minimal() + 
  labs(
    x = 'Age',
    y = 'Running Time',
    color = 'Treated',
    title = 'BART Gives us Uncertainty Estimates by Default'
  )


tmp <- post[1,]

faker |> 
  mutate(
    line = tmp
  ) |>
  ggplot() + 
  geom_point(aes(x=age,y=y,color=as.factor(z))) + 
  geom_line(aes(x=age,y=tmp,group=z))
