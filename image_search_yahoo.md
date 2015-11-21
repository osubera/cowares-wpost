

# 概要 #

  * ヤフー.jp で画像検索をする

# シナリオ #

  * [オリジナル配布物の ヤフー画像検索.txt](http://code.google.com/p/cowares-wpost/source/browse/trunk/wpost/20110218/%E3%83%A4%E3%83%95%E3%83%BC%E7%94%BB%E5%83%8F%E6%A4%9C%E7%B4%A2.txt)

# ページショット #

## !User-Agent!Mozilla/5.0 (X11; U; Linux i686; ja; rv:1.9.2.13) Gecko/20101203 Firefox/3.6.13 ##

  * `http://image.search.yahoo.co.jp/search?p=KAWAII&fr=&ei=UTF-8&pstart=1&b=41&ktot=0&dtot=2`
  * `http://image.search.yahoo.co.jp/search?p=KAWAII&fr=&ei=UTF-8&pstart=1&b=61&ktot=0&dtot=2`
    * b=41 などで、画像の開始番号を持ち、ページ制御しているようだが、 ktot dtot という謎の数字がある。
    * ktot dtot は、検索語によって異なるものを持ち、ページによって変化はしないようだ。
    * こいつらを正しく設定しないと、最初のページを表示し続ける。
    * とりあえず、最初のページに埋め込まれた ktot dtot を拾ってくれば動かせる。
  * `http://ord.yahoo.co.jp/o/image/SIG=13dvtqmjt/EXP=1298192685;_ylt=A3JuNGysh19N7wUApsGU3uV7;_ylu=X3oDMTA2dDlwbTE2BHlqZANwYw--/*-http%3A//image.search.yahoo.co.jp/search?p=KAWAII&fr=&ktot=0&dtot=2&ei=UTF-8&pstart=1&b=141`
    * ページ制御のリンクは、このように一度別のページを経由している。しかし、それをせず、直接 search を呼んでも動く。
  * 検索結果の解析
    * 検索件数は唯一の `<h1>` タグ付近にある。
```
<div id="Sf" class="cf">
<h1 class="t">画像検索結果</h1>
<p><em>KAWAII</em> で検索した結果<span class="bo">81～<strong id="ysrchcright">100</strong></span>件目 / 約<span class="bo">4,790,002</span>件</p>
</div>
```
    * `<h2>` が検索結果にリンクするブロックの開始位置にある。これは、画像検索結果だけでなく、スポンサードリンクの開始位置にもある。
```
<h2>画像</h2> <ol start="1" class="grid" id="gridlist">
    ... 画像検索結果一覧
    </ol>
    ...
<h2>
<a href="
http://ord.yahoo.co.jp/o/image/SIG=11oqm9hsa/EXP=1298192685;_ylt=A3JuNGysh19N7wUAncGU3uV7;_ylu=X3oDMTA2dDlwbTE2BHlqZANwYw--/*-http%3A//business.yahoo.co.jp/sponsor/
">スポンサードサーチ</a>
</h2>
    ... スポンサーリンク
```
    * 個別の検索結果は、`<ol>`内の `<li></li>` ブロックにある。
```
<li rel="gridmodule"> 
<div class="SeR"> 
<p class="tb"> 
<a
 href="http://ord.yahoo.co.jp/o/image/SIG=132b7eq49
/EXP=1298192685;_ylt=A3JuNGysh19N7wUAf8GU3uV7;_ylu=X3oDMTA2dDlwbTE2BHlqZANwYw--
/*-http%3A//image-search.yahoo.co.jp/detail?p=KAWAII&b=81&rkf=1&ib=84&ktot=0&dtot=2"
 rel="imgbox[plants]"
 rev="http://ord.yahoo.co.jp/o/image/SIG=12e653ahk
/EXP=1298192685;_ylt=A3JuNGysh19N7wUAQsGU3uV7;_ylu=X3oDMTA5NG1wbHZqBHlqZANwYwQwAw--
/*-http%3A//gaoh.jp/wp-content/uploads/2011/01/kawaii_title.jpg,500x479,86,http://ord.yahoo.co.jp/o/image/SIG=11rl70old/EXP=1298192685
/*-http%3A//gaoh.jp/event/rune_20100407.html?r=86&l=ri&fst=0,内藤ルネKawaii原展,86@k27IFQqOTysf3M:@0@S0FXQUlJ"
>
<img style="width: 130px; height: 125px; margin-left: -65px; margin-top: -62px;" title="クリックで拡大"
 src="http://msp.c.yimg.jp/image?q=tbn:k27IFQqOTysf3M::http://gaoh.jp/wp-content/uploads/2011/01/kawaii_title.jpg"
 alt="内藤ルネKawaii原展 | 美エンタ">
</a> 
</p><!-- /.tb --> 
<div class="info"> 
<h3 class="t">
<a href="
http://ord.yahoo.co.jp/o/image/SIG=132b7eq49
/EXP=1298192685;_ylt=A3JuNGysh19N7wUAgMGU3uV7;_ylu=X3oDMTA2dDlwbTE2BHlqZANwYw--
/*-http%3A//image-search.yahoo.co.jp/detail?p=KAWAII&b=81&rkf=1&ib=84&ktot=0&dtot=2
">内藤ルネ<em>Kawaii</em>...
</a>
</h3> 
<div class="e">500 x 479 - 225.3kB</div> 
</div><!--/.info --> </div><!--/.SeR --> 
</li>
```
    * 上のをかみくだいて整理する。
```
<li rel="gridmodule">
  <div class="SeR">
    <p class="tb">
      <a href="画像クリックでオーバーレイに拡大するリンク">
        <img サムネイル画像>
      </a>
    </p><!-- /.tb -->
    <div class="info">
      <h3 class="t"><a href="旧型（非Ajax）のページ遷移方式の拡大表示リンク">内藤ルネ<em>Kawaii</em>...</a></h3>
      <div class="e">500 x 479 - 225.3kB</div>
    </div><!--/.info -->
  </div><!--/.SeR -->
</li>
```
    * リンク先は、直接でなくヤフー経由なので、オリジナルがリンク切れのとき、キャッシュからサムネイルを表示する。見た目には、小さいサイズの画像だったら、リンク切れという判断をすることになる。
    * オリジナルのURLは、この例だと画像サムネイルに隠されている。しかし、こいつが存在しない、キャッシュの id だけの場合もあるので、いつも使えるわけではない。
      * `<img src=` の中身を `:` で split して、４つ目以降最後までとると、オリジナルURL。
```
src="http://msp.c.yimg.jp/image?q=tbn:k27IFQqOTysf3M::http://gaoh.jp/wp-content/uploads/2011/01/kawaii_title.jpg"

次のは、オリジナルを含まない例
src="http://isearch.c.yimg.jp/image?id=b15a5fe7b9d154359fd4598d5169e4bc"
```
    * `<a>` タグの `rev=` から取る方法だと、今のところ問題無さそう。
      * 最初の `/*-` から開始し、その後最初の ',' までが、オリジナル画像のURLと判断。
```
 rev="http://ord.yahoo.co.jp/o/image/SIG=12e653ahk
/EXP=1298192685;_ylt=A3JuNGysh19N7wUAQsGU3uV7;_ylu=X3oDMTA5NG1wbHZqBHlqZANwYwQwAw--
/*-http%3A//gaoh.jp/wp-content/uploads/2011/01/kawaii_title.jpg,500x479,86,http://ord.yahoo.co.jp/o/image/SIG=11rl70old/EXP=1298192685
/*-http%3A//gaoh.jp/event/rune_20100407.html?r=86&l=ri&fst=0,内藤ルネKawaii原展,86@k27IFQqOTysf3M:@0@S0FXQUlJ"
```
    * １ページあたり２０画像で、５０ページが最大。