

# 概要 #

  * ヤフー.jp にログインする

# シナリオ #

  * [オリジナル配布物の ヤフーにログイン.txt](http://code.google.com/p/cowares-wpost/source/browse/trunk/wpost/20110218/%E3%83%A4%E3%83%95%E3%83%BC%E3%81%AB%E3%83%AD%E3%82%B0%E3%82%A4%E3%83%B3.txt)

# ページショット #

## !User-Agent!Mozilla/5.0 (X11; U; Linux i686; ja; rv:1.9.2.13) Gecko/20101203 Firefox/3.6.13 ##

  * `https://login.yahoo.co.jp/config/login?.src=www&.done=http%3A%2F%2Fid.yahoo.co.jp%2Findex.html`
```
<form method="post" action="https://login.yahoo.co.jp/config/login?" autocomplete="off" name="login_form">
                <input type="hidden" name=".tries" value="1">
                <input type="hidden" name=".src" value="www">
                <input type="hidden" name=".md5" value="">
                <input type="hidden" name=".hash" value="">
                <input type="hidden" name=".js" value="">
                <input type="hidden" name=".last" value="">
                <input type="hidden" name="promo" value="">
                <input type="hidden" name=".intl" value="jp">
                <input type="hidden" name=".bypass" value="">
                <input type="hidden" name=".partner" value="">
                <input type="hidden" name=".u" value="5t9hke96lbej7">
                <input type="hidden" name=".v" value="0">
                <input type="hidden" name=".challenge" value="_hHG8dI2lQbU7.1GMKrPnBgf7RYN">
                <input type="hidden" name=".yplus" value="">
                <input type="hidden" name=".emailCode" value="">
                <input type="hidden" name="pkg" value="">
                <input type="hidden" name="stepid" value="">
                <input type="hidden" name=".ev" value="">
                <input type="hidden" name="hasMsgr" value="0">
                <input type="hidden" name=".chkP" value="Y">
                <input type="hidden" name=".done" value="http://id.yahoo.co.jp/index.html">
                <input type="hidden" name=".pd" value="">
                <input type="hidden" name=".protoctl" value="" >
               
                <table id="yregloginfield" summary="フォーム:ログイン情報を入力する">
                <tbody>
                    <tr class="yjid">
                        <td><label for="username" class="yjM">Yahoo! JAPAN ID:</label><br />
                        <input name="login" id="username" value="" class="yreg_ipt yjM" type="text"></td>
                    </tr>
                    <tr class="yjpw yjM">
                        <td><label for="passwd" class="yjM">パスワード:</label><br />
                        <input name="passwd" id="passwd" value="" class="yreg_ipt yjM" type="password"></td>
                    </tr>
               
                </tbody>
                </table>   
                              <div class="persistency yjSt"><input type="checkbox" id="persistent" name=".persistent"
value="y" CHECKED> <label for="persistent">次回からIDの入力を省略</label><br>
<p class="persistency">
共用のパソコンではチェックを外してください。</p></div>

                    <div class="yregloginbtn"><img src="https://s.yimg.jp/i/jp/sec/lock.png" border=0 alt="SSLで保護されています" width=15 height=17><input id=".save" type="image" value="ログイン" src="https://s.yimg.jp/images/login/reg06/button/login.png" /></div>
                </form>   

```
    * hidden の .u と .challenge を消しても、ログインできるようだ。
    * クッキーを使うので、クッキー許可を出さないとログインできない。 IE で最高セキュリティだとログインできないということ。
    * 逆にこれを使うなら、一度ログオンしておけば、クッキー許可でログイン状態、禁止でログアウト状態になる。
    * ヤフーは頻繁にパスワード再確認をするため、短期間しか有効にならない。
  * パスワード再確認
```

<fieldset id="loginfs">
<legend>パスワード再確認フォーム</legend>
<form method="post" action="https://login.yahoo.co.jp/config/login_verify2?" autocomplete="off" name="login_form">
    <input type="hidden" name=".src" value="www">
    <input type="hidden" name=".tries" value="1">
    <input type="hidden" name=".done" value="http://id.yahoo.co.jp/index.html">
    <input type="hidden" name=".md5" value="">
    <input type="hidden" name=".hash" value="">
    <input type="hidden" name=".js" value="">
    <input type="hidden" name=".partner" value="">
    <input type="hidden" name=".slogin" value="♪♪♪">
    <input type="hidden" name=".intl" value="jp">
    <input type="hidden" name=".fUpdate" value="">
    <input type="hidden" name=".prelog" value="">
    <input type="hidden" name=".bid" value="">
    <input type="hidden" name=".aucid" value="">
    <input type="hidden" name=".challenge" value="3MQgnSxGDglatkrWMhFr6RyqOYCK">
    <input type="hidden" name=".yplus" value="">
    <input type="hidden" name=".chldID" value="">
    <input type="hidden" name="pkg" value="">
    <input type="hidden" name="hasMsgr" value="0">
    <input type="hidden" name=".pd" value="">
    <input type="hidden" name=".protoctl" value="">
    <input type="hidden" name=".u" value="38n6qv16lk88n">

               <table id="yregloginfield" summary="フォーム:パスワード情報を入力する">
                   <tbody>
                   <tr class="yjid">
                       <td><label for="username" class="yjM">Yahoo! JAPAN ID:</label><br />
                       <div class="formv" id="username">♪♪♪</div></td>
                   </tr>
                   <tr class="yjpw yjM">
                       <td><label for="passwd" class="yjM">パスワード:</label><br />
                       <input name="passwd" id="passwd" value="" class="yreg_ipt yjM" type="password"></td>
                   </tr>
               </tbody></table>    
                   <div class="yregloginbtn"><img src="https://s.yimg.jp/i/jp/sec/lock.png" border="0" alt="SSLで保護されています" width="15" height="17"><input id=".save" type="image" value="続ける" src="https://s.yimg.jp/images/login/reg06/button/continue.png"></div>
               </form>    
               </fieldset>


```
    * ♪♪♪には、実際に使用中のヤフーIDが入る。
    * ヤフー側のタイミングで勝手にこれをはさむので、このページをチェック（タイトルとか）して、こいつが出たら、再ログイン送信する、という手順が良さそう。
  * `http://login.yahoo.co.jp/config/login?logout=1&.src=www&.done=http%3A%2F%2Fid.yahoo.co.jp%2Findex.html`
    * ログアウト
  * `https://lh.login.yahoo.co.jp/?.done=http%3A%2F%2Fid.yahoo.co.jp%2Findex.html`
    * ログイン履歴
    * ログインしていないと表示できないので、ログイン状況の確認にうってつけ。