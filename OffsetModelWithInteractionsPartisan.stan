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
  real duration[polls];
  
  //Interactions
  real casbypartisan[N];
  real casbymale[N];
  real durbypartisan[N];
  real durbymale[N];

  
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

	//Fixed effect for casualty spike and duration
	real beta_cas;
  real beta_dur; 

  //Fixed Effects for interactions
  real beta_casbypartisan;
  real beta_casbymale;
  real beta_durbypartisan;
  real beta_durbymale;


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
   
      //Level-3 (Wars) Partisan Random Slope

 }
 transformed parameters {
 //varying intercepts
 real beta_polls_int[polls];
 real beta_wars_int[wars];
 real beta_cas_slope[wars];
 real beta_dur_slope[wars];

  real beta_male_slope[wars];
 real beta_partisan_slope[wars];
 //variances
real<lower = 0> sigma_polls_intpos; 
real<lower = 0> sigma_wars_intpos;
real<lower = 0> sigma_cas_slopepos;
real<lower = 0> sigma_male_slopepos;
real<lower = 0> sigma_partisan_slopepos;
real<lower = 0> sigma_dur_slopepos;
 
 
 for(w in 1:wars){
 
 beta_wars_int[w] = beta_0 + u_war_int[w];
 beta_cas_slope[w] = beta_cas + u_cas_slope[w];
 beta_dur_slope[w] = beta_dur + u_dur_slope[w];
 beta_male_slope[w] = beta_male + u_male_slope[w];
 beta_partisan_slope[w] = beta_partisan + u_partisan_slope[w];

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
 }
model {
u_polls_int ~ normal(0, sigma_polls_intpos);
u_war_int ~ normal(0, sigma_wars_intpos);
u_cas_slope ~normal(0,sigma_cas_slopepos);
u_male_slope ~normal(0,sigma_male_slopepos);
u_partisan_slope ~normal(0,sigma_partisan_slopepos);
u_dur_slope ~normal(0, sigma_dur_slopepos);

beta_0 ~normal(0,100);
beta_cas ~normal(0,100);
beta_partisan ~normal(0,100);
beta_male ~normal(0,100);
beta_casbymale~normal(0,100);
beta_casbypartisan~normal(0,100);
beta_dur~normal(0,100);
beta_durbypartisan~normal(0,100);
beta_durbymale ~normal(0,100);

sigma_cas_slope ~cauchy(0,5);
sigma_partisan_slope ~cauchy(0,5);
sigma_male_slope ~cauchy(0,5);
sigma_polls_int ~cauchy(0,5);
sigma_wars_int ~cauchy(0,5);
sigma_dur_slope ~cauchy(0,5);


for(n in 1:N){
	y[n] ~ bernoulli_logit(beta_polls_int[pollsID[n]]  +beta_male_slope[warsID[n]]*male[n]+beta_partisan_slope[warsID[n]]*partisan[n] + beta_cas_slope[warsID[n]]*lncasualty[pollsID[n]] +beta_dur_slope[warsID[n]]*duration[pollsID[n]] + beta_casbypartisan*casbypartisan[n] + beta_casbymale*casbymale[n] + beta_durbypartisan*durbypartisan[n] + beta_durbymale*durbymale[n] );
  }
}

// generated quantities{
//   real beta_cas_slope_male[4];
//   real beta_cas_slope_repub[4];
//   real beta_cas_slope_partisan[4];
//   real beta_cas_slope_maleRepub[4];
//   
//   beta_cas_slope_male[1:4] = beta_cas_slope[1:4]+beta_casbymale;
//   beta_cas_slope_repub[1:4] = beta_cas_slope[1:4]+beta_casbyrepub;
//   beta_cas_slope_partisan[1:4] = beta_cas_slope[1:4]+beta_casbypartisan;
//   
//   beta_cas_slope_maleRepub[1:4] = beta_cas_slope[1:4]+beta_casbymale + beta_casbyrepub;
// 
// }

