#!/bin/bash
# Raspberry Pi 上で実行するセットアップコマンド（手順の詳細は docs/setup.md を参照）
# 実行前に etc/ 配下の設定ファイルのプレースホルダー（MAC アドレス、SSID、パスワード）を書き換えておくこと
set -eu

# Web サーバー、ソフトウェアアクセスポイント、DHCP サーバー
sudo apt install -y apache2 hostapd dnsmasq

# 設定ファイルを配置（dnsmasq.conf / dhcpcd.conf は既存ファイルへの追記）
sudo cp etc/udev/rules.d/99-ap0.rules /etc/udev/rules.d/
sudo cp etc/hostapd/hostapd.conf /etc/hostapd/
sudo cp etc/wpa_supplicant/wpa_supplicant.conf /etc/wpa_supplicant/
grep -v '^#' etc/dnsmasq.conf | sudo tee -a /etc/dnsmasq.conf > /dev/null
grep -v '^#' etc/dhcpcd.conf | sudo tee -a /etc/dhcpcd.conf > /dev/null

# hostapd は apt でインストールしても自動で有効にならない
sudo systemctl unmask hostapd.service
sudo systemctl enable hostapd.service
sudo rfkill unblock wifi

sudo systemctl restart dhcpcd.service
sudo systemctl restart hostapd.service
sudo systemctl restart dnsmasq.service
