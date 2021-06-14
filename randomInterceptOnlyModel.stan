data {
  int<lower=0> N; # number of responses
  int<lower=0> polls; # number of polls
  int<lower=0> wars; #number of wars
  // Cluster IDs
  int<lower = 1> pollsID[N];
  int<lower = 1> warsID[N];
  int<lower = 1> pollsforWarID[polls];
  
  // Outcome
  int<lower = 0, upper = 1> y[N];
  
  //int<lower=0> P; # number of predictors (including intercept)
  //int<lower=0,upper=1> y[N]; # binary outcome
  //matrix[N,P] x; # predictors (including intercept)
  
}
 parameters {
  // Define parameters to estimate
  // Population intercept (a real number)
  real beta_0;
   // Population slopes for fixed effects.
   //real betas[p];
 
	
	//Fixed effect for casualty rate
	//real beta_cas;
   

   // Level-2 (Polls) random intercept 
   real u_polls_int[polls];
   real<lower=0> sigma_polls_int;
 
   // Level-3  (Wars) random intercept
   real u_war_int[wars];
   real<lower=0> sigma_wars_int;
 }
 transformed parameters {
 //varying intercepts
 real beta_polls_int[polls];
 real beta_wars_int[wars];
 
//Individual log odds
real mu[N]; 
 
 
 for(w in 1:wars){
 
 beta_wars_int[w] = beta_0 + u_war_int[w];
 
 }
 
 for(poll in 1:polls){
 
 beta_polls_int[poll] = beta_wars_int[pollsforWarID[poll]] + u_polls_int[poll];
 
 }
 
 //Individual Log Odds
 for(i in 1:N){
 
 mu[i] = beta_polls_int[pollsID[i]];
 
 }
 
 }
model {
u_polls_int ~ normal(0, sigma_polls_int);
u_war_int ~ normal(0, sigma_wars_int);
  for(n in 1:N)
	y[n] ~ bernoulli_logit(mu[n]);
}
generated quantities {
  vector[N] log_lik;
  for (n in 1:N)
    log_lik[n] = bernoulli_logit_lpdf(y[n], mu[n]);
}
