#!/bin/sh

function choice(){
  echo "=================="
  echo "  サンプルスクリプト  "
  echo " [1] logsディレクトリのファイル一覧を取得し、1ファイルずつlsコマンドを実行"
  echo " [2] ssl_access_logファイルが何行あるか調べる"
  echo " [3] 圧縮したファイル(ssl_access_log-20210114.tar.gz)を表示する"
  echo " [4] 「apple」という文字を含む行が何行出てくるか調べて表示(ファイル毎)"
  echo " [5] 「apple」という文字を含む行がログ全体で何行出てくるか調べて合計の数字を計算して表示"
  echo " [6] workディレクトリを新規作成。存在した場合は削除して新しく作成する"
  echo " [7] 圧縮ファイルを1ファイルずつコピーして解凍し、行数をカウントする(圧縮ファイルのみ)"
  echo "=================="
}

choice
echo "何番を実行してみますか？"
read -p "INPUT:" str


######################################################################
#
# サンプル 1
# logsディレクトリのファイル一覧を取得し、1ファイルずつlsコマンドを実行
# 
######################################################################
if [ $str -eq 1 ]
then
  
  # せっかくなので、何回lsしたか数えてみる
  count=0

  # logsディレクトリをlsして、その結果を1つずつfor文でループする
  for filename in `ls ./logs/`
  do
    # 1ファイルずつ$filenameという変数にファイル名が入ってくるので、lsする
    ls -la ./logs/$filename

    # 数えるために1足す
    count=`expr $count + 1`
  done

  echo "${count}回 ls しました"
fi


######################################################################
#
# サンプル 2
# ssl_access_logファイルが何行あるか調べる 
#
######################################################################
if [ $str -eq 2 ]
then
  
  # wcコマンドを使って行数を数える
  # そのまま表示しても良いが一度、数えた数字を変数に入れて
  # 最後に結果を表示してみることにする

  # catされた行数を数え、その結果をcount変数に代入する
  # wc -l ssl_access_log
  # でも数えられるが、今回圧縮ファイルも扱うので、表示したものをカウントする方法にした
  count=`cat ./logs/ssl_access_log | wc -l`
  
  # 結果を表示
  echo "ログの行数は${count}行でした。"

fi


######################################################################
#
# サンプル 3
# 圧縮したファイル(ssl_access_log-20210114.tar.gz)を表示する
#
######################################################################
if [ $str -eq 3 ]
then

  # gzファイルはzcatを用い表示するが、
  # tar.gzファイルはtarコマンドで解凍オプションにて、「-O」オプションを付与することにより表示する

  # tarコマンドで解凍オプションにて、「-O」オプションを付与する
  tar -O -xzvf ./logs/ssl_access_log-20210114.tar.gz
fi


######################################################################
#
# サンプル 4
# 「apple」という文字を含む行が何行出てくるか調べて表示(ファイル毎)
#
######################################################################
if [ $str -eq 4 ]
then

  # サンプル1でやったループを使って、1ファイルずつgrepしてカウントする
  
  # logsディレクトリをlsして、その結果を1つずつfor文でループする
  for filename in `ls ./logs/`
  do

    # みやすさのためにファイル名を表示
    echo ${filename}
    
    # catするかtarするか判定しないといけないので、ファイル名で判定
    if [ ${filename} = "ssl_access_log" ]
    then
      # 対象の文字列でgrepして、カウントする
      cat ./logs/${filename} | grep "apple" | wc -l
    else
      # 対象の文字列でgrepして、カウントする
      tar -O -xzvf ./logs/${filename} | grep "apple" | wc -l    
    fi
    
  done


fi


######################################################################
#
# サンプル 5
# 「apple」という文字を含む行がログ全体で何行出てくるか調べて合計の数字を計算して表示
#
######################################################################
if [ $str -eq 5 ]
then

  # サンプル5でカウントした数字を変数に入れて保存する
  
  # 合計値の初期値を0にしておく
  sum=0
  
  # logsディレクトリをlsして、その結果を1つずつfor文でループする
  for filename in `ls ./logs/`
  do
    
    # catするかtarするか判定しないといけないので、ファイル名で判定
    if [ ${filename} = "ssl_access_log" ]
    then
      # 対象の文字列でgrepして、カウントする
      count=`cat ./logs/${filename} | grep "apple" | wc -l`
    else
      # 対象の文字列でgrepして、カウントする
      count=`tar -O -xzvf ./logs/${filename} | grep "apple" | wc -l`
    fi
    
    sum=`expr ${sum} + ${count}`
    
  done
  
  echo "合計行数は ${sum} 行でした。"

fi


######################################################################
#
# サンプル 6
# workディレクトリを新規作成。存在した場合は削除して新しく作成する
#
######################################################################
if [ $str -eq 6 ]
then

  # ディレクトリが存在しているか確認
  if [ -e ./work ]
  then
    # 存在していた場合には、ディレクトリを削除する
    rm -r ./work
  fi
  
  # ディレクトリを作成する
  mkdir ./work

  echo ""
  echo "【!注目!】"
  echo "workディレクトリが作成されたか確認してみてね！"
  echo "また、workディレクトリに適当なファイルを作成し、再実行すると新規に作成されているのが分かるよ。"
  echo ""
  
fi


######################################################################
#
# サンプル 7
# workディレクトリを新規作成。圧縮ファイルを1ファイルずつコピーして解凍し、行数をカウントする(圧縮ファイルのみ)
#
######################################################################
if [ $str -eq 7 ]
then

  # ディレクトリが存在しているか確認
  if [ -e ./work ]
  then
    # 存在していた場合には、ディレクトリを削除する
    rm -r ./work
  fi
  
  # ディレクトリを作成する
  mkdir ./work
  
  # logsディレクトリをlsして、その結果を1つずつfor文でループする
  for filename in `ls ./logs/`
  do

    # catするかtarするか判定しないといけないので、ファイル名で判定
    if [ ${filename} != "ssl_access_log" ]
    then

      # 1ファイルずつworkディレクトリにコピーする
      cp -i ./logs/${filename} ./work/
      
      # 解凍する
      tar -xzvf ./work/${filename}
      
      # 解凍前のファイルは削除する
      rm ./work/${filename}
      
      # 解凍されると、ファイル名から「.tar.gz」がなくなるので、
      # 変数ファイル名の「.tar.gz」部分をなくした変数を作成
      # ファイル名を「.」で分割したときの1個目の値を変数にセット
      filename2=`echo ${filename} | awk -F'.' '{print $1}'`
      
      # 行数をカウント
      wc -l ./work/${filename2}
      
      # カウントが終了したらファイルを削除する
      rm ./work/${filename2}

    fi
    
  done
fi

exit;
