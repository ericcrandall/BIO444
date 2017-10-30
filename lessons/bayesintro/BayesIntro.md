# Introduction to Bayesian Statistics
Eric Crandall  
`r Sys.Date()`  

```r
library(knitr)
library(TeachingPopGen)
```



## Bayesian Inference

Up until now, we have been working from the standpoint of null hypothesis testing.  That is, we have asked, given some expected value of a parameter or set of parameters, how frequently we would see a departure from that expectation as great or greater than that which we see in our data?  But, as has been pointed out before, if we reject our null hypothesis based on this analysis, all we really know is that the null hypothesis doesn't explain the data.  We do not directly obtain an alternative expected value of our parameter.

In Bayesian Statistics (named after the Reverend Thomas Bayes, an 18th Century Scotsman who first proposed Bayes Theorem), we turn things around a bit.  We start by using whatever prior information  we might have about the parameter we are estimating, and then ask, given a particular outcome, how should that distribution be refined (giving us a posterior distribution).  In other words, can we use the data to actually work towards an estimate of the parameter(s) in question.

For a hypothesis H and a dataset (evidence) E, Bayes Theorem can be stated as:

$$ P(H|E) = \frac{P(E|H)P(H)}{P(E)}$$
$P(H|E)$ is also known as the posterior. It is the value that we are really interested in, in science!

$P(E|H)$ is the likelihood: it is what we are actually estimating using frequentist statistics (e.g. a p-value is the probability of observing a particular statistic value, given a null model), but its not really what we want to know! 

$P(H)$ is what we call a prior - it is the information we bring to the current analysis. 

$P(E)$ can be a very difficult quantity to estimate, and the reason that Bayesian statistics weren't adopted until recently. Now we usually use Markov-Chain Monte Carlo sampling to get at this value.

### A Forensic Example

Let's look at a real example, taken from forensics.  This is taken from Shoemaker (1999), a very nice introduction to Bayesian Statistics for genetics.  We are in New Zealand, and we have a genotype obtained from a  blood sample from a crime.  There are three ethnic groups in New Zealand - Caucasian, Maori and Western Polynesion - we would like to determine the probabilities that the sample came from a member of each of these groups, **given what we know about the ethnic makeup of New Zealand**.

So we start with our *prior* information, which in this case is simply the distribution of the three ethnic groups in the population as a whole:

```r
pr.c <-.819 #proportion that is Caucasian
pr.m <-.137 # Maori
pr.wp <-.044 # Western Polynesian
```

We then need the *likelihoods* that the particular genotype would be found in these populations (presumably done by some prior population-based genotyping)

```r
l.c <-3.96*10^-9
l.m <-1.18*10^-8
l.wp <-1.91*10^-7
```

These can be thought of as "the probability of getting the genotype from a member of a particular ethnic group".

Next, we can calculate the total probability that this blood sample would be found in this population $P(E)$ by multiplying each likelihood by its corresponding prior probability and summing:


```r
p.E <-pr.c*l.c+pr.m*l.m+pr.wp*l.wp
p.E
```

```
## [1] 1.326384e-08
```
So over all, it's a rare genotype.  But we have it in our sample - that is a given.  What we want to know is what the probabilities are that the sample came from an individual from each of the three ethnicities.  To calculate these posterior probabilities, we plug them into Bayes' equation:

```r
ps.c <-(pr.c*l.c)/p.E
ps.m <-(pr.m*l.m)/p.E
ps.wp <-(pr.wp*l.wp)/p.E
```


Ethnicity       Prior   Posterior
-------------  ------  ----------
Caucasian       0.819   0.2445174
Maori           0.137   0.1218802
W.Polynesian    0.044   0.6336023

So what we see is that, for example, despite the fact that Western Polynesians comprise the smallest fraction of the total population (4.4%), in fact the probability is that the particular blood sample came from one of that group is the highest.

### Priors as continuous distributions

In the above to examples, we had a finite number of possibilities,  three (Caucasian, Maori or Western Polynesian).  But what if we were dealing with something for which a continuous range of outcomes were possible?  How then do we calculate $P(E)$, the sum of all possible values weighted by the likelihood of each?  In some cases, integral calculus can come to the rescue, but often the problem is too complex for such an analytical solution.

#### An example

Suppose you flip a coin 10 times and get 8 heads, is it a fair coin?  Remember, The standard way of getting at that question is to say, "given that it is a fair coin, what is the probability that the outcome is  8 heads?"  But that is based on the assumption that the coin is fair (i. e. prob{head}=0.5) - if that null hypothesis is rejected, it does not by istelf provide any guidance as to what an alternative hypothesis.

So let's reframe the question as a Bayesian would. Suppose that the true probability of getting a head is somewhere between 0 and 1, but we don't know what it is.  How can we find it?  One way would be to conduct an experiment, in which we have a magical coin for which p{head} varies between 0 and 1  with each toss. If we could do that, we could then ask which trials, with what probabilities, led to the outcome of 10 heads.

Not an easy experiment to do in real life, but simulating it is straightforward.  Let's suppose we do a million coin tosses, and for each one, there is a probability of a head of some value between zero and one.  First we can simulate the probabilities:


```r
set.seed(54321)
p <-runif(1000000,0,1) # generate 1 million random numbers between 0 and 1
head(p)
```

```
## [1] 0.4290078 0.4984304 0.1766923 0.2743935 0.2165102 0.8663611
```

And we can quickly plot these values as a histogram:

```r
par(mfrow=c(1,1))
hist(p,xlab="p", main="Prior Distribution of p")
```

![](BayesIntro_files/figure-html/unnamed-chunk-8-1.png)<!-- -->
This is the epitomy of what statisticians call an "uniformative prior"

Now, let's take each of those values of p and generate the hypothetical results of tossing a coin with that probability of success 10 times

```r
outcomes <-rbinom(1000000,10,p)
head(outcomes)
```

```
## [1] 4 5 4 3 4 9
```
And we can look at the distribution of outcomes we got

```r
hist(outcomes)
```

![](BayesIntro_files/figure-html/unnamed-chunk-10-1.png)<!-- -->
And we see that (not surprisingly) they are evenly distributed from 0 to 10.  But what we want to do is focus on those trials in which in fact the outcome was 8, and ask what values of p in our initial uniform prior led to that outcome

```r
post <-p[which(outcomes==8)]
head(post)
```

```
## [1] 0.6993061 0.8768612 0.7496563 0.8707650 0.9426930 0.8780674
```
We can then plot this posterior distribution and calculate its mean and upper and lower confidence intervals:

```r
mean(post)
```

```
## [1] 0.7502157
```

```r
colhist(post,xr=c(0,1),xlab="p",ylab="Number",main="Posterior Distribution, # Heads = 8")
mean(post)
```

```
## [1] 0.7502157
```

```r
quantile(post,(c(.025,.975)))
```

```
##      2.5%     97.5% 
## 0.4841486 0.9404076
```

```r
abline(v=mean(post),col="blue")
```

![](BayesIntro_files/figure-html/unnamed-chunk-12-1.png)<!-- -->

And we see that, if we consider the mean of this distribution to be our expectation of p, then it is about .75.  

As we have done previously, we have shaded the upper and lower tails of the distribution.  However, here they have a new meaning.  What we are saying is that, **given our prior distribution and the particular outcome (8 heads), we conclude that there is a 95% chance that the true value of p falls within the range (in this case) of ~.5 and ~.95**.  This is known as the *maximum credible interval* and  is quite different from the confidence intervals we have considered earlier.  Remember that those are **the range of outcomes you would expect to see, given some null hypothesis about p (e. g. Ho:p=0.5)**

So, what have we done:

1.  We made an assumption about the distribution of the probabilities of getting a head (some value between 0 and 1).
2.  Based on that distribution, we simulated the outcomes of coin flips using randomly selected coins from that distribution.
3.  We then selected as our posterior distribution all of those that gave the observed outcome (8 heads) and used the mean of that as our new estimate of the true value of p(heads).

#### Refining the estimate of p

Suppose I just told you the results of this experiment and asked you what your best estimate of p might be. Most likely it would be .8, yet what we saw from our Bayesian analysis is that we got something slightly lower - .75 or so.  Why the discrepency?

Remember - we had a completely uninformative prior - we started by assuming that any outcome was possible.  However, having done the experiment, we  saw that now the distribution of p was no longer uniform; rather it is a unimodal one with a mean of .75.  What would happen if we did our experiment again and got the same outcome?  Now, we can use   this new (posterior) distribution as our prior.  And we could continue to do this, refining our prior after each experiment.  The code below will do that for 50 iterations; we will then plot the mean value of p obtained for each iteration.




```r
set.seed(12345)
p <-runif(1000000,0,1)
out.mean <-rep(0,100)
for(i in 1:100){
  outcomes <-rbinom(1000000,10,p)
  out <- rbinom(1,10,.8)
  post1 <-p[which(outcomes==out)]
  out.mean[i] <-mean(post1)
  p <-sample(post1,1000000,replace=TRUE)
}
```

We can look at this in a couple of ways.  First, we can plot the change in the mean of the posterior distribution of p with successive iterations:

```r
plot(out.mean, xlab="Iteration",ylab="p", type="l",main="Iterative Estimation of p")
```

![](BayesIntro_files/figure-html/unnamed-chunk-14-1.png)<!-- -->

And we see that, as we expected intuitively, it approaches a value of .8.  We can also look at the final posterior distribution of p (after 50 iterations):

```r
par(mfrow=c(1,2))
colhist(post,xlab="P",ylab="Frequency",main="Initial Posterior Distribution")
colhist(post1,xlab="P",ylab="Frequency",main="Final Posterior Distribution",xr=c(0,1)) 
```

![](BayesIntro_files/figure-html/unnamed-chunk-15-1.png)<!-- -->

Two features are evident.  First, as we already saw, the mean of the distribution is very close to .8, which is what we would intuitively expect given that we keep getting 8 heads out of 10.  Second, compare the distribution with that we saw when we did the calculation based on our initial uniform prior distribution, we got the following confidence limits:

```r
quantile(post,c(.025,.975))
```

```
##      2.5%     97.5% 
## 0.4841486 0.9404076
```

```r
quantile(post1,c(.025,.975))
```

```
##      2.5%     97.5% 
## 0.7898124 0.8370315
```
So as we've added more data, refining our prior distribution as we do so, the accuracy of our estimate has increased.  This is as it should be.

### Summary

Thomas Bayes first proposed his theorem in the 18th century, yet it is only within the past 20 years or so that Bayesian statistics have been widely used.  There are multiple reasons for this, however two are worth mentioning:

1.  While the mathematics for simple cases are straightforward, as the number of parameters to be estimated increases and/or the prior distributions become more complex, significant computational power is required.
2.  There is always the question as to whether the logic is inherently subjective and therefore suspect.  After all, we started all the analyses we have done with an assumption about what we thought the truth to be and then analyzed the data in that context.

With respect to the first point, we've seen, in a simple case, how we can easily use computer simulation to handle the problem of modeling a prior.  Subsequently, we will see how sampling can be used to further refine this process.  Regarding the second point, one thing to keep in mind is that selection of a prior distribution is important - if, for example, in the New Zealand case, if there were in fact a fourth ethnic group that was not included in the prior distribution, then the posterior probabilities obtained would obviously be flawed. So the challenge is to define one's priors sufficiently broadly to cover all possibilities, but also sufficiently focused that, via whatever algroithm is used, a well-supported outcome can be achieved in a manageable way. 

Finally, as we will see, there are many population genetics problems in which, while we may have some prior information about how particular parameters may be distributed, we do not have a specific null hypothesis against which we can test the data.  In such cases, the Bayesian approach can be very powerful.


<a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/4.0/deed.en_US"><img alt="Creative Commons License" style="border-width:0" src="http://i.creativecommons.org/l/by-nc-sa/4.0/88x31.png" /></a><br />This work is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/4.0/deed.en_US">Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License</a>.
