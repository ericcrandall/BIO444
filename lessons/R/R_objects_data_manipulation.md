# Data Types, Data Handling and Data Cleaning in R
Eric D. Crandall  
`r Sys.Date()`  



Lesson ideas (and some text) from [Software Carpentry](http://software-carpentry.org), [Eric Anderson](https///swfsc.noaa.gov/staff.aspx?id=740) and [Greg Gilbert](http://people.ucsc.edu/~ggilbert/)

# Data Types

## Everything in R is an object

R has many **data structures**. These include


*  atomic vector

*  list

*  matrix

*  data frame

*  factors

## Atomic Vectors

The fundamental data structure in R: a vector in which every element is of the same mode. Like


```r
x <- c(1,2,3,5,7)
x
```

```
## [1] 1 2 3 5 7
```

The `c()` function (for "combine") is the simplest way to make a vector, but there are many other ways:


```r
y <- 1:7
y
```

```
## [1] 1 2 3 4 5 6 7
```


```r
z <- seq(from = 1, to =10, by=2 )
z
```

```
## [1] 1 3 5 7 9
```


```r
boink<-(runif(n = 5, min = 1, max = 10))
boink
```

```
## [1] 1.889392 3.378221 2.666754 3.811301 6.628572
```

...etc.

### Modes

Vectors may they may be of any "mode" There are four main "modes" of scalar data, in order from least to most general:

 1.  `logical` can take two values: `TRUE` and `FALSE`, which can be abbreviated, when you type them as `T` and `F`.
 2.  The `numeric` mode comes in two flavors: "integer" and "numeric" (real numbers). Examples: `1`, `3.14`, `8.2`, `10`, etc.

    * R will default to "numeric", but you can force numbers to be integers by typing `1L,2L,3L' etc. You can also do this with coercion (below)
 3.  `complex`: these are complex numbers of the form $a + bi$ where $a$ and $b$ are real numbers and $i=\sqrt{-1}.$ Examples: `3.2+7.3i`, `4+0i`
 4.  `character`: these take values that are often called "strings" in other languages. Examples: `"cat"`, `"foo"`, `"bar"`, `"boing"`.

### Indexing

Vectors may be **indexed** very simply.


```r
hotdog <- c("bun","wiener","mustard","ketchup","onions")
hotdog[4]
```

```
## [1] "ketchup"
```

### Replacing elements in a vector


```r
hotdog[4]<-"mayo"
hotdog
```

```
## [1] "bun"     "wiener"  "mustard" "mayo"    "onions"
```

### Adding Elements to a vector


```r
hotdog<-c(hotdog,"relish")
hotdog
```

```
## [1] "bun"     "wiener"  "mustard" "mayo"    "onions"  "relish"
```

### Coercion

This is all pretty basic stuff, until you start accidentally, or intentionally mixing modes.


```r
x <- c(1,2,3,5,7,"11")
x
```

```
## [1] "1"  "2"  "3"  "5"  "7"  "11"
```

The mode of everything is *coerced* to the mode of the element with the most general mode, and this can really bite you in the rear if you don't watch out!


All the data in an atomic vector *must be of the same mode*
If data are added so that modes are mixed, then *the whole vector gets changed so that everything is of the most general mode*

Example:

```r
# simple atomic vector of mode numeric
x <- 1:6
x
```

```
## [1] 1 2 3 4 5 6
```


```r
# now change one to mode character and see what happens
a<-x
a[1] <- "applesauce"
a
```

```
## [1] "applesauce" "2"          "3"          "4"          "5"         
## [6] "6"
```

```r
class(a)
```

```
## [1] "character"
```


#### Functions For Explicit Coercion

There is a whole family for coercing objects between different modes (or different types) that take the form `as.something`:


*  `as.logical(x)`

*  `as.numeric(x)`

*  `as.integer(x)`

*  `as.complex(x)`

*  `as.character(x)`

*  `as.matrix(x)`

*  `as.data.frame(x)`

These are vectorized---they coerce every element of the vector to the desired mode.

### Vectorization


*  In R, the term *vectorization* refers to the fact that, in many cases, when you apply a function to a vector, it applies the function to every element of the vector.

*  This is apparent in many of the *operators* and we will see it in plenty of other functions, too.


```r
y<-x+x
y
```

```
## [1]  2  4  6  8 10 12
```


```r
b<-a=="applesauce"
b
```

```
## [1]  TRUE FALSE FALSE FALSE FALSE FALSE
```


```r
c<-as.numeric(b)
c
```

```
## [1] 1 0 0 0 0 0
```

## Missing Data and Special Values in R

`NA` is the missing data value in R and may be used with all modes. It means "Not Available"

There are also two more interesting values:

 1.  `Inf` (-Inf) means $\infty$ (or $-\infty$) and arises from things like: 1/0 or log(0).
 2.  `NaN` means "Not a Number" and it arises from situations where you can't evaluate something and it doesn't have an obvious limit. Like 0/0 or Inf/-Inf or 0*Inf.

If you wish to test whether something is NA, or NaN or Inf you have: `is.na(x)` and `is.nan(x)` and `is.infinite(x)` which return logical vectors.


```r
x <- c(NA, 2, Inf, 4, NaN, 6)

is.nan(x) # only the NaN
```

```
## [1] FALSE FALSE FALSE FALSE  TRUE FALSE
```

```r
is.na(x) # both NA and NaN
```

```
## [1]  TRUE FALSE FALSE FALSE  TRUE FALSE
```

```r
is.infinite(x) # only Inf or -Inf
```

```
## [1] FALSE FALSE  TRUE FALSE FALSE FALSE
```

Some functions won't work with `NA` values, so you'll want to use `na.rm = T` when running the function

## Operators

### Most Operators are Vectorized

This is *important*! All *operators* try to operate *element-wise* on every *element* of a vector.

Example:


```r
fish.lengths <- c(121, 95, 87, 142)
fish.weights <- c(1011, 505, 702, 900)
fish.fatness <- fish.weights / fish.lengths
fish.fatness
```

```
## [1] 8.355372 5.315789 8.068966 6.338028
```

### Mathematical Operators

Operate on `numeric` or `complex` mode data and return the same


```r
x + y   # addition
```

```
## [1]  NA   6 Inf  12 NaN  18
```

```r
x - y   # subtraction
```

```
## [1]  NA  -2 Inf  -4 NaN  -6
```

```r
x * y   # multiplication
```

```
## [1]  NA   8 Inf  32 NaN  72
```

```r
x / y   # division
```

```
## [1]  NA 0.5 Inf 0.5 NaN 0.5
```

```r
x ^ y   # exponentiation
```

```
## [1]         NA         16        Inf      65536        NaN 2176782336
```

```r
x %% y  # modulo division (remainder) 10 %% 3 = 1 
```

```
## [1]  NA   2 NaN   4 NaN   6
```

```r
x %/% y # integer division: 10 %/% 3 = 3
```

```
## [1]  NA   0 NaN   0 NaN   0
```

### Logical Operators

These operate on `logical`s and return `logical`s. `numeric` and `complex` vectors are coerced to `logical` before applying these.


*  Unary operator = NOT
    * `!` Turns `TRUE` to `FALSE` and `FALSE` to `TRUE`


```r
x <- c(T, T, F, F)  # you can use abbreviations for TRUE and FALSE...
        
x
```

```
## [1]  TRUE  TRUE FALSE FALSE
```

```r
!x
```

```
## [1] FALSE FALSE  TRUE  TRUE
```

*  Binary operators
    * `&` --- Logical AND
    * `|` --- Logical OR


```r
x <- c(NA, T, F, T, F)
y <- c(T, T, F, F, NA)
        
x
```

```
## [1]    NA  TRUE FALSE  TRUE FALSE
```

```r
y
```

```
## [1]  TRUE  TRUE FALSE FALSE    NA
```

```r
x & y
```

```
## [1]    NA  TRUE FALSE FALSE FALSE
```

```r
x | y
```

```
## [1]  TRUE  TRUE FALSE  TRUE    NA
```

### Comparison operators

These are "binary" because they involve *two* arguments.\\ Operate *elementwise* on vectors and return *logical vectors*


```r
x < y    # less than
```

```
## [1]    NA FALSE FALSE FALSE    NA
```

```r
x > y    # greater than
```

```
## [1]    NA FALSE FALSE  TRUE    NA
```

```r
x <= y   # less than or equal to 
```

```
## [1]    NA  TRUE  TRUE FALSE    NA
```

```r
x >= y   # greater than or equal to
```

```
## [1]   NA TRUE TRUE TRUE   NA
```

```r
x == y   # equal to 
```

```
## [1]    NA  TRUE  TRUE FALSE    NA
```

```r
x != y   # not equal to
```

```
## [1]    NA FALSE FALSE  TRUE    NA
```
`==` is the "//comparison equals//" which tests for equality. (Be careful not to use `=` which, in today's versions of R, is actually interpreted as leftwards assignment.)


```r
d <- c(1,3,5,7,9)
e <- c(8,6,4,2,0)


d > e
```

```
## [1] FALSE FALSE  TRUE  TRUE  TRUE
```

```r
d == e
```

```
## [1] FALSE FALSE FALSE FALSE FALSE
```

```r
d != e
```

```
## [1] TRUE TRUE TRUE TRUE TRUE
```

## OK back to data types

R has many **data structures**. These include


*  atomic vector <== we have now talked this to death

*  **list**

*  **matrix**

*  **data frame**

*  **factors**

### Lists

A list is a special type of vector. Each element can be a different type.

In R lists act as containers. They are technically vectors, but unlike atomic vectors, the contents of a list are not restricted to a single mode and can encompass any mixture of data types and R objects, even lists containing further lists. This property makes them fundamentally different from atomic vectors.

Create lists using `list()` or coerce other objects using `as.list()`. An empty list of the required length can be created using `vector()`


```r
x <- list(1, "a", TRUE, 1+4i)
x
```

```
## [[1]]
## [1] 1
## 
## [[2]]
## [1] "a"
## 
## [[3]]
## [1] TRUE
## 
## [[4]]
## [1] 1+4i
```



```r
x <- vector("list", length = 5) ## empty list
length(x)
```

```
## [1] 5
```

```r
x
```

```
## [[1]]
## NULL
## 
## [[2]]
## NULL
## 
## [[3]]
## NULL
## 
## [[4]]
## NULL
## 
## [[5]]
## NULL
```



```r
x <- 1:10
x <- as.list(x)
length(x)
```

```
## [1] 10
```

 1.  What is the class of `x[1]`?
 2.  What about `x[1](1)`?


```r
mylist <- list(the_man = "Madison Bumgarner", b = 1:9, data = head(iris))
mylist
```

```
## $the_man
## [1] "Madison Bumgarner"
## 
## $b
## [1] 1 2 3 4 5 6 7 8 9
## 
## $data
##   Sepal.Length Sepal.Width Petal.Length Petal.Width Species
## 1          5.1         3.5          1.4         0.2  setosa
## 2          4.9         3.0          1.4         0.2  setosa
## 3          4.7         3.2          1.3         0.2  setosa
## 4          4.6         3.1          1.5         0.2  setosa
## 5          5.0         3.6          1.4         0.2  setosa
## 6          5.4         3.9          1.7         0.4  setosa
```

A list does not print to the console like a vector. Instead, each element of the list starts on a new line.

#### Indexing Lists

Elements are indexed by double brackets `[element_name](element_name)` or `[element_number](element_number)`. Single brackets will still return a(nother) list. If the list items have names, you may also use `$`.


```r
mylist$data[1]
```

```
##   Sepal.Length
## 1          5.1
## 2          4.9
## 3          4.7
## 4          4.6
## 5          5.0
## 6          5.4
```

is the same as


```r
mylist[3][1]
```

```
## $data
##   Sepal.Length Sepal.Width Petal.Length Petal.Width Species
## 1          5.1         3.5          1.4         0.2  setosa
## 2          4.9         3.0          1.4         0.2  setosa
## 3          4.7         3.2          1.3         0.2  setosa
## 4          4.6         3.1          1.5         0.2  setosa
## 5          5.0         3.6          1.4         0.2  setosa
## 6          5.4         3.9          1.7         0.4  setosa
```


#### Lists and other Objects often have attributes

Attributes are part of the object. These include:


*  names

*  dimnames

*  dim

*  class

*  attributes (contain metadata)

You can also glean other attribute-like information such as `length()` (works on vectors and lists) or number of characters `nchar()` (for character strings). The most useful function for understanding the nature of an object is `str()`

Lists can be extremely useful inside functions. You can “staple” together lots of different kinds of results into a single object that a function can return.


```r
dat<-read.csv("https://ericcrandall.github.io/BIO444/lessons/R/Ostracods.csv")
reg_ostracods<-lm(dat$ostracod_density~dat$depth)
reg_ostracods
```

```
## 
## Call:
## lm(formula = dat$ostracod_density ~ dat$depth)
## 
## Coefficients:
## (Intercept)    dat$depth  
##   3.778e-02    8.069e-06
```

```r
str(reg_ostracods)
```

```
## List of 12
##  $ coefficients : Named num [1:2] 3.78e-02 8.07e-06
##   ..- attr(*, "names")= chr [1:2] "(Intercept)" "dat$depth"
##  $ residuals    : Named num [1:100] 0.009743 -0.000935 -0.010417 0.010872 -0.005909 ...
##   ..- attr(*, "names")= chr [1:100] "1" "2" "3" "4" ...
##  $ effects      : Named num [1:100] -0.50199 -0.0522 -0.01094 0.01014 -0.00697 ...
##   ..- attr(*, "names")= chr [1:100] "(Intercept)" "dat$depth" "" "" ...
##  $ rank         : int 2
##  $ fitted.values: Named num [1:100] 0.049 0.0528 0.061 0.0547 0.0449 ...
##   ..- attr(*, "names")= chr [1:100] "1" "2" "3" "4" ...
##  $ assign       : int [1:2] 0 1
##  $ qr           :List of 5
##   ..$ qr   : num [1:100, 1:2] -10 0.1 0.1 0.1 0.1 0.1 0.1 0.1 0.1 0.1 ...
##   .. ..- attr(*, "dimnames")=List of 2
##   .. .. ..$ : chr [1:100] "1" "2" "3" "4" ...
##   .. .. ..$ : chr [1:2] "(Intercept)" "dat$depth"
##   .. ..- attr(*, "assign")= int [1:2] 0 1
##   ..$ qraux: num [1:2] 1.1 1.05
##   ..$ pivot: int [1:2] 1 2
##   ..$ tol  : num 1e-07
##   ..$ rank : int 2
##   ..- attr(*, "class")= chr "qr"
##  $ df.residual  : int 98
##  $ xlevels      : Named list()
##  $ call         : language lm(formula = dat$ostracod_density ~ dat$depth)
##  $ terms        :Classes 'terms', 'formula'  language dat$ostracod_density ~ dat$depth
##   .. ..- attr(*, "variables")= language list(dat$ostracod_density, dat$depth)
##   .. ..- attr(*, "factors")= int [1:2, 1] 0 1
##   .. .. ..- attr(*, "dimnames")=List of 2
##   .. .. .. ..$ : chr [1:2] "dat$ostracod_density" "dat$depth"
##   .. .. .. ..$ : chr "dat$depth"
##   .. ..- attr(*, "term.labels")= chr "dat$depth"
##   .. ..- attr(*, "order")= int 1
##   .. ..- attr(*, "intercept")= int 1
##   .. ..- attr(*, "response")= int 1
##   .. ..- attr(*, ".Environment")=<environment: R_GlobalEnv> 
##   .. ..- attr(*, "predvars")= language list(dat$ostracod_density, dat$depth)
##   .. ..- attr(*, "dataClasses")= Named chr [1:2] "numeric" "numeric"
##   .. .. ..- attr(*, "names")= chr [1:2] "dat$ostracod_density" "dat$depth"
##  $ model        :'data.frame':	100 obs. of  2 variables:
##   ..$ dat$ostracod_density: num [1:100] 0.0587 0.0519 0.0506 0.0656 0.039 0.0503 0.0664 0.0617 0.0452 0.0409 ...
##   ..$ dat$depth           : num [1:100] 1385 1865 2879 2100 883 ...
##   ..- attr(*, "terms")=Classes 'terms', 'formula'  language dat$ostracod_density ~ dat$depth
##   .. .. ..- attr(*, "variables")= language list(dat$ostracod_density, dat$depth)
##   .. .. ..- attr(*, "factors")= int [1:2, 1] 0 1
##   .. .. .. ..- attr(*, "dimnames")=List of 2
##   .. .. .. .. ..$ : chr [1:2] "dat$ostracod_density" "dat$depth"
##   .. .. .. .. ..$ : chr "dat$depth"
##   .. .. ..- attr(*, "term.labels")= chr "dat$depth"
##   .. .. ..- attr(*, "order")= int 1
##   .. .. ..- attr(*, "intercept")= int 1
##   .. .. ..- attr(*, "response")= int 1
##   .. .. ..- attr(*, ".Environment")=<environment: R_GlobalEnv> 
##   .. .. ..- attr(*, "predvars")= language list(dat$ostracod_density, dat$depth)
##   .. .. ..- attr(*, "dataClasses")= Named chr [1:2] "numeric" "numeric"
##   .. .. .. ..- attr(*, "names")= chr [1:2] "dat$ostracod_density" "dat$depth"
##  - attr(*, "class")= chr "lm"
```

```r
attributes(reg_ostracods)
```

```
## $names
##  [1] "coefficients"  "residuals"     "effects"       "rank"         
##  [5] "fitted.values" "assign"        "qr"            "df.residual"  
##  [9] "xlevels"       "call"          "terms"         "model"        
## 
## $class
## [1] "lm"
```

```r
names(reg_ostracods)
```

```
##  [1] "coefficients"  "residuals"     "effects"       "rank"         
##  [5] "fitted.values" "assign"        "qr"            "df.residual"  
##  [9] "xlevels"       "call"          "terms"         "model"
```

```r
class(reg_ostracods)
```

```
## [1] "lm"
```

 1.  How would you return just the slope coefficient from this regression?

### Matrix

In R, matrices are an extension of the numeric or character vectors. They are not a separate type of object but simply an atomic vector with dimensions; the number of rows and columns.


```r
m <- matrix(nrow = 2, ncol = 2)
m
```

```
##      [,1] [,2]
## [1,]   NA   NA
## [2,]   NA   NA
```

Matrices in R are filled column-wise, unless you add `byrow=T

```r
m <- matrix(1:6, nrow = 2, ncol = 3)
```

Other ways to construct a matrix


```r
m      <- 1:10
dim(m)<- c(2, 5)
#This takes a vector and transform into a matrix with 2 rows and 5 columns.

#Another way is to bind columns or rows using `cbind()` and `rbind()`. This will make a matrix so long as all vectors are numeric.

x <- 1:3
y <- 10:12
cbind(x, y)
```

```
##      x  y
## [1,] 1 10
## [2,] 2 11
## [3,] 3 12
```

### Data frame

A data frame is a very important data type in R. It's pretty much the *de facto* data structure for most tabular data and what we use for statistics.

A data frame is a special type of list where every element of the list has same length. Elements may be of different modes - logical, numeric, character etc.

Data frames can have additional attributes such as `rownames()`, which can be useful for annotating data, or like `subject_id` or `sample_id`. But most of the time they are not used.

Some additional information on data frames:


*  Usually created by `read.csv()` and `read.table()`.

*  Can convert to matrix with `data.matrix()` (preferred) or `as.matrix()`

*  Coercion will be forced and not always what you expect.

*  Can also create with `data.frame()` function.

*  Find the number of rows and columns with `nrow(dat)` and `ncol(dat)`, respectively.

*  Rownames are usually 1, 2, ..., n.

#### Creating data frames by hand


```r
dat <- data.frame(id = letters[1:10], x = 1:10, y = 11:20)
dat
```

```
##    id  x  y
## 1   a  1 11
## 2   b  2 12
## 3   c  3 13
## 4   d  4 14
## 5   e  5 15
## 6   f  6 16
## 7   g  7 17
## 8   h  8 18
## 9   i  9 19
## 10  j 10 20
```

#### Useful data frame functions


*  `head()` - show first 6 rows

*  `tail()` - show last 6 rows

*  `dim()` - returns the dimensions

*  `nrow()` - number of rows

*  `ncol()` - number of columns

*  `str()` - structure of each column

*  `names()` - shows the `names` attribute for a data frame, which gives the column names.

See that it is actually a special list:


```r
is.list(iris)
```

```
## [1] TRUE
```


### Summary of data types

 | Dimensions | Homogenous    | Heterogeneous | 
 | ---------- | ----------    | ------------- | 
 | 1-D        | atomic vector | list          | 
 | 2_D        | matrix        | data frame    | 

### Factors

Factors are special vectors that represent categorical data. Factors can be ordered or unordered and are important for modelling functions such as `lm()` and `glm()` and also in `plot()` methods.

Once created factors can only contain a pre-defined set values, known as *levels*.

Factors are stored as integers that have labels associated the unique integers. While factors look (and often behave) like character vectors, they are actually integers under the hood, and *you need to be careful when treating them like strings*. Some string methods will coerce factors to strings, while others will throw an error.

Factors can be created with `factor()`. Input is often a character vector. Sometimes factors can be left unordered. Example: male, female.


```r
sexid<-factor(c("female","male"))
sexid
```

```
## [1] female male  
## Levels: female male
```

Other times you might want factors to be ordered (or ranked). Example: low, medium, high.


```r
noise<-factor(c("low","medium","high"),levels=c("low","medium","high"), ordered=T)
noise
```

```
## [1] low    medium high  
## Levels: low < medium < high
```

Underlying it's represented by numbers 1, 2, 3.

```r
as.numeric(noise)
```

```
## [1] 1 2 3
```

When levels are set like this, the "baseline" level is always the first one. This is important for some modeling functions.

They are better than using simple integer labels because factors are what are called self describing. male and female is more descriptive than 1s and 2s. Helpful when there is no additional metadata.

Which is male? 1 or 2? You wouldn't be able to tell with just integer data. Factors have this information built in.

**R has an annoying habit of converting character fields to factors on import with `read.table()`**

This can be avoided by using `stringsAsFactors = F` as an option in this command, or by using `as.is` followed by a vector of numbers for columns that you don't want converted.

If you need to convert a factor to a character vector, simply use

`as.character(x)`

To convert a factor to a numeric vector, go via a character. Compare


```r
f <- factor(c(1,5,10,2))
as.numeric(f) ## wrong!
```

```
## [1] 1 3 4 2
```

```r
as.numeric(as.character(f))
```

```
## [1]  1  5 10  2
```


# Data Handling and Cleaning

R is a powerful tool for summarizing your data, checking for mistakes, sorting, cleaning etc. Everything Excel can do and much more!

Download the pelagics dataset import into R directly from the web


```r
pelagics <- read.table("https://ericcrandall.github.io/BIO444/lessons/R/pelagics_metadata.txt",stringsAsFactors = F, sep="\t", header=T)
```
### Uniquing

`unique()` will save only unique values of whatever you give it, whether it is a data frame or a vector


```r
unique(pelagics$genus)
```

```
## [1] "Auxis"         "Katsuwonus"    "Euthynnus"     "Scomberomorus"
## [5] "Rastrelliger"
```

```r
unique(pelagics$decimalLatitude)
```

```
##  [1]  -1.1854167  -1.8700667  -0.8666667   1.4917014   5.6164167
##  [6]   0.7833333  -0.8614531  -8.6509790   3.5915405  -5.1188650
## [11]  -5.8191700  -6.0000000   1.4820335  -6.0924606  -2.5330000
## [16]  -1.8816667  -6.9666667  -8.5911667 -10.4460842  -5.1308551
## [21]  -0.5897240  -9.4456381   1.1255279  -8.5253630  -8.5072831
## [26]  -0.9500000  -1.1421667
```

```r
newdata<-unique(pelagics[1:21,])
```

### Summarizing Data into Tables

`table()` is handy for making "pivot tables"


```r
table(pelagics$country,pelagics$genus)
```

```
##                   
##                    Auxis Euthynnus Katsuwonus Rastrelliger Scomberomorus
##   Indonesia          192       190        184          178           139
##   Papua New Guinea     0         6          0            0             0
##   Solomon Islands      0         0         28            0             0
```

```r
##or
##table(pelagics[,c("country","genus")])

##3 dimensional table!
bymarket<-table(pelagics$occurrenceRemarks,pelagics$genus,pelagics$country)
```

## Subsetting (indexing)

We have already learned how to subset data using square brackets `[]` and `$`. Let's go into these a bit more, and also learn how to get more specific in selecting data in data frames.

### Selecting columns and rows

Indexing with dataframe and matrices goes `[row, column]`


1. select columns by name


```r
myvars <- c("materialSampleID", "genus", "species")
newdata<- pelagics[,myvars]
```

2.  select columns or rows by number


```r
newdata <- pelagics[,c(1,2,3)]
newdata <- pelagics[,c(1,5:10)]
newdata <- pelagics[1:10,1:10]
```

3.  dropping columns and rows


```r
newdata <- pelagics[,-c(1,2,3)]
newdata <- pelagics[,-c(1,5:10)]
newdata <- pelagics[-c(1:10),-c(1:10)]
```

4.  Using `which()`


```r
which(pelagics$country=="Papua New Guinea")
```

```
## [1] 329 330 331 332 333 334
```

```r
which(pelagics$country=="Papua New Guinea"| pelagics$country=="Solomon Islands")
```

```
##  [1] 329 330 331 332 333 334 542 543 544 545 546 547 548 549 550 551 552
## [18] 553 554 555 556 557 558 559 560 561 562 563 564 565 566 567 568 569
```



```r
newdata <- pelagics[which(pelagics$country=="Papua New Guinea" | pelagics$country=="Solomon Islands"),]
newdata <- pelagics[which(pelagics$country=="Papua New Guinea" | pelagics$country=="Solomon Islands" & (pelagics$country=="Euthynnus")),]
```

### Sorting vectors and dataframes

**We will also begin to see how we "pipe" together commands in R**


```r
student<-c("Dana","Ruth","Ylva","Skylar","Hanna","Sophia","Trevor","Jacob")
sex<-c("f","f","f","m","f","f","m","m")
shoe<-c(12,8,7,6,10.5,8,12,11)
shoes<-as.data.frame(cbind(student,sex,shoe))
shoes[,3]<-as.numeric(as.character(shoes[,3]))
```

`sort()` sorts vectors


```r
sort(shoes[,1])
```

```
## [1] Dana   Hanna  Jacob  Ruth   Skylar Sophia Trevor Ylva  
## Levels: Dana Hanna Jacob Ruth Skylar Sophia Trevor Ylva
```

```r
sort(shoes[,2])
```

```
## [1] f f f f f m m m
## Levels: f m
```

```r
sort(shoes[,3])
```

```
## [1]  6.0  7.0  8.0  8.0 10.5 11.0 12.0 12.0
```

`order()` gets the sorted order of a vector, which can then be used to sort data frames


```r
order(shoes[,1])
```

```
## [1] 1 5 8 2 4 6 7 3
```

```r
order(shoes[,3])
```

```
## [1] 4 3 2 6 5 8 1 7
```

```r
shoes[order(shoes[,3]),]
```

```
##   student sex shoe
## 4  Skylar   m  6.0
## 3    Ylva   f  7.0
## 2    Ruth   f  8.0
## 6  Sophia   f  8.0
## 5   Hanna   f 10.5
## 8   Jacob   m 11.0
## 1    Dana   f 12.0
## 7  Trevor   m 12.0
```


```r
byname<-shoes[order(shoes[,1]),]
otherway<-shoes[order(shoes[,3], decreasing=T),]
```

### Merging Data Together

We've already met `cbind` and `rbind` and now we will meet `merge`


```r
hat<-c(7.5,7,7.25,6.75,8,7.75,7,8.3)
belt<-c(30,26,34,29,31,25,32,33)

#Yo, check out this randomization!

shoes<-shoes[sample(1:8,replace=F),]

moredata<-as.data.frame(cbind(student,sex,hat,belt))
moredata[,3]<-as.numeric(as.character(moredata[,3]))
moredata[,4]<-as.numeric(as.character(moredata[,4]))

shoes
```

```
##   student sex shoe
## 3    Ylva   f  7.0
## 8   Jacob   m 11.0
## 1    Dana   f 12.0
## 5   Hanna   f 10.5
## 6  Sophia   f  8.0
## 4  Skylar   m  6.0
## 2    Ruth   f  8.0
## 7  Trevor   m 12.0
```

```r
moredata
```

```
##   student sex  hat belt
## 1    Dana   f 7.50   30
## 2    Ruth   f 7.00   26
## 3    Ylva   f 7.25   34
## 4  Skylar   m 6.75   29
## 5   Hanna   f 8.00   31
## 6  Sophia   f 7.75   25
## 7  Trevor   m 7.00   32
## 8   Jacob   m 8.30   33
```


```r
merge(shoes,moredata,by="student")
```

```
##   student sex.x shoe sex.y  hat belt
## 1    Dana     f 12.0     f 7.50   30
## 2   Hanna     f 10.5     f 8.00   31
## 3   Jacob     m 11.0     m 8.30   33
## 4    Ruth     f  8.0     f 7.00   26
## 5  Skylar     m  6.0     m 6.75   29
## 6  Sophia     f  8.0     f 7.75   25
## 7  Trevor     m 12.0     m 7.00   32
## 8    Ylva     f  7.0     f 7.25   34
```

# Challenges

I used to wonder how baseball announcers could get random stats like "Casey Mudville has the most RBIs out of all of the players who are right handed batters but throw with their left hand in the National League" in just a few minutes or seconds after a play. Now I think that they do it with R.

Import this tab-delimited (https://ericcrandall.github.io/BIO444/lessons/R/baseball_players08.txt) data frame  into R. Then write a single line of R code to answer each of these 3 challenges:

### Challenge 1

How many National League baseball players batted right and threw with their left in 2008?

### Challenge 2

What are their names?

### Challenge 3

Provide a table that is sorted alphabetically by the number of RBIs they hit in 2008.



