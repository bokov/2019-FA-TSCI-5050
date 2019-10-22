#' ---
#' title: "TSCI 5050 Homework 2: Statistical Models"
#' author: "Your Name Here"
#' date: "10/21/2019"
#' ---
#' 
#+ init, message=FALSE,echo=FALSE,error=FALSE,warning=FALSE,results='hide'
# init -----
knitr::opts_chunk$set(comment=''); options(width=100); 
# additional packages to install
.projpackages <- c('GGally','tableone','pander','dplyr');
# name of this script
.currentscript <- "hw02.R"; 
# other scripts which need to run before this one.
.deps <- c( 'dictionary.R','data_characterization.R'); 
.junk<-capture.output(source('./scripts/global.R',chdir=T,echo=F,verbose=F));
#===========================================================#
###### Start of homework questions and your responses  ######
#===========================================================#
#' 
#' 
#' 
#' #### Instructions
#' 
#' Run `clean_slate()` and then build (ctrl-shift-K) this 
#' script into a report, just like you've gotten used to doing for 
#' `data_characterization.R`. I tried to make the homework readable both as
#' a script and a report, but some of the dynamic content will only be visible
#' in the report. But also source this script, `source(hw02.R)` or 
#' (ctrl-shift-S) so that your console session has all the same stuff in it as 
#' the report does.
#' 
#' Try out your answers in your console and when you get them to work, 
#' copy-paste them into this script. Some of your responses will be text, so
#' you should make sure to put `#'` at the start of each line of those. Some of
#' your responsess will be code, and for those make sure there are no `#'` nor
#' `#` preceding your code. Keep rebuilding your report every few minutes
#' while you work on it, so you can find and fix errors more easily.
#' 
#+ echo=FALSE
# Part 1 ----
#' 
#' #### Part 1. {#part1}
#' 
#' We will fit a linear regression model, like we did in class.
#' We start by creating a separate formula for each of your predictor variables
#' together with ``r outcomevars[1]``, your first outcome variable (I don't know 
#' what your variables are called, but this script does, because you used the 
#' `outcomevars` and `predictorvars` vectors to store their names).
aa <- paste(outcomevars[1], "~", predictorvars);
aa
#' **Question 1.1:** What does `outcomevars[1]` mean?
#' 
#' **Answer 1.1:**
#' 
#' 
#' ***
#' **Question 1.2:** Which side of the `~` is the resonse (or "y") and which is the
#' predictor ("x")?
#' 
#' **Answer 1.2:**
#' 
#' 
#' ***
#' **Question 1.3:** Try experimenting with the `paste()` command by giving it
#' other arguments. What does the `paste()` command do? What happens if one of 
#' the arguments is a vector?
#' 
#' **Answer 1.3:**
#' 
#' 
#' 
#' ***
#' Now let's fit our linear regression model using just one of these formulas at
#' first.
bb <- lm(aa[1],dat01);
summary(bb);
#' It looks wierd though, doesn't it? Instead of the *value* of `aa[1]`, which
#' is ``r aa[1]``, it literally says `aa[1]`. We can fix that using the 
#' `update()` command. It's a very useful command that lets you change various 
#' parts of a statistical model incrementally without having to rewrite the 
#' whole thing. Here we will "update" it to continue using the same outcome and 
#' predictor as it already was (that's what the `.`s in `.~.` mean) but as a 
#' side effect it will expand the `aa[1]` into the actual formula it represents.
cc <- update(bb,.~.);
summary(cc);
#' That's better. We can get a concise, one-line summary using the `glance()` 
#' command from the `broom` package.
dd <- glance(cc);
dd
#' Here are all the steps we just did, one after another:
aa <- paste(outcomevars[1], "~", predictorvars);
bb <- lm(aa[1],dat01);
cc <- update(bb,.~.);
dd <- glance(cc);
#' That's a lot of steps, and a lot of variables to create if all you need is
#' `dd`. Let's consolidate them into one expression.
#' 
#' Remember, if an expression returns the same value as a variable, you can 
#' substitute in the expression in place of the variable and vice versa:
identical( glance(cc) , glance(update(bb,.~.)) );
#' **Question 1.4:** Rewrite the above steps so that they are all one expression
#' by substituting in the command from each step, one after the other. I'll got
#' you started by substituting in `cc`, but now there is a `bb`. You do the 
#' rest: continue substituting in expressions until there are no  `bb` nor `aa` 
#' in the code below.
#' 
#' **Answer 1.4:** (complete the code below)
#+ answer1_4----

ee <- glance(update(bb,.~.));


#'                                                                                                            `r if(!identical(dd,ee)) "\n_There is an error in the above code, please review your answer._\n"`
#' ***
#' 
#' **Question 1.5:** Copy your expression from above and reformat is so that it
#' fits in a small windows without wrapping around. I recommend putting 
#' line-breaks after each `(` and before each `)` 
#' **or** 
#' before some of the commas.
#' RStudio will automatically indent the new line as appropriate. Make your 
#' code at least three lines long.
#'
#'  **Answer 1.5:** 
#+ answer1_5----

ee <- 'COPY AND MODIFY ANSWER FROM 1.4'


#'                                                                                                            `r if(!identical(dd,ee)) "\n_This question is not yet answered._\n"`
#' ***
#' 
#+ echo=FALSE
# Part 2 ----
#' #### Part 2. {#part2}
#' 
#' Now let's do all the formulas in `aa`, not just ``r aa[1]``. It's not a good 
#' practice to copy-paste the same code over and over. Instead, we could use a 
#' `for` loop. First we create an empty list.

AA <- list();

#' Then for each formula we create a model and add it to the list.

for(xx in aa){
  AA[[xx]] <- update(lm(xx,dat01),.~.);
}

#' It will take too much space to print out `AA` but here is a summary of it:

summary(AA);

#' **Question 2.1:** What does `foo[[bar]]` mean? Let's say the value of `bar`
#' is `"baz"`, and let's say that `foo` doesn't have any object inside it named
#' `"baz"`. What result would `foo[[bar]]` (or equivalently, `foo[["baz"]]`) 
#' return? (feel free to test your answer out in your console)
#' 
#' **Answer 2.1:**
#' 
#' 
#' ***
#' **Question 2.2:** Continuing the hypothetical example above, what will happen
#' if you do this: `foo[[bar]] <- 42` (or equivalently, `foo[["baz"]] <- 42`)? 
#' Now if `foo` *does* already have an object inside it named `"baz"`, then  
#' what happens if you do `foo[[bar]] <- 43` (or equivalently, 
#' `foo[["baz"]] <- 43`)?
#' 
#' **Answer 2.2:**
#' 
#' 
#' ***
#' 
#+ echo=FALSE
# Part 3 ----
#' #### Part 3. {#part3}
#' **Question 3.1:** Now `AA` is a list of `lm` objects, containing 
#' ``r outcomevars[1]`` regressed against each of the `predictorvars`. We need 
#' to do the same thing for the remaining `outcomevars`. We can put the loop 
#' from [part 2](#part2) inside another loop and that one will iterate over `outcomevars`. 
#' Below I wrote most of it. You just need to fill in the rest.
#' 
#' **Answer 3.1:** (complete the code below)
#+ answer3_1----

models00 <- list();
for(yy in outcomevars){
  yyformulas <- paste(yy,'~','REPLACE ME WITH THE CORRECT *UNQUOTED* VARIABLE');
  models00[[yy]] <- list();
  for(xx in yyformulas){
    'REPLACE ME WITH A MODIFIED VERSION OF THE 
     STATEMENT INSIDE THE LOOP FROM PART 2.
     AGAIN, NO QUOTES!'
  }
}
#' `r if(identical(unique(c(sapply(models00,sapply,class))),'lm')) "_You did it! Good job._" else "_Keep trying, you'll get it. Maybe try question 3.2 below if you're stuck._"`
#' 
#' ***
#' 
#' **Question 3.2:** Supposing that you have a list named `foo` and this time
#' it contains another list named `bar`: `foo<-list(bar=list())`. You store the 
#' name `"bar"` in a variable called `subItemName`, like this: 
#' `subItemName <- "bar"`. So you can access the inner list either directly
#' with `foo[["bar"]]` or indirectly with `foo[[subItemName]]`. To keep this 
#' relevant to Question 3.1, we'll use `foo[[subItemName]]`. 
#' 
#' Now you are asked to add an item named `bat`, with value `123` *inside* the 
#' sublist *without* replacing it. The name `"bat"` is stored in a variable 
#' named `subSubItemName`: `subSubItemName <- "bat"`. 
#' 
#' **The following is a wrong answer:** 
#' `foo[[subItemName]] <- 123`. 
#' It replaces the inner list with value `123` instead of putting the value 
#' inside it (with a name). 
#' **The following is also a wrong answer:** 
#' `foo[[subSubItemName]] <- 123` 
#' ...because it puts `123` next to the inner list rather than inside it.
#' 
#' So how would you insert the value `123` *inside* the inner list, not next to
#' it and not instead of it? 
#' 
#' **Answer 3.2:** (the code will be visible but will not run)
#+ answer3_2, eval=FALSE
# answer3_2 ----



#' Hint: I suggest you actually create `foo` by copy-pasting code from the 
#' question into your console so you can figure it out empirically.
#' 
#' Hint: `foo` is a list, `(foo)` is a list, `foo[[subItemName]]` is a list, and
#' `(foo[[subItemName]])` is also a list. For any of these you do the same thing 
#' to access items inside them-- you add `[[]]` and inside those brackets, a 
#' name or a variable containing that name. The parentheses are harmless but not
#' needed-- I put them there to help you see `foo[[subItemName]]` as one unit.
#' 
#' *** 
#' 
#+ echo=FALSE
# Part 4 ----
#' #### Part 4.
#' 
#' Let's create a summary table for each of the outcome variables. We will
#' start with the first model of ``r outcomevars[1]`` and then expand to cover all
#' of them.
#' (if you correctly answered question 3.1, the code below will show a result in
#' the report).
#+ part4glance, eval=!is(try(models00[[1]][[1]]),'try-error')

glance(models00[[1]][[1]]);

#' To do all the models for ``r outcomevars[1]`` we could use a `for` loop, but 
#' R provides another way to do this that's important for you to learn, and you
#' might find it more convenient once you get used to it. It's a function called
#' `sapply()`.
#' 
#' 1. The first argument to `sapply()` is whatever variable we loop over. In our 
#' case that's the list of models for ``r outcomevars[1]``-- `models00[[1]]` (not
#' `models[[1]][[1]]` anymore because we're doing everything inside 
#' `models[[1]]`, not just the first one). So we have: 
#' `sapply(models00[[1]])`.
#' 
#' 2. The second argument is a function *without parentheses*. That's because 
#' `foo()` returns the *results* of that function but `foo` returns a copy of 
#' *the function itself*. We're going to use the `glance` function:
#' `sapply(models00[[1]],glance)`.
#' 
#' 3. We add one last argument that will be passed  `sapply()` itself: 
#' `simplify=F`. This is to insure the results come out as a `list`. So the 
#' final version is: 
#' `sapply(models00[[1]],glance,simplify=FALSE)`
#' 
#' (if you correctly answered question 3.1, the code below will show a result in
#' the report).
#+ part4sapply, eval=!is(.test00<-bind_rows(sapply(models00[[1]],glance,simplify=FALSE)),'try-error') && 'p.value' %in% names(.test00)

sapply(models00[[1]],glance,simplify=FALSE);

#' Now we can use the `bind_rows()` command from the `dplyr` package. As its 
#' first argument `bind_rows` takes a `list` and as its `.id` argument it 
#' takes the name you want to give to the column that will hold the names of 
#' each row. Let's name that column `"model"`.
#' (if you correctly answered question 3.1, the code below will show a result in
#' the report).
#+ part4bindrows, eval=!is(.test00,'try-error') && 'p.value' %in% names(.test00)

bind_rows(sapply(models00[[1]],glance,simplify=FALSE),.id='model');

#' To arrange this table in order of increasing `p.value` we can use the 
#' `arrange_()` command from `dplyr` (the `_` is intentional, not a typo). 
#' The first argument is a `data.frame`-like object and the subsequent arguments 
#' are the names of columns by which you want the rows to be sorted.
#' (if you correctly answered question 3.1, the code below will show a result in
#' the report).
#+ part4arrange, warning=FALSE, eval=!is(.test00,'try-error') && 'p.value' %in% names(.test00)

arrange_(bind_rows(sapply(models00[[1]],glance,simplify=FALSE),.id='model'),'p.value');

#' By the way, when you see a list of p-values being used to to pick between 
#' several items, your instinct should be to correct them for multiple 
#' comparisons (for the best explanation of this problem that I have ever 
#' encountered, [please see this web-comic](https://xkcd.com/882/) ). 
#' Fortunately multiple comparison corrections are easy to do in R with the 
#' built-in `p.adjust()` function. It transforms a vector of raw p-values into a 
#' vector of adjusted p-values.
#' (if you correctly answered question 3.1, the code below will show a result in
#' the report).
#+ part4padjust, warning=FALSE, eval=!is(.test00,'try-error') && 'p.value' %in% names(.test00)

BB <- arrange_(bind_rows(sapply(models00[[1]],glance,simplify=FALSE),.id='model'),'p.value');
BB[['p.value']];
BB[['p.value']] <- p.adjust(BB[['p.value']]);
BB[['p.value']];

#' In fact, you can adjust p-values while you're creating the table, by using 
#' the `mutate()` command from `dplyr`. Mutate takes a `data.frame`-like object
#' as its first argument and named arguments for each of which the name is the 
#' column it will create or replace and the value is an expression that will be 
#' evaluated *inside* the `data.frame`. Since inside the `data.frame` columns 
#' are actual tangible variables, they are not quoted. Neither are the argument 
#' names because argument names are never quoted. So we have:
#' (if you correctly answered question 3.1, the code below will show a result in
#' the report).
#+ part4mutate, warning=FALSE, eval=!is(.test00,'try-error') && 'p.value' %in% names(.test00)

mutate(arrange_(bind_rows(sapply(models00[[1]],glance,simplify=FALSE),.id='model'),'p.value'),p.value=p.adjust(p.value));

#' Maybe expressing it with linke breaks as below makes it clearer which 
#' arguments go with which nested function:
#+ part4breakdown, eval=FALSE
mutate(
  arrange_(
    bind_rows(
      sapply(
        models00[[1]],glance,simplify=FALSE
        ),.id='model'
      ),'p.value'
    ),p.value=p.adjust(p.value)
  );
#' This is still kind of confusing because the first command that gets executed
#' is in the middle, and then execution moves outward. A popular alternative is
#' a command named `%>%` provided by the `magrittr` package. It is used by 
#' `dplyr` and tons of other packages. It takes whatever is on the left of it 
#' and turns it into the first argument of whatever is on the right of it. This
#' way you can chain together individual steps into a workflow more intuitive 
#' than nesting functions inside each other's arguments. Here are the `sapply()` 
#' and `bind_rows()` steps revised to use `%>%`:
#' (if you correctly answered question 3.1, the code below will show a result in
#' the report).
#+ part4pipe, warning=FALSE, eval=!is(.test00,'try-error') && 'p.value' %in% names(.test00)

sapply(models00[[1]],glance,simplify = FALSE) %>% bind_rows(.id='model');

#' Notice how in `bind_rows(.id='model')` we skip right over the first argument
#' and go straight to the second one. Now lets add the next step, `arrange_()`. 
#' (if you correctly answered question 3.1, the code below will show a result in
#' the report).
#+ part4pipearrange, warning=FALSE, eval=!is(.test00,'try-error') && 'p.value' %in% names(.test00)

sapply(models00[[1]],glance,simplify = FALSE) %>% 
  bind_rows(.id='model') %>%
  arrange_('p.value');

#' To avoid the command being too long, I put a line break _after_ each `%>%`
#' (putting line breaks before the `%>%`s would not have worked).
#' 
#' **Question 4.1:** Now it's your turn. Add the `mutate()` step to the end
#' of this pipeline.
#' 
#' **Answer 4.1:** 
#' (complete the code below once you have successfully answered question 3.1).
#+ answer4_1,warning=FALSE,eval=!is(.test00,'try-error') && 'p.value' %in% names(.test00)
# answer4_1----

CC <- sapply(models00[[1]],glance,simplify = FALSE) %>% 
  bind_rows(.id='model') %>% 
  arrange_('p.value') 

#'                                                                                                    `r if(!exists('BB') || !identical(CC,BB)) '\n_This question is not yet completed. Keep trying._\n\n'`
#' ***
#' **Question 4.2:** Now lets iterate over all the `outcomevars` and create this 
#' table for each of them! It is possible but tricky to do nested `sapply()`s so 
#' instead we will take the above pipeline and put it inside a `for` loop.
#' 
#' **Answer 4.2:** (complete the code below)
#+ answer4_2----

modeltables00 <- list();

for(yy in outcomevars){
  modeltables00[[yy]] <- 'COPY-PASTE YOUR ENTIRE ANSWER FROM QUESTION 4.1 IN
                          PLACE OF THIS MESSAGE (REMEMBER TO DELETE THE QUOTES
                          THAT ARE AROUND THIS MESSAGE) AND THEN REPLACE THE 1
                          NEAR THE BEGINNING WITH THE TEMPORARY VARIABLE BEING
                          USED BY THIS for LOOP'
}
#'
#'                                                                                                                                                                                                          `r if(!all(sapply(modeltables00,is,'tbl'))) "\n_This question is not yet completed. Keep trying._\n\n"`
#' ***
#' Here are the results, using `pander()` to format them for the report.
#' (if you have correctly answered question 4.2 the code below will show a 
#' result in the report)
#+ part4pander, eval=all(sapply(modeltables00,is,'tbl'))

panderOptions('table.split.table',Inf);
panderOptions('table.alignment.default','right');
pander(modeltables00);

#' Once you complete this assignment, congratulations. If you wish to use 
#' these tables in `data_characterization.R`, the only parts you need to copy 
#' over are your answer to question 3.1 and your answer to question 4.2. You 
#' should paste them into in the same order they appear here and after `dat01`
#' is created.










#+ wrapup, echo=FALSE,warning=FALSE,message=FALSE
#===========================================================#
##### End of your code, start of boilerplate code ###########
#===========================================================#
knitr::opts_chunk$set(echo = FALSE,warning = FALSE,message=FALSE);
tsave(file=paste0(.currentscript,'.rdata'),list=c('models00','modeltables00')
      ,verbose=FALSE);
#+ echo=FALSE,results='hide'
.wt <- walktrail();
c()

