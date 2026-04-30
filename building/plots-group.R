set.seed(1234)

library(tidyverse)
library(patchwork) 

n <- 10
dat <- tibble(
  id = 1:n,
  x  = rnorm(n,10,sd=2),
  y0 = 5 + 2*x + rnorm(n,0,1),
  y1 = 5 + 2*x + 2 + rnorm(n,0,1),
  z  = rep(c(1,0),each=5),

  y  = y1*z + y0*(1-z),
  obs.y1 = ifelse(z == 1,'Y','N'),
  obs.y0 = ifelse(z == 0,'Y','N')
)

dat |>
  ggplot() + 
  geom_segment(aes(x=x,xend = x, y=y0,yend=y1,group=id,color='lightgrey'),lty='dotted',alpha=.5) + 
  geom_point(aes(x=x,y=y0, color = 'Y(Z=0)',shape = obs.y0),size=5) + 
  geom_point(aes(x=x,y=y1,color = 'Y(Z=1)', shape = obs.y1),size=5) + 
  theme_minimal() + 
  scale_color_manual(
    values = c(
      "Y(Z=0)" = "#299a81",
      "Y(Z=1)" = "#6a2a88"
    )
  ) + 
  scale_shape_manual(
  values = c('Y' = 16, 'N' = 1),
  breaks = c(TRUE, FALSE),
  labels = c("Observed", "Unobserved")
  ) + 
  labs(
    x = 'X',
    y = 'Y',
    color = "Potential Outcomes",
    shape = "Observed"
  )


dat |> 
  mutate(
    ICE = y1 - y0
  ) |> 
  ggplot(aes(x=x,y=ICE,fill=as.factor(id))) + geom_col() + 
  geom_hline(aes(yintercept = mean(ICE)),lty='dashed') + 
  theme_minimal() + 
  labs(
    x = 'X',
    y = 'Individual Causal Effect'
  ) + 
  theme(legend.position='none')



#### PATE
n <- 100
dat <- tibble(
  id = 1:n,
  x  = runif(n,5,10),
  y0 = 5 + 2*x + rnorm(n,0,1),
  y1 = 5 + 2*x + 2 + rnorm(n,0,1),
  z  = rep(c(1,0),each=(n/2)),

  y  = y1*z + y0*(1-z),
  obs.y1 = ifelse(z == 1,'Y','N'),
  obs.y0 = ifelse(z == 0,'Y','N')
)

dat |> 
 mutate(
    ICE = y1 - y0,
    pos = ifelse(ICE > 0,'Y','N')
  ) |> 
  ggplot(aes(x=id,y=ICE,fill=pos)) + 
  geom_col(stat='identity') + 
  geom_hline(yintercept = 0,color='black',lty='dashed') + 
  geom_hline(aes(yintercept = mean(ICE)),color = '#2461da',linewidth=2) + 
  scale_fill_manual(
    values = c(
      'Y' = '#46d3d3',
      'N' = '#db4c4c'
    )
  ) + 
  theme_minimal() + 
  labs(
    x = 'ID',
    y = 'Individual Causal Effect'
  ) + 
  theme(legend.position='none')

dat.sate <- dat |> 
  rowwise() |> 
  mutate(
    ICE = y1 - y0,
    pos = ifelse(ICE > 0,'Y','N'),
    coll = ifelse(rbinom(1,1,.6),1,0)
  )

dat.sate.new <- dat.sate |> filter(coll == 1)

dat.sate |> 
  ggplot(aes(x=id,y=ICE,fill=pos,alpha=coll)) + 
  geom_col(stat='identity') + 
  geom_hline(yintercept = 0,color='black',lty='dashed') + 
  geom_hline(aes(yintercept = mean(ICE)),color = '#5f5f5f',alpha=0.3,linewidth=2) + 
  geom_hline(aes(yintercept = mean(ICE)),color = '#6d24da',linewidth=2,data=dat.sate.new) + 
  scale_fill_manual(
    values = c(
      'Y' = '#46d3d3',
      'N' = '#db4c4c'
    )
  ) + 
  theme_minimal() + 
  labs(
    x = 'ID',
    y = 'Individual Causal Effect'
  ) + 
  theme(legend.position='none')


dat.cate <- dat |>
  rowwise() |> 
  mutate(
  age = ifelse(x > 8,sample(25:30,1,replace=TRUE),sample(21:24,1,replace=TRUE))
) |> ungroup()

p.cate.age <- dat.cate |> 
  ggplot() + 
  geom_rect(
    data = \(dat.cate) dat.cate |> subset(age == 27),
    aes(xmin = x - 0.01, xmax = x + 0.01, ymin = -Inf, ymax = Inf),
    fill = "#43f049",
    alpha = 0.3,
    inherit.aes = FALSE
  ) +
  geom_point(aes(x=x, y=y0,color=age,shape=obs.y0)) + 
  geom_point(aes(x=x, y=y1,color=age,shape=obs.y1)) + 
  geom_segment(aes(x=x,xend = x,y=y0,yend=y1,group=id),color='darkgrey',alpha=0.8,lty='dotted') +
  theme_minimal() + 
  scale_shape_manual(
    values= c('Y' = 16, 'N' = 1),
    labels= c('Y' = 'Observed','N' ='Unobserved')
  ) + 
  labs(
    x = 'X',
    y = 'Y',
    color = 'Age',
    shape = 'Observed'
  ) + 
  theme(legend.position = 'none')

dat.cate.filt<- dat.cate |> 
  mutate(
    ICE = y1-y0,
    pos = ifelse(ICE > 0,'Y','N')
  ) |> 
  filter(age == 27)

p.cate.calc <- dat.cate.filt |> 
  ggplot() + 
  geom_point(aes(x=id,y=ICE,color = pos),size=3) + 
  geom_hline(aes(yintercept= 0),color='black',lty='dashed') + 
  geom_hline(aes(yintercept= mean(ICE)),linewidth=2,color='#f38123') + 
  scale_fill_manual(
    values = c(
      'Y' = '#46d3d3',
      'N' = '#db4c4c'
    )
  ) + 
  theme_minimal() + 
  theme(legend.position='none')

p.cate.age + p.cate.calc
