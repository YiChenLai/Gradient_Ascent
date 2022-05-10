# 梯度上升法 (Gradient Ascent)

## 1. 介紹

&emsp;&emsp;梯度上升法的原理就好比一個登山客在山中行走，而登山客只往自身位置附近最陡峭的上坡行走，一直走直到沒有上坡為止，即到達山頂。相當於我們今天進行優化，每次都往最好的結果進行參數的調整，最後即可以得到找到最好參數。梯度演算法是一個非常直觀的優化演算法，在腦海裡想像就可以了解其背後的計算原理，但同時缺點也很明顯，就是容易困在**區域最佳解 (Loacal Optimal Solution)** 之中。區域最佳解可以理解為群峰裡的其中一座高山，但不是群峰裡的最高峰。若登山客的目標是爬到最高峰，也就是**全域最佳解 (Globe Optimal Solution)**，以梯度上升法作為優化演算法是非常容易找尋到區域最佳解，因此，又被稱作為區域演算法。之後，有許多人開始針對爬山的過程進調整，詳細內容可以參考[維基百科 (梯度下降法)](https://en.wikipedia.org/wiki/Gradient_descent)。

&emsp;&emsp;同時，也有人提出基因演算法以及群粒子演算法，在搜尋最佳解過程中以基因變異或候鳥飛行中的資訊共享方法，來避免困在區域最佳解的可能。這兩種演算法也被稱作為全域演算法，而全域演算法也不止這兩種，在此就不多在著墨。

---
## 2. 背景條件與基本原理

&emsp;&emsp;本程式碼是根據我在研究過程中，因為特定的背景條件下進行改良設計的，而當時情況是 :

* **在模型 (Model) 中計算每一個評價分數 (Score) 都需要耗費大量時間。**
* **在 n 維度的模型中，每次的梯度上升一步都需要評價 Seed 本身與鄰近 2n 個 Near Seed 的分數，共要評價 2n+1 次**

&emsp;&emsp;在此先定義 : 
* 從 Model 中隨機取一個 Seed 到此 Seed 的找到最佳解，這個過程為「一次搜尋」。

&emsp;&emsp;梯度上升法的「一次搜尋」的流程圖 :

![image](https://github.com/YiChenLai/Gradient_Ascent/blob/master/image/Flowchart/flowchart_1.png)

&emsp;&emsp;因此，要尋找全域最佳解時，就有必要進行「多次搜尋」。運氣好的話可能 1 ~ 100 次，但「單次搜尋」所計算的時間成本很高，單靠運氣來優化是不可靠的，更何況運氣不好到需要上千次。

![image](https://github.com/YiChenLai/Gradient_Ascent/blob/master/image/Flowchart/flowchart_1_1.png)

---
## 3. 設計思路
&emsp;&emsp;上一段內容可以了解，進行「一次搜尋」的時間成本很高，因此我的提出的想法是 : **分區評價**

&emsp;&emsp;先將 Model 進行等分分區 (Zoon)，並在每個 Zoon 個別取 x 個樣本 Seed 進行評價並加總，作為各個 Zoon 的評價分數。之後，再從最高分的 Zoon 隨機取 Seed 進行梯度上升的搜尋。分區評價的梯度上升法流程圖 :

![image](https://github.com/YiChenLai/Gradient_Ascent/blob/master/image/Flowchart/flowchart_2.png)

