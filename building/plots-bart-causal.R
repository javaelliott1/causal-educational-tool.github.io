library(tidyverse)
library(bartCause)

set.seed(432)
n   <- 200
dat <- tibble(
  id = 1:n,
  age= runif(n,18,60),
  y0 = 100 + 0.05*age**2 + rnorm(n,0,3),
  y1 = 100 + age - 10 - 200*(1/age) + rnorm(n,0,3),
  z  = ifelse(age > 50, 0, rbinom(n,1,prob=.5)),
  y  = y1*z + y0*(1-z)
)


dat |> 
  ggplot(aes(x=age,y=y,color=as.factor(z))) + 
  geom_point() + 
  theme_minimal() + 
  labs(
    x = 'Age',
    y = 'Running Time',
    color = 'Treated',
    title = 'Our Observed Data',
    subtitle = 'Expanded for Causal Framework'
  ) 

dat |> 
  group_by(z) |> 
  mutate(avg_age = mean(age)) |> ungroup() |>
  ggplot(aes(x=age)) + 
  geom_histogram(aes(fill = as.factor(z),group=as.factor(z))) + 
  geom_vline(aes(xintercept = avg_age,color=as.factor(z)),lty='dashed',linewidth=2) + 
  scale_color_manual(
    values = c('1' = 'blue','0' = 'red')
  ) + 
  labs(
    x = 'Age',
    fill = 'Treated',
    color = 'Treated',
    title = 'Age Distribution Across Z',
    subtitle = 'The vertical lines (average ages) being so far away indicates imbalance.'
  ) + 
  theme_minimal()



dat |> 
  mutate(
    obs.y1 = ifelse(z == 1,'Y','N'),
    obs.y0 = ifelse(z == 0,'Y','N')
  ) |> 
  ggplot() + 
  geom_segment(aes(x=age,xend=age,y=y0,yend=y1,group=id),alpha=0.5,data=dat |> filter(age < 50)) + 
  geom_point(aes(x=age,y=y0,color=as.factor(z),shape = obs.y0)) +
  geom_point(aes(x=age,y=y1,color=as.factor(z),shape = obs.y1)) +
  scale_shape_manual(
    values = c('Y' = 16, 'N' = 1)
  ) + 
  theme_minimal() + 
  labs(
    x = 'Age',
    y = 'Running Time',
    color = 'Treated',
    shape = 'Observed',
    title = 'Suspending Belief to View Potential Outcomes',
    subtitle = 'We would calculate the individual causal effect for each person if we could'
  )

dat |> 
  mutate(
    ICE = y1 - y0
  ) |> 
  ggplot(aes(x=reorder(id,-ICE),y=ICE)) + 
  geom_col() + 
  geom_hline(aes(yintercept  = mean(ICE)),color='red',lty='dashed') + 
  theme_minimal() + 
  labs(
    x = '',
    y = 'Individual Causal Effect',
    title = paste0('Average Causal Effect of ',round(mean(dat$y1 - dat$y0),2)),
    subtitle = 'We would never be able to see this in the real world'
  ) + 
  theme(axis.text.x = element_blank())

#diff.means
diff.means <- dat |> group_by(z) |> summarise(avg.y = mean(y))

boot <- sapply(1:10000, function(i){
  boot.dat <- dat[sample(1:nrow(dat),replace=T),]
  mn.1 <- boot.dat |> filter(z==1) |> pull(y) |> mean()
  mn.0 <- boot.dat |> filter(z==0) |> pull(y) |> mean()

  mn.1 - mn.0
})
diff.means.se <- sd(boot)


dat |> 
  group_by(z) |> 
  mutate(y.avg = mean(y)) |> ungroup() |>
  ggplot(aes(x=age,y=y,color=as.factor(z))) + 
  geom_point() + 
  geom_hline(aes(yintercept = y.avg,color=as.factor(z))) + 
  geom_segment(aes(x=30,xend=30,y=192,yend=117),color='black') + 
  theme_minimal() + 
  labs(
    x = 'Age',
    y = 'Running Times',
    color = 'Treated',
    title = paste0('Difference in Means estimates -75 with CI (-84.95,-65.05)'),
    subtitle = 'True ATT is -59.12'
  )


summary(lm(y ~ z + age,data=dat))

dat |> 
  ggplot(aes(x=age,y=y,color=as.factor(z))) + 
  geom_point() +
  geom_abline(intercept = 51.4,slope = 3.5,color='red') + 
  geom_abline(intercept = 51.4 - 51.8,slope = 3.5,color='blue') + 
  geom_segment(aes(x=30,xend=30,y=156.4,yend = 104.6),color='black') + 
  theme_minimal() + 
  labs(
    x = 'Age',
    y = 'Running Time',
    color = 'Treated',
    title = paste0('Linear Regression estimates -51.8 with CI (-56.41,-47.196)'),
    subtitle = 'True ATT is -59.12'
  )
