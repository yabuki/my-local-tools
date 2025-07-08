# Backup tool resticのwrapper

## 使い方

1. 初期化は、手動でやれ。 `restic -r path/to/respo init`
2. initで設定したresticのパスワードは、Odayla/passwd.txtやOrlanth/passwd.txtに書いておく。頑張るなら、gpgで暗号化してもいいが、ローカルで使うだけなので、ここでは頑張らない。
3. make でコマンド一覧を出せ。
4. お好きなコマンドを実行する。/etc/sudoersにnopassで設定してもいいかもしれない。
