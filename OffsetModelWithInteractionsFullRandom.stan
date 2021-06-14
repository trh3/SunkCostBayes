data {
  int<lower=0> N; # number of responses
  int<lower=0> polls; # number of polls
  int<lower=0> wars; #number of wars
  // Cluster IDs
  int<lower = 1> pollsID[N];
  int<lower = 1> warsID[N];
  int<lower = 1> pollsforWarID[polls];
  
  //Covariates
  real lncasualty[polls];
  int<lower = 0, upper = 1> partisan[N];
  int<lower = 0, upper = 1> male[N];
  int<lower = 0, upper = 1> success[N];
  int<lower = 0, upper = 1> mistake[N];
  real duration[polls];
  
  //Interactions
  real casbypartisan[N];
  real casbymale[N];
  real durbypartisan[N];
  real durbymale[N];
  real casbysuccess[N];
  real casbymistake[N];
  real durbysuccess[N];
  real durbymistake[N];
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
   real beta_partisan;
   real beta_male;
   real beta_success;
   real beta_mistake;
	//Fixed effect for casualty spike and duration
	real beta_cas;
  real beta_dur; 
  
  //Fixed Effects for interactions
  real beta_casbypartisan;
  real beta_casbymale;
  real beta_durbypartisan;
  real beta_durbymale;
  real beta_casbymistake;
  real beta_casbysuccess;
  real beta_durbymistake;
  real beta_durbysuccess;


   // Level-2 (Polls) random intercept 
   real u_polls_int[polls];
   real<lower=0> sigma_polls_int;
 
   // Level-3  (Wars) random intercept
   real u_war_int[wars];
   real<lower=0> sigma_wars_int;
   
   //Level-3 (Wars) Cas Random Slope
   real u_cas_slope[wars];
   real<lower = 0> sigma_cas_slope;
   
   real u_dur_slope[wars];
   real<lower = 0> sigma_dur_slope;
   
   
      //Level-3 (Wars) Male Random Slope
   real u_male_slope[wars];
   real<lower = 0> sigma_male_slope;
   
      //Level-3 (Wars) Repub Random Slope
   real u_partisan_slope[wars];
   real<lower = 0> sigma_partisan_slope;
   
      real u_success_slope[wars];
   real<lower = 0> sigma_success_slope;
   
      real u_mistake_slope[wars];
   real<lower = 0> sigma_mistake_slope;
   
      //Level-3 (Wars) Partisan Random Slope

 
      //Level-3 (Wars) Repub Random Slope
   real u_casbymale_slope[wars];
   real<lower = 0> sigma_casbymale_slope;
 
   real u_casbypartisan_slope[wars];
   real<lower = 0> sigma_casbypartisan_slope;
   
      real u_casbysuccess_slope[wars];
   real<lower = 0> sigma_casbysuccess_slope;
   
      real u_casbymistake_slope[wars];
   real<lower = 0> sigma_casbymistake_slope;
 
   real u_durbymale_slope[wars];
   real<lower = 0> sigma_durbymale_slope;
   
      real u_durbypartisan_slope[wars];
   real<lower = 0> sigma_durbypartisan_slope;
   
      real u_durbysuccess_slope[wars];
   real<lower = 0> sigma_durbysuccess_slope;
   
      real u_durbymistake_slope[wars];
   real<lower = 0> sigma_durbymistake_slope;
   


 }
 transformed parameters {
 //varying intercepts
 real beta_polls_int[polls];
 real beta_wars_int[wars];
 real beta_cas_slope[wars];
 real beta_dur_slope[wars];

 real beta_male_slope[wars];
 real beta_partisan_slope[wars];
 real beta_success_slope[wars];
 real beta_mistake_slope[wars];
 real beta_casbymale_slope[wars];
 real beta_casbypartisan_slope[wars];
 real beta_casbysuccess_slope[wars];
 real beta_casbymistake_slope[wars];
 real beta_durbymale_slope[wars];
 real beta_durbypartisan_slope[wars];
 real beta_durbysuccess_slope[wars];
 real beta_durbymistake_slope[wars];
 
 //variances
real<lower = 0> sigma_polls_intpos; 
real<lower = 0> sigma_wars_intpos;
real<lower = 0> sigma_cas_slopepos;
real<lower = 0> sigma_male_slopepos;
real<lower = 0> sigma_partisan_slopepos;
real<lower = 0> sigma_dur_slopepos;
real<lower = 0> sigma_mistake_slopepos;
real<lower = 0> sigma_success_slopepos;

real<lower = 0> sigma_casbymale_slopepos;
real<lower = 0> sigma_casbypartisan_slopepos;
real<lower = 0> sigma_casbymistake_slopepos;
real<lower = 0> sigma_casbysuccess_slopepos;

real<lower = 0> sigma_durbymale_slopepos;
real<lower = 0> sigma_durbypartisan_slopepos;
real<lower = 0> sigma_durbymistake_slopepos;
real<lower = 0> sigma_durbysuccess_slopepos;
 
 for(w in 1:wars){
 
 beta_wars_int[w] = beta_0 + u_war_int[w];
 beta_cas_slope[w] = beta_cas + u_cas_slope[w];
 beta_dur_slope[w] = beta_dur + u_dur_slope[w];
 beta_male_slope[w] = beta_male + u_male_slope[w];
 beta_partisan_slope[w] = beta_partisan + u_partisan_slope[w];
beta_success_slope[w] = beta_success + u_success_slope[w];
beta_mistake_slope[w] = beta_mistake + u_mistake_slope[w];
  beta_casbymale_slope[w] =  beta_casbymale + u_casbymale_slope[w];
  beta_casbypartisan_slope[w]=  beta_casbypartisan + u_casbypartisan_slope[w];
  beta_casbysuccess_slope[w] =  beta_casbysuccess + u_casbysuccess_slope[w];
  beta_casbymistake_slope[w] =  beta_casbymistake + u_casbymistake_slope[w];
  beta_durbymale_slope[w] =  beta_durbymale + u_durbymale_slope[w];
  beta_durbypartisan_slope[w]=  beta_durbypartisan + u_durbypartisan_slope[w];
  beta_durbysuccess_slope[w] =  beta_durbysuccess + u_durbysuccess_slope[w];
  beta_durbymistake_slope[w] =  beta_durbymistake + u_durbymistake_slope[w];
 
 }
 
 for(poll in 1:polls){
 
 beta_polls_int[poll] = beta_wars_int[pollsforWarID[poll]] + u_polls_int[poll];
 
 }
 

 sigma_polls_intpos = fabs(sigma_polls_int); 
 sigma_wars_intpos = fabs(sigma_wars_int);
 sigma_cas_slopepos = fabs(sigma_cas_slope);
 sigma_male_slopepos = fabs(sigma_male_slope);
 sigma_partisan_slopepos = fabs(sigma_partisan_slope);
 sigma_dur_slopepos = fabs(sigma_dur_slope); 
 sigma_mistake_slopepos = fabs(sigma_mistake_slope);
 sigma_success_slopepos = fabs(sigma_success_slope);
 
  sigma_casbymale_slopepos = fabs(sigma_casbymale_slope);
 sigma_casbypartisan_slopepos = fabs(sigma_casbypartisan_slope);
 sigma_casbymistake_slopepos = fabs(sigma_casbymistake_slope);
 sigma_casbysuccess_slopepos = fabs(sigma_casbysuccess_slope);
 
   sigma_durbymale_slopepos = fabs(sigma_durbymale_slope);
 sigma_durbypartisan_slopepos = fabs(sigma_durbypartisan_slope);
 sigma_durbymistake_slopepos = fabs(sigma_durbymistake_slope);
 sigma_durbysuccess_slopepos = fabs(sigma_durbysuccess_slope);
 
 }
 
model {
u_polls_int ~ normal(0, sigma_polls_intpos);
u_war_int ~ normal(0, sigma_wars_intpos);
u_cas_slope ~normal(0,sigma_cas_slopepos);
u_male_slope ~normal(0,sigma_male_slopepos);
u_partisan_slope ~normal(0,sigma_partisan_slopepos);
u_dur_slope ~normal(0, sigma_dur_slopepos);
u_mistake_slope ~normal(0, sigma_mistake_slopepos);
u_success_slope ~normal(0, sigma_success_slopepos);
u_casbymale_slope~normal(0,sigma_casbymale_slopepos);
u_casbypartisan_slope~normal(0,sigma_casbypartisan_slopepos);
u_casbymistake_slope~normal(0,sigma_casbymistake_slopepos);
u_casbysuccess_slope~normal(0,sigma_casbysuccess_slopepos);

u_durbymale_slope~normal(0,sigma_durbymale_slopepos);
u_durbypartisan_slope~normal(0,sigma_durbypartisan_slopepos);
u_durbymistake_slope~normal(0,sigma_durbymistake_slopepos);
u_durbysuccess_slope~normal(0,sigma_durbysuccess_slopepos);


beta_0 ~normal(0,10);
beta_cas ~normal(0,10);
beta_partisan ~normal(0,10);
beta_male ~normal(0,10);
beta_casbymale~normal(0,10);
beta_casbypartisan~normal(0,10);
beta_dur~normal(0,10);
beta_durbypartisan~normal(0,10);
beta_durbymale ~normal(0,10);
beta_casbymistake ~normal(0,10);
beta_casbysuccess ~normal(0,10);
beta_durbymistake ~normal(0,10);
beta_durbysuccess ~normal(0,10);


sigma_cas_slope ~cauchy(0,5);
sigma_partisan_slope ~cauchy(0,5);
sigma_male_slope ~cauchy(0,5);
sigma_polls_int ~cauchy(0,5);
sigma_wars_int ~cauchy(0,5);
sigma_dur_slope ~cauchy(0,5);
sigma_mistake_slope~cauchy(0,5);
sigma_success_slope~cauchy(0,5);

sigma_casbypartisan_slope ~cauchy(0,5);
sigma_casbymale_slope ~cauchy(0,5);
sigma_casbymistake_slope~cauchy(0,5);
sigma_casbysuccess_slope~cauchy(0,5);

sigma_durbypartisan_slope ~cauchy(0,5);
sigma_durbymale_slope ~cauchy(0,5);
sigma_durbymistake_slope~cauchy(0,5);
sigma_durbysuccess_slope~cauchy(0,5);

for(n in 1:N){
	y[n] ~ bernoulli_logit(beta_polls_int[pollsID[n]]  +beta_male_slope[warsID[n]]*male[n]+beta_partisan_slope[warsID[n]]*partisan[n] + beta_cas_slope[warsID[n]]*lncasualty[pollsID[n]] +beta_dur_slope[warsID[n]]*duration[pollsID[n]] + beta_casbypartisan_slope[warsID[n]]*casbypartisan[n] + beta_casbymale_slope[warsID[n]]*casbymale[n] + beta_durbypartisan_slope[warsID[n]]*durbypartisan[n] + beta_durbymale_slope[warsID[n]]*durbymale[n] + beta_casbymistake_slope[warsID[n]]*casbymistake[n] +beta_casbysuccess_slope[warsID[n]]*casbysuccess[n] + beta_durbymistake_slope[warsID[n]]*durbymistake[n]+beta_durbysuccess_slope[warsID[n]]*durbysuccess[n] +beta_success_slope[warsID[n]]*success[n] +beta_mistake_slope[warsID[n]]*mistake[n]);
  }
}


