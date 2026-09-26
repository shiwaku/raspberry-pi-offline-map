# raspberry-pi-offline-map

Raspberry Pi 4 を Wi-Fi アクセスポイント化し、インターネットに接続できない環境（災害時など）でも、スマートフォンやノート PC のブラウザから地図を表示できるオフライン地図表示システムです。

MapLibre GL JS で、国土地理院の最適化ベクトルタイル・標高タイル（3D 地形）と PLATEAU 建築物モデルを表示します。

- 発表資料：[Raspberry PiとMapLibre GL JSを用いたオフライン地図表示システムの試作](https://www.docswell.com/s/shi-works/KEX8L8-2024-11-10-174230)（2024-11）
- 参考：[UNVT Portable](https://github.com/unvt/portable)

## 構成

```
raspberry-pi-offline-map
├─ html/            Raspberry Pi の /var/www/html に置くビューワ一式
│  ├─ index.html    MapLibre GL JS ビューワ
│  ├─ lib/          maplibre-gl@4.5.0, pmtiles@2.11.0（オフラインで動くよう同梱）
│  ├─ glyphs/       Noto Sans JP / Noto Serif JP のフォントグリフ
│  ├─ sprite/       地図記号
│  ├─ style/        最適化ベクトルタイル用スタイル (std.json)
│  └─ public/       地図データの置き場所（リポジトリには含まない）
├─ rpi-config/      Raspberry Pi の設定ファイル
│  ├─ etc/          /etc 以下に置くファイル（hostapd, dnsmasq, dhcpcd, udev, wpa_supplicant）
│  └─ setup-commands.sh
└─ docs/
   └─ setup.md      構築手順（機材、OS 書き込み、アクセスポイント化、データ転送）
```

## ネットワーク構成

| 項目 | 値 |
|---|---|
| アクセスポイント | 仮想インターフェース `ap0`（`wlan0` はクライアントとして併用） |
| IP アドレス | `192.168.249.1/24` |
| DHCP 配布範囲 | `192.168.249.50`〜`192.168.249.150` |
| Web サーバー | Apache2 |
| ビューワの URL | `http://192.168.249.1/` |

## 地図データ

`html/public/` に次のデータを置きます。容量が大きいためリポジトリには含めていません。

| ファイル | 内容 | サイズ | 入手先 |
|---|---|---|---|
| `optimal_bvmap-v1.pmtiles` | 国土地理院 最適化ベクトルタイル | 約 16 GB | https://cyberjapandata.gsi.go.jp/xyz/optimal_bvmap-v1/optimal_bvmap-v1.pmtiles |
| `PLATEAU_2023_LOD0.pmtiles` | PLATEAU 建築物モデル LOD0（210 都市） | 約 2.9 GB | https://shi-works.com/pmtiles/plateau/PLATEAU_2023_LOD0.pmtiles |
| `gsi-dem-terrain-rgb/` | 国土地理院 標高タイル DEM10B（Mapbox Terrain-RGB 形式の XYZ タイル） | 約 8.7 GB | 配布停止中（下記） |

標高タイルは、以前は `gsi-dem-terrain-rgb.zip` として配布していましたが、現在は公開していません。zip を持っている場合は、展開して `html/public/gsi-dem-terrain-rgb/{z}/{x}/{y}.png` となるように配置してください。

## 使い方

1. [docs/setup.md](docs/setup.md) に従って Raspberry Pi OS を書き込み、SSH で接続する
2. `rpi-config/etc/` 配下のプレースホルダー（MAC アドレス、SSID、パスワード）を書き換え、Raspberry Pi に転送して `setup-commands.sh` を実行する
3. `html/public/` に地図データを置き、`html/` の中身を Raspberry Pi の `/var/www/html` に転送する
4. スマートフォンやノート PC から Wi-Fi `UNVTPortable` に接続し、`http://192.168.249.1/` を開く

構築手順は 2024 年 9 月時点の Raspberry Pi OS（Debian 12 ベース、32bit）で確認したものです。

## ライセンス

[CC BY 4.0](LICENSE)

地図データの出典：国土地理院（最適化ベクトルタイル、標高タイル）、国土交通省 3D 都市モデル Project PLATEAU
