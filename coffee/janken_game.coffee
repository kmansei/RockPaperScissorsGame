$ ->
  app.initialize()

window.app =
  life:
    my: 3
    enemy: 3

  initialize: ->
    @setBind()

  setBind: ->
    $('#gamestart').on 'click', =>
      @showHand()
      @timer()
    $('#gamerestart').on 'click', =>
      @reset 'clear', 'over'
    #グー = 1　チョキ = 2 パー = 3
    $('#gu').on 'click', =>
      @clickHand 1
    $('#tyoki').on 'click', =>
      @clickHand 2
    $('#pa').on 'click', =>
      @clickHand 3

  showHand: ->
    $('#gamestart').fadeOut 'fast'
    $('#open').fadeIn 'normal'

  #制限時間
  timer: ->
    m = $('#m')
    setInterval =>
      m.html5jpMeterPolyfill()
      #文字列を10進法で表した数字に変換
      val = parseFloat m.attr('value')
      val -= 0.05
      m.attr 'value', val
      console.log val
      if val <= 0
        @life.my--
        @decrease_life @life.my, 'my'
        @damaged 'me'
        m.attr 'value', 5
    , 50


  clickHand: (mynumber) ->
    enemynumber = _.random 1, 3
    @display_img enemynumber, 'you'
    @display_img mynumber, 'me'
    @judgement mynumber, enemynumber
    m = $('#m')
    m.attr 'value', 5
    #@check @life.my, @life.enemy
    #@check mynumber, enemynumber

  #勝敗を決める
  judgement : (mynumber, enemynumber) ->
    if mynumber is enemynumber
      $('#judge').text '引き分けです!'
    else if mynumber - enemynumber is -2 or mynumber - enemynumber is 1
      @life.my--
      @decrease_life @life.my, 'my'
      $('#judge').text 'あなたの負けです!'
      @damaged 'me'
    else
      @life.enemy--
      @decrease_life @life.enemy, 'enemy'
      $('#judge').text 'あなたの勝ちです！'
      @damaged 'you'

  #負けた手の画像を光らせる
  damaged : (who) ->
    $(".#{who}").fadeOut 'fast', ->
      $(".#{who}").fadeIn 'fast'

  #画像を表示
  display_img : (image_number, who) ->
    switch image_number
      when 1
        $(".#{who}").attr 'src', 'img/グー.jpg'
      when 2
        $(".#{who}").attr 'src', 'img/チョキ.jpg'
      when 3
        $(".#{who}").attr 'src', 'img/パー.jpg'

  #確認用
  check : (mynumber, enemynumber) ->
    console.log mynumber
    console.log enemynumber

  #ライフを減らす
  decrease_life : (lifepoint, who) ->
    $(".#{who}life_#{lifepoint}").hide 1000
    if lifepoint is 0 and who is 'enemy'
      setTimeout =>
        @result 'clear'
      , 1350
    else if lifepoint is 0 and who is 'my'
      setTimeout =>
        @result 'over'
      , 1350

  #結果の画面を表示
  result: (which) ->
    $('#open').fadeOut 'fast'
    $("#game#{which}").fadeIn 500
    $('#gamerestart').fadeIn '500'

  #リスタート機能(ハートを再表示&テキストを元に戻す)
  reset: (win, lose) ->
    $('#gamerestart').fadeOut 'fast'
    $("#game#{win}").fadeOut 'fast'
    $("#game#{lose}").fadeOut 'fast'
    $('.me').attr 'src', 'img/はてな.jpg'
    $('.you').attr 'src', 'img/はてな.jpg'
    $('#judge').text '勝敗は？'
    for i in [0..2]
      $(".mylife_#{i}").fadeIn 'normal'
      $(".enemylife_#{i}").fadeIn 'normal'
    @life.my = 3
    @life.enemy = 3
    m = $('#m')
    m.attr 'value', 5
    @showHand()

