# zabbix_sample_vagrant

## Zabbixサーバの構築

```
 # git clone https://github.com/masatomix/zabbix_sample_vagrant.git
 # cd zabbix_sample_vagrant/server/
 # vagrant up
```

と実行することで、Ubuntu Linuxの構築から Docker のインストール、Dockerサーバ上でのZabbixのインストール、そのクライアントでのZabbix Agentのインストールと設定と起動、までが行われます。


## Zabbix Agentの構築

```
 # git clone https://github.com/masatomix/zabbix_sample_vagrant.git
 # cd zabbix_sample_vagrant/agent/
 # vagrant up
```

と実行することで、Ubuntu Linuxの構築から Zabbix Agentのインストールと設定と起動、までが行われます。


2018/05/05追記:
日本語を設定しようとしたら、文字コードの関係でInsert出来なかったのと、画面上のフォントが日本語に微妙に対応していなかった、事を受けて修正。
MySQLのコンテナについて、
     --character-set-server=utf8mb4 \
     --collation-server=utf8mb4_unicode_ci
というオプションを追加したのと、

WEBサーバのコンテナについて、IPAフォントを使うよう設定を追加しました。
