# my-local-tools

## rdiff-backup

- backup script

- 気をつける点
    - パーミッション
    ```
     pwd
    /misc/removable/Orlanth/home
      Odayla  yabuki  …  removable  Orlanth  home  ls -la
    合計 16
    drwxr-xr-x  4 yabuki yabuki 4096  3月 22  2021 .
    drwxrwxr-x  3 yabuki yabuki 4096 12月  2 23:46 ..
    drwx------  4 yabuki yabuki 4096 12月  8 14:47 rdiff-backup-data
    drwxr-xr-x 52 yabuki yabuki 4096 12月  8 14:05 yabuki
    ```
    としておくこと。

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
