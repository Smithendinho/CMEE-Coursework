# Import Packages
library(dplyr) # Mutate function 
library(minpack.lm) # Contains the NLLSLM function
library(purrr) # Contains the Possibly function used to continue iterations after error

# Import Data & Formula
Data <- read.csv("../data/WrangledData.csv")

# Subset Data into unique IDs corresponding to individual growth curves
Data2 <- group_split(Data, ID)

##########################
### DEFINE ALL FORMULA ###
##########################

# Logistic Model Formula
logistic_model <- function(t, r_max, K, N_0){ # The classic logistic equation
  return(N_0 * K * exp(r_max * t)/(K + N_0 * (exp(r_max * t) - 1)))
}

# Gompertz Model Formula
gompertz_model <- function(t, r_max, K, N_0, t_lag){
  return(N_0 + (K - N_0) * exp(-exp(r_max * exp(1) * (t_lag - t)/((K - N_0) * log(10)) + 1)))
} 

# Formula for Generating AICc values
get_AICc <- function(x,df,resids) {
  n = nrow(df)
  params = length(coef(x))
  AIC <- n +2 + n*log((2*pi)/n)+n*log(resids)+2*params
  AICc <- AIC +(2*params*(params+1))/(n-params-1)
  return(AICc)
}

# Formula for Generating BIC values
get_BIC<- function(x,df,resids) {
  n = nrow(df)
  params = length(coef(x))
  BIC <- n + 2 + n*log((2*pi)/n)+n*log(resids)+log(n)*params
  return(BIC)
}

###############################
### FIT ALL LOGISTIC MODELS ###
###############################
set.seed(105)
print("Fitting Logistic Models")
num_iterations <- 100
Logi_func = function(x) {
  for (i in 1:num_iterations) {
    
    tryCatch({
      
      df <- x
      N0_start_logi <- rnorm(1,min(df$PopBio),2)
      popbio_values <- df$PopBio
      top_10_perc <- quantile(popbio_values,0.85)
      top_10_values <- popbio_values[popbio_values>top_10_perc]
      K_start_Log <- rnorm(1, mean(top_10_values), sd = mean(top_10_values)/10)
      max_pop_index <- which.max(df$PopBio)
      t_max_pop <- df$Time[max_pop_index]
      t_lag_start <- rnorm(1, df$Time[which.max(diff(diff(df$PopBio)))], df$Time[which.max(diff(diff(df$PopBio)))]/5)
      r_max_start_Logi <- abs(rnorm(1, 0,5))
      # rnorm(1, coef(lm(df$PopBio ~ df$Time, data = df[df$Time > t_lag_start & df$Time < t_max_pop,]))[2], 5)
      
      fit_model <- nlsLM(PopBio ~ logistic_model(t = Time, r_max, K, N_0),
                         data = df,
                         start = list(r_max = 0.01, N_0 = N0_start_logi, K = K_start_Log),
                         lower = c(r_max = 0, N_0 = min(df$PopBio), K = 0),
                         upper = c(r_max = 10, N_0 = 3000, K = max(df$PopBio)),
                         control = nls.lm.control(maxiter = 100))
      
      df$predicted_logistic <- predict(fit_model)
      df$residuals <- log(df$PopBio) - log(df$predicted_logistic)
      df$residuals_sqrd <- (df$residuals)^2
      SS_Residual <- sum(df$residuals_sqrd)
      df$total_resids <- log(df$PopBio) - mean(log(df$PopBio))
      df$total_resids_sqrds <- df$total_resids^2
      SS_total <- sum(df$total_resids_sqrds)
      R_squared_Log <- 1 - (SS_Residual / SS_total)
      
      summary <- summary(fit_model)
      r_max_logi <- summary$parameters[1]
      N_0_logi <- summary$parameters[2]
      K_logi <- summary$parameters[3]
      
      result <- data.frame(SubsetID = unique(df$ID),
                           Logistic_AICc = get_AICc(fit_model,df, SS_Residual),
                           Logistic_Rsqrd = R_squared_Log,
                           Logistic_BIC = get_BIC(fit_model,df, SS_Residual),
                           Logistic_r_max = r_max_logi,
                           Logistic_N_0 = N_0_logi,
                           Logistic_K = K_logi,
                           Medium = unique(df$Medium),
                           Actual_K = max(log(df$PopBio)),
                           Units = unique(df$PopBio_units))
      
      if (i == 1 || R_squared_Log > max(final_result_logi$Logistic_Rsqrd)) {
        final_result_logi <- result
      }
    })
  }
  return(final_result_logi)
}
fixthis_Logi = possibly(.f = Logi_func, quiet = TRUE)
x <- system.time(MyResLogi <- bind_rows(lapply(Data2, fixthis_Logi)))[1]
print(paste0("Logistic model fitting time in seconds: ", round(x,4)))

###############################
### FIT ALL GOMPERTZ MODELS ###
###############################
print("Fitting Gompertz Models")
set.seed(105)
Gomp_func = function(x) {
  for (i in 1:num_iterations){
    tryCatch({
      df <- x
      N0_start_Gomp <- rnorm(1, mean = min(log(df$PopBio)), sd = 0.1)
      popbio_values <- log(df$PopBio)
      top_10_perc <- quantile(popbio_values,0.8)
      top_10_values <- log(popbio_values[popbio_values>top_10_perc])
      K_start_Gomp <- mean(top_10_values)
      max_pop_index <- which.max(df$PopBio)
      t_max_pop <- df$Time[max_pop_index]
      t_lag_start <- rnorm(1, df$Time[which.max(diff(diff(log(df$PopBio))))], 1)
      r_max_start_Gomp <- abs(rnorm(1, coef(lm(log(df$PopBio) ~ df$Time, data = df[df$Time > t_lag_start & df$Time < t_max_pop,]))[2], 5))
      
      
      fit_model <- nlsLM(log(PopBio) ~ gompertz_model(t = Time, r_max, K, N_0, t_lag), 
                         data = df, 
                         start = list(r_max = 0.1, t_lag =t_lag_start, N_0 = -5, K = 0),
                         lower = c(t_lag = 0, r_max = 0, N_0 = -25, K = min(log(df$PopBio))),
                         control = nls.lm.control(maxiter = 100))
      
      
      df$total_resids <- log(df$PopBio)-mean(log(df$PopBio))
      df$total_resids_sqrds <- df$total_resids^2
      SS_total <- sum(df$total_resids_sqrds)
      
      df$predicted_gomp <- predict(fit_model)
      df$residuals <- log(df$PopBio)-df$predicted_gomp
      df$residuals_sqrd_gomp <- (df$residuals)^2
      SS_Residual <- sum(df$residuals_sqrd_gomp)
      R_squared_Gomp <- 1 - (SS_Residual/SS_total)

      summary <- summary(fit_model)
      r_max_gomp <- summary$parameters[1]
      t_lag_gomp <- summary$parameters[2]
      N_0_gomp <- summary$parameters[3]
      K_gomp <- summary$parameters[4]
      
      result <- data.frame(SubsetID = unique(df$ID),
                           Gompertz_AICc = get_AICc(fit_model,df,SS_Residual),
                           Gompertz_Rsqrd = R_squared_Gomp,
                           Gompertz_BIC = get_BIC(fit_model,df,SS_Residual),
                           Gompertz_r_max = r_max_gomp,
                           Gompertz_t_lag = t_lag_gomp,
                           Gompertz_N_0 = N_0_gomp,
                           Gompertz_K = K_gomp)
      
      if (i == 1 || R_squared_Gomp > max(final_result_Gomp$Gompertz_Rsqrd)) {
        final_result_Gomp <- result
      }
    })
  } 
  return(final_result_Gomp)
}

fixthis_Gomp = possibly(.f = Gomp_func, quiet = TRUE)
xy <- system.time(MyResGomp <- bind_rows(lapply(Data2, fixthis_Gomp)))[1]
print(paste0("Gompertz model fitting time in seconds: ", round(xy,4)))

############################
### FIT ALL CUBIC MODELS ###
############################
print("Fitting Cubic Models")
Cubic_func = function(x){
  df <- x
  model <- lm(log(PopBio) ~ poly(Time,3), data = df)
  summary <- summary(model)
  R_Squared <- summary$r.squared
  df$predicted_cubic <- predict(model)
  df$residuals <- log(df$PopBio) - df$predicted_cubic
  SS_Residuals <- sum(df$residuals^2)
  
  result <- data.frame(SubsetID = unique(df$ID),
                       Cubic_AICc = get_AICc(model, df, SS_Residuals),
                       Cubic_Rsqrd = R_Squared,
                       Temperature = unique(df$Temp),
                       Cubic_BIC = get_BIC(model,df, SS_Residuals),
                       Species = unique(df$Species))
  return(result)
}

fixthis_Cubic = possibly(.f = Cubic_func, quiet = TRUE)
xyz <- system.time(MyResCubic<- bind_rows(lapply(Data2, fixthis_Cubic)))[1]

print(paste0("Cubic Model fitting time in seconds: ", round(xyz,4)))

################################
### MAKE STATISTIC DATA SETS ###
################################

Stats_data <- merge(MyResGomp, MyResLogi, by = "SubsetID")
Stats_data <- merge(Stats_data, MyResCubic, by = "SubsetID")

####################################################
### ADD COLUMN FOR R SQRD, AICc AND BIC BEST FIT ###
####################################################

Stats_data$Rsqrd_Winner <- ifelse(
  Stats_data$Logistic_Rsqrd == pmax(Stats_data$Gompertz_Rsqrd,
                                    Stats_data$Logistic_Rsqrd,
                                    Stats_data$Cubic_Rsqrd), "Logistic",
                          ifelse(
  Stats_data$Cubic_Rsqrd == pmax(Stats_data$Gompertz_Rsqrd,
                                 Stats_data$Logistic_Rsqrd,
                                 Stats_data$Cubic_Rsqrd), "Cubic", "Gompertz"))

Stats_data <- Stats_data %>%
 mutate(AIC_Winner = case_when(
    Logistic_AICc - Gompertz_AICc <= -2 & Logistic_AICc - Cubic_AICc <= -2 ~ "Logistic",
    Gompertz_AICc - Logistic_AICc <= -2 & Gompertz_AICc - Cubic_AICc <= -2 ~ "Gompertz",
    Cubic_AICc - Gompertz_AICc <= -2 & Cubic_AICc - Logistic_AICc <= -2 ~ "Cubic",
    TRUE ~ "No clear winner"
  ))

Stats_data <- Stats_data %>%
  mutate(BIC_Winner = case_when(
    Logistic_BIC - Gompertz_BIC <= -2 & Logistic_BIC - Cubic_BIC <= -2 ~ "Logistic",
    Gompertz_BIC - Logistic_BIC <= -2 & Gompertz_BIC - Cubic_BIC <= -2 ~ "Gompertz",
    Cubic_BIC - Gompertz_BIC <= -2 & Cubic_BIC - Logistic_BIC <= -2 ~ "Cubic",
    TRUE ~ "No clear winner"
  ))

#######################
### ADD AIC WEIGHTS ###
#######################

# First find the delta AICcs
Stats_data$Gomp_delta_AICc <- Stats_data$Gompertz_AICc - pmin(Stats_data$Gompertz_AICc, Stats_data$Logistic_AICc, Stats_data$Cubic_AICc)
Stats_data$Logi_delta_AICc <- Stats_data$Logistic_AICc - pmin(Stats_data$Gompertz_AICc, Stats_data$Logistic_AICc,Stats_data$Cubic_AICc)
Stats_data$Cubic_delta_AICc <- Stats_data$Cubic_AICc - pmin(Stats_data$Gompertz_AICc, Stats_data$Logistic_AICc,Stats_data$Cubic_AICc)

# Calculate Weights
Stats_data$Gomp_Akaike <- exp(-0.5*Stats_data$Gomp_delta_AICc)/(exp(-0.5*Stats_data$Gomp_delta_AICc)+exp(-0.5*Stats_data$Logi_delta_AICc)+exp(-0.5*Stats_data$Cubic_delta_AICc))

Stats_data$Logi_Akaike <- exp(-0.5*Stats_data$Logi_delta_AICc)/(exp(-0.5*Stats_data$Gomp_delta_AICc)+exp(-0.5*Stats_data$Logi_delta_AICc)+exp(-0.5*Stats_data$Cubic_delta_AICc))

Stats_data$Cubic_Akaike <- exp(-0.5*Stats_data$Cubic_delta_AICc)/(exp(-0.5*Stats_data$Gomp_delta_AICc)+exp(-0.5*Stats_data$Logi_delta_AICc)+exp(-0.5*Stats_data$Cubic_delta_AICc))

# Sum should add to 1
Stats_data$Akaike_sum <- Stats_data$Gomp_Akaike+Stats_data$Logi_Akaike+Stats_data$Cubic_Akaike

############################################
### MODEL SELECTION USING AKAIKE WEIGHTS ###
############################################

Stats_data <- Stats_data %>%
  mutate(Akaike_Winner = case_when(
    Gomp_Akaike > 0.9 ~ "Gompertz",
    Logi_Akaike > 0.9 ~ "Logistic",
    Cubic_Akaike > 0.9 ~ "Cubic",
    TRUE ~ "No clear winner"
  ))

###############################################################################
### REDO AKAIKE WEIGHTS FOR JUST GOMP & LOGI FOR ROBUST PARAMETER ESTIMATES ###
###############################################################################

# First find the delta AICcs
Stats_data$Gomp_delta_AICc2 <- Stats_data$Gompertz_AICc - pmin(Stats_data$Gompertz_AICc, Stats_data$Logistic_AICc)
Stats_data$Logi_delta_AICc2 <- Stats_data$Logistic_AICc - pmin(Stats_data$Gompertz_AICc, Stats_data$Logistic_AICc)


# Calculate Weights
Stats_data$Gomp_Akaike2 <- exp(-0.5*Stats_data$Gomp_delta_AICc2)/(exp(-0.5*Stats_data$Gomp_delta_AICc2)+exp(-0.5*Stats_data$Logi_delta_AICc2))

Stats_data$Logi_Akaike2 <- exp(-0.5*Stats_data$Logi_delta_AICc2)/(exp(-0.5*Stats_data$Gomp_delta_AICc2)+exp(-0.5*Stats_data$Logi_delta_AICc2))

Stats_data$Akaike2sum <- Stats_data$Logi_Akaike2+Stats_data$Gomp_Akaike2

##########################################################
### CALCULATE PARAMETER ESTIMATES USING AKAIKE WEIGHTS ###
##########################################################

Stats_data$Rmax <- round((Stats_data$Gompertz_r_max*Stats_data$Gomp_Akaike2)+(Stats_data$Logistic_r_max*Stats_data$Logi_Akaike2),2)
Stats_data$K <- round((Stats_data$Gompertz_K*Stats_data$Gomp_Akaike2)+(Stats_data$Logistic_K*Stats_data$Logi_Akaike2),2)

#####################################
### EXPORT STATS DATAFRAME TO CSV ###
#####################################

write.csv(Stats_data, "../results/stats_data.csv")

############## GOODBYE! #############

