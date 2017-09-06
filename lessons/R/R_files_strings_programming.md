# Introduction to R
Eric D. Crandall  
`r Sys.Date()`  

# Datasets used in this lesson
- Plankton Samples
    - [*Google Drive*](https://drive.google.com/open?id=0BxvcQQYg3-HaaU9KRlJsbk5WbXc)
    - [*Webserver*](https://ericcrandall.github.io/BIO444/lessons/R/plankton_samples.zip)
 - Pelagic Fishes Metadata
    - [*Google Drive*](https://drive.google.com/open?id=0BxvcQQYg3-HadEExRlhpa1NwcXM)
    - [*Webserver*](https://ericcrandall.github.io/BIO444/lessons/R/pelagics_metadata.txt)


# Programming in R


Some lesson ideas from [Software Carpentry](http://software-carpentry.org)

## Working with the filesystem
R has many useful functions that can work with the file system on your computer (either Windows or Mac). First thing to learn is `getwd()` and `setwd()`, which will tell you about your working directory (like `pwd`) and let you change it to something else (like `cd`), respectively.

```r
getwd()
```

```
## [1] "/Users/cran5048/github/BIO444/lessons/R"
```

It's a good idea to set up a working "r-rena" in every project folder that will serve as the working directory for that project.

Other useful functions include `list.files` and `list.dirs`.


```r
list.files("/Users/eric/Desktop/filesystem")
```

```
## character(0)
```


## String manipulation and grepping
The ability to manipulate text strings in R is very useful when dealing with the file system etc. One useful function is `paste()`. Set the separator between strings using `sep =`


```r
paste("Today is", date())
```

```
## [1] "Today is Wed Sep  6 15:36:41 2017"
```

```r
paste("Eeny","meeny","miny","moe", sep="&")
```

```
## [1] "Eeny&meeny&miny&moe"
```

```r
paste("Users","eric","google_drive","CSUMB","BIO444",sep = "/")
```

```
## [1] "Users/eric/google_drive/CSUMB/BIO444"
```

Strsplit pretty much does the opposite. It breaks up text strings based on a delimiter.

```r
strsplit("/Users/eric/google_drive/CSUMB/BIO444",split="/")
```

```
## [[1]]
## [1] ""             "Users"        "eric"         "google_drive"
## [5] "CSUMB"        "BIO444"
```

Notice that the output is in a list. You need to "open the boxcar" to get to the goods.

```r
pathsplit<-strsplit("/Users/eric/google_drive/CSUMB/BIO444",split="/")
pathsplit[[1]]
```

```
## [1] ""             "Users"        "eric"         "google_drive"
## [5] "CSUMB"        "BIO444"
```

Then there is the `grep` family of functions

* grep()  #returns a vector of indices of elements that yielded a match to the regular expression
* grepl() #returns a vector of logical values for every element (T or F)
* sub() #replaces the first instance of a regular expression with a replacement pattern
* gsub() # replaces all instances of a regular expression with a replacement pattern

Here I will demonstrate grep statements and also show how to build up a complex statement out of simpler statements.

Read in the data:


```r
# downloading from the web
pelagics<-read.table(file="https://ericcrandall.github.io/BIO444/lessons/R/pelagics_metadata.txt",header=T,sep="\t",stringsAsFactors=F)
```


```r
#find indices of fish market fish
fishnumbers<-grep("Fish Market", pelagics$occurrenceRemarks)
str(fishnumbers)
```

```
##  int [1:807] 1 2 3 4 5 6 7 8 9 10 ...
```

```r
#find sample_IDs for all fish market fish
fishmarket_fish<-pelagics$materialSampleID[grep("Fish Market", pelagics$occurrenceRemarks)]

#add an "f" to Sample_Ids for all fish from the fish market
pelagics$materialSampleID[grep("Fish Market",
                    pelagics$occurrenceRemarks)]<-sub("([0-9]+.[0-9]+)",                                    "\\1f",pelagics$materialSampleID[grep("Fish Market", pelagics$occurrenceRemarks)])
```

## Functions
Just like in Unix, it can be useful to write functions that do specific tasks so that you may automate them in the future.

Let's start by defining a function `fahr_to_kelvin` that converts temperatures from Fahrenheit to Kelvin:

### Basic format

```r
fahr_to_kelvin <- function(temp) {
  kelvin <- ((temp - 32) * (5 / 9)) + 273.15
  return(kelvin)
}
```

We define `fahr_to_kelvin` by assigning it to the output of `function`.
The list of argument names are contained within parentheses.
Next, the body of the function--the statements that are executed when it runs--is contained within curly braces (`{}`).
The statements in the body are indented by two spaces.
This makes the code easier to read but does not affect how the code operates. 

When we call the function, the values we pass to it are assigned to those variables so that we can use them inside the function.

Inside the function, we use a _return statement_ to send a result back to whoever asked for it. However, if you don't use `return`, the function will return the value of the last statement that it evaluates. Probably best to use it for now.

Let's try running our function.
Calling our own function is no different from calling any other function:


```r
# freezing point of water
fahr_to_kelvin(32)
```

```
## [1] 273.15
```

```r
# boiling point of water
fahr_to_kelvin(212)
```

```
## [1] 373.15
```

#### Composing Functions

Now that we've seen how to turn Fahrenheit into Kelvin, it's easy to turn Kelvin into Celsius:


```r
kelvin_to_celsius <- function(temp) {
  celsius <- temp - 273.15
  return(celsius)
}

#absolute zero in Celsius
kelvin_to_celsius(0)
```

```
## [1] -273.15
```

What about converting Fahrenheit to Celsius?
We could write out the formula, but we don't need to.
Instead, we can _compose_ the two functions we have already created:


```r
fahr_to_celsius <- function(temp) {
  temp_k <- fahr_to_kelvin(temp)
  result <- kelvin_to_celsius(temp_k)
  return(result)
}

# freezing point of water in Celsius
fahr_to_celsius(32.0)
```

```
## [1] 0
```

This is another taste of how larger programs are built: we define basic operations, then combine them in ever-large chunks to get the effect we want. 

Real-life functions will usually be larger than the ones shown here--typically half a dozen to a few dozen lines--but they shouldn't ever be much longer than that, or the next person who reads it won't be able to understand what's going on.


Just like in Unix, it is a good idea to write simple functions that can be strung together.

#### Argument Position and Defaults

In the functions above `temp` is an argument to the function. It is then passed into the function as a variable to be operated upon. To be precise, R has three ways that arguments supplied by you are matched to the *formal arguments* of the function definition

1. by complete name, 
2. by partial name (matching on initial *n* characters of the argument name), and
3. by position.

Arguments are matched in the manner outlined above in *that order*: by complete name, then by partial matching of names, and finally by position. You may set defaults for a function by entering them with `=`


```r
fahr_to_celsius <- function(temp=98.5, correction=0 ) {
  temp_k <- fahr_to_kelvin(temp)
  result <- kelvin_to_celsius(temp_k)
  result <- result + correction
  return(result)
}

# freezing point of water in Celsius
fahr_to_celsius()
```

```
## [1] 36.94444
```

```r
fahr_to_celsius(correction=10, temp=98.5)
```

```
## [1] 46.94444
```

```r
fahr_to_celsius(cor=10, t=98.5)
```

```
## [1] 46.94444
```

```r
fahr_to_celsius(98.5,10)
```

```
## [1] 46.94444
```

## Using other people's functions
One great strength of R is its broad and active user base. *Many* published statistical methods are accompanied by a "package" of functions that will carry out the method in R. Before you re-invent the wheel by writing a function to do a particular analysis, it is worth searching the web to find out if someone has already written it for you.

You can install R packages using the `install.packages()` function. You can keep these packages updated using the `update.packages()` function. Packages can be loaded into memory using the `library()` function, or if you are using someones functions in a function of your own, use `require()`. 

Here we will install some packages that will be used in the rest of the class.


```r
install.packages("poppr","adegenet","ape","ggplot2","mmod","magrittr","dplyr","treemap","pegas","hierfstat","seqinr","strataG","gdistance","ecodist","reshape2","ggplot2","WriteXLS","knitr", dependencies = T)
```


Your packages are stored in a directory close to the R executable. You may find it useful to move this directory somewhere more accessible, and point R to it permanently, so that you don't lose access to these packages when you update the R executable. Instructions for this are [*here*](https://stackoverflow.com/questions/1401904/painless-way-to-install-a-new-version-of-r).



## For loops
`For` loops allow you to complete repetitive tasks. Basically, they automate repetitive tasks by running each item in a vector through the task.

### Basic format

```r
for(variable in collection) {
  do things with each value of the variable
}
```

We can name the loop variable anything we like (with a few restrictions, e.g. the name of the variable cannot start with a digit).
`in` is part of the `for` syntax.
Note that the body of the loop is enclosed in curly braces `{ }`.

We could write code that does this:


```r
best_practice <- "Let the computer do the work"

print_words <- function(sentence) {
  sentence<-strsplit(sentence,split = " ")[[1]]
  print(sentence[1])
  print(sentence[2])
  print(sentence[3])
  print(sentence[4])
  print(sentence[5])
  print(sentence[6])
}

print_words(best_practice)
```

```
## [1] "Let"
## [1] "the"
## [1] "computer"
## [1] "do"
## [1] "the"
## [1] "work"
```

but that's a bad approach for two reasons:

 1. It doesn't scale: if we want to print the elements in a vector that's hundreds long, we'd be better off just typing them in.

 2. It's fragile: if we give it a longer vector, it only prints part of the data, and if we give it a shorter input, it returns `NA` values because we're asking for elements that don't exist!


```r
best_practice<-"Sometimes it pays to be lazy, write a script, let the computer do the work"
print_words(best_practice[-6])
```

```
## [1] "Sometimes"
## [1] "it"
## [1] "pays"
## [1] "to"
## [1] "be"
## [1] "lazy,"
```


Here's a better approach:


```r
print_words <- function(sentence) {
  sentence<-strsplit(sentence,split = " ")[[1]]
  for (word in sentence) {
    print(word)
  }
}

print_words(best_practice)
```

```
## [1] "Sometimes"
## [1] "it"
## [1] "pays"
## [1] "to"
## [1] "be"
## [1] "lazy,"
## [1] "write"
## [1] "a"
## [1] "script,"
## [1] "let"
## [1] "the"
## [1] "computer"
## [1] "do"
## [1] "the"
## [1] "work"
```

This is shorter---certainly shorter than something that prints every character in a hundred-letter string---and more robust as well.

## Apply

#### `for` or `apply`?

A `for` loop is used to apply the same function calls to a collection of objects.
R has a family of functions, the `apply` family, which can be used in much the same way.

The `apply` family members include

 * `apply`  - apply over the margins of an array (e.g. the rows or columns of a matrix)
 * `lapply` - apply over an object and return list
 * `sapply` - apply over an object and return a simplified object (an array) if possible
 * `vapply` - similar to `sapply` but you specify the type of object returned by the iterations

Each of these has an argument `FUN` which takes a function to apply to each element of the object. Basically, `apply` and friends are `for` loops that are even shorter and faster to write (and run faster too). You just write a custom function, and it will apply it across your data.

Besides being a fancier, hipper version of the `for` loop, `apply` is useful for summarizing large datasets. Note that vectorization for things like `mean` and `sum` only works within a vector. If you have a matrix or dataframe, you need to use apply to take the mean across multiple columns or rows.


```r
m <- matrix(data=cbind(rnorm(100, mean = 0), rnorm(100, mean = 2), rnorm(100, mean = 5), rnorm(100, mean = 10), rnorm(100, mean =15)), nrow=100, ncol=5)

head(m)
```

```
##             [,1]       [,2]     [,3]      [,4]     [,5]
## [1,] -1.04192069  2.3598147 4.820039  9.953989 14.17993
## [2,]  0.21985077  2.7946697 4.869805  8.711597 15.16703
## [3,] -1.22905578  0.6847772 6.498812 11.053479 15.16038
## [4,]  0.09577823  3.9803027 4.124618  8.935129 13.96942
## [5,]  0.04191788 -0.6064269 3.532146 10.789976 12.99315
## [6,]  2.37889496  2.1625249 6.173228  9.484261 15.78074
```

```r
apply(m,MARGIN = 2,FUN = mean) # margin = 2 takes columns, margin=1 takes rows
```

```
## [1]  0.235789  1.835394  5.072873  9.763194 15.022193
```

## Challenge

CSUMB has a fancy new camera that can be towed like a plankton net, and which photographs individual plankters that drift in front of it. Let's write a function that grabs all the data from a plankton camera directory and makes a histogram of occurrances by depth for any particular type of plankton. 

Find the data files inside [*plankton_samples*](https://drive.google.com/open?id=0BxvcQQYg3-HaaU9KRlJsbk5WbXc) directory.


__This is not as hard as it sounds!__ 
Break the task into small stages:
1. Write a command to get the filenames of the plankton directory
2. Initialize an empty dataframe `allplankton<-NULL`
3. Write a `for` loop to grab all the file names from the directory and concatenate them into one big data frame.
4. Make an object with all the rows for which a particular plankter occurs (use a test case, like "amphipod")
5. Make a histogram of this object.
6. Wrap the whole thing in a function wrapper that takes `path`, `plankter` and `breaks` as input variables.

If you want, you can use `setwd()` to get to the directory with the plankton sample data files and load a single file as a test case for building the script.


