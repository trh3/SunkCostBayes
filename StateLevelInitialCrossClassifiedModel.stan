data {
  int<lower=0> N; # number of responses
  int<lower=0> polls; # number of polls
  int<lower=0> states; #number of wars
  // Cluster IDs
  int<lower = 1> pollID[N];
  int<lower = 1> stateID[N];
  
  //Covariates
  real cas[N];
  int<lower = 0, upper = 1> male[N];
  int<lower = 0, upper = 1> repub[N];
  int<lower = 0, upper = 1> mistake[N];
  real dur[N];

  
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
   real beta_repub;
   real beta_male;
   real beta_mistake;
	//Fixed effect for casualty spike and duration
	real beta_cas;

  real beta_casbyrepub;
  real beta_casbymale;
  real beta_casbymistake;
  
   // Level-2 (Polls) random intercept 
   //real u_polls_int[polls];
   //real<lower=0> sigma_polls_int;
 
   // Level-3  (Wars) random intercept
  real u_state_int[states];
   real<lower=0> sigma_states_int;
   
   //Level-3 (Wars) Cas Random Slope
   real u_cas_state_slope[states];
   real<lower = 0> sigma_cas_state_slope;
   
   //real u_dur_state_slope[states];
   //real<lower = 0> sigma_dur_state_slope;
   
   
 }
 transformed parameters {
 //varying intercepts
 real beta_state_int[states];
 real beta_cas_state_slope[states];
 //real beta_dur_state_slope[states];

  //variances
//real<lower = 0> sigma_polls_intpos; 
real<lower = 0> sigma_states_intpos;
real<lower = 0> sigma_cas_state_slopepos;
//real<lower = 0> sigma_dur_state_slopepos;

 for(s in 1:states){
 
 beta_state_int[s] = beta_0 + u_state_int[s];
 beta_cas_state_slope[s] = beta_cas + u_cas_state_slope[s];
 //beta_dur_state_slope[s] = beta_dur + u_dur_state_slope[s];

 }


// sigma_polls_intpos = fabs(sigma_polls_int); 
 sigma_states_intpos = fabs(sigma_states_int);
 sigma_cas_state_slopepos = fabs(sigma_cas_state_slope);
 //sigma_dur_state_slopepos = fabs(sigma_dur_state_slope);
 }
 
model {
//u_polls_int ~ normal(0, sigma_polls_intpos);
u_state_int ~ normal(0, sigma_states_intpos);
u_cas_state_slope ~normal(0,sigma_cas_state_slopepos);
//u_dur_state_slope ~normal(0,sigma_dur_state_slopepos);

beta_0 ~normal(0,10);
beta_cas ~normal(0,10);
beta_repub ~normal(0,10);
beta_male ~normal(0,10);
beta_mistake~normal(0,10);
beta_casbyrepub~normal(0,10);
beta_casbymale~normal(0,10);
beta_casbymistake~normal(0,10);


sigma_cas_state_slope ~cauchy(0,5);
//sigma_dur_state_slope ~cauchy(0,5);
//sigma_polls_int ~cauchy(0,5);
sigma_states_int ~cauchy(0,5);

for(n in 1:N){
	y[n] ~ bernoulli_logit(beta_state_int[stateID[n]] + beta_cas_state_slope[stateID[n]]*cas[n]  + beta_repub*repub[n] + beta_male*male[n]+ beta_mistake*mistake[n] +beta_casbyrepub*cas[n]*repub[n]+beta_casbymale*cas[n]*male[n]+beta_casbymistake*cas[n]*mistake[n]);
  }
}


