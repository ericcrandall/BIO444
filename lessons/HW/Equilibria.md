---
title: <center>The Hardy Weinberg Equilibrium</center>
date: '2017-12-07'
output:
  html_document:
    keep_md: yes
    toc: yes
    toc_depth: 3
  md_document:
    toc: yes
    variant: markdown_github
  pdf_document:
    toc: yes
    toc_depth: 3
---
Lesson based on materials from [Bruce Cochrane](http://www.teachingpopgen.org)








## What is it?

The starting point for population genetics is the  Hardy Weinberg equilibrium.  It is the basis on which everything is built, so a thorough understanding of what it says and what it assumes is critical.  In this unit, we will briefly go through the basics of it ( the familiar p and q approach).  We will then examine it in more detail.


### A Sample Problem

So let's approach this as a problem in data analysis.  Imagine a single nucleotide polymorphism (SNP) that occurs in a population such that 6 individuals have genotype G/G, 28 individuals have genotype G/T (heterozygotes) and 66 individuals have genotype T/T.

Genotype | Number
---|---  
G G | 6
G T | 28
T T | 66

We want to ask two questions:

1.  What are the allele frequencies (i. e. how many G's and how many T's are there)?
2.  Most importantly, if these individuals were to mate at random, what would be the allele frequencies in the F1 generation?

#### Determining Allele Frequencies

So let's proceed as follows.  First of all, we will create a vector with of the observed data.

```r
obs <- c(6,28,66)
```
Recall that c() is a function that concatenates a number of values, in this case integers, in order to create a vector.

Now, let's ask how many G's there are.  Recognizing that every GG homozygote has two and every GT heterozygote has one, we can calculate that by

```r
nA <-2*obs[1]+obs[2]
nA
```

```
## [1] 40
```
And to make that a frequency, we need to divide it by the total number of *alleles*, which, since these are diploid individuals, is simply two times the number of individuals genotyped (N).

```r
N <-sum(obs)
p <-nA/(2*N)
p
```

```
## [1] 0.2
```
Now, we could repeat that process to determine the frequency of T, but here one of the simplest but most important relationships comes in to play.  Note that this is a biallelic locus, so if a particular allele is not G, it has to be T.  Thus, if we set the frequency of T to be q, then p+q must equal 1, or

```r
q <-1-p
q
```

```
## [1] 0.8
```
#### Random Mating

Now, suppose we turn the question around.  Given p and q, as calculated above, and assuming that random mating then occurs, what genotype numbers frequencies would we expect to see?  There are two ways we can approach this, one mathematical and one graphical.  First, the mathematical one.  Think of the population as orginating from a pool of alleles with frequencies p and q.  Literally, think of a pool of G's and T's. If that is the case, what is the chance that we reach into the pool and pull out a G? It turns out that the probability is the frequency of G! What is the chance that we pulling two Gs? These are independent events, so we multiply the probabilities: the frequency of G times frequency of G! And the same thing goes with the other genotypes below.  We can calculate the expected probabilities of the three genotypes (GG, GT, and TT) as

p{GG} = p{G}*p{G} = p^2^  
p{TT} = p{T}*p{T} = q^2^  
p{GT} =p{GT} or p{TG}   
= P{G} * P{T} + P{T} *P{G}  
= pq + qp   
= 2pq

We can can make a vector of those frequencies as follows

```r
fexp <-c(p^2,2*p*q,q^2)
fexp
```

```
## [1] 0.04 0.32 0.64
```
And finally, given those frequencies, what numbers of genotypes would we expect to see in a sample size of N?  Here, R makes it very easy to multiply the frequency vector by N


```r
Nexp <-fexp*N # multiplies each element of fexp by N
as.integer(Nexp) # get rid of decimal positions
```

```
## [1]  4 32 64
```
Contrast that with our observed numbers

```r
obs
```

```
## [1]  6 28 66
```
And they look pretty close.  Of course we need to test that statistically (which we will in a bit), but before we do so, let's see what's happened to p and q as a result of random mating:

```r
p1 <-(2*Nexp[1]+Nexp[2])/(2*N)
q1 <- 1-p1
p1;q1
```

```
## [1] 0.2
```

```
## [1] 0.8
```
And again, contrast those values with what we determined from the original data:


```r
p;q
```

```
## [1] 0.2
```

```
## [1] 0.8
```
And note.  **p and q have not changed**.


#### A Sample problem:

Below are some (completely made-up) data.  Use them to 

1.  Calculate p and q.
2.  calculate expected genotype frequencies
3.  Calculate expected genotype numbers

Genotype | Number
---|---
AA|69
Aa|101
aa|30


```r
obs <-c(69,101,30)
p <-(2*obs[1]+obs[2])/(2*sum(obs))
p
```

```r
q <-1-p
q
```

```r
genos <-c(p^2,2*p*q,q^2)
genos
gebis2 <-genos*sum(obs)
```

### And Why is This Important?

So what have we shown?  We can summarize as follows:

1.  Given a random mating population, with allele frequencies p and q, the expected genotype frequencies are p^2^, 2pq, and q^2^.
2.  In an ideal population, allele frequencies do not change.
3.  One generation of random mating is sufficient to restore HWE to autosomal loci (X linked are a bit different)
3.  And what is an "ideal" population?  It is one with the following properties  

>* Infinite size  
>* Random mating  
>* No Mutation  
>* No Migration  
>* No selection

In other words, *A population that is in Hardy Weinberg Equilibrium is not evolving*.  Thus, it becomes the null hypothesis from which we work; hence a deep understanding of its properties is essential if we are to thoroughly understand the genetics of the evolutionary process.

##### A graphical derivation



![](../images/HW.jpg)


 

### Calculations Based on Genotype Frequencies

Note that, at times problems are formulated in terms of genotype *frequencies* rather than numbers.  In those cases, the typical formula given is

p = f(AA) + 1/2(f(Aa))

But let's look at this a little more closely - Suppose we multiply it by 2N/2N.  Then we get

P =(2N*f(AA))+2N*(1/2(f(Aa)))/2N

But what is this?  N * f(AA) is simply the number of AA genotypes counted, and N *F(Aa) is the number of Aa, so this whole equation can be rewritten as

p=(2 * #(AA) + # (Aa))/2N

Which is exactly the same formula as above.  

So to wrap it up, when you start a Hardy-Weinberg problem, the first question to ask is whether you are given genotype *Numbers* or *frequencies* and go from there.  What you do **not** want to do is to treat the numbers as frequencies or vice versa.






### Exploring in More Depth

So at this point, we've seen how we can calculate allele frequencies, and we've also seen that in an ideal population, those frequencies do not change - the population does not evolve.  And it is worth it at this point to briefly summarize the properties of an ideal population:

1.  It is infinitely large
2.  Mating is random
3.  There is no mutation
4.  There is no migration
5.  There is no selection

Much of the rest of our time will be focused on understanding the consequences departures from one or more of these conditions - how do we detect them and what are their consequences?  Before that, however, we need to delve into the Hardy Weinberg Equilibrium a bit more deeply.

### Testing for departures from Hardy Weinberg

This is a subject we will be exploring in more depth in a later unit, but for starters, let's keep it simple.  Assume we can observe some genotypes:

Genotype| N
---|---
AA | 56
Aa | 78
aa | 22

We can calculate the frequencies of the two alleles as we did before:


```r
obs <-c(56,78,22)
N <-sum(obs)
p <-(2*obs[1]+obs[2])/(2*N)
q <- 1-p
p; q
```

```
## [1] 0.6089744
```

```
## [1] 0.3910256
```
And from those, we can calculate our expected genotype *numbers*

```r
exp <-N*c(p^2,2*p*q,q^2)
exp
```

```
## [1] 57.85256 74.29487 23.85256
```
So now we have observed and expected numbers; it would seem a logical step to apply the chi-square test to see if the difference between the two is significant. What we are doing is quantitating the departure from the expectations of an hypothesis for categorical data.  In our case, the categories are genotypes; the hypothesis is that the population is in Hardy-Weinberg equilibrium, and the data are the observed genotype *numbers*, which are compared to those expected based on HWE.

We've done the calculations above, so &chi;^2^ can be calculated easily by



```r
chi <-sum((obs-exp)^2/exp)
chi
```

```
## [1] 0.3879836
```

But how many degrees of freedom?  One rule of thumb is that degrees of freedom are one less than the number of classes, suggesting that it might be two in this case.  However there is another wrinkle.  In this case we used the actual data to estimate a parameter used in determining our expected values - p.  That costs us another degree of freedom. Another way to think of it is that our genotype frequencies are actually derived from two allelic frequencies (p and q).  So in the case of testing Hardy Weinberg with data from a biallelic locus, we only have one degree of freedom.  

So what is the probability that we would observe this much deviation based on chance alone (in which case we would accept our hypothesis)?  One way to do that is simulation - generate a bunch of &chi;^2^ distributed random variables and see where the 5% cutoff falls.  In this case, we will do a *one tail test*, since the range of our statistic is from zero to infinity (with zero the value obtained if the observed data exactly match the expectation)


```r
set.seed(123)
ch <- rchisq(100000,1)
colhist(ch,tail=1, xr=c(0,20),xlab="chi-square",ylab="Number",main="Are the Data Consistent with HWE?")
abline(v=chi,col="blue")
```

![](Equilibria_files/figure-html/unnamed-chunk-20-1.png)<!-- -->

```r
quantile(ch,.95)
```

```
##      95% 
## 3.851331
```

And we see that the data in fact fall within the range expected we observed as a result of chance.

We can also calculate the probability of this particular &chi;^2^ value as follows:


```r
pr <-1-pchisq(chi,1)
pr
```

```
## [1] 0.5333612
```

And we see that the probability of observing this much or more deviation from Hardy-Weinberg expectations is 53%, far higher than our normal standard of 5% for rejecting the null hypothesis.  So we can conclude in this case that the hypothesis cannot be rejected.

#### The more conventional approach

When you've done &chi;^2^ testing in the past, you've probably used a table that lists degrees of freedom and cutoff values that have been determined analytically.  For example, for one degree of freedom, that value is 3.84; we see that it is very similar to the number we obtained from our simulation above.  A small version of this table is also shown below:


```r
df <-c(1:10)
chicrit.05 <-sapply(df, function(x) qchisq(.95,x))
chicrit.01 <-sapply(df,function (x) qchisq(.99,x))
kable(data.frame(df,p.05 = chicrit.05,p.01=chicrit.01))
```



 df        p.05        p.01
---  ----------  ----------
  1    3.841459    6.634897
  2    5.991465    9.210340
  3    7.814728   11.344867
  4    9.487729   13.276704
  5   11.070498   15.086272
  6   12.591587   16.811894
  7   14.067140   18.475307
  8   15.507313   20.090235
  9   16.918978   21.665994
 10   18.307038   23.209251

#### A coding note

the hw() function in TeachingPopGen will accomplish much of what we have done so far.  Given some set of single locus, biallelic genotypes, it will return all the basic information.  For example


```r
dat.obs <-c(55,75,12) #observed numbers of AA, Aa, and aa
dat.hw <-hw(dat.obs)
```

```
## [1] p= 0.651408450704225 q= 0.348591549295775
##      obs exp
## [1,]  55  60
## [2,]  75  64
## [3,]  12  17
## [1] chi squared = 3.772 p =  0.052 with 1 d. f.
## [1] F =  -0.163
```
Note that it will print the results to the console; it also returns a list, in this case to the variable dat.hw:


```r
str(dat.hw)
```

```
## List of 6
##  $ Observed    : num [1:3] 55 75 12
##  $ Expected    : num [1:3] 60.3 64.5 17.3
##  $ Allele_freqs: num [1:2] 0.651 0.349
##  $ Chisq       : num 3.77
##  $ prob        : num 0.0521
##  $ F           : num -0.163
```


### Homozyogsity, Heterozygosity, and F


So by now we've looked at the chi-squared approach to testing whether observed genotype **numbers** are consistent with the prediction of Hardy-Weinberg.  There is, however, another way we can make this comparison - one that is less statistical, but which (as we shall see) is very relevant biologically.

#### A couple of definitions

We will use the following terms extensively in what follows:

* *Homozygosity* - the frequency of homozygotes (of any sort, e. g. AA and aa in the biallelic case) in a sample or population
* *Heterozygosity*  the total frequency of heterozygotes in the population

#### Expected Values

As is the case with any such measure, we need to have expectations.  These are pretty straightforward, especially:

1.  Expected homozygosity is simply ∑p<sub>i</sub>^2^, where the p's are the frequencies of the k alleles in the population
2.  Expected heterozygosity is easy for the biallelic case - it is simply 2p(1-p).  That could be extended to the case of multiple alleles, but remembering that every individual is either a homozygote or a heterozygote, a simpler calculation is

E(heterozygosity)=1-E(homozygosity) = 1- ∑p<sub>i</sub>^2^

#### Comparing some observations.

Now that we have our expectations, we can turn to some data.  These come from real data and are a staple of chapter-end problems in Genetics and Evolution texts.  The organisms are brown bears, the phenotypes are brown (dominant) vs. white(recessive) and the genotypes of a single base in the melanocortin receptor gene which is responsible for the difference are as follows:

Genotype | Phenotype | N
---|---|---
AA|Brown|42
AG|Brown|24
GG|White|21

So we can do some basic calculations


```r
genos <-c(AA=42,AG=24,GG=21)
genos
```

```
## AA AG GG 
## 42 24 21
```
And we can do our basic Hardy-Weinberg calculations as we have before

```r
hw.genos <-hw(genos)
```

```
## [1] p= 0.620689655172414 q= 0.379310344827586
##    obs exp
## AA  42  34
## AG  24  41
## GG  21  13
## [1] chi squared = 14.922 p =  0 with 1 d. f.
## [1] F =  0.4141
```
And we see that this is not an ideal population.  In fact, by inspection, we see that the observed number of heterozygotes, 24, is less than the expected one, 40.9655172.  But we want to make this more quantitative, comparing the observed and expected homozygosity and heterozygosity.  But since these must add up to one, and for reasons that will become clear down the road, we'll focus on heterozygosity.  Furthermore, from here on out, we'll work with frequencies rather than numbers (although  the latter would work equally well).

So first, what are the observed frequencies?

```r
genos.f.obs <-genos/sum(genos)
genos.f.obs
```

```
##        AA        AG        GG 
## 0.4827586 0.2758621 0.2413793
```
The observed heterozygosity is thus 0.276; to make the notation easier, we'll assign that a name

```r
Hobs <-genos.f.obs[2]
```
Now, what about the expected?  Remembering that that is 2pq, we calculate it as

```r
allele.freqs <-hw.genos$Allele_freqs
Hexp <-2*allele.freqs[1]*allele.freqs[2]
unname(Hexp)
```

```
## [1] 0.470868
```
Note that an alternate way of calculating this would simply be

```r
homo.exp <-(allele.freqs)^2
homo.exp <-sum(homo.exp)
unname(1-homo.exp)
```

```
## [1] 0.470868
```
Which gives us the same value.

### The F statistic

So what we want to do now is to come up with a numerical value to compare observed and expected heterozygosity.  Obviously, if they are equal (that is, we have a Hardy-Weinberg population), then the ratio will be 1.  Similarly, if there are no heterozygotes observed, then the ratio would be zero.  Thus, by subtracting the ratio from 1, we get a statistic that increases from zero to one, proportionate with increasing departure from HW.  Thus for our bear case here, we find that

```r
f.bears <-1-(Hobs/Hexp)
unname(f.bears)
```

```
## [1] 0.4141414
```
This statistic has a variety of names - Wright's F Statistic and the Fixation Index are two common ones.  We won't say more about it at this point, however we will be using it extensively in the future.  But the key points to realize are

1.  If a population is in HWE, then Hobs=Hexp so F= 1-1 = 0
2.  If there are *fewer* heterozygotes observed than expected, then F will be positive (as in the bear case)
3.  If there are *more* heterozygotes observed than expected, then F is negative

So what is a significant value of F?  At this point, we will leave that question open, but we will come back to it.

Finally, as an aside, the explanation for the bear data is that bears preferentially mate with ones of their own color.  Thus, brown X white matings occur less frequently than they would in a random mating population, thus reducing the frequency of heterozygotes.











