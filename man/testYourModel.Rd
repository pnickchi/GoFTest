% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/testYourModel.R
\name{testYourModel}
\alias{testYourModel}
\title{Apply Goodness of Fit (GoF) Test for user Specified Distribution Model}
\usage{
testYourModel(
  x,
  score,
  Fx,
  mle = NULL,
  ngrid = length(x),
  gridpit = FALSE,
  precision = 1e-06,
  method = "cvm"
)
}
\arguments{
\item{x}{A numeric vector of length n for data points. The input must be numeric.}

\item{score}{can be a function provided by user that returns a matrix with n rows and p columns. The rows corresponds to each data point
and each column corresponds to each parameter in the model. If score is such a function, the first argument must take x (data points) and
the second argument must take a vector of mle estiamte of parameters. The function must return a matrix of n rows and p columns. testYourModel
function tries apply score function with mle as input to calculate score matrix.
The score input can instead be a matrix with n rows and p columns.}

\item{Fx}{can be a function to calculate the probability inverse transform of data.
A user provided function to calculate probability inverse transform of vector data, x. The first argument must be
vector of data values, x. The second argument must be a vector of unknown parameters. The number of parameters in this function
must match the number of parameters in score function (score_fn). See details for more examples.}

\item{mle}{Either null (if there is no parameter in the model) or a vector of mle estimate (s) of the unknown
parameter(s) in the model. The lenght of this vector must be the same as the number of columns of matrix
returned by score.}

\item{ngrid}{The number of equally spaced points to discritize the (0,1) interval to estimate the covariance of the stochastic process.}

\item{gridpit}{A Boolean indicator. If TRUE, ngrid is ignored and (0,1) interval is divided based on probability inverse transformed
values. If FALSE (default value), (0,1) is divided into ngrid equally spaced points to estimate process.}

\item{precision}{The theory behind GoF based on empirical distribution function (edf) works well if the mle is indeed the root of
derivative of log likelihood. The user provided score function is evaluated at mle to verify its closeness to zero.
Precision is used to check how close score function is to zero. The default value of precision is 1e-6.}

\item{method}{a character to indicate which statistics to calculate.
The possible values are 'cvm' for Cramer-von Mises, 'ad' for Anderson-Darling, and 'both' for both methods. The default value is 'cvm'.}
}
\value{
A list of two.
\itemize{
\item Statistic: The Cramer-von-Mises statistic (and Anderson_Darling if method = 'both').
\item pvalue: The approximate pvalue of the test. If method = 'both', two pvalues are returned.
}
}
\description{
This function can apply goodness of fit test based on empirical distribution function to any distribution defined by user.
In the case of no parameter estimation, the function requires score and probability transform inverse of data.
If there is any parameter that needs to be estimated, the function requires MLE of parameter too.
}
\examples{
set.seed(123)
# Example 1
# Generate some random data from Exponential dist
n <- 50
sim_data <- rexp(n, rate = 2)
# Estimate mle of scale parameter
theta    <- expMLE(x = sim_data)
testYourModel(x = sim_data, score = expScore, Fx = expFx, mle = theta, method = 'both')
# Example 2
# Generate some random data from Exponential dist
n <- 50
sim_data <- runif(n)
# Estimate mle of scale parameter
theta    <- expMLE(x = sim_data)
testYourModel(x = sim_data, score = expScore, Fx = expFx, mle = theta, method = 'cvm')
# Example 3
# Generate some random data from Normal dist
n <- 50
sim_data <- rnorm(n)
# Estimate mle of mean and sd
theta    <- normalMLE(x = sim_data)
testYourModel(x = sim_data, score = normalScore, Fx = normalPIT, mle = theta)
# Example 4
# Generate some random data from Normal dist
n <- 50
sim_data <- rnorm(n)
# Estimate mle of mean and sd
theta.value  <- normalMLE(x = sim_data)
score.matrix <- normalScore(x = sim_data, theta = theta.value)
pit.values   <- normalPIT(x = sim_data, theta = theta.value)
testYourModel(x = sim_data, score = score.matrix, Fx = pit.values, mle = theta.value)
}
