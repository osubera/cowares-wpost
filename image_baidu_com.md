

# 概要 #

  * Baidu で画像検索をする

# シナリオ #


# ページショット #

## !User-Agent!Mozilla/5.0 (X11; U; Linux i686; ja; rv:1.9.2.13) Gecko/20101203 Firefox/3.6.13 ##

  * `http://image.baidu.com/i?ct=201326592&cl=2&lm=-1&tn=baiduimage&istype=2&fm=index&pv=&z=0&word=%C3%C8&s=0`
  * `http://image.baidu.com/i?ct=201326592&cl=2&lm=-1&tn=baiduimage&istype=2&fm=index&pv=&z=0&word=%C3%C8&s=0#pn=15`
    * GB2312 エンコードなので、 `萌 (utf8=%E8%90%8C)` が `%C3%C8` となる。
    * ページ送りしても #pn=15 みたいにページ内ジャンプかのごとく処理している。
  * どうやら、画像情報が全部、スクリプトで来ているっぽい。
```
</body> の後に、<script> があって、
</body><script>var imgdata = {"queryEnc":"%C3%C8","displayNum":8729021,"listNum":2000,"bdFmtDispNum" : "?8,720,000","bdSearchTime" : "0.027","data":[{"thumbURL":"http:/

という感じで続いていく。

"data" 以後の配列が、画像データで、
{} ブロックが１個分。

{"thumbURL":"http://t2.baidu.com/it/u=1206338301,3563550419&fm=0&gp=0.jpg","pageNum":1,"objURL":"http://a3.att.hudong.com/53/66/01300000559649127354660578856.jpg     ","fromURL":"http://tupian.hudong.com/a3_53_66_01300000559649127354660578856_jpg.html     ","fromURLHost":"http://tupian.hudong.com     ","currentIndex":"28766     ","width":800,"height":800,"type":"jpg","filesize":"58","bdSrcType":"0","di":"45827234940","is":"0,0","bdSetImgNum":0,"fromPageTitle":"<strong> 萌</strong>     ","token":"6891"},

},{}]};
のように、ブランクデータが来たらエンド
```