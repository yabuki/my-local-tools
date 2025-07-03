# my-local-tools

## restic

rdiff-backupからresticにパックアップコマンドを変更する。こっちの方が良い。

## rdiff-backup

### ライセンス

私が書いた部分は AGPL にします。書くというか自分で独自の
表現をした部分というべきか。

AGPLの詳細については、rdiff-backupディレクトリにあるCOPYINGを参照のこと。

### このツールは何か

各マシンから、OdaylaにつないであるHDDに/home/の内容を
rdiff-backupでバックアップを取るスクリプトです。

### 使い方

rdiff-backupディレクトリの各マシンのディレクトリに行き

`make`でできることを確認した、あとにバックアップを実行する。

### 初期の手順

1. mkfsします。ext4かbtrfsあたりか。
2. automountしているので、設定します。UUIDがよい?
3. /misc/removableのしたに、マシン名ごとにディレクトリー
    を切ります。sudo chown yabuki:yabuki ディレクトリ名
    として、一般ユーザが書けるようにしておきます。

    ```
    $ pwd
    /misc/removable/Orlanth/home
    $ ls -la
    合計 16
    drwxr-xr-x  4 yabuki yabuki 4096  3月 22  2021 .
    drwxrwxr-x  3 yabuki yabuki 4096 12月  2 23:46 ..
    drwx------  4 yabuki yabuki 4096 12月  8 14:47 rdiff-backup-data
    drwxr-xr-x 52 yabuki yabuki 4096 12月  8 14:05 yabuki
    ```
    こんな感じ。

### note

rootの権限をもったものは対象としない。ssh root@マシン名 でsshアクセスを許さないと
いけないので、それはちょっとね。


- 実行コマンドラインと結果

    ```
     make -f Orlanth.mk backup
    if [ $(ssh yabuki@odayla.local "[ -d /misc/removable/Orlanth ];echo \$?") -eq 0 ]; then \
    /usr/bin/rdiff-backup \
    --print-statistics \
    --exclude-globbing-filelist '/home/yabuki/scm/git/my-local-tools/rdiff-backup/Orlanth/Orlanth-exclude.list' \
    /home/ \
    yabuki@odayla.local::/misc/removable/Orlanth/home/ ; \
    else \
    echo "I couldn't get /misc/removable/Orlanth" | mail -s "Is /misc/removable/Orlanth active?" yabuki ; \
    fi
    Warning: Permanently added 'odayla.local' (ED25519) to the list of known hosts.
    yabuki@odayla.local's password: 
    --------------[ Session statistics ]--------------
    StartTime 1670475963.00 (Thu Dec  8 14:06:03 2022)
    EndTime 1670477972.66 (Thu Dec  8 14:39:32 2022)
    ElapsedTime 2009.66 (33 minutes 29.66 seconds)
    SourceFiles 936516
    SourceFileSize 27802853863 (25.9 GB)
    MirrorFiles 1
    MirrorFileSize 0 (0 bytes)
    NewFiles 936515
    NewFileSize 27802853863 (25.9 GB)
    DeletedFiles 0
    DeletedFileSize 0 (0 bytes)
    ChangedFiles 1
    ChangedSourceSize 0 (0 bytes)
    ChangedMirrorSize 0 (0 bytes)
    IncrementFiles 0
    IncrementFileSize 0 (0 bytes)
    TotalDestinationSizeChange 27802853863 (25.9 GB)
    Errors 0
    --------------------------------------------------
    ```
#### rdiff-backup compare

実行すると、差分があるためか、なんの理由か分からないが
```
make: *** [makefile:51: compare] エラー 1
```
となる。bash script文頭に-をつけても、無視されました。と追加のメッセージがでる。

差分自体の内容はわかるので、どのように対処するべきかは、原因が追求しきれて
いないが、気がついたときに直すことにする。

## Thinkpad T480 touchpad ON/OFF

自分Thinkpad T480のタッチパッドが大体は不要なんだけど、大きな動きを
させたいときだけONにしたいかも。ってことで xinputを使って
タッチバッドのON/OFFをする。スクリプトを書いて置いておく。

元ネタは、[How to Enable/Disable Touchpad in Linux | Baeldung on Linux](https://www.baeldung.com/linux/enable-disable-touchpad/)
になります。

決め打ちスクリプトなんで他のマシンに転用するときは、忘れずに
読むこと。将来他のノートでも同じニーズがでたらどうするかも考えてね。
(yadmで管理する?)

### 軽く事前設計

1. 使い方を出す。-h --helpも同様に

### 依存するもの/使う物

- git@github.com:ko1nksm/getoptions.git
    - コマンドラインパーサー
    - [シェルスクリプト(bash等)の引数解析が究極的に簡単になりました #Bash - Qiita](https://qiita.com/ko1nksm/items/9ee16927b7f8899c4a9e)
    - 実行する場所にはインストールしておくこと。gengetoptionsでembedしても
    getoptionsコマンドを呼んでいるので必要だ。
- shellcheck
    - `apt install shellcheck`
- xinput
    - タッチパッドのon/offに利用している
