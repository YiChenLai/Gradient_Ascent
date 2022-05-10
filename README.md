# 梯度上升法 (Gradient Ascent)

## 介紹

此梯度上升法是有經過改良，可以解決較容易陷入區域最佳解 (Loacal Optimal Solution) 的情況。

梯度演算法的基本原理 :

```flow
st=>start: Start:>http://www.google.com[blank]
e=>end:>http://www.google.com
op1=>operation: My Operation
sub1=>subroutine: My Subroutine
cond=>condition: Yes
or No?:>http://www.google.com
io=>inputoutput: catch something...
para=>parallel: parallel tasks

st->op1->cond
cond(yes)->io->e
cond(no)->para
para(path1, bottom)->sub1(right)->op1
para(path2, top)->op1

```
