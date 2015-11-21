

# 概要 #

  * グーグルで画像検索をする

# シナリオ #


# ページショット #

## !User-Agent!Mozilla/5.0 (X11; U; Linux i686; ja; rv:1.9.2.13) Gecko/20101203 Firefox/3.6.13 ##

  * `http://www.google.co.jp/images?um=1&hl=ja&safe=off&gbv=2&biw=1000&bih=793&tbs=isch%3A1&sa=1&q=KAWAII&aq=f&aqi=g-r10&aql=&oq=`
  * `http://www.google.co.jp/images?um=1&hl=ja&safe=off&gbv=2&tbs=isch:1&q=kawaii+anime&revid=232401679&sa=X&ei=kqlfTfPuLIK4vwO7qLyoAQ&ved=0CDMQ1QIoAA&biw=999&bih=794`
    * こちらのウィンドウサイズを送信しているようだが、 1000x793 になったり 999x794 になったりと、安定しないのが笑える。これはこっちの GPU の問題なんだが。何かちらちらして疲れるのは気のせいではなかったわけだ。
    * セーフサーチ設定をパラメータで持っている。前はクッキー使ってた気がしたがどうなんだろ。一度クッキー持つと、こいつが生成される？
```
<!--a--><h2 class=hd>検索結果</h2>
これが大きな結果ブロックの開始

このあと、いくつかの階層があって、
<span class=rg_ctlv><ul class=rg_ul data-pg=1 data-cnt=20>
これが論理的１ページの開始。
１つのページが複数の論理ページに分割されて、
論理ページを後ろに追加読み込みしていく構造。


論理ページ内では li タグが画像１個に対応
<li class=rg_li style="width:188px;height:135px" ><a class=rg_l style="width:188px;height:141px;margin-top:0px;margin-left:0px" href="/imgres?q=kawaii+anime&um=1&hl=ja&safe=off&sa=X&biw=999&bih=793&tbs=isch:1&tbnid=akDlvW71uSZZLM:&imgrefurl=http://static.animeonly.org/jap/gallery/search/(keyword)/kawaii%252Bneko&imgurl=http://static.animeonly.org/albums/Wallpapers/1600x1200/0/Anime_Kawaii_Neko.jpg&ei=w61fTamhJpGgvQPrmdzGAQ&zoom=1&w=1600&h=1200"><canvas id="cvs_akDlvW71uSZZLM:b" style="display:block" width=188 height=141></canvas><img class=rg_i id=akDlvW71uSZZLM:b data-src="http://t1.gstatic.com/images?q=tbn:ANd9GcTzDeMPU0APUeeG6dJus3DQihfj1NHTE0gcrFfPnCsioIXxO8GL" data-sz=f height=141 width=188 style="width:188px;height:141px" onload="google.isr.fillCanvas(this);google.stb.csi.onTbn(0, this)"></a></li>


上のだと、次のURLがオリジナル
http://static.animeonly.org/albums/Wallpapers/1600x1200/0/Anime_Kawaii_Neko.jpg

サムネイルはスクリプトでロードしているが、

<div id=foot class=tsf-p role=contentinfo><script>google.stb.csi.startLSI();</script><script>(function(x){x&&(x.src='data:image/jpg;base64,/9j/4AAQSkZJRgABAQAAAQABAAD/2wBDAAkGBwgHBgkIBwgKCgkLDRYPDQwMDRsUFRAWIB0iIiAdHx8kKDQsJCYxJx8fLT0tMTU3Ojo6Iys/RD84QzQ5Ojf/2wBDAQoKCg0MDRoPDxo3JR8lNzc3Nzc3Nzc3Nzc3Nzc3Nzc3Nzc3Nzc3Nzc3Nzc3Nzc3Nzc3Nzc3Nzc3Nzc3Nzc3Nzf/wAARCADDAI8DASIAAhEBAxEB/8QAHAAAAQQDAQAAAAAAAAAAAAAABgMEBQcAAQII/8QAPhAAAgEDAwEFBQcCBAUFAAAAAQIDAAQRBRIhMQYTQVFhByJxgaEUIzKRscHRQlIVJHLwM1NigqIWNbLh8f/EABkBAAMBAQEAAAAAAAAAAAAAAAECAwAEBf/EACIRAAMBAAIDAQACAwAAAAAAAAABAhEDIRIxQQQTMiJRYf/aAAwDAQACEQMRAD8ACFWlFU1tVpVVrm0saVK7C0oq0y1W8FlbFh+M8AUND8FJ7iCHh5FB8iaY3mtW9sqbfvGJzgHihmad5WLliWPUmm4Qtk9fOqKF9Ju38CiDtEhyZIGwfJqlrG

このあたり、
一番最後のところに、データっぽいものがある。
大きさから、アイコンかもしれないけど。

<img class=rg_i id=OirwM6YNJJdJgM:b data-src="http://t0.gstatic.com/images?q=tbn:ANd9GcT25YppMP2SRTCXdLgZ4AIJ35dqOULxvMgla6ik6PC7-tBtKqYowYdsZFfW" height=130 width=158 style="width:158px;height:130px" onload="google.isr.fillCanvas(this);google.stb.csi.onTbn(0, this)">

ページによって、このような base64 データになっていたり、 html タグになっていたりする。

```